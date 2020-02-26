# 진저티 청년참여 플랫폼

## 로컬 개발 및 테스트

### 실서버 데이터베이스를 로컬로 다운로드

mysql > drop database demosx_buttercon_development
mysql > create database `demosx_buttercon_development` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

$ mysqldump -uadmin -p`${비번 lastpass 작업Shared RDS에 있음}` -h database-buttercon.clpurnr5lyok.ap-northeast-2.rds.amazonaws.com demosx_buttercon | mysql -h `localhost` -uroot -p`${로컬서버 비번}` demosx_buttercon_development

### 패키징

```bash
maven clean package
// 테스트 없이 패키징
mvn package -Dmaven.test.skip=true
```

### 자동 테스트

* /src/main/resources/egovframework/egovProps/globals-override-test.properties
    * globals-override-main.properties 의 각 값을 테스트 환경에 맞춰 오버라이드 해야할 때 사용
* `globals-override-test.properties` 파일의 `Globals.Url` 부분에 새로운 디비스키마를 만들어 주는 것이 좋다.
    * `globals-override-development.properties` 와 같은 디비 스키마를 바라볼 경우, 로컬에서 수동 테스트 데이타와 충돌하여, 자동 테스트 실패.
    * 로컬 디비에 테스트 스키마를 새로 만든다. `create schema buttercontest DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`

`globals-override-test.properties` 예:
```
Globals.UserName=swain
Globals.Password=swain
Globals.Url=jdbc:mysql://127.0.0.1:3306/buttercontest?useSSL=false
```

### 로컬실행 유의사항

* `/src/main/resources/egovframework/egovProps/` 디렉토리 밑에 파일생성: `globals-override-development.properties`
* 생성된 파일에 로컬 MYSQL의 `UserName,Password,Url` 항목을 넣는다.

`globals-override-development.properties` 예:
```
Globals.UserName=swain
Globals.Password=swain
Globals.Url=jdbc:mysql://127.0.0.1:3306/buttercon?useSSL=false
```

* 로컬 디비에 개발 스키마를 새로 만든다. `create schema buttercon DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
* 톰켓 환경에 (jvm.options) 자바 변수를 넣어준다. `-Dspring.profiles.active=development`
* `globals.properties`에 있는 변수 중 `ENC(...)`로 묶여있는 암호화 변수는 모두 `globals-override-development.properties`파일에서 다른 수로 덮어야 한다.
    * `Globals.kakaoClientId=a` 도커파일에 있는 암호 `-Dorg.demosx.master.password=needtochange` 가 아닌 다른 비밀번호로 암호화 되어 있기 때문에, 변경하지 않으면 구동이 되지 않는다.

`globals-override-development.properties` 예:
```
Globals.SmtpUser=a
Globals.SmtpPassword=a
Globals.naverClientId=
Globals.naverClientSecret=
Globals.kakaoClientId=a
Globals.twitterClientId=
Globals.twitterClientSecret=
Globals.facebookClientId=a
Globals.facebookClientSecret=a
Globals.googleClientId=a
Globals.googleClientSecret=a
```

* 스키마 변경은 flywaydb 라이브러리를 활용하여 관리. (추가설치 불필요)
    * /src/main/resources/db/migration 디렉토리에 V7__Add_issue_users.sql 다음으로 V8__${아무이름}을 넣으면, 실행 시 자동으로 sql코드를 읽어 디비에 반영.

### 로컬개발

~~`mvn sass:watch` SASS 자동 컴파일~~
크롬은 sass를 자동으로 src와 매칭시켜 줘서 위의 명령어를 킬 필요가 없다.

#### vscode 
##### extensions
* fsdeploy: 프런트 jsp개발
* jsp, java 관련 모두
* tomcat
* lombok

## 프로젝트 빌드

자바 및 maven 환경이 설치되어 있어야 합니다.

```bash
mvn package
```

빌드 시 target폴더에 war 파일이 생성됩니다.

##### docker mysql

```
# docker pull mysql:5
# mkdir -p $HOME/docker/volumes/mysql
# docker run --rm --name mysql \
  -e MYSQL_ROOT_PASSWORD=docker \
  -e MYSQL_DATABASE=buttercon \
  -e MYSQL_USER=swain \
  -e MYSQL_PASSWORD=swain \
  -d -p 3306:3306 \
  -v $HOME/docker/volumes/mysql:/var/lib/mysql \
  mysql:5 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# brew install mysql-client@5.7
# mysql -h 127.0.0.1 -P 3306 -u swain -p
```

### ENVIRONMENT VARIABLES

기본 값
* globals.properties 암호화 비번: `org.demosx.master.password=${aws}`
* 로깅레벨: `org.apache.logging.log4j.simplelog.StatusLogger.level=ERROR`
* 회원가입 금지 `BLOCK_NEW_USER=true`
* 배너 보이기 `SHOW_BANNER=true`
* 서버 환경 `spring.profiles.active=default`
    * production
    * development


#### 서버 환경

/src/main/resources/egovframework/egovProps/globals.properties,
/src/main/resources/egovframework/egovProps/globals-override-*.properties 등의 환경변수 값

```bash
Globals.Password=데이터베이스암호
Globals.Url=데이터베이스접속Url
Globals.naverClientId=네이버ClientId
Globals.naverClientSecret=네이버ClientSecret
Globals.kakaoClientId=카카오ClientId
Globals.twitterClientId=트위터ClientId
Globals.twitterClientSecret=트위터ClientSecret
Globals.facebookClientId=페이스북ClientId
Globals.facebookClientSecret=페이스북ClientSecret
```

* main 환경: globals.properties 파일의 프로퍼티가 기본값, 프로파일 값(spring.profiles.active)에 따라 globals-override-${spring.profiles.active}.properties 파일의 프로퍼티가 오버라이드
* test 환경: 역시 globals.properties 파일의 프로퍼티가 기본값, 이를 테스트 환경에 맞게 오버라이드하는 globals-override-test.properties


## 서버 배포

2020년 2월 28일 beanstalk 사용으로 변경, ROOT.war 파일을 빈즈톡에 수동으로 업로드한다.
`eb deploy` 의 경우 https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-configuration.html 의 Deploying an Artifact instead of the project folder 를 참고한다.
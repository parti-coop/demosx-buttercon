# 진저티 청년참여 플랫폼

## 환경설정

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

* main 환경

globals.properties 파일의 프로퍼티가 기본값이고, 프로파일 값(spring.profiles.active)에 따라 globals-override-${spring.profiles.active}.properties 파일의 프로퍼티가 오바라이드

* test 환경
역시 globals.properties 파일의 프로퍼티가 기본값이고, 이를 테스트 환경에 맞게 오버라이드하는 globals-override-test.properties

## 로컬 개발 및 테스트

### 패키징

`maven clean package`

#### 테스트 없이 패키징

`mvn package -Dmaven.test.skip=true`

### 자동 테스트

* /src/main/resources/egovframework/egovProps/globals-override-test.properties
    * globals-override-main.properties 의 각 값을 테스트 환경에 맞춰 오버라이드 해야할 때 사용
* `globals-override-test.properties` 파일의 `Globals.Url` 부분에 새로운 디비스키마를 만들어 주는 것이 좋다. 
    * `globals-override-development.properties` 와 같은 디비 스키마를 바라볼 경우, 로컬에서 수동 테스트 데이타와 충돌하여, 자동 테스트 실패.
    * 로컬 디비에 테스트 스키마를 새로 만든다. `create schema buttercontest DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;`

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

* 로컬 디비에 개발 스키마를 새로 만든다. `create schema buttercon DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;`
* 톰켓 환경에 자바 변수를 넣어준다. `-Dspring.profiles.active=development`
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

### 개발

`mvn sass:watch`
SASS 자동 컴파일

## 프로젝트 빌드

자바 및 maven 환경이 설치되어 있어야 합니다.

```bash
mvn package
```

빌드 시 target폴더에 war 파일이 생성됩니다.

## 서버 설치

* 미리 설정된 관리자 아이디와 암호: contact@parti.xyz / needtochange
* /deploy 폴더를 서버에 ~에 복사한다.
* 서버 ~/docker/docker-compose.override.yml을 ~/docker/docker-compose.overried.yml로 복사하고 해당 파일 안의 org.demosx.master.password 값을 입력한다.

## 배포 방법

1. 프로젝트 빌드를 한다.
2. 서버 ~/current 에 war를 복사한다.
    * 버전에 따라 도커 내에서 WAR 파일이 안풀리는 경우 발견. 톰켓 권한이 문제로 추정.
3. 서버 ~/docker/build.sh를 실행한다.

## 할일

* butter.do 상세보기
* 수정하여 버터 추가하기
* 이전 버전과 mergely 사용하여 비교 (아마도 수정과 같은 페이지?)
* 슬렉 이벤트 후크 넣기

### 2차로 미루어진 기능

* 댓글 달기
* 수정 요청하기
* 메이커가 수정요청 반영하기/거절하기
* 사소한 수정 이력은 건너뛰고 비교

## 서원 낙서장

1. Butters 와 User 를 @ManyToMany로 엮음.
2. JPA 코드의 projection, dto, domain의 차이를 3일만에 이해함, 아직 QBean은 잘 이해가지 않음.
3. https://naver.com

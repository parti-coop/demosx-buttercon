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

## 테스트

* /src/main/resources/egovframework/egovProps/globals-override-test.properties
  * globals-override-main.properties 의 각 값을 테스트 환경에 맞춰 오버라이드해야할 때 사용

## 개발 및 테스트

* flywaydb를 사용하여 스키마 변경을 관리합니다.

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
3. 서버 ~/docker/build.sh를 실행한다.

## 할일

* 관리자 아이디어랑 아이디어 댓글 관리
* 개안정보처리방침
* 이용약관
* 업로드 파일이 배포 후에도 잘 저장되는가?
* ROBOT.txt
* 푸터

* 네이버 등 각종 로그인 설정
* 이메일 연결
* 도메인 설정

* 주소복사
* 버터나이프크루

* https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css --> 로컬 bootstrap로 변경
* README 업데이트
* 50/500
* tinymce 정리

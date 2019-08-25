# 진저티

## 환경설정

/src/main/resources/egovframework/egovProps/globals-override-main.properties
메인의 환경변수 값

```
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

## 테스트

* /src/main/resources/egovframework/egovProps/globals-override-test.properties
  * globals-override-main.properties 의 각 값을 테스트 환경에 맞춰 오버라이드해야할 때 사용

## 개발 및 테스트

* flywaydb를 사용하여 스키마 변경을 관리합니다.

## 최초 설치

* 미리 설정된 관리자 아이디와 암호: contact@parti.xyz / needtochange

## 프로젝트 빌드

자바 및 maven 환경이 설치되어 있어야 합니다.

```
mvn package
```

빌드 시 target폴더에 war 파일이 생성됩니다.

## docker 실행 방법

1. 프로젝트 빌드를 한다.
2. 생성된 war 파일을 ROOT.war 파일로 이름을 변경한다.
3. docker/webapps 경로에 복사한다.
4. docker 경로로 이동 후 `docker-compose up`

## 할일
* hans@slowalk.co.kr 메일 주소변경
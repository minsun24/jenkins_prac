## 1. build된 jar 파일이 있는 경우
#FROM eclipse-temurin:17-jre-alpine
#
#WORKDIR /app
#
#COPY build/libs/*.jar ./
#
#RUN mv $(ls *.jar | grep -v plain) app.jar
#
#ENTRYPOINT ["java", "-jar", "app.jar"]

## ------------------------------------------------
#eclipse-temurin:17-jre-alpine
## build 된 것을 실행할 때 사용


## 2. build 후 jar  파일로 실행되게 수정 (멀티 스테이징)
## 2-1. gradle 이미지로 build(jar 파일 생성)
FROM gradle:8.5-jdk17-alpine AS build
WORKDIR /app
COPY . .
# 현재 위치(. => 내가 작성한 프로젝트)의 모든 것들을
# (. == /app)app이라는 폴더로 복사

#RUN gradle clean build --no-daemon (안정성 측면으로는, 테스트 포함하는 빌드가 좋지만, 개발 효율성을 위해서는 테스트 제외하고 빌드)

# 데몬 쓰레드 쓰지 않고, 메인 쓰레드만 사용하겠다.(불필요한 자원(JVM 등) 낭비/소모 방지, 속도 향상)
# daemon thread (백그라운드에서 동작하는 쓰레드)
RUN gradle clean build --no-daemon -x test

## 2-2. 앞선 build 라는 이름의 스테이지 결과로 실행 스테이지 시작
FROM eclipse-temurin:17-jre-alpine

COPY --from=build /app/build/libs/*.jar ./
## build 라는 스테이지의 결과로부터
## jar 파일 2개가 app 폴더로 복사됨.

RUN mv $(ls *.jar | grep -v plain) app.jar

## 컨테이너 내부에서는 7777 포트로 app.jar 가 실행 됨
ENTRYPOINT ["java", "-jar", "app.jar"]


## 테스트
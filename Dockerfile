FROM bitnami/git:2.44.0 AS git

WORKDIR /app

RUN git clone https://github.com/krlld/common-lib
RUN git clone https://github.com/krlld/parent
RUN git clone https://github.com/krlld/hrm

FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

COPY --from=git /app/common-lib /app/common-lib
COPY --from=git /app/parent /app/parent
COPY --from=git /app/hrm /app/hrm

RUN mvn -f ./common-lib clean install -DskipTests
RUN mvn -f ./parent clean install -DskipTests
RUN mvn -f ./hrm clean install -DskipTests

FROM openjdk:17-slim

WORKDIR /app

COPY --from=build /app/web/target/*.jar /app/*.jar

CMD ["java", "-jar", "/app/*.jar"]
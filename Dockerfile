FROM openjdk:8
COPY target/cicd-project-test-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]

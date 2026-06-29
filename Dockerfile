# Stage 1: Build WAR với Maven
FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
WORKDIR /app

# Cache Maven dependencies trước (chỉ re-download khi pom.xml đổi)
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Build project
COPY src ./src
RUN mvn clean package -DskipTests -q

# Stage 2: Chạy trên Tomcat 10 (tương thích Jakarta EE 10)
FROM tomcat:10.1-jdk17-temurin

# Xóa app mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# setenv.sh: chuyển Render env vars thành Java system properties
COPY setenv.sh /usr/local/tomcat/bin/setenv.sh
RUN sed -i 's/\r//' /usr/local/tomcat/bin/setenv.sh && chmod +x /usr/local/tomcat/bin/setenv.sh

# Deploy WAR thành ROOT (app chạy ở /, không cần /HotelBookingManagementSystem/)
COPY --from=build /app/target/HotelBookingManagementSystem.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

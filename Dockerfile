# Stage 1: Build Application and Cache
FROM gradle:8-jdk22 AS build
WORKDIR /home/gradle/src

# Copy only dependency files first to leverage Docker cache
COPY build.gradle.* gradle.properties* ./
RUN gradle build --no-daemon > /dev/null 2>&1 || true

# Copy full source and build the JAR
COPY --chown=gradle:gradle . .
RUN gradle buildFatJar --no-daemon

# Stage 2: Generate a self-signed SSL certificate
# We use ARG to get these from GitHub Actions secrets
ARG KEYSTORE_PASSWORD
ARG KEY_PASSWORD

RUN keytool -keystore /helios_portfolio.jks \
    -alias heliosAlias \
    -genkeypair \
    -keyalg RSA \
    -keysize 4096 \
    -validity 365 \
    -storepass "${KEYSTORE_PASSWORD}" \
    -keypass "${KEY_PASSWORD}" \
    -dname 'CN=localhost, OU=ktor, O=ktor, L=Unspecified, ST=Unspecified, C=US'

# Stage 3: Create the Runtime Image
FROM amazoncorretto:22 AS runtime
EXPOSE 2502

# Set these so the Java app can see them at runtime
ARG KEYSTORE_PASSWORD
ENV KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD

RUN mkdir -p /app/storage/cv
COPY --from=build /helios_portfolio.jks /app/helios_portfolio.jks
COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/ktor-app.jar

WORKDIR /app
ENTRYPOINT ["java","-jar","/app/ktor-app.jar"]
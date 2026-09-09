# Stage 1: Build Application and Cache
FROM gradle:8-jdk22 AS build
WORKDIR /home/gradle/src

# Copy only dependency files first to leverage Docker cache
COPY build.gradle.* gradle.properties* ./
RUN gradle build --no-daemon > /dev/null 2>&1 || true

# Copy full source and build the JAR
COPY --chown=gradle:gradle . .
RUN gradle buildFatJar --no-daemon

# Stage 2: Create the Runtime Image
FROM amazoncorretto:22 AS runtime
EXPOSE 2502

# No secrets are baked in. The SSL keystore is generated at container start from
# KEYSTORE_PASSWORD / KEY_PASSWORD in the environment; see docker-entrypoint.sh.
RUN mkdir -p /app/storage/cv
COPY --from=build /home/gradle/src/build/libs/helios-portfolio.jar /app/ktor-app.jar
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/app/docker-entrypoint.sh"]

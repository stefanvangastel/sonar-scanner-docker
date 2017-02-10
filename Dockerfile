#
# Dockerfile creating a minimal sonar-scanner image based on Alpine JRE, capable of both:
# - Scanning a mounted volume
# - Acting as a CI image for e.g. Gitlab CI or Jenkins
#
FROM openjdk:jre-alpine

# Define version
ENV SCANNER_VERSION 2.8

# Install dep's like unzip and wget
RUN apk add --no-cache unzip wget

# Create project directory
RUN mkdir /project

# Make it workdir for 
WORKDIR /project

# Download, extract and remove zip
RUN wget -O sonar-scanner.zip https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/:sonar-scanner-$SCANNER_VERSION.zip && \
    unzip sonar-scanner.zip && \
    mv sonar-scanner-$SCANNER_VERSION/bin/sonar-scanner /usr/bin/sonar-scanner && \
    chmod +x /usr/bin/sonar-scanner && \
    rm sonar-scanner.zip
   
# Run sonar-scanner
CMD ["sonar-scanner"]

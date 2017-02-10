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

# Download, extract and remove zip
RUN wget -O sonar-scanner.zip https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-$SCANNER_VERSION.zip && \
    unzip sonar-scanner.zip -d / && \
    chmod +x /sonar-scanner-$SCANNER_VERSION/bin/sonar-scanner && \
    rm sonar-scanner.zip

# Set home
ENV SONAR_SCANNER_HOME /sonar-scanner-$SCANNER_VERSION

# Apply some heap space improvements
ENV SONAR_RUNNER_OPTS "-Xmx512m -XX:MaxPermSize=128m"

# Symlink to /usr/bin (For CI)
RUN ln -s /sonar-scanner-$SCANNER_VERSION/bin/sonar-scanner /usr/bin/sonar-scanner

# Create a workdir for the 'Scanning a mounted volume' option
RUN mkdir /project
WORKDIR /project
   
# Run sonar-scanner
CMD ["sonar-scanner"]

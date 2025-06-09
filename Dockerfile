# Dockerfile
FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
   apt-get install -y curl jq sudo unzip git libicu-dev libssl-dev && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

# Create runner user
RUN useradd -m github && \
   echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/github/actions-runner

# Download GitHub Actions runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz && \
   tar xzf actions-runner.tar.gz && \
   rm actions-runner.tar.gz

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to runner user
USER github

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
   apt-get install -y curl jq sudo unzip git libicu-dev libssl-dev xz-utils && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user for the runner
RUN useradd -m github && \
   echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory for all following commands
WORKDIR /home/github/actions-runner

# Download GitHub Actions runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz && \
   tar xzf actions-runner.tar.gz && \
   rm actions-runner.tar.gz

# Install Terraform
ARG TERRAFORM_VERSION="1.12.1"
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
   unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
   mv terraform /usr/local/bin/terraform && \
   chmod +x /usr/local/bin/terraform && \
   terraform -version && \
   rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Install Node.js (LTS version)
ARG NODE_VERSION="22.16.0"
RUN curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz | tar -xJvC /usr/local --strip-components=1

# Set environment variables
ENV HOME=/home/github
ENV TERRAFORM_CONFIG=$HOME/.terraform.d/terraform.rc

# Create plugin cache directory and config file as root
RUN mkdir -p /home/github/.terraform.d/plugin-cache && \
   echo "plugin_cache_dir = \"/home/github/.terraform.d/plugin-cache\"" > /home/github/.terraform.d/terraform.rc && \
   chown -R github:github /home/github/.terraform.d

# Copy and make entrypoint script executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown github:github /entrypoint.sh

# Switch to github user
USER github

ENTRYPOINT ["/entrypoint.sh"]
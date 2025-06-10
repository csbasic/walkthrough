FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
   apt-get install -y curl jq sudo unzip git libicu-dev libssl-dev xz-utils && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user for the runner
RUN useradd -m github && \
   echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/github/actions-runner

# Download GitHub Actions runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz && \
   tar xzf actions-runner.tar.gz && \
   rm actions-runner.tar.gz

# Install Terraform
ARG TERRAFORM_VERSION="1.12.1"
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
   && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
   && mv terraform /usr/local/bin/ \
   && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Install Node.js (LTS version)
ARG NODE_VERSION="22.16.0"
RUN curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz | tar -xJvC /usr/local --strip-components=1

# Set root password
# WARNING: Hardcoding passwords directly in a Dockerfile is highly insecure
# and strongly discouraged for production environments or images that will be shared.
# Anyone with access to the Dockerfile or the built image can easily retrieve this password.
RUN echo "root:root" | chpasswd

# Give permissions to the new 'github' user for the working directory
RUN chown -R github:github /home/github/actions-runner

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER github

ENTRYPOINT ["/entrypoint.sh"]
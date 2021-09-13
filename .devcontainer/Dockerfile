# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.194.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version: bullseye, buster, stretch
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ARG FREGOT_VERSION
RUN wget "https://github.com/fugue/fregot/releases/download/${FREGOT_VERSION}/fregot-${FREGOT_VERSION}-linux-x86_64.tar.gz" \
  && tar -zxvf "fregot-${FREGOT_VERSION}-linux-x86_64.tar.gz" \
  && cd "fregot-${FREGOT_VERSION}-linux-x86_64" \
  && mv fregot /usr/local/bin \
  && cd .. \
  && rm -rf "fregot-${FREGOT_VERSION}-linux-x86_64"

ARG OPA_VERSION
RUN curl -L -o opa "https://openpolicyagent.org/downloads/${OPA_VERSION}/opa_linux_amd64_static" \
  && chmod 755 ./opa \
  && mv opa /usr/local/bin

ARG CONFTEST_VERSION
RUN wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" \
  && wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt" \
  && grep 'Linux_x86_64.tar.gz' < checksums.txt | sha256sum --check  --status \
  && tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest \
  && mv conftest /usr/local/bin \
  && rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" checksums.txt


# Install Terraform
ARG TERRAFORM_VERSION
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
  && grep "linux_amd64.zip" < "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check --status \
  && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && mv terraform /usr/local/bin/ \
  && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" 

COPY packages.txt ./
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && xargs apt-get -y --no-install-recommends install < packages.txt \
  && apt-get autoremove -y && apt-get clean -y 

# ** [Optional] Uncomment this section to install additional packages. **
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>




# Makefile to install Docker, KIND, OpenTofu, Cosign, kubectl, and Helm

# Variables
KUBECTL_VERSION = v1.30.3
KIND_VERSION = v0.20.0
COSIGN_VERSION = v2.4.0
TOFU_VERSION = v1.8.1
HELM_VERSION = v3.15.3

# Targets
.PHONY: all docker kind opentofu cosign kubectl helm

all: docker kind opentofu cosign kubectl helm

docker:
	@echo "Installing Docker..."
	@curl -fsSL https://get.docker.com -o get-docker.sh
	@sh get-docker.sh
	@sudo usermod -aG docker $$USER
	@rm get-docker.sh
	@echo "Docker installed successfully."

kind:
	@echo "Installing KIND..."
	@curl -Lo ./kind https://kind.sigs.k8s.io/dl/$(KIND_VERSION)/kind-linux-amd64
	@chmod +x ./kind
	@sudo mv ./kind /usr/local/bin/kind
	@echo "KIND installed successfully."

opentofu:
	@echo "Installing Tofu CLI..."
    @wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh
    @chmod +x install-opentofu.sh
    @sh install-opentofu.sh --install-method standalone
	@rm -f install-opentofu.sh
    @echo "Tofu CLI installed successfully."


cosign:
	@echo "Installing Cosign..."
	@curl -Lo ./cosign https://github.com/sigstore/cosign/releases/download/$(COSIGN_VERSION)/cosign-linux-amd64
	@chmod +x ./cosign
	@sudo mv ./cosign /usr/local/bin/cosign
	@echo "Cosign installed successfully."

kubectl:
	@echo "Installing kubectl..."
	@curl -LO "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl"
	@chmod +x ./kubectl
	@sudo mv ./kubectl /usr/local/bin/kubectl
	@echo "kubectl installed successfully."

helm:
	@echo "Installing Helm..."
	@curl -Lo helm.tar.gz https://get.helm.sh/helm-$(HELM_VERSION)-linux-amd64.tar.gz
	@tar -zxvf helm.tar.gz
	@sudo mv linux-amd64/helm /usr/local/bin/helm
	@rm -rf linux-amd64 helm.tar.gz
	@echo "Helm installed successfully."

clean:
	@echo "Cleaning up installed binaries..."
	@sudo rm -f /usr/local/bin/kind
	@sudo rm -f /usr/local/bin/opentofu
	@sudo rm -f /usr/local/bin/cosign
	@sudo rm -f /usr/local/bin/kubectl
	@sudo rm -f /usr/local/bin/helm
	@echo "Cleanup done."

help:
	@echo "Makefile to install Docker, KIND, OpenTofu, Cosign, kubectl, and Helm."
	@echo "Usage:"
	@echo "  make all          Install all tools."
	@echo "  make docker       Install Docker."
	@echo "  make kind         Install KIND."
	@echo "  make opentofu     Install OpenTofu."
	@echo "  make cosign       Install Cosign."
	@echo "  make kubectl      Install kubectl."
	@echo "  make helm         Install Helm."
	@echo "  make clean        Remove installed binaries."
	@echo "  make help         Display this help message."

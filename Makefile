LOCALSTACK_VERSION := 4.5.0
INSTALL_DIR := /usr/local/bin
BINARY := $(INSTALL_DIR)/localstack

LOCALSTACK_PORT := 4566
LOCALSTACK_URL := http://localhost:$(LOCALSTACK_PORT)


start: $(BINARY)
	@echo "➡️  Démarrage de localstack..."
	@$(BINARY) start --host $(LOCALSTACK_URL)

.PHONY: start

stop:
	@echo "➡️  Arrêt de localstack..."
	@$(BINARY) stop

.PHONY: stop

$(BINARY):
	@echo "➡️  Vérification de la présence du binaire localstack..."
	@if [ ! -f "$(BINARY)" ]; then \
		echo "❌ localstack not found. Installing..."; \
		ARCH=$$(uname -m); \
		if [ "$$ARCH" = "x86_64" ]; then \
			URL="https://github.com/localstack/localstack-cli/releases/download/v$(LOCALSTACK_VERSION)/localstack-cli-$(LOCALSTACK_VERSION)-linux-amd64-onefile.tar.gz"; \
		elif [ "$$ARCH" = "aarch64" ] || [ "$$ARCH" = "arm64" ]; then \
			URL="https://github.com/localstack/localstack-cli/releases/download/v$(LOCALSTACK_VERSION)/localstack-cli-$(LOCALSTACK_VERSION)-linux-arm64-onefile.tar.gz"; \
		else \
			echo "❌ Unsupported architecture: $$ARCH"; \
			exit 1; \
		fi; \
		curl --location --output localstack.tar.gz $$URL; \
		sudo tar xvzf localstack.tar.gz -C $(INSTALL_DIR); \
		rm -f localstack.tar.gz; \
		echo "✅ localstack installed in $(BINARY)"; \
	else \
		echo "✅ localstack already installed in $(BINARY)"; \
	fi


VENV_DIR := .venv
PYTHON := $(VENV_DIR)/bin/python
PIP := $(VENV_DIR)/bin/pip
TFLOCAL := $(shell pwd)/$(VENV_DIR)/bin/tflocal

$(TFLOCAL):
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "➡️ Creating python virtualenv..."; \
		python3 -m venv $(VENV_DIR); \
		$(PIP) install --upgrade pip; \
	fi
	@if ! $(PIP) show terraform-local > /dev/null 2>&1; then \
		echo "➡️ Installing terraform-local in virtualenv..."; \
		$(PIP) install terraform-local; \
	else \
		echo "✅ terraform-local already installed in virtualenv"; \
	fi

.PHONY: terraform-local


tests: $(TFLOCAL) setup_localstack
	@echo "➡️  Testing all modules..."
	@TF_LOCAL=$(TFLOCAL) go test -v ./infra/modules/... -count=1


.PHONY: tests

setup_localstack: $(BINARY)
	@echo "➡️  Checking LocalStack status..."
	@if curl -s --fail $(LOCALSTACK_URL) > /dev/null; then \
		echo "✅ LocalStack API is up."; \
	else \
		echo "❌ LocalStack not responding. Starting it..."; \
		$(MAKE) start; \
		for i in {1..10}; do \
			if curl -s --fail $(LOCALSTACK_URL) > /dev/null; then \
				echo "✅ LocalStack API is up."; \
				break; \
			else \
				echo "⏳ Waiting for LocalStack to start..."; \
				sleep 2; \
			fi; \
		done; \
		if ! curl -s --fail $(LOCALSTACK_URL) > /dev/null; then \
			echo "❌ LocalStack failed to start."; \
			exit 1; \
		fi; \
	fi

.PHONY: setup_localstack

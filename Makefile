.PHONY: all init plan apply destroy clean help

# Кольори для виводу
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

# Змінні
GITOPS_ENGINE ?= argocd
ENVIRONMENT ?= dev

# Модулі в порядку розгортання
MODULES = vpc eks karpenter gitops security monitoring workloads

help: ## Показати це повідомлення з допомогою
	@echo ''
	@echo 'Використання:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Доступні команди:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${YELLOW}%-15s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Ініціалізувати всі terraform модулі
	@for module in $(MODULES); do \
		echo "${GREEN}Initializing $$module...${RESET}" && \
		cd terraform/$$module && terraform init && cd ../../; \
	done

plan: ## Показати план змін для всіх модулів
	@for module in $(MODULES); do \
		echo "${GREEN}Planning $$module...${RESET}" && \
		cd terraform/$$module && terraform plan && cd ../../; \
	done

apply: ## Застосувати всі модулі в правильному порядку
	@for module in $(MODULES); do \
		echo "${GREEN}Applying $$module...${RESET}" && \
		cd terraform/$$module && \
		if [ "$$module" = "gitops" ]; then \
			terraform apply -var="gitops_engine=$(GITOPS_ENGINE)" -auto-approve; \
		else \
			terraform apply -auto-approve; \
		fi && \
		cd ../../; \
	done
	@echo "${GREEN}Applying Kubernetes manifests...${RESET}"
	kubectl apply -f terraform/workloads/app.yaml
	kubectl apply -f terraform/workloads/external-secret.yaml

destroy: ## Знищити всю інфраструктуру (в зворотньому порядку)
	@echo "${YELLOW}Warning: This will destroy all resources. Are you sure? (y/N)${RESET}" && read ans && [ $${ans:-N} = y ]
	@for module in $(shell echo "$(MODULES)" | tr ' ' '\n' | tac); do \
		echo "${GREEN}Destroying $$module...${RESET}" && \
		cd terraform/$$module && terraform destroy -auto-approve && cd ../../; \
	done

clean: ## Очистити всі локальні terraform файли
	@find . -type d -name ".terraform" -exec rm -rf {} +
	@find . -type f -name ".terraform.lock.hcl" -delete
	@find . -type f -name "terraform.tfstate*" -delete

validate: ## Перевірити конфігурацію всіх модулів
	@for module in $(MODULES); do \
		echo "${GREEN}Validating $$module...${RESET}" && \
		cd terraform/$$module && terraform validate && cd ../../; \
	done

fmt: ## Форматувати всі terraform файли
	@for module in $(MODULES); do \
		echo "${GREEN}Formatting $$module...${RESET}" && \
		cd terraform/$$module && terraform fmt && cd ../../; \
	done

status: ## Показати статус кластера
	@echo "${GREEN}Cluster Info:${RESET}"
	@kubectl cluster-info
	@echo "\n${GREEN}Nodes:${RESET}"
	@kubectl get nodes
	@echo "\n${GREEN}Pods:${RESET}"
	@kubectl get pods -A

logs: ## Показати логи системних подів
	@kubectl logs -n monitoring -l app=prometheus -f

# За замовчуванням показуємо help
all: help 
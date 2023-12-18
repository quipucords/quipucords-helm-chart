#
# Makefile for the Discovery Helm chart.
#

test_password = "testpassword1"

all:	help

dry-run:
	@helm install --generate-name --dry-run --debug ./discovery --set server.password="$(test_password)"

install:
	@if test -n "${SERVER_PASSWORD}"; then \
	  if test -n "${NAME}"; then \
	    helm install "${NAME}" ./discovery --set server.password="${SERVER_PASSWORD}"; \
	  else \
	    helm install discovery ./discovery --set server.password="${SERVER_PASSWORD}"; \
	  fi \
	else \
	  if test -n "${NAME}"; then \
	    helm install "${NAME}" ./discovery; \
	  else \
	    helm install discovery ./discovery; \
	  fi \
	fi

install-unique:
	@if test -n "${SERVER_PASSWORD}"; then \
	  helm install --generate-name ./discovery --set server.password="${SERVER_PASSWORD}"; \
	else \
	  helm install --generate-name ./discovery; \
	fi

lint:
	@helm lint ./discovery --set server.password="$(test_password)"

ls:
	@helm list --filter '^discovery'

uninstall:
	@if test -n "${NAME}"; then \
	   helm uninstall "${NAME}"; \
	else \
	   helm uninstall discovery; \
	fi

create-pull-secret:
	@pull_secret="discovery-pull-secret"; \
	default="quay.io"; \
	reg_server=$$(read -p "Registry server - $$default: " server; echo $$server); \
	reg_server=$${reg_server:-$$default}; \
	\
	default="$$(whoami)"; \
	reg_username=$$(read -p "Registry username - $$default: " username; echo $$username); \
	reg_username=$${reg_username:-$$default}; \
	\
	reg_password=$$(read -s -p "Registry password: " pwd; echo $$pwd); \
	stty echoe; echo; \
	\
	default="$${reg_username}@redhat.com"; \
	reg_email=$$(read -p "Registry user e-mail - $$default: " email; echo $$email); \
	reg_email=$${reg_email:-$$default}; \
	\
	echo "Creating $${reg_server} $${pull_secret} for $${reg_username} ..."; \
	oc delete secret/$${pull_secret} --ignore-not-found=true; \
	oc create secret docker-registry $${pull_secret} --docker-server="$${reg_server}" --docker-username="$${reg_username}" --docker-password="$${reg_password}" --docker-email="$${reg_email}"

help:
	@echo "Makefile for the Discovery Helm Chart."
	@echo ""
	@echo "Make targets:"
	@echo "  help                       Shows this output."
	@echo "  create-pull-secret         Creates a Discovery image pull secret."
	@echo "  dry-run                    Does a dry-run Installation and sends generated object to standard output."
	@echo "  install <params>           Installs Discovery onto the current namespace."
	@echo "     <params> = NAME=... SERVER_PASSWORD=..."
	@echo ""
	@echo "  install-unique <params>    Installs Discovery with a unique generated name onto the current namespace."
	@echo "     <params> = SERVER_PASSWORD=..."
	@echo ""
	@echo "  lint                       Run Lint against the Discovery Chart"
	@echo "  ls                         Show the installed Discovery helm charts."
	@echo "  uninstall <params>         Uninstalls Discovery from the current namespace."
	@echo "     <params> = NAME=..."


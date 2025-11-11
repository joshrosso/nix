.PHONY: rebuild update clean check-host help

# Default target
.DEFAULT_GOAL := rebuild

# Detect the current hostname
HOST_NAME := $(shell hostname)

# Validate that the host directory and flake exist
check-host:
	@if [ ! -d "$(HOST_NAME)" ]; then \
		echo "Error: No directory found for hostname '$(HOST_NAME)'"; \
		echo "Please create a directory and flake configuration for this host"; \
		exit 1; \
	fi
	@if [ ! -f "$(HOST_NAME)/flake.nix" ]; then \
		echo "Error: No flake.nix found in $(HOST_NAME)/"; \
		echo "Please create a flake configuration for this host"; \
		exit 1; \
	fi

rebuild: check-host
	@echo "Running: cd $(HOST_NAME) && sudo nixos-rebuild switch --flake .#$(HOST_NAME)"
	@cd $(HOST_NAME) && sudo nixos-rebuild switch --flake .#$(HOST_NAME)

update: check-host
	@echo "Running: cd $(HOST_NAME) && nix flake update"
	@cd $(HOST_NAME) && nix flake update

clean: check-host
	@echo "Running: nix store gc --verbose"
	@nix store gc --verbose

help:
	@echo "NixOS Configuration Makefile"
	@echo ""
	@echo "Detected hostname: $(HOST_NAME)"
	@echo ""
	@echo "Available targets:"
	@echo "  rebuild (default) - Rebuild and switch NixOS configuration"
	@echo "  update            - Update flake dependencies"
	@echo "  clean             - Run garbage collection on the Nix store"
	@echo "  help              - Show this help message"

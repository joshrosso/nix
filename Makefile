.PHONY: rebuild help

# Default target
.DEFAULT_GOAL := rebuild

# Detect the current hostname
HOST_NAME := $(shell hostname)

rebuild:
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
	@echo "Running: cd $(HOST_NAME) && sudo nixos-rebuild switch --flake .#$(HOST_NAME)"
	@cd $(HOST_NAME) && sudo nixos-rebuild switch --flake .#$(HOST_NAME)

help:
	@echo "NixOS Configuration Makefile"
	@echo ""
	@echo "Detected hostname: $(HOST_NAME)"
	@echo ""
	@echo "Available targets:"
	@echo "  rebuild (default) - Rebuild and switch NixOS configuration"
	@echo "  help              - Show this help message"

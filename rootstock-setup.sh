#!/bin/bash

# Target Foundry version
TARGET_VERSION="20b3da1"

# Function to install Rust if not installed
install_rust() {
    echo "Rust is not installed. Please install it by running:"
    echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
}

# Function to install Foundry at the target version
install_foundry() {
    echo "Installing Foundry version $TARGET_VERSION..."
    rm -rf ~/.foundry  # Remove previous Foundry installation if present
    curl -L https://foundry.paradigm.xyz | bash
    foundryup -C "$TARGET_VERSION"

    # Verify installation
    if command -v forge &> /dev/null; then
        echo "Foundry successfully installed at version $(forge --version | awk '{print $3}')."
    else
        echo "Foundry installation failed. Please check for errors."
        exit 1
    fi
}

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
    install_rust
else
    echo "Rust is installed: $(rustc --version)"
fi

# Check if Foundry is installed, then remove and reinstall if needed
if [ -d "$HOME/.foundry" ]; then
    echo "Found existing Foundry installation. Removing it..."
    install_foundry
else
    echo "No existing Foundry installation found. Installing Foundry..."
    install_foundry
fi

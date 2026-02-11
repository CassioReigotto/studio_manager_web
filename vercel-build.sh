#!/bin/bash
set -e

# Baixa o Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Adiciona o Flutter ao PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Mostra versão (debug)
flutter --version

# Build web
flutter build web

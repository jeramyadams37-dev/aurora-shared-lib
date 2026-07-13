#!/bin/bash
#
# install.sh — Aurora Shared Lib universal installer
#
# Pulls any combination of modules directly into the current project
# with ONE command, no manual copy-paste required.
#
# Usage (run from inside your project folder):
#
#   curl -sL https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main/install.sh | bash -s -- gemini
#   curl -sL https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main/install.sh | bash -s -- gemini ci secrets build
#   curl -sL https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main/install.sh | bash -s -- all
#
# Modules:
#   gemini   -> src/lib/geminiClient.js
#   ci       -> .github/workflows/android.yml
#   secrets  -> lib/secrets_loader.py + .env.example + .gitignore entry
#   build    -> scripts/build_apk.sh
#   all      -> installs everything above

set -e

REPO_RAW="https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main"

install_gemini() {
  mkdir -p src/lib
  curl -sL "$REPO_RAW/gemini/geminiClient.js" -o src/lib/geminiClient.js
  echo "✅ Installed src/lib/geminiClient.js"
}

install_ci() {
  mkdir -p .github/workflows
  curl -sL "$REPO_RAW/ci-templates/android.yml" -o .github/workflows/android.yml
  echo "✅ Installed .github/workflows/android.yml — remember: this expects an npm run build script in package.json"
}

install_secrets() {
  mkdir -p lib
  curl -sL "$REPO_RAW/secrets/secrets_loader.py" -o lib/secrets_loader.py
  if [ ! -f .env ]; then
    touch .env
  fi
  if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo ".env" >> .gitignore
  fi
  echo "✅ Installed lib/secrets_loader.py (+ ensured .env is gitignored)"
}

install_build() {
  mkdir -p scripts
  curl -sL "$REPO_RAW/build-scripts/build_apk.sh" -o scripts/build_apk.sh
  chmod +x scripts/build_apk.sh
  echo "✅ Installed scripts/build_apk.sh"
}

if [ "$#" -eq 0 ]; then
  echo "Usage: install.sh [gemini] [ci] [secrets] [build] [all]"
  exit 1
fi

for module in "$@"; do
  case "$module" in
    gemini)  install_gemini ;;
    ci)      install_ci ;;
    secrets) install_secrets ;;
    build)   install_build ;;
    all)     install_gemini; install_ci; install_secrets; install_build ;;
    *)       echo "⚠️  Unknown module: $module (skipping)" ;;
  esac
done

echo ""
echo "Done. Modules installed for this project."

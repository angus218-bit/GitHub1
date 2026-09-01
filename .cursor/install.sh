#!/usr/bin/env bash
# Idempotent environment bootstrap for the Copilot Performance System.
#
# Installs the documentation/config validation toolchain used by
# scripts/validate.sh. Safe to run repeatedly: each tool is pinned and
# only (re)installed to a user-writable location. No shell profiles are
# mutated; scripts/validate.sh adds these directories to PATH at runtime.
set -euo pipefail

YAMLLINT_VERSION="1.35.1"
MARKDOWNLINT_CLI_VERSION="0.42.0"
ACTIONLINT_VERSION="1.7.7"

NPM_PREFIX="${HOME}/.npm-global"
LOCAL_BIN="${HOME}/.local/bin"
mkdir -p "${LOCAL_BIN}"
export PATH="${LOCAL_BIN}:${NPM_PREFIX}/bin:${PATH}"

echo "==> Installing yamllint ${YAMLLINT_VERSION} (pip)"
python3 -m pip install --user --break-system-packages --quiet \
  "yamllint==${YAMLLINT_VERSION}"

echo "==> Installing markdownlint-cli ${MARKDOWNLINT_CLI_VERSION} (npm)"
npm config set prefix "${NPM_PREFIX}" >/dev/null
npm install -g --silent "markdownlint-cli@${MARKDOWNLINT_CLI_VERSION}"

echo "==> Installing actionlint ${ACTIONLINT_VERSION} (binary)"
if [ "$("${LOCAL_BIN}/actionlint" --version 2>/dev/null | head -1)" != "${ACTIONLINT_VERSION}" ]; then
  tmp="$(mktemp -d)"
  curl -fsSL \
    "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz" \
    -o "${tmp}/actionlint.tar.gz"
  tar -xzf "${tmp}/actionlint.tar.gz" -C "${tmp}" actionlint
  install -m 0755 "${tmp}/actionlint" "${LOCAL_BIN}/actionlint"
  rm -rf "${tmp}"
fi

if [ -f apps/demo/package.json ]; then
  echo "==> Installing apps/demo dependencies"
  npm ci --prefix apps/demo
fi
if [ -f apps/family-hearth/package.json ]; then
  echo "==> Installing apps/family-hearth dependencies"
  npm ci --prefix apps/family-hearth
fi

echo "==> Toolchain versions:"
echo "    yamllint      $(yamllint --version 2>&1)"
echo "    markdownlint  $(markdownlint --version 2>&1)"
echo "    actionlint    $("${LOCAL_BIN}/actionlint" --version 2>&1 | head -1)"
echo "==> install.sh complete"

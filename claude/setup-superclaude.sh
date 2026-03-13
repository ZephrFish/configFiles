#!/usr/bin/env bash
# setup-superclaude.sh — Install SuperClaude command framework on any host
#
# @decision DEC-SC-SETUP-001
# @title Cross-host SuperClaude setup via pipx + git clone
# @status accepted
# @rationale SuperClaude installs via pipx (for the CLI) and uses `superclaude install`
#   to populate ~/.claude/commands/sc/ with 31 slash commands. This script handles
#   the full pipeline: clone, pipx install, command install, and doctor check.
#
# Usage:
#   bash ~/tools/configFiles/claude/setup-superclaude.sh
#
# Override clone location:
#   SUPERCLAUDE_HOME=/opt/superclaude bash setup-superclaude.sh

set -euo pipefail

SUPERCLAUDE_HOME="${SUPERCLAUDE_HOME:-$HOME/tools/SuperClaude}"
CLAUDE_DIR="${HOME}/.claude"

# ─── Preflight ────────────────────────────────────────────────────────

echo "=== SuperClaude Setup ==="
echo "SUPERCLAUDE_HOME: ${SUPERCLAUDE_HOME}"
echo ""

if [[ ! -d "${CLAUDE_DIR}" ]]; then
    echo "[ERROR] ~/.claude not found. Install Claude Code first."
    exit 1
fi

# ─── Dependencies ─────────────────────────────────────────────────────

echo "--- Dependencies ---"
MISSING=false

for tool in python3 pipx; do
    if command -v "$tool" &>/dev/null; then
        echo "[OK]       $tool"
    else
        echo "[MISSING]  $tool (required)"
        MISSING=true
    fi
done

echo ""
if [[ "$MISSING" == "true" ]]; then
    echo "[!] Install missing deps first:"
    echo "    macOS:  brew install python3 pipx"
    echo "    Linux:  pip install pipx && pipx ensurepath"
    exit 1
fi

# ─── Clone Repo ───────────────────────────────────────────────────────

if [[ ! -d "${SUPERCLAUDE_HOME}/.git" ]]; then
    echo "--- Cloning SuperClaude ---"
    mkdir -p "$(dirname "${SUPERCLAUDE_HOME}")"
    git clone https://github.com/NomenAK/SuperClaude.git "${SUPERCLAUDE_HOME}"
else
    echo "--- Updating SuperClaude repo ---"
    git -C "${SUPERCLAUDE_HOME}" pull origin master 2>&1 || echo "[WARN] Pull failed, continuing with existing version"
fi

# ─── Install via pipx ────────────────────────────────────────────────

echo ""
echo "--- Installing via pipx ---"

if pipx list 2>/dev/null | grep -q superclaude; then
    echo "SuperClaude already in pipx, upgrading..."
    pipx upgrade superclaude 2>&1 || echo "[WARN] Upgrade failed, may already be latest"
else
    echo "Installing SuperClaude via pipx..."
    pipx install superclaude 2>&1
fi

echo ""
superclaude version 2>&1

# ─── Install Commands ────────────────────────────────────────────────

echo ""
echo "--- Installing commands ---"
superclaude update 2>&1

# ─── Health Check ─────────────────────────────────────────────────────

echo ""
echo "--- Health check ---"
superclaude doctor 2>&1

# ─── Done ─────────────────────────────────────────────────────────────

echo ""
INSTALLED=$(ls "${CLAUDE_DIR}/commands/sc/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "=== Done: ${INSTALLED} commands installed ==="
echo ""
echo "Commands: /sc:help to list all, /sc:sc to dispatch"
echo "Update:   pipx upgrade superclaude && superclaude update"
echo "Check:    superclaude doctor"

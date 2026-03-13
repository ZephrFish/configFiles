#!/usr/bin/env bash
# setup-raptor.sh — Install RAPTOR + global Claude Code commands on any host
#
# @decision DEC-RAPTOR-SETUP-001
# @title Cross-host RAPTOR setup script generating global Claude Code commands
# @status accepted
# @rationale ~/.claude is not version-controlled, so wrapper commands must be
#   generated on each host. This script auto-clones the repo if missing, checks
#   deps, and writes 12 raptor-prefixed command files that use the subshell
#   pattern ( cd RAPTOR_HOME && ... ) for correct Python import resolution.
#   Safe to re-run: skips non-RAPTOR files to avoid overwriting user commands.
#
# Usage (on a new host):
#   1. Ensure Claude Code is installed (~/.claude/ exists)
#   2. Copy this script to the host, or:
#      scp ~/.claude/scripts/setup-raptor.sh user@host:~/.claude/scripts/
#   3. bash ~/.claude/scripts/setup-raptor.sh
#
# The script will clone RAPTOR to ~/tools/raptor if not present.
# Override with: RAPTOR_HOME=/other/path bash setup-raptor.sh

set -euo pipefail

RAPTOR_HOME="${RAPTOR_HOME:-$HOME/tools/raptor}"
CLAUDE_COMMANDS="${HOME}/.claude/commands"

# ─── Preflight ────────────────────────────────────────────────────────

echo "=== RAPTOR Global Setup ==="
echo "RAPTOR_HOME: ${RAPTOR_HOME}"
echo "Commands dir: ${CLAUDE_COMMANDS}"
echo ""

if [[ ! -f "${RAPTOR_HOME}/raptor.py" ]]; then
    echo "[!] raptor.py not found at ${RAPTOR_HOME}"
    echo "    Cloning repo..."
    mkdir -p "$(dirname "${RAPTOR_HOME}")"
    git clone https://github.com/gadievron/raptor.git "${RAPTOR_HOME}"
fi

if [[ ! -d "${HOME}/.claude" ]]; then
    echo "[ERROR] ~/.claude not found. Install Claude Code first."
    exit 1
fi

mkdir -p "${CLAUDE_COMMANDS}"

# ─── Dependency Check ─────────────────────────────────────────────────

echo "--- Dependencies ---"
MISSING_REQ=false

for tool in semgrep python3; do
    if command -v "$tool" &>/dev/null; then
        echo "[OK]       $tool"
    else
        echo "[MISSING]  $tool (required)"
        MISSING_REQ=true
    fi
done

for tool in codeql afl-fuzz; do
    if command -v "$tool" &>/dev/null; then
        echo "[OK]       $tool"
    else
        echo "[OPTIONAL] $tool"
    fi
done

echo ""
if [[ "$MISSING_REQ" == "true" ]]; then
    echo "[!] Install missing required deps:"
    echo "    macOS:  brew install semgrep python3"
    echo "    Linux:  pip install semgrep"
    echo ""
fi

# ─── Write Commands ───────────────────────────────────────────────────

echo "--- Creating commands ---"

write_cmd() {
    local name="$1" content="$2"
    local target="${CLAUDE_COMMANDS}/${name}.md"
    if [[ -f "$target" ]] && ! grep -q "RAPTOR_HOME" "$target" 2>/dev/null; then
        echo "[SKIP] ${name}.md (non-RAPTOR file exists)"
        return
    fi
    printf '%s\n' "$content" > "$target"
    echo "[OK]   ${name}.md"
}

RH="${RAPTOR_HOME}"

write_cmd "raptor" "# RAPTOR - Security Testing Assistant (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`
**IMPORTANT:** All RAPTOR Python commands MUST be run from RAPTOR_HOME using a subshell:
\`\`\`bash
( cd ${RH} && python3 raptor.py <subcommand> [args] )
\`\`\`

## Modes

| Mode | Command | Use When |
|------|---------|----------|
| Agentic | \`( cd ${RH} && python3 raptor.py agentic --repo <path> )\` | Full autonomous scan + exploit + patch |
| Scan | \`( cd ${RH} && python3 raptor.py scan --repo <path> )\` | Quick Semgrep scan |
| CodeQL | \`( cd ${RH} && python3 raptor.py codeql --repo <path> )\` | Deep static analysis |
| Fuzz | \`( cd ${RH} && python3 raptor.py fuzz --binary <path> --duration <s> )\` | Binary fuzzing |
| Web | \`( cd ${RH} && python3 raptor.py web --url <url> )\` | Web app testing (alpha) |
| Analyze | \`( cd ${RH} && python3 raptor.py analyze --repo <path> --sarif <file> )\` | LLM analysis of SARIF |

## Intent Mapping
- \"scan this code\" -> agentic mode
- \"fuzz this binary\" -> fuzz mode
- \"test this website\" -> web mode
- \"check for secrets\" -> scan with \`--policy_groups secrets\`

## Output
Results go to \`${RH}/out/\`. Skills/agents at \`${RH}/.claude/\`. Tiers at \`${RH}/tiers/\`.

## Sub-commands
/raptor-scan, /raptor-agentic, /raptor-fuzz, /raptor-web, /raptor-codeql, /raptor-analyze,
/raptor-validate, /raptor-exploit, /raptor-patch, /raptor-crash-analysis, /raptor-oss-forensics"

write_cmd "raptor-scan" "# RAPTOR Security Scanner (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

Full autonomous: \`( cd ${RH} && python3 raptor.py agentic --repo <path> )\`
Quick Semgrep: \`( cd ${RH} && python3 raptor.py scan --repo <path> )\`
CodeQL only: \`( cd ${RH} && python3 raptor.py codeql --repo <path> )\`
With policies: \`( cd ${RH} && python3 raptor.py scan --repo <path> --policy_groups secrets,owasp )\`

Always use absolute paths. Output: \`${RH}/out/\`"

write_cmd "raptor-agentic" "# RAPTOR Full Autonomous Workflow (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

Autonomously: Semgrep/CodeQL scan -> LLM analysis -> exploit PoCs -> secure patches.
Nothing applied to your code — generated in \`${RH}/out/\`.

Execute: \`( cd ${RH} && python3 raptor.py agentic --repo <path> )\`"

write_cmd "raptor-fuzz" "# RAPTOR Binary Fuzzer (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

Basic (110 min): \`( cd ${RH} && python3 raptor.py fuzz --binary <path> --duration 6600 )\`
Quick (10 min): \`( cd ${RH} && python3 raptor.py fuzz --binary <path> --duration 600 --max-crashes 5 )\`
With corpus: \`( cd ${RH} && python3 raptor.py fuzz --binary <path> --corpus <seeds> --duration 3600 )\`

macOS fix: \`sudo afl-system-config\`
Output: \`${RH}/out/fuzz_<binary>_<timestamp>/\`"

write_cmd "raptor-web" "# RAPTOR Web Scanner (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

WARNING: Alpha/stub.

\`( cd ${RH} && python3 raptor.py web --url <url> )\`

Only scan authorized targets."

write_cmd "raptor-codeql" "# RAPTOR CodeQL Analysis (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

\`( cd ${RH} && python3 raptor.py codeql --repo <path> )\`

Deep static analysis with dataflow validation. Slower but finds complex vulns."

write_cmd "raptor-analyze" "# RAPTOR LLM Analysis (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

\`( cd ${RH} && python3 raptor.py analyze --repo <path> --sarif <sarif-file> )\`

Analyze existing SARIF findings with LLM."

write_cmd "raptor-validate" "# RAPTOR Exploitability Validation (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`
**Skills:** \`${RH}/.claude/skills/exploitability-validation/\`

You (Claude) ARE the LLM. Execute stages: 0 -> A -> B -> C -> D -> E.

Python imports: \`import sys; sys.path.insert(0, '${RH}')\`

Usage: \`/raptor-validate <target_path> [--vuln-type <type>] [--findings <file>]\`
Output: \`${RH}/out/exploitability-validation-<timestamp>/\`"

write_cmd "raptor-exploit" "# RAPTOR Exploit PoC Generator (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

Pre-check: \`import sys; sys.path.insert(0, '${RH}'); from packages.exploitation import exploit_bootstrap\`

Run: \`( cd ${RH} && python3 raptor.py agentic --repo <path> --sarif <file> --no-patches --max-findings <N> )\`

Educational/research purposes only."

write_cmd "raptor-patch" "# RAPTOR Patch Generator (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`

\`( cd ${RH} && python3 raptor.py agentic --repo <path> --sarif <file> --no-exploits --max-findings <N> )\`

Review patches before applying."

write_cmd "raptor-crash-analysis" "# RAPTOR Crash Analysis (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`
**Skills:** \`${RH}/.claude/skills/crash-analysis/\`
**Agents:** \`${RH}/.claude/agents/\`

Usage: \`/raptor-crash-analysis <bug-tracker-url> <git-repo-url>\`

Requirements: rr, gcc/clang (ASAN), gdb, gcov"

write_cmd "raptor-oss-forensics" "# RAPTOR OSS Forensics (Global Wrapper)

**RAPTOR_HOME:** \`${RH}\`
**Skills:** \`${RH}/.claude/skills/oss-forensics/\`
**Agents:** \`${RH}/.claude/agents/\`

1. Read: \`${RH}/.claude/skills/oss-forensics/orchestration/SKILL.md\`
2. Follow workflow exactly

Requirements: GOOGLE_APPLICATION_CREDENTIALS, internet access
Output: \`${RH}/.out/oss-forensics-{timestamp}/\`"

# ─── Done ─────────────────────────────────────────────────────────────

echo ""
INSTALLED=$(ls "${CLAUDE_COMMANDS}"/raptor*.md 2>/dev/null | wc -l | tr -d ' ')
echo "=== Done: ${INSTALLED} commands installed ==="
echo ""
echo "Usage: /raptor, /raptor-scan, /raptor-agentic, /raptor-fuzz, etc."
echo "Update: cd ${RH} && git pull && bash ~/.claude/scripts/setup-raptor.sh"

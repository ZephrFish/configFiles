# Claude Code Portability

Setup scripts and configuration for replicating the Claude Code environment across hosts.

## Directory Contents

| File | Purpose |
|------|---------|
| `setup-raptor.sh` | Install RAPTOR security framework + 12 global slash commands |
| `setup-superclaude.sh` | Install SuperClaude command framework + 31 `/sc:*` commands |
| `lab-controller/` | MCP server for SSH/WinRM multi-host lab control |

## Quick Start (New Host)

### Prerequisites

1. [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed (`~/.claude/` exists)
2. Git, Python 3
3. Platform package manager (Homebrew on macOS, apt/pip on Linux)

### RAPTOR Setup

RAPTOR is an autonomous security testing framework (Semgrep + CodeQL + AFL++ + LLM analysis).

```bash
# Clone this repo (if not already present)
git clone https://github.com/ZephrFish/configFiles.git ~/tools/configFiles

# Run the RAPTOR setup script
bash ~/tools/configFiles/claude/setup-raptor.sh
```

This will:
- Clone [gadievron/raptor](https://github.com/gadievron/raptor) to `~/tools/raptor` (if not present)
- Check dependencies (semgrep, python3, codeql, afl-fuzz)
- Create 12 global `/raptor-*` slash commands in `~/.claude/commands/`
- Skip any existing non-RAPTOR commands to avoid conflicts

#### RAPTOR Dependencies

| Tool | Required | Install (macOS) | Install (Linux) |
|------|----------|-----------------|-----------------|
| semgrep | Yes | `brew install semgrep` | `pip install semgrep` |
| python3 | Yes | `brew install python3` | `apt install python3` |
| codeql | Optional | `brew install codeql` | [GitHub releases](https://github.com/github/codeql-cli-binaries/releases) |
| afl-fuzz | Optional | `brew install aflplusplus` | `apt install afl++` |

#### RAPTOR Commands (after setup)

| Command | Description |
|---------|-------------|
| `/raptor` | Main dispatcher — routes to appropriate mode |
| `/raptor-scan` | Quick Semgrep static analysis |
| `/raptor-agentic` | Full autonomous workflow (scan + exploit + patch) |
| `/raptor-fuzz` | Binary fuzzing with AFL++ |
| `/raptor-web` | Web application scanning (alpha) |
| `/raptor-codeql` | Deep CodeQL dataflow analysis |
| `/raptor-analyze` | LLM analysis of existing SARIF files |
| `/raptor-validate` | Exploitability validation pipeline (6-stage) |
| `/raptor-exploit` | Exploit PoC generation |
| `/raptor-patch` | Secure patch generation |
| `/raptor-crash-analysis` | Crash root-cause analysis (rr + ASAN) |
| `/raptor-oss-forensics` | GitHub forensic investigation |

#### Custom RAPTOR_HOME

By default RAPTOR clones to `~/tools/raptor`. Override with:

```bash
RAPTOR_HOME=/opt/security/raptor bash ~/tools/configFiles/claude/setup-raptor.sh
```

All generated commands will use the custom path in their subshell patterns.

#### Updating RAPTOR

```bash
cd ~/tools/raptor && git pull
bash ~/tools/configFiles/claude/setup-raptor.sh
```

### SuperClaude Setup

SuperClaude is a command framework that adds 31 `/sc:*` slash commands to Claude Code — structured workflows for analysis, implementation, design, testing, research, and project management.

```bash
bash ~/tools/configFiles/claude/setup-superclaude.sh
```

This will:
- Clone [NomenAK/SuperClaude](https://github.com/NomenAK/SuperClaude) to `~/tools/SuperClaude` (if not present)
- Install the `superclaude` CLI via pipx
- Run `superclaude update` to install 31 commands to `~/.claude/commands/sc/`
- Run `superclaude doctor` to verify health

#### SuperClaude Dependencies

| Tool | Required | Install (macOS) | Install (Linux) |
|------|----------|-----------------|-----------------|
| python3 | Yes | `brew install python3` | `apt install python3` |
| pipx | Yes | `brew install pipx` | `pip install pipx` |

#### SuperClaude Commands (31 total, all under `/sc:*`)

| Category | Commands |
|----------|----------|
| **Analysis** | `/sc:analyze`, `/sc:explain`, `/sc:reflect`, `/sc:recommend` |
| **Implementation** | `/sc:implement`, `/sc:build`, `/sc:test`, `/sc:cleanup`, `/sc:improve` |
| **Design** | `/sc:design`, `/sc:spec-panel`, `/sc:business-panel`, `/sc:brainstorm` |
| **Research** | `/sc:research`, `/sc:index`, `/sc:index-repo` |
| **Workflow** | `/sc:workflow`, `/sc:task`, `/sc:spawn`, `/sc:estimate` |
| **Documentation** | `/sc:document` |
| **Project** | `/sc:pm`, `/sc:git`, `/sc:agent` |
| **Session** | `/sc:load`, `/sc:save`, `/sc:select-tool` |
| **Meta** | `/sc:sc` (dispatcher), `/sc:help`, `/sc:README` |

#### Custom SUPERCLAUDE_HOME

```bash
SUPERCLAUDE_HOME=/opt/superclaude bash ~/tools/configFiles/claude/setup-superclaude.sh
```

#### Updating SuperClaude

```bash
pipx upgrade superclaude && superclaude update
```

#### Doctor Check

```bash
superclaude doctor
```

Validates installation health, command integrity, and configuration.

### Lab Controller Setup

Lab Controller is an MCP server providing SSH/WinRM tools for instrumenting research across multiple hosts (Proxmox hypervisors, Windows DCs, Linux targets, etc.).

```bash
bash ~/tools/configFiles/claude/lab-controller/setup.sh

# Or with a custom hosts file:
bash ~/tools/configFiles/claude/lab-controller/setup.sh /path/to/my-hosts.json
```

This will:
- Create a Python venv at `~/.claude/lab-controller/.venv/`
- Install dependencies (paramiko, pywinrm, mcp)
- Copy `server.py` to `~/.claude/lab-controller/`
- Wire the MCP server into `~/.claude/.mcp.json`
- Add tool permissions to `~/.claude/settings.json`

#### Configuration

Edit `~/.claude/lab-controller/hosts.json` to define your hosts:

```json
{
  "hosts": {
    "my-host": {
      "aliases": ["my-host", "myhost", "mh"],
      "host": "10.0.0.1",
      "username": "root",
      "type": "ssh",
      "platform": "proxmox",
      "capabilities": ["qm", "ludus"],
      "description": "My Proxmox hypervisor"
    }
  }
}
```

Or override the hosts file path with: `LAB_HOSTS_FILE=/path/to/hosts.json`

#### Lab Controller Tools (12)

| Tool | Description |
|------|-------------|
| `lab_connect` | Connect by alias — resolves to SSH/WinRM with platform context |
| `host_info` | Show registered hosts, aliases, capabilities |
| `ssh_connect` | Open named SSH session (paramiko) |
| `ssh_exec` | Run command on SSH host |
| `ssh_upload` | Upload file via SFTP |
| `ssh_download` | Download file via SFTP |
| `winrm_connect` | Register Windows host (NTLM/Kerberos) |
| `winrm_cmd` | Run cmd.exe on Windows host |
| `winrm_ps` | Run PowerShell on Windows host |
| `sessions_list` | Show all active sessions |
| `session_disconnect` | Close a session |
| `multi_exec` | Run same command across all hosts |

#### Alias Resolution

Aliases are fuzzy — hyphens, underscores, and case are normalized:
- `ultralab_proxmox`, `ultra-lab`, `UltraLab`, `ultra` all resolve to the same host
- `mde_lab`, `defender_lab`, `pve02` all resolve to PVE02

#### Subagent Integration

Sessions are shared across subagents. Connect hosts in the main conversation, then spawn parallel agents to execute on different hosts simultaneously:

```
Main:    lab_connect("pve02")  ->  lab_connect("ultra")
Agent A: ssh_exec("pve02", "qm list")
Agent B: ssh_exec("ultra-lab", "ludus range status")
```

## Architecture Notes

### Why Subshell Pattern? (RAPTOR)

RAPTOR's `raptor.py` uses relative Python imports (`from packages.`, `from core.`). Running it from another directory fails. The `( cd ~/tools/raptor && python3 raptor.py ... )` subshell pattern:
- Changes directory only for that command
- Leaves your shell's cwd unchanged
- Resolves all relative imports correctly

### Why raptor- Prefix?

The global `~/.claude/commands/` namespace is shared across all projects. Using `raptor-` prevents collision with existing commands (e.g., the existing `/scan` debt marker scanner is preserved).

### Why sc: Prefix? (SuperClaude)

SuperClaude uses the `sc:` namespace prefix, managed by the `superclaude` CLI. All 31 commands install to `~/.claude/commands/sc/` and are invoked as `/sc:<command>`.

### Hook Compatibility

Your global `~/.claude` hooks still govern all tool operations:
- `pre-bash.sh` — gates shell commands (Semgrep, AFL++, CodeQL, etc.)
- `pre-mcp.sh` — intercepts MCP tool calls
- `pre-write.sh` — enforces @decision annotations on generated files

### Full Install (New Host)

```bash
# 1. Clone configFiles
git clone https://github.com/ZephrFish/configFiles.git ~/tools/configFiles

# 2. Install RAPTOR (security scanning)
bash ~/tools/configFiles/claude/setup-raptor.sh

# 3. Install SuperClaude (command framework)
bash ~/tools/configFiles/claude/setup-superclaude.sh

# 4. Install Lab Controller (multi-host MCP)
bash ~/tools/configFiles/claude/lab-controller/setup.sh
```

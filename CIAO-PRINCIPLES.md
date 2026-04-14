# CIAO Defensive Programming Principles (v2.9.1)

**Original Author**: Cloudgen Wong (`cloudgen.wong@gmail.com`)  
**Widely adopted and extended by**: Wilgat Wong in projects such as `pix-client`, `poe-client`, `SyncPrjs`, `pomo`, `ChronicleLogger`, `certbot-nginx`, `mariadb-galera`, etc.

**CIAO** = **C**aution • **I**ntentional • **A**nti-fragile • **O**ver-engineered

---

## Purpose

CIAO is a defensive programming philosophy designed as the **best practice when working with AI**.  
It forces both AI and human developers to think beyond the immediate task — toward long-term robustness, security, auditability, traceability, and maximum compatibility across environments and user scenarios.

---

## Advantages of the CIAO Principle
Here’s why the CIAO principle is one of the best programming principles you can use today:

* Super safe and bug-resistant — It forces you (and AI) to check everything upfront, so crashes, security holes, and weird errors almost disappear.

* Perfect for AI agents — It is specifically designed as the best practice when working with AI. Tools like OpenClaw, GitHub Copilot, Claude, or any other AI coding assistant follow CIAO rules automatically, producing code that is safe, traceable, and compatible with real-world systems.

* Anti-fragile & future-proof — Your code survives updates, different operating systems, Docker, CI/CD pipelines, minimal servers, and unexpected user inputs.

* Easy to read and maintain — Even months later, you (or another developer, or an AI) can understand exactly what the code does and why.

* Built-in security & auditability — Every change is logged, backed up, and versioned, making it ideal for professional, enterprise, or open-source projects.

* Saves time in the long run — Less debugging, fewer hotfixes, and fewer “why did this break?” moments.

* Works with any language or platform — Python, Shell, JavaScript, Go, etc. — the CIAO principle is language-agnostic and environment-friendly.

In short: If you want code that works safely and well with AI agents such as OpenClaw, the CIAO principle is currently the best defensive programming approach available. It turns AI assistance from a risk into a superpower.

---
## CIAO vs SOLID Principles

CIAO and SOLID are both valuable but serve different purposes in modern software development.

**SOLID** (Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, Dependency Inversion) is a set of classic object-oriented design principles popularized by Robert C. Martin ("Uncle Bob"). It focuses on creating clean, flexible, and maintainable class structures in large-scale OOP systems.  
[Learn more about SOLID principles](https://en.wikipedia.org/wiki/SOLID) • [Robert C. Martin on SOLID](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html)

**CIAO** (Caution • Intentional • Anti-fragile • Over-engineered) is a defensive programming philosophy specifically designed as the **best practice when working with AI agents**. It emphasizes robustness, security, auditability, and resistance to careless modifications — whether by humans or AI tools like Grok, Claude, or OpenClaw.

### Quick Comparison

| Aspect                        | **SOLID Principles**                                      | **CIAO Defensive Principles**                                      |
|-------------------------------|-----------------------------------------------------------|--------------------------------------------------------------------|
| **Primary Focus**             | Clean, extensible OOP class design                        | Safety, resilience, and protection against errors/AI changes       |
| **Core Mindset**              | Make code flexible and easy to extend                     | Assume nothing, over-protect everything, make breakage loud        |
| **Best Suited For**           | Large-scale applications, libraries, frameworks           | Scripts, automation tools, AI-generated code, minimal environments |
| **Attitude Toward Change**    | Controlled extension without modification                 | Force backups, visible warnings, and explicit checks before changes |
| **Verbosity**                 | Prefers clean, abstract code                              | Intentionally verbose with headers, warnings, and traceability     |
| **Environment Awareness**     | Limited (mostly design-time)                              | Strong (pyenv, conda, venv, Docker, CI/CD, least-privilege, etc.)  |
| **AI Compatibility**          | General good design                                       | Explicitly built to work safely with AI coding assistants          |

### When to Use SOLID, CIAO, or Both

- Use **SOLID** when designing core application architecture, reusable libraries, or long-lived object models. It promotes low coupling and high cohesion.
- Use **CIAO** when writing scripts, deployment tools, DevOps automation, or any code that will be touched by AI agents or run in unpredictable real-world environments. Its principles (such as Least-Privilege User, Right Backup & Restore Strategy, Defensive Storage Location Handling, and Protect Against AI Modification) act as a strong safety net.
- **Best practice**: Combine both — apply SOLID for elegant high-level design and layer CIAO rules on top for runtime safety, auditability, and AI resilience.

In the age of AI-assisted coding, CIAO complements SOLID by addressing risks that traditional design principles do not fully cover: careless simplifications, environment quirks, missing backups, and accidental renaming of critical paths (e.g., cookies.* or storage locations).

**Related keywords**:  
[CIAO vs SOLID](https://github.com/cloudgen/ciao) • [defensive programming with AI](https://github.com/cloudgen/ciao) • [SOLID principles explained](https://en.wikipedia.org/wiki/SOLID) • **best programming principles for AI** • **AI-safe coding standards** • **defensive programming vs SOLID** • **anti-fragile software development** • **CIAO defensive principles** • **robust coding for AI agents**

---

## Core Principles

### 1. Caution (Defensive by Default)
- Assume nothing about the runtime environment, inputs, memory, permissions, or system state.
- Always add explicit checks for NULL, bounds, allocation failures, permission issues, etc.
- Provide safe, graceful fallbacks instead of crashes or silent failures.

### 2. Intentional Verbosity & Transparency
- Code must be deliberately verbose with clear section headers and comments.
- Every major function and component must include a **General Purpose** section explaining its objective.

### 3. Anti-fragile & Resilient Design
- Code should survive minimal environments, unexpected inputs, and edge cases.

### 4. Single Source of Output
- All program output (info, warnings, errors, debug) **must** go through centralized logging functions only.

### 5. Single Point of Entry
- Every major module or component should have a clear **Single Point of Entry** for initialization.

### 6. General Purpose Requirement
- Every public or reusable function must clearly state its **General Purpose**.

### 7. Reusable Function Protection
- Reusable functions must include this exact warning:

  ```text
  # !!! DO NOT MODIFY OR SIMPLIFY THIS FUNCTION !!!
  # Designed to be reusable in other projects.
  ```

### 8. Least-Privilege User *(New in v2.9.0)*
- Run operations with the **minimum permissions necessary**.
- Create and use a dedicated non-root user (e.g. `nginx-adm` in the `certbot-nginx` project) for day-to-day tasks.
- Give this user ownership of only the files/directories it needs (e.g. full ownership of the `/etc/nginx` config tree).
- Configure **restricted sudoers** that allow only specific safe commands (e.g. `systemctl start/stop/reload/restart/status nginx`) with `NOPASSWD`.
- Certain commands like `nginx -t` can be run directly as the least-privilege user (no sudo required) because it owns the configuration files.
- Strictly separate **system installation / setup** (which may require root) from **routine operations** (which must run as the least-privilege user).
- This significantly reduces the attack surface, prevents accidental or malicious privilege escalation, and makes the entire solution much safer — especially important for scripts that AI agents may read, modify, or extend.

### 9. Safe Temporary File Handling *(Strengthened in v2.9.1)*

- **Never assume** any temporary storage location exists, is writable, is mounted with exec permission, or has sufficient space.
- **Never** hard-code predictable temporary file or directory names (e.g. `/tmp/myapp.tmp`, `/tmp/.cache-$$`). This creates race conditions and symlink attacks (CWE-377).
- **Always** respect the standard `$TMPDIR` environment variable first.
- **Always** use the `mktemp` utility (or equivalent safe equivalent) to create unique, unpredictable, securely permissioned temporary files or directories.
- Prefer creating a **temporary directory** (`mktemp -d`) over individual files whenever multiple temporary items are needed.
- Implement a strict fallback chain when the primary location fails:
  1. `$TMPDIR` (if set and writable)
  2. `/tmp`
  3. `/var/tmp` (non-volatile fallback)
  4. `~/Library/Caches/` (macOS) or `$HOME/.cache/` (Linux)
  5. Current working directory (as last resort, with explicit warning)
- Explicitly test that the chosen location is writable and has enough space **before** use.
- Prefer **volatile** (RAM-based) storage such as `/dev/shm` (when available and appropriate) for performance-critical temporary data, but fall back gracefully if `/dev/shm` is not present or is mounted noexec.
- Always use **atomic write patterns**: write to a temporary file first, then `mv` (atomic on the same filesystem) to the final location.
- **Mandatory cleanup strategy**: Use `trap` to guarantee removal of all temporary files/directories on EXIT, ERR, INT, TERM, or any abnormal termination.
- Set a restrictive `umask 077` at the beginning of any script that creates temporary files.
- Log every temporary file creation, fallback event, and cleanup action through the centralized logging system (see Principle 4).
- In minimal environments (Docker, Alpine, chroot, CI/CD, noexec /tmp, read-only rootfs, full disk, etc.), the mechanism must still work without crashing and must provide clear diagnostic messages.

### 10. Right Backup & Restore Strategy *(Strengthened in v2.9.1)*

- **Before ANY** destructive, modifying, or state-changing operation (file edit, configuration change, package installation, database alteration, service restart, variable refactoring, path update, renaming, folder creation, etc.), **always** create a dated backup **first**.
- **Never** overwrite, delete, rename, or refactor the original without first creating a proper backup.
- Use **simple, clean, and consistent naming conventions** proven in real projects such as `certbot-nginx` and `SyncPrjs`.
- **Official CIAO backup naming conventions** (must be followed exactly):

  **For individual files:**
  ```
  <original-name>.YYYYMMDD-N.bak
  ```
  Example: `default.conf.20260408-1.bak` or `mariadb-galera.20260411-3.bak`

  **For folders** (especially cookie storage or project data directories):
  ```
  ~/.app/{full-project-name}.YYYYMMDD-N.bak/
  ```
  Example:  
  `~/.app/grok-iron.20260409-1.bak/cookies.sqlite`  
  `~/.app/cf-iron.20260409-2.bak/`  
  `~/.app/poe-1n4003.20260409-5.bak/`

  Where:
  - `YYYYMMDD` = current date (`$(date +%Y%m%d)`)
  - `-N` = incremental counter starting from 1 on the same day (to avoid overwriting same-day backups)
  - The backup must preserve the original structure inside the backup folder.

- **Explicitly protect critical naming patterns** (such as anything starting with `cookies.` or cookie storage paths under `~/.app/` from SyncPrjs and other projects): any backup must preserve the exact original prefix and path. **Never rename** such protected identifiers during backup or restore.
- Always store backups in the appropriate location (e.g. same directory for config files, or under `~/.app/` for project data).
- Create the backup directory if it does not exist, using correct permissions and respecting the Least-Privilege User principle (#8).
- **Log every backup creation and restore attempt** through the centralized logging system (Principle 4), including full source path, backup path, and reason.
- Provide clear restore instructions or a corresponding restore function.
- Use safe copy operations (copy first, then modify original).
- In non-interactive mode, create the backup automatically without prompting.
- In constrained environments, fail loudly if backup cannot be created.

### 11. Independent Three-Digit Versioning per Component
- Every class, module, or major component maintains its own independent `MAJOR.MINOR.PATCH` version.

### 12. Security & Traceability Reasons
- Strictly separate `stdout` (user-facing) and `stderr` (diagnostics).
- Support multiple log levels: ERROR, WARNING, INFO, DEBUG.
- Debug mode must be switchable via environment variable (e.g. `DEBUG=1`).

### 13. Support for Multiple Version Management Systems & Shells
- Be compatible with `sdkman`, `pyenv`, `conda`, `nvm`, `rbenv`, etc.
- Support multiple shells: `sh`, `dash`, `ash`, `bash`, `zsh`, `fish`, `Git Bash`, etc.

### 14. Interactive vs Non-Interactive Mode Awareness (New in v2.8)
- Always be aware of whether the program is running in **interactive** or **non-interactive** mode.
- Detect non-interactive environments (e.g., scripts, CI/CD, `curl | sh`, Docker builds, Ansible, etc.).
- When performing actions that normally require user input (e.g., package installation, database setup, confirmation prompts):
  - Provide safe defaults or automatic behavior in non-interactive mode.
  - Example: When installing MariaDB, use `--no-interactive`, `--yes`, or appropriate flags (`DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server`).
  - Never hang waiting for user input in non-interactive contexts.
- Support common non-interactive installation patterns such as `curl | sh` pipelines.
- Clearly document how the program behaves in both interactive and non-interactive modes.

### 15. Encouraging User Help Functions
- Provide clear, comprehensive help / usage information (`--help`, `-h`, or `help` command).
- Make help output useful even for non-interactive usage (e.g., include examples, environment variables, and non-interactive flags).
- Encourage users to discover safe usage patterns through helpful messages.
- In error cases, suggest the appropriate help command or relevant documentation.

### 16. Input Pattern Checking
- Always validate user input and command-line arguments before use.
- Reject or sanitize dangerous patterns (e.g., overly long strings, unexpected characters, malicious paths).
- Provide clear error messages when input validation fails.
- Log rejected inputs at appropriate log levels for traceability.

### 17. Defensive Storage Location Handling *(New in v2.9.1)*

- **Never assume** any storage location (for cookies, logs, configuration, data files, temporary data, or any app-specific files) exists, is writable, has correct permissions, or follows a standard home-directory layout.
- **Never hard-code** absolute paths such as `~/.app/`, `~/logs/`, or similar without dynamic resolution.
- Storage locations **must** be determined using a strict environment-aware hierarchy that respects virtual environments and tools such as pyenv, conda, venv, etc. (inspired by ChronicleLogger).
- The base storage directory resolution order (when no explicit path is provided) must follow this priority:
  1. User-provided or configured base directory
  2. Conda environment (if inside conda): `<conda_root>/.app/<appname>`
  3. pyenv / pyenv-virtualenv (if detected): `<pyenv_venv_root>/.app/<appname>`
  4. Standard Python venv (if `VIRTUAL_ENV` is set): `<venv_root>/.app/<appname>`
  5. Regular user home: `~/.app/<appname>` (using proper `os.path.expanduser("~")` or equivalent)
  6. Root user fallback: `/var/<appname>`
- Sub-directories (such as `log/`, `cookies/`, `config/`, `data/`, etc.) must be placed under the resolved base directory (e.g. `<base>/log/`, `<base>/cookies/`).
- **Never rename, refactor, or change** any protected naming patterns such as paths starting with `cookies.`, cookie storage under `~/.app/`, or similar critical identifiers used in SyncPrjs and other projects.
- Always perform explicit checks before use:
  - Directory existence
  - Writability and sufficient permissions
  - Correct ownership (respecting Least-Privilege User principle #8)
- Create directories safely with proper permissions if they do not exist.
- Log every storage location resolution, creation, or access attempt through the centralized logging system (Principle 4).
- In case of failure (permission denied, no home directory, read-only filesystem, etc.), fail loudly with clear diagnostic messages instead of assuming defaults or silent fallback.
- When performing backups involving any storage locations (cookies, logs, etc.), strictly follow the backup naming conventions in Principle 10 and preserve original structures and protected prefixes.
- This rule applies to **all** persistent storage needs (cookies, log files, configuration, application data, etc.) to ensure compatibility across different environments including pyenv, conda, Docker, minimal servers, and CI/CD.

Mandatory visible warning block (must be placed near any code that determines, resolves, or uses storage locations, cookies, logs, or app data paths):

```text
# =============================================================================
# DEFENSIVE STORAGE LOCATION HANDLING - CIAO PRINCIPLE 18
# !!! NEVER ASSUME STORAGE PATHS (cookies, logs, config, data, etc.) !!!
# !!! NEVER HARD-CODE ~/.app/ OR SIMILAR PATHS !!!
# Use environment-aware resolution supporting pyenv, conda, venv (inspired by ChronicleLogger)
# Never rename protected patterns such as cookies.* 
# Previous AI assistants repeatedly broke compatibility by casually changing
# storage locations or assuming standard directories exist.
# This rule prevents that and ensures broad environment compatibility.
# =============================================================================
```

### 18. Protect Against AI & Human Modification
- Use large, visible CIAO headers at the top of every file.
- Make security-critical, backup, versioning, logging, environment-awareness, and interactive-mode sections highly visible for AI audit.

---

## How to Apply CIAO in Your Project

1. Add this file (`CIAO-PRINCIPLES.md`) to your repository root or `docs/` folder.
2. Include the full CIAO header at the top of every source file.
3. Follow the principles of Single Point of Entry, centralized logging, independent versioning, proper backup strategy, and interactive/non-interactive awareness.
4. When AI assists in writing or refactoring code, always cross-check against these principles.

---

## Keywords

**[CIAO principle](https://github.com/cloudgen/ciao)** • **[CIAO defensive programming](https://github.com/cloudgen/ciao)** • **best programming principles for AI** • **AI-friendly coding standards** • **defensive programming with AI agents** • **OpenClaw compatible code** • **[cloudgen CIAO](https://github.com/cloudgen)** • **safe AI-generated code** • **robust coding philosophy** • **anti-fragile software development** • **least-privilege user principle** • **least privilege in bash scripting** • **CIAO v2.9.1** • **[certbot-nginx least privilege](https://github.com/Wilgat/certbot-nginx)** • **nginx-adm user** • **restricted sudoers** • **secure scripting best practices** • **AI safe coding principles** • **defensive programming least privilege** • **least privilege principle** • **CIAO least-privilege user** • **CIAO principles** • **defensive programming principles**

---

## How to Apply the CIAO Principle in Your Project

1. Copy the full **CIAO-PRINCIPLES.md** file into your repository (root or docs folder).  
2. Include the standard CIAO header at the top of every source file.  
3. When instructing AI agents (like OpenClaw) to write or edit code, explicitly say: “Follow the CIAO principle, including the least-privilege user rule.”  
4. Benefit from code that is significantly safer, clearer, more secure, and more reliable.

**Last updated**: April 2026 (v2.9.1)


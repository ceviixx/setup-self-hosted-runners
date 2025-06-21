# 🏃‍♂️ Multi GitHub Runner Setup

This script allows you to easily set up and manage multiple **self-hosted GitHub Actions runners** on a single machine. It's designed to speed up parallel workflows, reduce runner setup time, and simplify lifecycle management.

## 🚀 Features
- 🧠 Intelligent one-time runner download (no repeated downloads)
- ⚙️ Auto-configuration of multiple runners with unique names
- 🔁 Systemd service installation for each runner
- 💥 `init` and `deinit` modes to start or clean up all runners
- 🏷️ Custom labels for targeted job execution in workflows

---

## 📦 Prerequisites
- A Linux machine (Ubuntu recommended)
- `curl` installed
- `sudo` privileges (for service installation)
- A valid GitHub Actions runner registration token

You can generate the token in your GitHub repo:  
`Settings → Actions → Runners → Add Runner → Copy the token`

---

## 🛠️ Installation & Usage
Clone the repo and run:
```bash
chmod +x setup-multiple-runners.sh
```

---

## ➕ Initialize Runners
```bash
./setup-multiple-runners.sh init
```

This will:
- Download the GitHub Actions runner binary (if not already downloaded)
- Create multiple runner directories (e.g. runner-1, runner-2, ...)
- Configure and register each runner with GitHub
- Install and start each runner as a system service

➖ Remove All Runners
```bash
./setup-multiple-runners.sh deinit
```

This will:
Stop and uninstall each runner service
Delete all runner directories

---

### 🔧 Configuration
Edit the following variables in the script:
```bash
GITHUB_URL="https://github.com/<your-username>/<your-repo>"
GITHUB_TOKEN="<your-registration-token>"
RUNNER_VERSION="2.316.1"    # Check for updates at https://github.com/actions/runner/releases
NUM_RUNNERS=3                # How many runners you want to spawn
BASE_DIR="$HOME/actions-runners"
```

---

### 🧪 Example Workflow
In your GitHub Actions `.yml` file, use:
```yml
runs-on: [self-hosted, parallel]
```
This will target all runners registered with the `parallel` label.

---

### 🧼 Cleanup Tip
To remove "stale" runners from the GitHub UI manually:
Go to `Settings → Actions → Runners → ... → Remove`
(Or use the GitHub API to automate this)
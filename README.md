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

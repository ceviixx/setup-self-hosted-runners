#!/bin/bash

# ====== Configuration ======
GITHUB_URL="https://github.com/<user>/<repo>"                   # Repository URL
GITHUB_TOKEN="<YOUR_TOKEN_HERE>"                                # GitHub token: Settings → Actions → Add runner
RUNNER_VERSION="2.316.1"                                        # Runner version
NUM_RUNNERS=3                                                   # Number of parallel runners to create
BASE_DIR="$HOME/actions-runners"
RUNNER_TAR="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"  # Name of the runner archive
# ============================

# Function to initialize and start all runners
function init_runners() {
  # Ensure base directory exists
  mkdir -p "$BASE_DIR"
  cd "$BASE_DIR" || exit 1

  # Download the runner archive only if it hasn't already been downloaded
  if [ ! -f "$RUNNER_TAR" ]; then
    echo "⬇️ Downloading runner version $RUNNER_VERSION ..."
    curl -o "$RUNNER_TAR" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/$RUNNER_TAR"
  else
    echo "✅ Runner $RUNNER_VERSION already downloaded."
  fi

  # Create, configure, and start each runner
  for i in $(seq 1 "$NUM_RUNNERS"); do
    RUNNER_NAME="runner-$i"
    RUNNER_DIR="$BASE_DIR/$RUNNER_NAME"

    echo "📦 Creating $RUNNER_NAME in $RUNNER_DIR ..."
    mkdir -p "$RUNNER_DIR"
    cd "$RUNNER_DIR" || exit 1

    # Copy the runner archive into this runner directory
    cp "$BASE_DIR/$RUNNER_TAR" .

    # Extract the runner
    echo "📦 Extracting runner ..."
    tar xzf "$RUNNER_TAR"

    # Configure the runner
    echo "⚙️ Configuring runner $RUNNER_NAME ..."
    ./config.sh --unattended \
                --url "$GITHUB_URL" \
                --token "$GITHUB_TOKEN" \
                --name "$RUNNER_NAME" \
                --work "_work" \
                --labels "self-hosted,parallel" \
                --replace

    # Install and start the runner as a service
    echo "🚀 Installing $RUNNER_NAME as a service ..."
    sudo ./svc.sh install
    sudo ./svc.sh start

    echo "✅ $RUNNER_NAME is active!"

    cd "$BASE_DIR" || exit 1
  done

  echo "🎉 All $NUM_RUNNERS runners have been successfully set up and started!"
}

# Function to stop, uninstall, and remove all runners
function deinit_runners() {
  if [ ! -d "$BASE_DIR" ]; then
    echo "❌ Runner base directory ($BASE_DIR) not found. Aborting."
    exit 1
  fi

  echo "🧹 Cleaning up all runners in $BASE_DIR ..."

  for i in $(seq 1 "$NUM_RUNNERS"); do
    RUNNER_NAME="runner-$i"
    RUNNER_DIR="$BASE_DIR/$RUNNER_NAME"

    if [ -d "$RUNNER_DIR" ]; then
      echo "🛑 Stopping and uninstalling service for $RUNNER_NAME ..."
      cd "$RUNNER_DIR" || continue
      sudo ./svc.sh stop
      sudo ./svc.sh uninstall

      echo "🗑️  Deleting directory $RUNNER_DIR ..."
      cd "$BASE_DIR" || exit 1
      rm -rf "$RUNNER_DIR"
    else
      echo "⚠️  $RUNNER_DIR does not exist, skipping."
    fi
  done

  echo "✅ All runners have been removed."
}

# ====== Script Control via Arguments ======
case "$1" in
  init)
    init_runners
    ;;
  deinit)
    deinit_runners
    ;;
  *)
    echo "⚠️  Invalid parameter. Usage:"
    echo "  $0 init     # Creates and starts runners"
    echo "  $0 deinit   # Stops, uninstalls and removes all runners"
    exit 1
    ;;
esac

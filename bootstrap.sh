#!/bin/bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
    echo "Usage: bootstrap.sh <username>" >&2
    exit 1
fi

USERNAME="$1"
BRANCH=${2:-main}
GITHUB_RAW="https://raw.githubusercontent.com/paulriley/fizzsh/${BRANCH}"

echo "==> Installing packages"
apt-get update -qq
apt-get install -y -qq sudo zsh zsh-autosuggestions zsh-syntax-highlighting curl

echo "==> Creating user ${USERNAME}"
if ! id "${USERNAME}" &>/dev/null; then
    useradd -m -s /bin/zsh "${USERNAME}"
fi

echo "==> Configuring passwordless sudo"
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}
chmod 440 /etc/sudoers.d/${USERNAME}

echo "==> Deploying zsh config"
curl -fsSL "${GITHUB_RAW}/.zshrc" -o /home/${USERNAME}/.zshrc
chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.zshrc

echo "==> Deploying SSH CA"
curl -fsSL "${GITHUB_RAW}/keys/user_ca.pub" -o /etc/ssh/user_ca.pub
chmod 644 /etc/ssh/user_ca.pub

echo "==> Configuring sshd"
grep -q "TrustedUserCAKeys" /etc/ssh/sshd_config || \
    echo "TrustedUserCAKeys /etc/ssh/user_ca.pub" >> /etc/ssh/sshd_config

grep -q "AuthorizedPrincipalsFile" /etc/ssh/sshd_config || \
    echo "AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u" >> /etc/ssh/sshd_config

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

mkdir -p /etc/ssh/auth_principals
echo "${USERNAME}" > /etc/ssh/auth_principals/${USERNAME}
chmod 644 /etc/ssh/auth_principals/${USERNAME}

echo "==> Restarting sshd"
systemctl restart sshd

echo "==> Done. Connect as ${USERNAME}@<host>"

# wslrpc

[Discord Rich Presence (RPC)](https://discord.com/rich-presence) for [Windows Subsystem for Linux (WSL, WSL2)](https://docs.microsoft.com/en-us/windows/wsl/about)

### Usage:
You need to have [Node.js](https://nodejs.org/en/) installed on both Windows and WSL for this to work.

Install
```bash
# run in WSL
git clone https://github.com/furrepanther/wslrpc /mnt/linuxdata/Github/wslrpc
cd /mnt/linuxdata/Github/wslrpc
npm ci
sudo ./install.sh
```

The installer fails closed unless both `node` and `node.exe` are visible.  It
writes `/etc/profile.d/wslrpc.sh`, which is idempotent: concurrent login shells
cannot start duplicate copies, and the `WSLRPC_DISABLE=1` environment variable
disables startup.  The stock upstream installer was replaced because it
started an unbounded background copy on every login shell.

Uninstall
```bash
# run in WSL
sudo ./uninstall.sh
cd .. && rm -rf wslrpc
```

### Config
In `./config.json`.

This project provides Discord Rich Presence only.  It does not implement
Discord channel reads, bot messages, or webhooks; those remain separate MCP
capabilities and must have their own configured upstream and credentials.

### Note:
Currently only Ubuntu and Kali are directly supported, but it also works with other distros if you configure it manually.

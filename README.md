# Speedtest by Ookla - Bash Script

A lightweight bash script to easily run Ookla Speedtest directly from your Linux terminal with custom server selection.

## Quick Start

Run the script instantly using a single command:

`bash <(curl -sL https://raw.githubusercontent.com/codeduy/speedtest_by_ookla_script/main/speedtest-cli.sh)`

## Requirements

Ensure you have `curl` and `jq` installed on your system to fetch and parse the server list.
* **Ubuntu/Debian:** `sudo apt install curl jq`
* **AlmaLinux/RHEL:** `sudo dnf install curl jq`

## Credits

* Custom server list search reference: [Speedsearch](https://speedsearch.1234000.xyz/) (Based on [Shapes0/speedsearch](https://github.com/Shapes0/speedsearch)).

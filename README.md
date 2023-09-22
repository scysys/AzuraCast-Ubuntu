# AzuraCast Traditional Installer for Ubuntu 22.04 LTS

**Things to Note**

- This installer only supports Ubuntu 22.04 LTS.
- It installs AzuraCast in its stable version without Docker (currently version 0.19.1).

For assistance with this product itself, refer to AzuraCast here: <https://github.com/AzuraCast/AzuraCast>

Before posing questions, consider reviewing AzuraCast's documentation at: <https://docs.azuracast.com/>

To support the AzuraCast developers, visit: <https://docs.azuracast.com/en/contribute/donate>

## Why I Use My Own Repository

I intend to use AzuraCast with modifications (I only require the AutoDJ feature). For quick adaptability and security, I know precisely what's been done here. Using repositories from other sites would necessitate verifying their changes. I'm not fond of unforeseen tasks, so understand that I can only guarantee this approach. However, integrating this into the default repository is straightforward. I don't believe the developers would want this outside their Docker setup.

## Installation (Latest Stable 0.19.1)

Copy and paste the entire line into your CLI.

```
mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && git checkout 0.19.1 && chmod +x install.sh && ./install.sh -i
```

Post-installation, verify everything functions correctly. If you come across issues tied to this installer, please report them here and refrain from troubling the AzuraCast developers with problems specific to this repository.

![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) *Reboot is necessary after your initial install!*

## How to Upgrade from 0.18.6 to 0.19.1?

The prior installer doesn't have an upgrade routine. You must first update the installer itself.

```
rm -rf /root/azuracast_installer && mkdir -p /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && git checkout 0.19.1 && chmod +x install.sh && ./install.sh --upgrade
```

## Installation (Latest Rolling Release)

Copy and paste the entire line into your CLI.

```
mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && git checkout main && chmod +x install.sh && ./install.sh --install_rrc
```

After installation, ensure everything is operational. If you identify any installer-related issues, report them here without involving the AzuraCast developers with issues specific to this repository.

![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) *Reboot is essential after your first installation!*

## How to Upgrade from a Rolling Release?

It's not as straightforward as it was with Docker. If the developers introduce new dependencies, issues will arise. However, if changes are only within the panel, there should be no problems. If you're not comfortable with CLI, stick with the Stable Release from this repo.

```
rm -rf /root/azuracast_installer && mkdir -p /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && git checkout rolling && chmod +x install.sh && ./install.sh --upgrade_rrc
```

## Available Commands

Usage: install.sh --help or install.sh -h

*Installation / Upgrade (Stable)*

- `-i`, `--install`: Install the latest stable version of AzuraCast
- `-u`, `--upgrade`: Upgrade to the latest stable version of AzuraCast

*Installation / Upgrade (Rolling Release)*

- `-r`, `--install_rrc`: Install the latest Rolling Release of AzuraCast (not recommended for production use)
- `-v`, `--upgrade_rrc`: Upgrade to the latest Rolling Release of AzuraCast
  
*AzuraCast*

- `-c`, `--clean`: Clean AzuraCast's www_tmp Directory
- `-o`, `--changeports`: Alter the Ports where the AzuraCast Panel runs

*Icecast KH*

- `-w`, `--icecastkh18`: Install/Update to Icecast KH 18
- `-t`, `--icecastkhlatest`: Install/Update to the newest Icecast KH build on GitHub
- `-s`, `--icecastkhmaster`: Install/Update to the latest Icecast KH from the master branch in Github

*Liquidsoap*

For AzuraCast Stable versions after 0.18.5, utilize Liquidsoap version 2.2.x or higher. For versions prior to 0.18.5, use Liquidsoap versions below 2.2.x. Version 2.1.4 is the latest compatible edition.

- `-n`, `--liquidsoaplatest`: Install/Update to the most recent Liquidsoap Version
- `-m`, `--liquidsoapcustom`: Install/Update to a Liquidsoap Version of your choice

*Miscellaneous*

- `-z`, `--upgrade_installer`: Update Installer to the most recent version
- `-v`, `--version`: Display version details
- `-h`, `--help`: Show this help information

## Tested With

- OVH
- Hetzner
- Digitalocean

I conduct automatic tests with these three hosts for each version. Just because it's Ubuntu 22.04 LTS doesn't imply all hosting providers are standardized with their images. If errors arise, open an issue with the logs.

## Good to Know

- I currently run it error-free on VPS systems with 1 vCPU and 2 GB RAM.
- I've modified the original [php.ini](/web/php/php.ini) that comes with AzuraCast [here](https://github.com/AzuraCast/AzuraCast/blob/main/util/docker/web/php/php.ini.tmpl). You can revert it to its original state or use some of the predefined templates [here](/web/php). Bear in mind, these configurations are based on my knowledge. Always verify any changes yourself before using these templates.

# AzuraCast Installer for Ubuntu 22.04

Some things to know
- This Installer will actually only Support Ubuntu 22.04
- It will Install AzuraCast in its actual Stable Version without Docker.
- It will be usable for Installation and Update processes. (Update not implemented yet)

If you need help with this great Product check AzuraCast here: https://github.com/AzuraCast/AzuraCast

Maybe you should take a look at AzuraCast´s great Documentation before ask a question: https://docs.azuracast.com/

If you want to help the developers of AzuraCast take a look here: https://docs.azuracast.com/en/contribute/donate

## Why i used an own Repository for this here?

Ill personally plan to using AzuraCast in an modified way. (Need this great AutoDJ only) I need an fast way to react on changes, to make modifications and the most important reason is security. I know what i done here. When i using the Repository on ohter sides, it will make me work to check what was changed. I hate work that was not planned, so please understand that i only can ensure this in this way.

For sure when i will make modifications to AzuraCast itself, i will send it to the main project. 🥳

## How to install?

Just on line for you

```
mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && chmod +x install.sh && ./install.sh -i
```

Make sure after install that anything is working. Please open installer related issues directly here and not distrub the AzuraCast Developers with errors that are related to this repro here.

Ill prefer that you do a Reboot after your first install.

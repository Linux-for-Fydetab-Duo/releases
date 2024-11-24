[![Latest GitHub Release](https://img.shields.io/github/release/Linux-for-Fydetab-Duo/releases.svg?label=Latest%20Release)](https://github.com/Linux-for-Fydetab-Duo/releases/releases/latest)
[![Total GitHub Downloads](https://img.shields.io/github/downloads/Linux-for-Fydetab-Duo/releases/total.svg?&color=E95420&label=Total%20Downloads)](https://github.com/Linux-for-Fydetab-Duo/releases/releases)
# Images

This repository contains files needed to build each image for the FydeTab Duo

Currently, the following images are available:

- Arch Linux
- Debian 12 (Bookworm)

## Prerequisites

- [ImageForge](https://github.com/Linux-for-Fydetab-Duo/imageforge)
- archlinux-install-scripts
- Root access
- mmdebstrap (for Debian images)
- debian-archive-keyring (for Debian images)

## Instructions

1. Clone this repository
2. Run the profiledef in the folder of the image you want to build
```
sudo profiledef -c /path/to/image -w /path/to/workdir -o /path/to/output-dir
```
3. Wait for the image to be built
4. Flash the image to a microSD card or emmc

## Credits 

- [7Ji](https://github.com/7Ji/archrepo) for VPU acceleration in chromium and ffmpeg (Arch Linux)

VC Clock
========
a lightweight Analog Clock applet for linux (Based (C & Crystal) and GTK2).

The app supports two modes:

- **Normal mode**: Updates once per second.
- **Soft mode** (`-f, --soft`): Updates more smoothly with sub-second precision.

Preview
-------
<div align="center"><table><tr>
    <td align="center">
      <b>Soft Mode</b><hr>
      <img src="https://github.com/VC365/vc-clock/blob/main/assets/soft_mode.gif" alt="soft_mode" />
    </td>
    <td align="center">
      <b>Normal Mode</b><hr>
      <img src="https://github.com/VC365/vc-clock/blob/main/assets/normal_mode.gif" alt="normal_mode" />
    </td>
  </tr></table></div>

CLI Options
-----------
```bash
vc-clock -h
Usage: vc-clock [--size <icon_size>] [--utime <milliseconds>] [-h] [-v] [-f] [-n]
 Options:
    --size PIXEL                 Icon size (16 - 128). Default is 32.
    --utime MILLISECONDS         Update interval for soft mode (100 - 1000). Default is 240.
    -n, --no-tooltip             Disable tooltip.
    -f, --soft                   Enable soft mod.
    -v, --version                Show version.
    -h, --help                   Show this help message.
                 Credit : VC365 (https://github.com/VC365) 
```

Installation
------------
### Using AUR

```bash
paru -S vc-clock
# or
yay -S vc-clock
```
#### Manual Installation
```bash
git clone https://aur.archlinux.org/vc-clock.git
cd vc-clock
makepkg -si
```
### Using the installer script

```bash
chmod a+x installer.sh
./installer.sh install c
# OR
./installer.sh install crystal
```

To uninstall:

```bash
./installer.sh uninstall
```

Usage
-----
```bash
vc-clock &
```

## Contributing

1. Fork it (<https://github.com/VC365/vc-clock/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [VC365](https://github.com/VC365) - creator and maintainer

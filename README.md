VC Clock
========
a lightweight Analog Clock applet for linux (Based C and GTK2).

The app supports two modes:

- **Normal mode**: Updates once per second.
- **Soft mode** (`--soft`): Updates more smoothly with sub-second precision.

CLI Options
-----------
```bash
  -size <pixel>             Icon size (16 - 128). Default is 32.
  -utime <milliseconds>     Update interval for soft mod! (100 - 1000). Default is 500.
  -h, --help                Show this help message.
  -v, --version             Show version.
  -f, --soft                Enable soft mod.
  -n, --no-tooltip          Disable tooltip.
```

Preview
-------
<div align="center"><table><tr>
    <td align="center">
      <b>Soft Mode</b><hr>
      <img src="https://github.com/user-attachments/assets/3c038bdd-6673-4c1a-8b7b-c9ab8c87214f" alt="soft_mode" />
    </td>
    <td align="center">
      <b>Normal Mode</b><hr>
      <img src="https://github.com/user-attachments/assets/edc7afb3-b3be-4825-a78a-26f561284c86" alt="normal_mode" />
    </td>
  </tr></table></div>

Installation
------------
```bash
chmod a+x install.sh
./install.sh install
```

To uninstall:

```bash
./install.sh uninstall
```

## Usage

```bash
vc-clock &
```

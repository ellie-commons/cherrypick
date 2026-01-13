
<div align="center">
    <img alt="An icon of an eyedropper with a rainbow circle in the background" src="data/icons/png/128.png">
  <h1>Cherrypick</h1>
  <h3>Cherry-pick colors on your screen</h3>
<span align="center"> <img class="center" src="https://github.com/elly-code/cherrypick/blob/main/data/screenshots/window-light.png" alt="A screenshot of a window with a side displaying options and the other a single solid color"></span>
</div>

  <a href="https://elementary.io">
    <img src="https://elly-code.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>

## Installation

Cherrypick is designed and developed primarily for [elementary OS]. The latest stable release is available via AppCenter.

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.elly_code.cherrypick) 

[<img src="https://flathub.org/assets/badges/flathub-badge-en.svg" width="160" alt="Download on Flathub">](https://flathub.org/apps/io.github.elly_code.cherrypick)



## 💝 Donations

You can donate to various contributors:
 - Phoneybadger, the initial creator of the app (https://ko-fi.com/X8X7D99T6)
 - teamcons, the main devs and maintainers behind Cherrypick (https://ko-fi.com/teamcons)


## 🏗️ Building

Installation is as simple as installing the above, downloading and extracting the zip archive, changing to the new repo's directory,
and run the following command:

### On elementary OS or with its appcenter remote installed

```bash
flatpak-builder --force-clean --user --install-deps-from=appcenter --install builddir ./io.github.elly_code.cherrypick.yml
```

### On other systems:

First, install the elementary Flatpak runtime & SDK:

```bash
flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
flatpak install appcenter io.elementary.Platform//8.2 io.elementary.Sdk//8.2
```

Then follow the elementary OS instructions


## Credits
- Directly inspired by and uses some code from the now unmaintained [ColorPicker](https://github.com/RonnyDo/ColorPicker)
- CMYK support by @DSLitvinov
- [Palette](https://github.com/cassidyjames/palette) for code reference
- [Harvey](https://github.com/danrabbit/harvey) for code reference and design inspiration.
- [Codecard](https://github.com/manexim/codecard) for code reference.

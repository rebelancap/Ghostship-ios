<!-- NAMING NOTE (decision for you): upstream Ghostship deliberately never names the
     N64 game it runs, so this README is written game-neutral to match. If you'd rather
     name it publicly, it's a find-and-replace to add the title to the pitch, the ROM
     line, the extract-script comment, and the © credit. -->

# Ghostship for iPhone & Apple Vision Pro

Run **Ghostship** on your iPhone and Apple Vision Pro — the full game with saves, the
Ghostship enhancements menu, game controllers and a tunable touch layout, and on Vision
Pro a stereoscopic **3D mode** that puts the game on a world-locked panel floating in your
room with real depth.

Built on [Ghostship](https://github.com/HarbourMasters/Ghostship) and
[libultraship](https://github.com/HarbourMasters/libultraship), rendering natively on
**Metal** — no translation layer. 100% vibe coded with lots of passion and attention
to detail.

![Ghostship on Apple Vision Pro](docs/screenshots/visionos-window.jpg)

*Ghostship on Apple Vision Pro — a resizable window floating in your room, with the
on-screen touch layout. The same build also runs in stereoscopic 3D.*

---

## Install

**Add the SideStore source** — the easiest path, and the app auto-updates when new
versions ship:

| Device | Source | Source URL |
| --- | --- | --- |
| iPhone / iPad | HarbourMasters ports | `https://raw.githubusercontent.com/rebelancap/harbourmasters-ports/main/apps-ios.json` |
| iPhone / iPad | All ports | `https://raw.githubusercontent.com/rebelancap/all-ports/main/apps-ios.json` |
| Apple Vision Pro | HarbourMasters ports | `https://raw.githubusercontent.com/rebelancap/harbourmasters-ports/main/apps-visionos.json` |
| Apple Vision Pro | All ports | `https://raw.githubusercontent.com/rebelancap/all-ports/main/apps-visionos.json` |

Ghostship is in both sources — add either one (HarbourMasters ports carries just the
HarbourMasters family; All ports carries every rebelancap port).

In [SideStore](https://sidestore.io) / [AltStore](https://altstore.io): *Sources → **+** →
paste the URL*, then install Ghostship.

**Getting SideStore onto your device** — on both platforms SideStore itself is installed
with **iloader**:

- **iPhone / iPad:** [iloader](https://github.com/nab138/iloader).
- **Apple Vision Pro:** my [iloader fork](https://github.com/rebelancap/iloader/releases#release-visionos) —
  upstream doesn't do visionOS. It runs on an Apple Silicon Mac and pairs with the headset
  over Wi-Fi: no cable, no Dev Strap, no Xcode.

Then add the source in SideStore exactly as above.

**Prefer a manual install?** Download `ghostship-*-iOS.ipa` / `ghostship-*-visionOS.ipa`
from the [latest release](../../releases/latest) and install it through SideStore/AltStore
yourself (iPhone can also use [Sideloadly](https://sideloadly.io)).

Then **add your ROM** — the app walks you through it on first launch.

## Texture Packs (strongly recommended)

The port supports Harbour Masters' `.o2r` mods, and the one worth installing is
**[SM64 Reloaded](https://github.com/GhostlyDark/SM64-Reloaded)** by GhostlyDark — a
UHD texture pack in two flavours.

| Device | Recommended | Why |
| --- | --- | --- |
| **iPhone** | **HD** | Out-resolves the phone's panel already; stays cool and holds a high frame rate. The 4K pack runs but pushes the phone into sustained thermal throttling for detail you cannot see at that screen size. |
| **Apple Vision Pro** | **4K** | The headset renders at a far higher effective resolution and has the GPU headroom — 4K holds a locked frame rate with thermals barely off idle. This is where the pack earns its size. |

- **Project & releases:** [github.com/GhostlyDark/SM64-Reloaded](https://github.com/GhostlyDark/SM64-Reloaded)
  ([releases](https://github.com/GhostlyDark/SM64-Reloaded/releases))
- **Downloads**:
  [evilgames.eu/texture-packs/sm64-reloaded.htm](https://evilgames.eu/texture-packs/sm64-reloaded.htm) —
  grab the Ghostship `HD O2R` (iPhone) or `4K O2R` (Vision Pro)

**Installing:** extract the download on a computer, then copy the resulting `.o2r` into
*On My iPhone / Apple Vision Pro → Ghostship → **mods*** in the Files app and relaunch.
Then turn the pack on in the game's menu: enable **Use Alternate Assets** (it's off by
default, so this step is required — until you flip it you'll see the vanilla textures).
Turn it back off to compare against vanilla

## Features

- The full game with saves, audio and music, and cutscenes
- The **Ghostship enhancements menu** — the reason these ports exist: higher frame rates,
  widescreen, and the whole quality-of-life catalogue
- **In-app ROM extraction** — no PC tools, no companion app
- **Game controllers** (Backbone, DualSense, Xbox…) with menu-aware navigation
- **Touch controls** built for the game: floating analog stick, the N64 button cluster
  with C-buttons for the camera, and a **layout customizer** — drag any button, scale
  70–140%, left-handed mirror, opacity, haptics, and **per-button hide/show** so you can
  drop the buttons you never use
- **60 / 120 Hz** (ProMotion) and a supersampling slider for extra sharpness
- Texture packs and other `.o2r` mods via drag-and-drop in Files
- On-screen fps + thermal readout for tuning
- **Apple Vision Pro:** a free-resizing 2D window rendering at true 4K, plus a
  **stereoscopic 3D mode** — the game on a world-locked panel floating in your room,
  with foveated rendering for full-resolution clarity where you're looking, spatial audio
  anchored to the screen, and live-tunable stereo depth, focus, screen size/distance/height,
  surroundings dimming, and a recenter button

## Requirements

- iPhone on **iOS 15+**, or **Apple Vision Pro** (visionOS 2+)
- **SideStore**, installed with [iloader](https://github.com/nab138/iloader) — Apple Vision
  Pro needs my [visionOS fork](https://github.com/rebelancap/iloader/releases#release-visionos)
  and an Apple Silicon Mac
- Your own ROM

## FAQ

**Do I need a PC to extract the ROM?** No — extraction runs inside the app on your device.

**The app stopped launching after about a week?** Apps sideloaded with a free Apple
account expire after 7 days (paid developer accounts last a year). SideStore/iloader
refresh them automatically in the background — open the sideloading app and let it
re-sign.

**Found a bug, or it crashed?** The app keeps its own logs, and its folder is visible in
**Files** — open *On My iPhone / Apple Vision Pro → Ghostship* and grab:

- `crash.txt` — a backtrace, written if the app died (this is the important one)
- `logs/` — the newest `.log` file

Attach those to a [GitHub issue](../../issues) or send them over Discord, along with what
you were doing and whether a texture pack was installed. A crash without `crash.txt` is
usually the app being killed for memory — worth saying so, and where you were.

---

## Building from source

Requires macOS with Xcode and `cmake` (`brew install cmake`).

```sh
scripts/bootstrap.sh          # clone + pin upstream Ghostship (submodules recursive)
scripts/build-oracle.sh       # native macOS build — generates the asset archive
scripts/extract-sm64-o2r.sh   # build the game archive from your ROM (for the simulator)

scripts/build-sim.sh          # iOS Simulator build
scripts/run-sim.sh            # install + launch + screenshot

scripts/build-ios.sh          # signed iPhone build
scripts/build-visionos.sh     # signed Apple Vision Pro build
```

Upstream Ghostship is vendored **unmodified and pinned by commit**; every local change is
a reviewable patch in `overlay/patches/`, applied by `scripts/apply-overlay.sh` (a patch that fails to apply fails the build). The iOS/visionOS app shell lives in `app/ios/`.


## Credits & license

- [Ghostship](https://github.com/HarbourMasters/Ghostship) by **Harbour Masters** and
  contributors — the port this is built on
- [libultraship](https://github.com/HarbourMasters/libultraship) (MIT) and the Harbour
  Masters asset pipeline — the platform layer
- Original game © **Nintendo**. This project is not affiliated with or endorsed by
  Nintendo, and ships no Nintendo content.

<!-- TODO: pick a license for this repo's own code (the app shell + overlay patches).
     Upstream has no root LICENSE file; libultraship/ZAPDTR are MIT. -->

# Test Browser

A lightweight, native browser for the **iPad 4 (MD510B/A) running iOS 10.3.4**.

The project starts with Apple's built-in `WKWebView`. The first goal is a stable, usable browser on the original hardware; replacing or extending the rendering engine is a separate research project.

## Current target

- Device: iPad 4 / A6X / 32-bit ARM
- OS: iOS 10.3.4
- Language: Objective-C
- UI: UIKit
- Web engine: WKWebView (system WebKit)
- Packaging: jailbreak-installable Debian package via Theos

## First milestone

- [x] Initial application structure
- [x] Address field and basic navigation controls
- [ ] Build successfully for 32-bit ARM
- [ ] Install and test on the iPad 4
- [ ] Add tabs and bookmarks
- [ ] Add downloads
- [ ] Investigate compatibility improvements for modern websites

## Build

This is a Theos application project. Install Theos and provide an iOS SDK/toolchain that can emit 32-bit ARM binaries. Newer Apple SDK/toolchains may have dropped 32-bit device support, so do not assume the latest Xcode SDK will work.

From the project directory:

```sh
make
```

The package will be produced under `packages/` when packaging is enabled by the local Theos setup.

## Important engine limitation

The browser UI does not make old WebKit modern. Some current sites may fail because iOS 10's WebKit lacks newer JavaScript, CSS, TLS and media features. We will measure compatibility on-device and improve it incrementally without pretending that a user-agent change fixes engine limitations.

## Project layout

- `Browser/`: browser interface and navigation
- `Resources/`: app metadata and assets
- `Makefile`: Theos build configuration

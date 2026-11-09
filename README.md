# exam_jyoti

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Releasing the Linux Snap

Run the release script with the new Flutter/Snap version (including its build
number). It updates both version files, packs the Snap, uploads it to the beta
channel, and deletes the local package only after a successful upload:

```bash
./scripts/release_snap.sh 1.0.0+19
```

The script requires `snapcraft` and an amd64 build environment. If packing or
uploading fails, it leaves any generated Snap package in place for inspection
or retry.

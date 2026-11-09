# Snap build and release troubleshooting

## LXD build cannot reach Ubuntu package servers

`snapcraft pack` may fail during `apt update` with a message such as `Failed to
refresh package list`. This can happen even when DNS works: the managed LXD
container may not be able to forward network traffic.

Check the Snapcraft containers and test an HTTP connection from the build
container:

```bash
lxc --project snapcraft list
lxc --project snapcraft start <snapcraft-container>
lxc --project snapcraft exec <snapcraft-container> -- \
  curl -4 -I --connect-timeout 10 \
  http://archive.ubuntu.com/ubuntu/dists/resolute/InRelease
sudo iptables -S DOCKER-USER
sudo iptables -L FORWARD -n -v --line-numbers
```

In the environment where this issue occurred, the `DOCKER-USER` chain was empty
and forwarding was blocked. These temporary rules allowed the LXD bridge to
reach the package server:

```bash
sudo iptables -I DOCKER-USER -i lxdbr0 -j ACCEPT
sudo iptables -I DOCKER-USER -o lxdbr0 \
  -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

Only apply firewall rules if the machine uses this Docker/LXD forwarding setup
and the connection test confirms the problem. These `iptables` rules are
runtime changes and may not survive a reboot. Once the connection test succeeds,
retry `snapcraft pack`.

## Build fails finding the desktop file

Snapcraft must be given the path to the launcher relative to the `snap/`
directory. The launcher is stored at
[`gui/ksvh-exam-scholar.desktop`](./gui/ksvh-exam-scholar.desktop), so the app
entry in [`snapcraft.yaml`](./snapcraft.yaml) must use:

```yaml
desktop: gui/ksvh-exam-scholar.desktop
```

If Snapcraft reports that `snap/ksvh-exam-scholar.desktop` does not exist, check
this value and ensure the launcher file is present.

## App installs but does not appear in the desktop app grid

The Snap needs a desktop launcher and an icon. Keep the desktop entry in
`snap/gui/`, set the `desktop` field as shown above, and ensure the build copies
an icon to `meta/gui/icon.png`. These files are packaged into the Snap under
`meta/gui/`.

To confirm the artifact contains them:

```bash
unsquashfs -ll ./ksvh-exam-scholar_<version>_amd64.snap \
  | grep -E 'meta/gui/.*(desktop|icon\.png)'
```

After uploading, make sure the revision containing the launcher has been
released to the channel users install, then refresh or reinstall the Snap.

## GTK aborts while loading a theme icon

Messages about `canberra-gtk-module` or Mesa are not necessarily fatal. The
fatal error in this build was GTK failing to decode a PNG/SVG theme icon, for
example `Unrecognized image file format`.

The Snap needs its GdkPixbuf image loader, Glycin loader configuration, and
shared MIME database included and configured. The `stage-packages`,
`environment`, and `override-prime` entries in [`snapcraft.yaml`](./snapcraft.yaml)
set these up. Do not remove the generated `loaders.cache`, MIME cache, or the
absolute paths to the bundled Glycin loader executables when changing the
packaging.

Rebuild and test the resulting Snap; a successful `snapcraft pack` alone does
not verify that GTK can load its icons.

## Build and upload workflow

1. Keep the version in `pubspec.yaml` and `snap/snapcraft.yaml` in sync.
2. Run `snapcraft pack` as your normal user. Do not run it with `sudo`; that can
   create root-owned build files or cause Flutter to fail when the project path
   contains spaces.
3. If the build succeeds, verify the expected `.snap` file exists before
   uploading. An upload error saying the file is invalid or missing after a
   failed build is a consequence of the missing artifact.
4. Upload to beta first, install/test that Store revision, then release the
   tested revision to stable:

   ```bash
   snapcraft upload --release=beta ./ksvh-exam-scholar_<version>_amd64.snap
   snapcraft status ksvh-exam-scholar
   snapcraft release ksvh-exam-scholar <revision> stable
   ```

The `_apt` warning about downloading a package unsandboxed was not the cause of
the failed builds described above; the missing desktop file and blocked LXD
network connection were the actual errors.

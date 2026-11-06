# ubi9-oc-tools

Let's run `oc`, `openshift-install` and `oc mirror` in a container.

The image is based on `ubi9-minimal` and is published to
`ghcr.io/johankok/ubi9-oc-tools`.

## What's included

OpenShift clients (from the `stable-4.22` channel on mirror.openshift.com,
verified against the published `sha256sum.txt`):

- `oc`
- `openshift-install`
- `oc-mirror`

Supporting tools:

- `jq` for working with JSON output
- `less` as the default pager
- `watch` (from `procps-ng`), e.g. `watch oc get pods`
- `nmstate` for working with network configuration with agent based installer
- `pigz` for fast parallel compression
- `bash-completion` with completion for `oc` and `openshift-install`
- `ssh` for emergency access to nodes
- `tar` for unpacking archives such as must-gather output
- `rsync` so `oc rsync` can use its default rsync strategy
- `vi` so `oc edit` can use it

## Usage

Start an interactive shell:

```sh
podman run -it --rm ghcr.io/johankok/ubi9-oc-tools
```

To use an existing kubeconfig, mount it into the container:

```sh
podman run -it --rm \
  -v ~/.kube:/root/.kube:Z \
  ghcr.io/johankok/ubi9-oc-tools
```

Or run a single command:

```sh
podman run --rm -v ~/.kube:/root/.kube:Z \
  ghcr.io/johankok/ubi9-oc-tools oc get nodes
```

### Shell completion

Tab completion for `oc` and `openshift-install` is available in interactive
bash sessions. Make sure you start the container with `-it`; completion is not
loaded when you run a single command or use `sh`.

## Building locally

```sh
podman build --platform linux/amd64 -t ubi9-oc-tools -f Containerfile .
```

To change the OpenShift version, edit `VERSION` in
`bin/download-oc-tools.sh`.

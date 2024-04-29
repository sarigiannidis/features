
# puppeteer on alpine (alpine-puppeteer)

Install puppeteer on alpine

## Example Usage

```json
"features": {
    "ghcr.io/sarigiannidis/features/alpine-puppeteer:1": {}
}
```



# shot

Run ```shot``` to create a new screenshot as follows:

```bash
shot https://michalis.site test.png
```

## Install

if it's not already executable run:

```bash
chmod +x shot.js
```

To install and link the script run:

```bash
npm install
npm link
```

Once ```link``` has been run, the script can be run from anywhere on the system.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sarigiannidis/features/blob/main/src/alpine-puppeteer/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

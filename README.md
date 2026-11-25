# Homebrew tap for App Map

[App Map](https://github.com/yonivav/app-map) is an AI agent skill that draws a clickable map of a
mobile app's code (Flutter, iOS, Android) and keeps it current.

```bash
brew install yonivav/app-map/app-map
cd your-app
app-map install --auto
```

Then ask your coding agent: *"Build an app map of this repo"*.

`app-map install` takes the same options as `install.sh` (`--user`, `--link`, `--agent codex`…;
see `app-map install --help`). Every other command goes to the skill's CLI: `app-map build`,
`app-map verify`, `app-map changes`… Run `app-map` for the list.

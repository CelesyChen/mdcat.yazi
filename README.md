# mdcat.yazi

Preview Markdown files in [Yazi](https://github.com/sxyazi/yazi) with
[mdcat](https://github.com/swsnr/mdcat).

Install it with:

```bash
ya pkg add atareao/mdcat
```

Then add this to `yazi.toml`:

```toml
[plugin]
prepend_previewers = [
  { url = "*.md", run = 'mdcat -- CLICOLOR_FORCE=1 FORCE_COLOR=1 mdcat --ansi --local --columns="$w" --theme="$([ "$t" = "dark" ] && echo catppuccin-mocha || echo catppuccin-latte)" "$1"' },
]
```

The command uses `$1` for the file path, `$w` for the preview width, and `$t`
for the terminal theme. Make sure `mdcat` is installed and available in
`PATH`.

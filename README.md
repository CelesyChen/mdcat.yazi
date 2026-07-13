# mdcat.yazi

An external Markdown previewer for [Yazi](https://github.com/sxyazi/yazi),
powered by [mdcat](https://github.com/swsnr/mdcat).

Unlike Yazi's built-in code preview, this plugin renders Markdown as a
terminal document. Headings, lists, links, code blocks, emphasis, and other
Markdown elements are displayed using mdcat's ANSI output.

## Requirements

- Yazi 26.1.22 or later
- [mdcat](https://github.com/swsnr/mdcat) available in `PATH`

For example, on macOS or Linux:

```sh
cargo install mdcat
```

You can verify the installation with:

```sh
mdcat --version
```

## Installation

Install the plugin through Yazi's package manager:

```sh
ya pkg add CelesyChen/mdcat
```

Yazi will install the repository as `mdcat.yazi` under its plugin directory.

## Configuration

Add the following to `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_previewers]]
url = "*.md"
run = "mdcat"
```

The short `run = "mdcat"` form uses the plugin's built-in command. It:

- enables ANSI output;
- avoids loading remote Markdown resources;
- limits output to the current preview width;
- selects Catppuccin Mocha for dark terminals and Catppuccin Latte for light
  terminals;
- supports Yazi preview scrolling.

Markdown links are converted to visible text such as `a (https://example.com)`
inside the preview. They are intentionally not interactive, because Yazi's
text preview does not preserve mdcat's terminal hyperlink metadata.

## Custom command

The plugin also accepts a shell command in the same style as
[`piper.yazi`](https://github.com/yazi-rs/plugins/tree/main/piper.yazi). The
command receives these variables:

| Variable | Meaning |
| --- | --- |
| `$1` | Path of the file being previewed |
| `$w` | Width of the preview area |
| `$h` | Height of the preview area |
| `$t` | Terminal theme: `dark` or `light` |

For example:

```toml
[[plugin.prepend_previewers]]
url = "*.md"
run = 'mdcat -- mdcat --ansi --local --columns="$w" "$1"'
```

The command is executed through `sh -c`, so quote paths and shell arguments
carefully.

## License

MIT. See [LICENSE](LICENSE).

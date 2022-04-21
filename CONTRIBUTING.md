# Contributing

I am open to feature adds and pull requests and issues. Feel free to open them and I will take a look!

I can't promise all features will be added, but feel free to open an issue to
  discuss before starting.

## Testing

This uses the `vimrunner` gem to test.

To run tests, install the gem:

```
bundle install
```

Then you need a vim server running. On a Mac,
[MacVim](https://macvim-dev.github.io/macvim/) is a good option.

Add a `.env` file with the following:

```
# .env

VIM_TADA_VIM_PATH="/Applications/MacVim.app/Contents/bin/mvim"
VIM_TADA_REFOCUS_COMMAND="open /Applications/Alacritty.app"
```

- `VIM_TADA_VIM_PATH` is the application path to the vim server app.
- `VIM_TADA_REFOCUS_COMMAND` is for when you have a different app running vim,
it will refocus back to your existing app (Terminal.app, iTerm 2, Alacritty,
etc.).

Run tests with

```
rake
```

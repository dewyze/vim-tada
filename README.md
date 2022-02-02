# Vim Tada

Turn your todos :white_check_mark: into tadas :tada:.

Vim tada is a file syntax and tools for managing a simple todo list including a
hierarchy and some metadata.

## Installation

Using your preferred package manager add `dewyze/vim-tada`. For example, with
[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'dewyze/vim-tada'
```

## Features

## Configuration

Vim tada has a variety of configuration options below is a list of them all:

#### `g:tada_todo_symbols_set`

**Default:** `unicode`
**Options:** `ascii`

This variable will set `g:tada_todo_symbols` to a preset set of values:

- `unicode`: `{ 'todo': ' ', 'inProgress': '•', 'done': '✔︎', 'blocked':'☒' }`
- `ascii`: `{ 'todo': ' ', 'inProgress': '-', 'done': 'x', 'blocked':'o' }`

#### `g:tada_todo_symbols`

**Default**: `{ 'todo': ' ', 'inProgress': '•', 'done': '✔︎', 'blocked':'☒' }`
(Set via `unicode` in `g:tada_todo_symbols_set`)
**Options**: Any dictionary with the keys: `['todo', 'inProgress', 'done', 'blocked']`

These are the symbols used to iterate through todo statuses.

## Keymaps and Commands

## Contributing

## License

MIT

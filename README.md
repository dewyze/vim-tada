# Vim Tada

Turn your todos :white_check_mark: into tadas :tada:.

Vim tada is a file syntax and tools for managing a simple todo list including a
hierarchy and some metadata.

![Vim-tada](https://user-images.githubusercontent.com/1312168/156285987-5ffaa526-816a-4e1c-895c-aeaf36951ebe.png)

## Features

- Smart keymaps built for speed
  - Toggle todo states with `<Space>`
  - Collapse todo's various levels with `<C-T>1` - `<C-T>6`
  - Collapse topics with `<Enter>`
- Customizable statuses, symbols, and colors
- Supports up to 6 levels of nested to-do's
- Global and file specific configuration
- Archive collapsible sections

## Motivation

Sometimes on solo projects, I have wanted an organized todo structure. But
things like GitHub projects, Trello, Jira, etc. are all too complicated.
Additionally, when it's just me, I wanted to not have to leave my vim editor in
order to keep track of what I wanted to work on. So...vim-tada!

I may eventually add advanced opt-in functionality with labels, dates, and some
  GUI-ish features. Or maybe not.

## Installation

Using your preferred package manager add `dewyze/vim-tada`. For example, with
[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'dewyze/vim-tada'
```

## Sections

1. [Format](#format)
1. [Topics](#topics)
1. [Todos](#todos)
1. [Folds](#folds)
1. [Metadata](#metadata)
1. [Archives](#archives)
1. [Todo Pane](#todo-pane)
1. [Keymaps](#keymaps)
1. [Configuration](#configuration)
1. [File Config](#file-config)
1. [Contributing](#contributing)

## Format

Vim tada will recognize files named `Tadafile` or with the `.tada` extension.

- **Topics**: Start with `-` and end with `:`
    - This is a topic:
- **Todo Items**: Start with `- [ ] ` followed by text
    - [ ] This is a todo item
- **List Items**: Start with `-` but do not end with `:`
    - This is a list item
- **Notes**: Notes start with a `>`
    > This is a note
- **Metadata**: Starts with `| ` followed by one of: `[@,^,$,&,#,!,?]` and `:`
    - This is a topic followed by metadata:
      | @:alice,bob
      | ^:2022-04-01
      | !:High
- **Comment**: Comments start with a `#`
    - \# This is a comment
- **Archive**: Starts with a `=== Archive Title` line, followed by lines
prefixed with `=`
    === My Archive
    = - This is an archived topic:

## Topics

Topics are just headers. You can think of them as milestones, epics, or stories.
Or you can think of them as organizational folders. Or just as `h1`, `h2`, `h3`.
They are just a way to organize todos and list items. They are indented by one
`shiftwidth` level. I.e. if your `shiftwidth` is 2, then a one space indent will
not register as a topic.

Topics also determine how [folds](#folds) work. See [that section](#folds) for
more details.

Topics can also have [metadata](#metadata).
> Note: Currently metadata does nothing. Eventually I hope for it to allow for
some advanced features with sorting, displaying info, or developing an
interactive UI.

## Todos

Todos are the bread and butter of vim-tada! You can create a todo item by
pressing `<C-Space>`. It will toggle a box with `- [ ] ` in your line.

### Toggling Todos

![todo](https://user-images.githubusercontent.com/1312168/156286093-6b2e3768-3c54-4b98-8144-c8a212744cf6.gif)

If you want to toggle between todo states:

- `<space>`: Toggle between todo item states

### Configuring Todos

You can configure todo statuses and symbols.

#### Todo Style

A todo style is a predetermined set of statuses and symbols:

- `unicode` (default): `blank: [ ], in_progress: [•], done: [✔], flagged: [⚑]`
- `ascii` (default): `blank: [ ], in_progress: [-], done: [x], flagged: [o]`
- `simple` (default): `blank: [ ], done: [✔]`
- `markdown` (default): `blank: [ ], done: [x]`

You can just set the style and these will be the todo states.

```vim
let g:tada_todo_styles = 'ascii'
```

Or via [file specific configs](#file-config):

```vim
@config.todo_style = 'ascii'
```

#### Todo Statuses and Symbols

You can set the todo statuses to anything you want, and the symbols as well.

Via global config in a vimrc:

```vim
let g:tada_todo_statuses = ['planned', 'doing', 'complete']
let g:tada_todo_symbols = {'planned': ' ' , 'doing': '🛠️', 'complete': '✅' }
```

Or via a [file specific configs](#file-config):

```vim
@config.todo_statuses = ['planned', 'doing', 'complete']
@config.todo_symbols = {'planned': ' ' , 'doing': '🛠️', 'complete': '✅' }
```

**NOTE:** For now, the status names are not visible and serve no purpose. I
think eventually they may be displayed or used in a some UI elements.
**NOTE:** The first status in the array is considered the "default" for new todo
items.

## Folds

![Folding](https://user-images.githubusercontent.com/1312168/156286175-acaf53dc-1132-4897-997b-c5181bc6bf0d.gif)

You can fold topics basic on the indent level of the topic. There are several
shortcuts you can use:

- `<Enter>` in insert mode will, if on a topic, will collapse that topic.
- `<C-T>#` where `#` is a number `1-6` will fold to various topic levels.
- `<C-T>0` will unfold everything except an archive.
- `<C-T>o` will completely open all folds for the topic under the cursor.
- `<C-T>c` will close all folds for the line under the cursor.

These are just shortcuts on top of some existing vim fold commands, so if you
know the vim fold commands, feel free to use those.

## Metadata

:construction::construction: **UNDER CONSTRUCTION** :construction::construction:

For now, metadata does nothing. Eventually it can/will be used to add some
advanced functionality for sorting, shortcuts, or an advanced UI.

### Metadata fields

Metadata syntax is `| <sym>:<val>`

Possible symbols are:
- `?`: Status
- `@`: Assignees (comma separated)
- `^`: Start date (YYYY-MM-DD)
- `$`: End date (YYYY-MM-DD)
- `&`: External Link
- `#`: Tags
- `!`: Priority

## Archives

If you complete a top level topic (or any topic) you can move it to an "archive"
which is fancy for a folded section at the bottom of the file.

Highlight the lines you want to archive and type `<C-T>a`.

This will move the lines to the bottom of the file, and add an archive header
`===` if an archive does not exist.

**NOTE:** This does not change indentation, which is why I recommend only
archiving top level topics.

The archive will stay closed at all fold levels, but can be toggled open with
`<Enter>`.

## Todo Pane

You can quickly open a specified tada file with the pane open command.

`<LocalLeader>td` will open the `Tadafile` in a vertical split on the right.
This is the only tada command available outside of editing a tada file.

### Todo Pane Configuration

#### `g:tada_todo_pane_file`

**Default:** `Tadafile`

Set the file that is opened by the tada todo pane. Another option could be
`todo.tada` or anything that meets the [format](#format) extension.

#### `g:tada_todo_pane_location`

**Default:** `right`

Set the location for the tada todo pane.
Acceptable values: `left, top, right, bottom`

#### `g:tada_todo_pane_map`

**Default:** `<LocalLeader>td`

Set the global keymap for opening a tada side pane.

#### `g:tada_todo_pane_size`

**Default:** `min([round(&columns * 0.33), 60])` (33% width of vim, or 60
columns whichever is the minimum).

Set the size for a tada side pane. Can be a number or a calculation.

## Keymaps

The following maps are present in tada specific files:

#### Insert Mode
- `<C-Space>`: to toggle adding/removing a todo box `- [ ]`
- `<C-H>`: to clear anything to the left of the cursor
- `:`: on an empty line to dedent to a topic
- `|`: on an empty line to convert it to metadata
- `>`: on an empty line to convert it to a note

#### Normal Mode
- `<C-Space>` to toggle adding/removing a todo box `- [ ]`
- `(` Goes to the previous topic
- `)` Goes to the next topic
- `{` Goes to the previous parent topic
- `}` Goes to the next parent topic

## Configuration

Vim tada has a variety of configuration options below is a list of them all:

#### Configuring Todo Styles

See [todo styles](#todo-style) for information on using pre-defined todo styles.


#### Configuring Todo Statuses and Symbols
See [configuring todos](#configuring-todos) for information on configuring todo
statuses and symbols.

#### `g:tada_autolines`

**Default:** `1`

By default, when pressing `<Enter>`, `o`, or `O`, automatically insert the same
leading characters.

#### `g:tada_count_nested_todos`

**Default:** `1`

By default, when using [folds](#folds), the summary line will sum todo items
from children. If you are on a slower machine, this could be slow. Set this to 0
to turn this feature off.

#### `g:tada_goto_maps`

**Default:** `1`

This determines whether `(`,`)`,`{`,`}` are remapped in normal mode.

#### `g:tada_map_box`

**Default:** `<C-Space>`

For both normal and insert mode, this will toggle a box `- [ ] ` on a line.

#### `g:tada_map_empty_line`

**Default:** `<C-H>`

In insert mode, this will clear everything to the left of the cursor.

#### `g:tada_map_prefix`

**Default:** `<C-T>`

For folds and archives (and future features) this is the map prefix used.

#### `g:tada_no_map`

**Default:** `0`

Use this to turn off all the mappings for `<Space>`, `<C-T>`, `<C-Space>`, `<C-H>`.

#### `g:tada_smart_tab`

**Default:** `1`

By default, `<Tab>` will indent list/todo items if they are empty.

#### `g:tada_todo_switch_status_mapping`

**Default:** `<Space>`

Set the mapping to toggle between todo states.

### Colors

You can configure the colors by overriding any of the following keys.

A color must be one of the following:

- A hex string beginning with `#` (for terminals that support `guifg`)
- An integer (for terminals using `ctermfg`)
- An array with [`<gui hex>`, `<cterm int>`]

**NOTE:** if you override the todo key, you need to define all of the colors.

```vim
let red = ["#cc6666", 168]
let orange = ["#de935f", 173]
let yellow = ["#f0c674", 180]
let canary = ["#bfbc91", 179]
let green = ["#84b97c", 108]
let jade = ["#4bb1a7", 73]
let blue = ["#81a2be", 80]
let royal = ["#648cb4", 74]
let purple = ["#b294bb", 140]
let gray = ["#969896", 245]
let white = ["#ffffff", 255]

let g:tada_colors = {
\   "archive": gray,
\   "comment": gray,
\   "invalid_config": red,
\   "metadata": jade,
\   "note": canary,
\   "todo": {
\     "in_progress": yellow,
\     "done": green,
\     "flagged": red,
\   },
\   "topic": {
\     "1": purple,
\     "2": royal,
\     "3": orange,
\     "4": purple,
\     "5": royal,
\     "6": orange,
\   },
\ }
```

## File Config

Sometimes you may want different statuses or symbols for a specific file. (Maybe
the file is more complex or simple than your typical file). You can set file
specific configurations. You can put this anywhere in your file.

**NOTE:** These must be one line long, they are not parsed if they are multiple
lines.

```vim
# proj.tada
@config.todo_statuses = ['blank', 'done']
@config.todo_symbols = { 'blank': ' ', 'done': 'D' }
```

Available settings:
- `@config.todo_stasuses`: Array of strings
- `@config.todo_symbols`: Hash with statuses as keys
- `@config.todo_style`: One of: `unicode`, `ascii`, `markdown`, `simple`
- `@config.colors`: Hash with string keys and hex/int/array colors. See
[colors](#colors)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

### Improvements

See the final sections of the [proj.tada](proj.tada):

- Fancy Todo Lists
- Project Collaboration
- UI Based

## [Code of Conduct](CODE_OF_CONDUCT.md)

## [License](LICENSE)

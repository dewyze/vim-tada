" Vim syntax file
" Language:   Tada
" Maintainer: John DeWyze <john@dewyze.dev>
" Filenames:  *.tada

if exists("b:current_syntax")
  finish
endif

syn spell toplevel
syn sync fromstart
syn case ignore

syn region tadaLevel1TopicTitle matchgroup=tadaDelimiter start="^-\s\?" end=":$"
syn region tadaLevel2TopicTitle matchgroup=tadaDelimiter start="^\s\{2}-\s\?" end=":$"
syn region tadaLevel3TopicTitle matchgroup=tadaDelimiter start="^\s\{4}-\s\?" end=":$"

let b:current_syntax = "tada"

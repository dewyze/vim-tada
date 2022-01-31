require "vimrunner"
require "tempfile"
require "vimrunner/rspec"

VIM_PATH = "/Applications/MacVim.app/Contents/bin/mvim"

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true
  config.start_vim do
    vim = Vimrunner::Server.new(executable: VIM_PATH).start
    vim.prepend_runtimepath(File.expand_path('../..', __FILE__))
    vim.command "runtime ftdetect/tada.vim"
    vim.command "set nospell"
    vim.command "set nofoldenable"
    vim
  end
end

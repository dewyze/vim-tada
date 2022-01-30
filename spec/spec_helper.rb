require "vimrunner"
require "vimrunner/rspec"

VIM_PATH = "/Applications/MacVim.app/Contents/bin/mvim"

Vimrunner::RSpec.configure do |config|
  plugin_path = File.expand_path("..", File.dirname(__FILE__))

  config.reuse_server = true
  config.start_vim do
    vim = Vimrunner::Server.new(executable: VIM_PATH).start
    vim.prepend_runtimepath(plugin_path)
    vim.command "set nospell"
    vim.command "set nofoldenable"
    vim
  end
end

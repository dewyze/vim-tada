require "dotenv/load"
require "pry"
require "tempfile"
require "vimrunner"
require "vimrunner/rspec"

class VimExecutablePathMissing < StandardError
  def message
    "You need to set the VIM_TADA_VIM_PATH environment variable in the .env file with the path to your vim executable."
  end
end

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true
  raise VimExecutablePathMissing unless ENV["VIM_TADA_VIM_PATH"]
  config.start_vim do
    vim = Vimrunner::Server.new(executable: ENV["VIM_TADA_VIM_PATH"]).start
    vim.prepend_runtimepath(File.expand_path('../..', __FILE__))
    vim.command "runtime ftdetect/tada.vim"
    vim.add_plugin(File.expand_path('../vim', __FILE__), 'plugin/syntax_test.vim')
    vim.command "set nospell"
    vim.command "set nofoldenable"
    vim.command "set backspace=indent,eol,start"
    vim
  end

  def with_file(content = "")
    Tempfile.create(["test", ".tada"]) do |file|
      file.write content
      file.rewind
      vim.edit file.path
      yield file
    end
  end
end

RSpec::Matchers.define :have_highlight do |expected|
  match do |pattern|
    vim.echo("TestSyntax('#{pattern}', '#{expected}')") == '1'
  end

  failure_message do |pattern|
    <<~MSG
      Expected highlight: '#{expected}'
        Actual highlight: '#{vim.echo("CursorGroup()")}'
    MSG
  end
end

RSpec.configure do |config|
  config.before(:each) { vim.command("call ResetConfiguration()") }

  config.after(:all) do
    vim.command "!#{ENV["VIM_TADA_REFOCUS_COMMAND"]}" if ENV["VIM_TADA_REFOCUS_COMMAND"]
  end
end

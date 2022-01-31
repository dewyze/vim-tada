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
    vim
  end

  def assert_correct_highlighting(string, patterns, group)
    Tempfile.create(["file", ".tada"]) do |file|
      file.write string
      file.rewind
      vim.edit file.path

      Array(patterns).each do |pattern|
        # TODO: add a custom matcher
        expect(vim.echo("TestSyntax('#{pattern}', '#{group}')")).to eq '1'
      end
    end
  end
end

RSpec.configure do |config|
  config.after(:all) do
    vim.command "!#{ENV["VIM_TADA_REFOCUS_COMMAND"]}" if ENV["VIM_TADA_REFOCUS_COMMAND"]
  end
end

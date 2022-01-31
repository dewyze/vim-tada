require "pry"
require "tempfile"
require "vimrunner"
require "vimrunner/rspec"

VIM_PATH = "/Applications/MacVim.app/Contents/bin/mvim"

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true
  config.start_vim do
    vim = Vimrunner::Server.new(executable: VIM_PATH).start
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

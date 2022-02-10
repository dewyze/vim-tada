RSpec.describe "filetype" do
  it "returns true for a '.tada' file" do
    with_file do
      expect(vim.echo("&filetype")).to eq("tada")
    end
  end

  it "returns true for a '.tada' file" do
    Dir.mktmpdir do |dir|
      File.open("#{dir}/Tadafile", "w") do |file|
        vim.edit file.path

        expect(vim.echo("&filetype")).to eq("tada")
      end
    end
  end

  it "sets the todo style to mark down for a markdown file" do
    vim.command("let g:tada_todo_style = 'markdown'")

    with_file("") do
      expect(vim.echo("b:tada_todo_style")).to eq("markdown")
      expect(vim.echo("b:tada_todo_statuses")).to eq("['blank', 'done']")
      expect(vim.echo("b:tada_todo_symbols['blank']")).to eq(" ")
      expect(vim.echo("b:tada_todo_symbols['done']")).to eq("x")
    end
  end
end

RSpec.describe "config specs" do
  it "sets buffer variables from config lines" do
    content = <<~CONTENT
      Topic:
       - Thing

      @config.todo_statuses = ['blank']
    CONTENT

    with_file(content) do |file|
      expect(vim.echo("b:tada_todo_statuses")).to eq("['blank']")
    end
  end

  describe "todo styles" do
    it "defaults to unicode" do
      with_file("") do
        expect(vim.echo("b:tada_todo_style")).to eq("unicode")
        expect(vim.echo("b:tada_todo_statuses")).to eq("['blank', 'in_progress', 'done', 'blocked']")
        expect(vim.echo("b:tada_todo_symbols['blank']")).to eq(" ")
        expect(vim.echo("b:tada_todo_symbols['in_progress']")).to eq("•")
        expect(vim.echo("b:tada_todo_symbols['done']")).to eq("✔")
        expect(vim.echo("b:tada_todo_symbols['blocked']")).to eq("⚑")
      end
    end

    it "sets the stasuses and symbols for 'ascii'" do
      vim.command("let g:tada_todo_style = 'ascii'")

      with_file("") do
        expect(vim.echo("b:tada_todo_style")).to eq("ascii")
        expect(vim.echo("b:tada_todo_statuses")).to eq("['blank', 'in_progress', 'done', 'blocked']")
        expect(vim.echo("b:tada_todo_symbols['blank']")).to eq(" ")
        expect(vim.echo("b:tada_todo_symbols['in_progress']")).to eq("-")
        expect(vim.echo("b:tada_todo_symbols['done']")).to eq("x")
        expect(vim.echo("b:tada_todo_symbols['blocked']")).to eq("o")
      end
    end

    it "sets the stauses and symbols for 'simple'" do
      vim.command("let g:tada_todo_style = 'simple'")

      with_file("") do
        expect(vim.echo("b:tada_todo_style")).to eq("simple")
        expect(vim.echo("b:tada_todo_statuses")).to eq("['blank', 'done']")
        expect(vim.echo("b:tada_todo_symbols['blank']")).to eq(" ")
        expect(vim.echo("b:tada_todo_symbols['done']")).to eq("✔")
      end
    end

    it "sets the stauses and symbols for 'markdown'" do
      vim.command("let g:tada_todo_style = 'markdown'")

      with_file("") do
        expect(vim.echo("b:tada_todo_style")).to eq("markdown")
        expect(vim.echo("b:tada_todo_statuses")).to eq("['blank', 'done']")
        expect(vim.echo("b:tada_todo_symbols['blank']")).to eq(" ")
        expect(vim.echo("b:tada_todo_symbols['done']")).to eq("x")
      end
    end
  end
end

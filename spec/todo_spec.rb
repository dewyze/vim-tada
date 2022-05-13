RSpec.describe "todo" do
  let(:content) do
    <<~CONTENT
      #{SIGIL} [ ] Todo item
      #{SIGIL} [•] In progress item
      #{SIGIL} [✔] Done item
      #{SIGIL} [⚑] Flagged item
    CONTENT
  end

  describe "advancing statuses" do
    it "advances todo list items" do
      with_file(content) do |file|
        vim.normal "gg"
        vim.feedkeys " j j j "
        vim.write


        expect(file.read).to eq(<<~NEW)
        #{SIGIL} [•] Todo item
        #{SIGIL} [✔] In progress item
        #{SIGIL} [⚑] Done item
        #{SIGIL} [ ] Flagged item
        NEW
      end
    end

    context "with custom symbols" do
      it "advances with the custom symbols" do
        content = <<~CONTENT
          #{SIGIL} [T] Todo item
          #{SIGIL} [I] Doing item
          #{SIGIL} [Z] Donezo item
          #{SIGIL} [S] Stuck item
        CONTENT

        vim.command("let g:tada_todo_statuses = ['todo', 'doing', 'donezo', 'stuck']")
        vim.command("let g:tada_todo_symbols = { 'todo': 'T', 'doing': 'I', 'donezo': 'Z', 'stuck': 'S' }")

        with_file(content) do |file|
          vim.normal "gg"
          vim.feedkeys " j j j "
          vim.write

          expect(file.read).to eq(<<~NEW)
            #{SIGIL} [I] Todo item
            #{SIGIL} [Z] Doing item
            #{SIGIL} [S] Donezo item
            #{SIGIL} [T] Stuck item
          NEW
        end
      end
    end
  end

  it "doesn't move the cursor if after the box" do
    content = <<~CONTENT
      #{SIGIL} [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg03w"
      vim.feedkeys ' iMy '
      vim.write

      expect(file.read).to eq(<<~NEW)
        #{SIGIL} [•] My Todo item
      NEW
    end
  end

  it "doesn't move the cursor if before the box" do
    content = <<~CONTENT
      #{SIGIL} [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg0"
      vim.feedkeys ' iMy '
      vim.write

      expect(file.read).to eq(<<~NEW)
        My #{SIGIL} [•] Todo item
      NEW
    end
  end

  it "doesn't move the cursor if in the box" do
    content = <<~CONTENT
      #{SIGIL} [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg0wl"
      vim.feedkeys ' iMy'
      vim.write

      expect(file.read).to eq(<<~NEW)
        #{SIGIL} [My•] Todo item
      NEW
    end
  end
end

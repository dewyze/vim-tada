RSpec.describe "todo" do
  let(:content) do
    <<~CONTENT
      - [ ] Todo item
      - [•] In progress item
      - [✔︎] Done item
      - [⚑] Blocked item
    CONTENT
  end

  describe "advancing statuses" do
    it "advances todo list items" do
      with_file(content) do |file|
        vim.normal "gg"
        vim.feedkeys " j j j "
        vim.write

        expect(file.read).to eq(<<~NEW)
        - [•] Todo item
        - [✔︎] In progress item
        - [⚑] Done item
        - [ ] Blocked item
        NEW
      end
    end

    context "with custom symbols" do
      it "advances with the custom symbols" do
        content = <<~CONTENT
          - [T] Todo item
          - [I] Doing item
          - [Z] Donezo item
          - [S] Stuck item
        CONTENT

        vim.command("let g:tada_todo_statuses = ['todo', 'doing', 'donezo', 'stuck']")
        vim.command("let g:tada_todo_symbols = { 'todo': 'T', 'doing': 'I', 'donezo': 'Z', 'stuck': 'S' }")

        with_file(content) do |file|
          vim.normal "gg"
          vim.feedkeys " j j j "
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [I] Todo item
            - [Z] Doing item
            - [S] Donezo item
            - [T] Stuck item
          NEW
        end
      end
    end
  end

  it "advances todo list items in reverse" do
    with_file(content) do |file|
      vim.normal "gg"
      vim.feedkeys '\<C-space>j\<C-space>j\<C-space>j\<C-space>'
      vim.write

      expect(file.read).to eq(<<~NEW)
        - [⚑] Todo item
        - [ ] In progress item
        - [•] Done item
        - [✔︎] Blocked item
      NEW
    end
  end

  it "doesn't move the cursor if after the box" do
    content = <<~CONTENT
      - [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg03w"
      vim.feedkeys ' iMy '
      vim.write

      expect(file.read).to eq(<<~NEW)
        - [•] My Todo item
      NEW
    end
  end

  it "doesn't move the cursor if before the box" do
    content = <<~CONTENT
      - [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg0"
      vim.feedkeys ' iMy '
      vim.write

      expect(file.read).to eq(<<~NEW)
        My - [•] Todo item
      NEW
    end
  end

  it "doesn't move the cursor if in the box" do
    content = <<~CONTENT
      - [ ] Todo item
    CONTENT

    with_file(content) do |file|
      vim.normal "gg0wl"
      vim.feedkeys ' iMy'
      vim.write

      expect(file.read).to eq(<<~NEW)
        - [My•] Todo item
      NEW
    end
  end
end

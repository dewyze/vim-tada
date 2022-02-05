RSpec.describe "todo" do
  let(:content) do
    <<~CONTENT
      - [ ] Todo item
      - [•] In progress item
      - [✔︎] Done item
      - [☒] Blocked item
    CONTENT
  end

  it "advances todo list items" do
    with_file(content) do |file|
      vim.normal "gg"
      vim.feedkeys " j j j "
      vim.write

      expect(file.read).to eq(<<~NEW)
        - [•] Todo item
        - [✔︎] In progress item
        - [☒] Done item
        - [ ] Blocked item
      NEW
    end
  end

  it "advances todo list items in reverse" do
    with_file(content) do |file|
      vim.normal "gg"
      vim.feedkeys '\<C-space>j\<C-space>j\<C-space>j\<C-space>'
      vim.write

      expect(file.read).to eq(<<~NEW)
        - [☒] Todo item
        - [ ] In progress item
        - [•] Done item
        - [✔︎] Blocked item
      NEW
    end
  end

  it "doesn't advance the cursor" do
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
end

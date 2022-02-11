RSpec.describe "map specs" do
  describe "<C-H> in insert mode" do
    it "empties the beginning of the line" do
      content = <<~CONTENT
        - [ ] Todo Item
        - [ ] Description
      CONTENT

      with_file(content) do |file|
        vim.normal "ggj3w"
        vim.feedkeys 'i\<C-H>'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - [ ] Todo Item
                Description
        NEW
      end
    end
  end

  describe "delete list item if immediately typing metadata" do
    it "removes the leading hyphen" do
      content = <<~CONTENT
        - Todo Item:
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>| Description'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Todo Item:
            | Description
        NEW
      end
    end
  end
end

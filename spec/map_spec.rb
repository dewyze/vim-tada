RSpec.describe "map specs" do
  describe "<C-E> in insert mode" do
    it "empties the beginning of the line" do
      content = <<~CONTENT
        - [ ] Todo Item
        - [ ] Description
      CONTENT

      with_file(content) do |file|
        vim.normal "ggj3w"
        vim.feedkeys 'i\<C-E>'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - [ ] Todo Item
                Description
        NEW
      end
    end
  end
end

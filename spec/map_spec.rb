RSpec.describe "map specs" do
  describe "<C-H> in insert mode" do
    it "works with dash lines" do
      content = <<~CONTENT
        - Topic:
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>\<C-H>Description'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            Description
        NEW
      end
    end

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

    it "works with a preceding character" do
      content = <<~CONTENT
        - [ ] Todo Item
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>\<BS>\<C-H> Description'
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
        vim.feedkeys '\<CR>|Description'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Todo Item:
            | Description
        NEW
      end
    end

    it "removes the leading todo boxes" do
      content = <<~CONTENT
        - [ ] Todo Item:
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>|Description'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - [ ] Todo Item:
                | Description
        NEW
      end
    end
  end

  describe "delete list item if immediately typing note" do
    it "removes the leading hyphen" do
      content = <<~CONTENT
        - Todo Item:
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>>Note'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Todo Item:
            > Note
        NEW
      end
    end

    it "removes the leading todo box" do
      content = <<~CONTENT
        - [ ] Todo Item:
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>>Note'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - [ ] Todo Item:
                > Note
        NEW
      end
    end
  end

  describe "dedent and remove box if typing colon after hypen or box" do
    it "removes the leading hyphen" do
      content = <<~CONTENT
        - Topic:
          - [ ] Todo Item
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<CR>:Topic 2:'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            - [ ] Todo Item
          - Topic 2:
        NEW
      end
    end

    it "removes the leading todo box" do
      content = <<~CONTENT
        - Topic 1:
          - Topic 2
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<CR>:Topic 3:'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic 1:
            - Topic 2
          - Topic 3:
        NEW
      end
    end
  end
end

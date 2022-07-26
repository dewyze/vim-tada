RSpec.describe "tabs" do
  describe "with smart tabs off" do
    it "does not indent list items" do
      content = <<~CONTENT
        #{SIGIL} Item
      CONTENT

      vim.command("let g:tada_smart_tab = 0")

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>\<Tab>Item 2'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} Item
          #{SIGIL}   Item 2
        CONTENT
      end
    end

    it "does not indent todo items" do
      content = <<~CONTENT
        #{SIGIL} [ ] Item
      CONTENT

      vim.command("let g:tada_smart_tab = 0")

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<CR>\<Tab>Item 2'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} [ ] Item
          #{SIGIL} [ ]   Item 2
        CONTENT
      end
    end

    it "does not indent note items" do
      content = <<~CONTENT
        #{SIGIL} [ ] Item
              >
      CONTENT

      vim.command("let g:tada_smart_tab = 0")

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys ' \<Tab>Note'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} [ ] Item
                >   Note
        CONTENT
      end
    end
  end

  describe "with smart tabs on" do
    it "indents list items" do
      content = <<~CONTENT
        #{SIGIL} Item
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>\<Tab>Item 2'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} Item
            #{SIGIL} Item 2
        CONTENT
      end
    end

    it "indents todo items" do
      content = <<~CONTENT
        #{SIGIL} [ ] Item
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>\<Tab>Item 2'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} [ ] Item
            #{SIGIL} [ ] Item 2
        CONTENT
      end
    end

    it "indents note items" do
      content = <<~CONTENT
        #{SIGIL} [ ] Item
              >
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys ' \<Tab>Note'
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} [ ] Item
                  > Note
        CONTENT
      end
    end

    it "does not indent non-empty lines" do
      content = <<~CONTENT
        #{SIGIL} [ ] Item
      CONTENT

      with_file(content) do |file|
        vim.normal "A"
        vim.feedkeys '\<CR>Item'
        vim.feedkeys '\<Tab>2' # Same line does not work
        vim.write

        expect(file.read).to eq(<<~CONTENT)
          #{SIGIL} [ ] Item
          #{SIGIL} [ ] Item  2
        CONTENT
      end
    end
  end
end

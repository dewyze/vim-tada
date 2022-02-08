RSpec.describe "autolines" do
  describe "with configuration off" do
    before { vim.command("let g:tada_autolines = 0") }

    it "does not insert metadata line" do
      content = <<~CONTENT
          - Topic:
            | @:john
      CONTENT

      with_file(content) do |file|
        vim.normal "2GA"
        vim.feedkeys '\<CR>$:3'
        vim.write

        expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john
              $:3
        NEW
      end
    end

    it "does not insert todo line" do
      content = <<~CONTENT
          - Topic:
            - [ ] Walk the dog
      CONTENT

      with_file(content) do |file|
        vim.normal "2GA"
        vim.feedkeys '\<CR>Milk the cat'
        vim.write

        expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Walk the dog
              Milk the cat
        NEW
      end
    end

    it "does not insert topic line" do
      content = <<~CONTENT
          - Topic:
      CONTENT

      with_file(content) do |file|
        vim.normal "1GA"
        vim.feedkeys '\<CR>Milk the cat'
        vim.write

        expect(file.read).to eq(<<~NEW)
            - Topic:
            Milk the cat
        NEW
      end
    end
  end

  describe "metadata" do
    context "with a non empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            | @:john
        CONTENT
      end

      it "adds the metadata symbol for <CR>" do
        with_file(content) do |file|
          vim.normal "2GA"
          vim.feedkeys '\<CR>$:3'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john
              | $:3
          NEW
        end
      end

      it "adds the metadata symbol for o" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys 'o$:3'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john
              | $:3
          NEW
        end
      end

      it "adds the metadata symbol for O" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys 'O$:3'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | $:3
              | @:john
          NEW
        end
      end
    end

    context "with an empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            | @:john
            |
        CONTENT
      end

      it "removes the pipe and adds a blank line for <CR>" do
        with_file(content) do |file|
          vim.normal "3GA"
          vim.feedkeys '\<CR>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john

              Hello
          NEW
        end
      end

      it "removes the pipe and adds a blank line for o" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys 'oHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john

              Hello
          NEW
        end
      end

      it "adds the metadata symbol for O" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys 'OHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              | @:john
              | Hello
              |
          NEW
        end
      end
    end
  end

  describe "todo list items" do
    context "with a non empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            - [ ] Feed the dog
        CONTENT
      end

      it "adds a todo box for <CR>" do
        with_file(content) do |file|
          vim.normal "2GA"
          vim.feedkeys '\<CR>Milk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Feed the dog
              - [ ] Milk the cat
          NEW
        end
      end

      it "adds a todo box for o" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys "oMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Feed the dog
              - [ ] Milk the cat
          NEW
        end
      end

      it "adds a todo box for O" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys 'OMilk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Milk the cat
              - [ ] Feed the dog
          NEW
        end
      end
    end

    context "with an empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            - [ ] Feed the dog
            - [ ]
        CONTENT
      end

      it "removes the pipe and adds a blank line for <CR>" do
        with_file(content) do |file|
          vim.normal "3GA"
          vim.feedkeys '\<CR>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Feed the dog

              Hello
          NEW
        end
      end

      it "removes the pipe and adds a blank line for o" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys 'oHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Feed the dog

              Hello
          NEW
        end
      end

      it "adds a todo box for O" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys "OMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - [ ] Feed the dog
              - [ ] Milk the cat
              - [ ]
          NEW
        end
      end
    end

    it "adds the configured todo state" do
      content = <<~CONTENT
          - Topic:
            - [◦] Feed the dog
      CONTENT

      vim.command "let g:tada_todo_symbols = { 'todo': '◦', 'in_progress': '•', 'done': '✔︎', 'blocked':'☒' }"
      with_file(content) do |file|
        vim.normal "2GA"
        vim.feedkeys '\<CR>Hello'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            - [◦] Feed the dog
            - [◦] Hello
        NEW

      end
    end

    it "uses the configured empty state" do
      content = <<~CONTENT
          - Topic:
            - [◦]
      CONTENT

      vim.command "let g:tada_todo_symbols = { 'todo': '◦', 'in_progress': '•', 'done': '✔︎', 'blocked':'☒' }"
      with_file(content) do |file|
        vim.normal "2GA"
        vim.feedkeys '\<CR>Hello'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:

            Hello
        NEW

      end
    end
  end

  describe "list items" do
    context "with a non empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            - Feed the dog
        CONTENT
      end

      it "adds a list item for <CR>" do
        with_file(content) do |file|
          vim.normal "2GA"
          vim.feedkeys '\<CR>Milk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Feed the dog
              - Milk the cat
          NEW
        end
      end

      it "adds a list item for o" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys "oMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Feed the dog
              - Milk the cat
          NEW
        end
      end

      it "adds a list item for O" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys 'OMilk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Milk the cat
              - Feed the dog
          NEW
        end
      end
    end

    context "with an empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
            - Feed the dog
            -
        CONTENT
      end

      it "removes the dash and adds a blank line for <CR>" do
        with_file(content) do |file|
          vim.normal "3GA"
          vim.feedkeys '\<CR>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Feed the dog

              Hello
          NEW
        end
      end

      it "removes the dash and adds a blank line for o" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys 'oHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Feed the dog

              Hello
          NEW
        end
      end

      it "adds a list item for O" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys "OMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
              - Feed the dog
              - Milk the cat
              -
          NEW
        end
      end
    end
  end

  describe "topics" do
    context "with a non empty line" do
      let(:content) do
        <<~CONTENT
          - Topic:
        CONTENT
      end

      it "adds a list item for <CR>" do
        with_file(content) do |file|
          vim.normal "1GA"
          vim.feedkeys '\<CR>Milk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
            - Milk the cat
          NEW
        end
      end

      it "adds a list item for o" do
        with_file(content) do |file|
          vim.normal "1G$"
          vim.feedkeys "oMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Topic:
            - Milk the cat
          NEW
        end
      end

      it "adds a list item for O" do
        with_file(content) do |file|
          vim.normal "1G$"
          vim.feedkeys 'OMilk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Milk the cat
            - Topic:
          NEW
        end
      end
    end
  end
end

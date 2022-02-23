RSpec.describe "box toggle specs" do
  describe "<C-B> converting boxes to list items" do
    context "in normal mode" do
      it "doesn't move the cursor if after the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg03w"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW
        end
      end

      it "doesn't move the cursor if before the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg0"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW
        end
      end

      it "doesn't move the cursor if in the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg02w"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW

          vim.normal "gg0w"
          vim.feedkeys '\<C-B>iMy '
          vim.write

          file.rewind
          expect(file.read).to eq(<<~NEW)
            - [ ] My Todo item
          NEW
        end
      end

      it "works with an empty box" do
        content = <<~CONTENT
          - [ ]
        CONTENT

        with_file(content) do |file|
          vim.normal "gg$"
          vim.feedkeys '\<C-B>aHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Hello
          NEW
        end
      end

      it "adds a box at same level for empty line below todo item" do
        content = <<~CONTENT
          - [ ] Todo Item
                A
        CONTENT

        with_file(content) do |file|
          vim.normal "G$x"
          vim.feedkeys '\<C-B>aHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Todo Item
            - [ ] Hello
          NEW
        end

      end
    end

    context "in insert mode" do
      it "doesn't move the cursor if after the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg03wi"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW
        end
      end

      it "doesn't move the cursor if before the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg0i"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW
        end
      end

      it "doesn't move the cursor if in the box" do
        content = <<~CONTENT
          - [ ] Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg02wi"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Todo item
          NEW

          vim.normal "gg0w"
          vim.feedkeys 'i\<C-B>My '
          vim.write

          file.rewind
          expect(file.read).to eq(<<~NEW)
            - [ ] My Todo item
          NEW
        end
      end

      it "works with an empty box" do
        content = <<~CONTENT
          - [ ]
        CONTENT

        with_file(content) do |file|
          vim.normal "gg$"
          vim.feedkeys 'i\<C-B>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Hello
          NEW
        end
      end

      it "adds a box at same level for empty line below todo item" do
        content = <<~CONTENT
          - [ ] Todo Item
                A
        CONTENT

        with_file(content) do |file|
          vim.normal "G$a"
          vim.feedkeys '\<BS>\<C-B>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Todo Item
            - [ ] Hello
          NEW
        end

      end
    end
  end

  describe "<C-B> converting list items to boxes" do
    context "in normal mode" do
      it "doesn't move the cursor if after the box" do
        content = <<~CONTENT
          - Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg02w"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Todo item
          NEW
        end
      end

      it "doesn't move the cursor if before the box" do
        content = <<~CONTENT
          - Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg0"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Todo item
          NEW
        end
      end

      it "works with an empty item" do
        content = <<~CONTENT
          -
        CONTENT

        with_file(content) do |file|
          vim.normal "gg$"
          vim.feedkeys '\<C-B>AHello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Hello
          NEW
        end
      end

      it "works with box configuration" do
        content = <<~CONTENT
          - Todo item
        CONTENT

        vim.command("let g:tada_todo_statuses = ['doing', 'donezo']")
        vim.command("let g:tada_todo_symbols = {'doing': 'o', 'donezo': 'd' }")

        with_file(content) do |file|
          vim.normal "$"
          vim.feedkeys '\<C-B>'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [o] Todo item
          NEW
        end

      end
    end

    context "in insert mode" do
      it "doesn't move the cursor if after the box" do
        content = <<~CONTENT
          - Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg02wi"
          vim.feedkeys '\<C-B>my '
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Todo my item
          NEW
        end
      end

      it "doesn't move the cursor if before the box" do
        content = <<~CONTENT
          - Todo item
        CONTENT

        with_file(content) do |file|
          vim.normal "gg0i"
          vim.feedkeys '\<C-B>My '
          vim.write

          expect(file.read).to eq(<<~NEW)
            My - [ ] Todo item
          NEW
        end
      end

      it "works with an empty list item" do
        content = <<~CONTENT
          -
        CONTENT

        with_file(content) do |file|
          vim.normal "A"
          vim.feedkeys '\<C-B>Hello'
          vim.write

          expect(file.read).to eq(<<~NEW)
            - [ ] Hello
          NEW
        end
      end
    end
  end

  describe "<C-B> converting non dash items to boxes" do
    it "works with a description" do
      content = <<~CONTENT
        - Topic:
          - [ ] Todo item
                Description
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<C-B>'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            - [ ] Todo item
            - [ ] Description
        NEW
      end
    end

    it "works with a quote" do
      content = <<~CONTENT
        - Topic:
          - [ ] Todo item
                >
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<C-B> Hello'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            - [ ] Todo item
            - [ ] > Hello
        NEW
      end
    end

    it "works with a comment" do
      content = <<~CONTENT
        - Topic:
          - [ ] Todo item
                #
      CONTENT

      with_file(content) do |file|
        vim.normal "GA"
        vim.feedkeys '\<C-B> Hello'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - Topic:
            - [ ] Todo item
            - [ ] # Hello
        NEW
      end

    end
  end
end

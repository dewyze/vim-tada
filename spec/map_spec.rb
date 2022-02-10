RSpec.describe "map specs" do
  describe "<C-B> adding/removing boxes" do
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

          # This one is weird. I wish it would produce the empty space between
          # them, but it does not in normal mode. It's also made complicated
          # by the fact that I trim all whitespace at the end of lines (thus
          # all the "Hello" strings added so they work in my tests.
          # For now, I'm not worried about someone changing a box but not
          # typing. If they have an empty string, they can still do it in one
          # character with 'a'.
          expect(file.read).to eq(<<~NEW)
            - Hello
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
    end
  end
end

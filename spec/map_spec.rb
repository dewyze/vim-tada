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
    end
  end
end

RSpec.describe "map specs" do
  describe "remaps" do
    it "remaps spaces for todo toggling" do
      content = <<~CONTENT
        - [ ] Todo item
      CONTENT

      vim.command("let g:tada_todo_switch_status_mapping = \"<C-S>\"")
      with_file(content) do |file|
        vim.normal "$"
        vim.feedkeys '\<C-S>'
        vim.write

        expect(file.read).to eq(<<~NEW)
          - [•] Todo item
        NEW
      end
    end
  end

  describe "nomap" do
    it "disables maps" do
      content = <<~CONTENT
          - [ ] Todo item
      CONTENT

      vim.command("let g:tada_no_map = 1")
      with_file(content) do |file|
        vim.normal "$"
        vim.feedkeys '\<Space>'
        vim.write

        expect(file.read).to eq(<<~NEW)
            - [ ] Todo item
        NEW
      end
    end
  end

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

  describe "goto maps" do
    let(:content) do
      <<~CONTENT
          - Parent 1:
            - Topic 1:
              - [ ] Todo 1
              - Topic 2:
                - [ ] Todo 2
            - Topic 3:
              - [ ] Todo 3
      CONTENT
    end

    context "with '('" do
      it "does nothing if off" do
        vim.command("let g:tada_goto_maps = 0")

        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys "(iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            X- Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to previous topic when not on topic" do
        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys "(iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to previous sibling when on topic" do
        with_file(content) do |file|
          vim.normal "6G$"
          vim.feedkeys "(iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1X:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to previous parent when on first topic" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys "(iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1X:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo 3
          NEW
        end
      end
    end

    context "with '{'" do
      it "does nothing if off" do
        vim.command("let g:tada_goto_maps = 0")

        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys "{iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            X- Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to previous parent topic when not on topic" do
        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys "{iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to previous parent when on topic" do
        with_file(content) do |file|
          vim.normal "6G$"
          vim.feedkeys "{iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1X:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo 3
          NEW
        end
      end
    end

    context "with ')'" do
      it "does nothing if off" do
        vim.command("let g:tada_goto_maps = 0")

        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys ")iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo X3
          NEW
        end
      end

      it "goes to next topic when not on topic" do
        with_file(content) do |file|
          vim.normal "3G$"
          vim.feedkeys ")iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to next sibling when on topic" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys ")iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to next parent when on first topic" do
        with_file(content) do |file|
          vim.normal "3G$"
          vim.feedkeys ")iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end
    end

    context "with '}'" do
      it "does nothing if off" do
        vim.command("let g:tada_goto_maps = 0")

        with_file(content) do |file|
          vim.normal "G$"
          vim.feedkeys "}iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3:
                - [ ] Todo X3
          NEW
        end
      end

      it "goes to next parent topic when not on topic" do
        with_file(content) do |file|
          vim.normal "3G$"
          vim.feedkeys "}iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to next parent when on topic" do
        with_file(content) do |file|
          vim.normal "4G$"
          vim.feedkeys "}iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end

      it "goes to next parent when on first topic" do
        with_file(content) do |file|
          vim.normal "3G$"
          vim.feedkeys ")iX"
          vim.write

          expect(file.read).to eq(<<~NEW)
            - Parent 1:
              - Topic 1:
                - [ ] Todo 1
                - Topic 2:
                  - [ ] Todo 2
              - Topic 3X:
                - [ ] Todo 3
          NEW
        end
      end
    end
  end
end

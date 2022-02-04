RSpec.describe "autolines" do
  describe "metadata" do
    context "with a non empty line" do
      let(:content) do
        <<~CONTENT
          Topic:
            | @:john
        CONTENT
      end

      it "adds the metadata symbol for <CR>" do
        with_file(content) do |file|
          vim.normal "2GA"
          vim.feedkeys '\<CR>$:3'
          vim.write

          expect(file.read).to eq(<<~NEW)
            Topic:
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
            Topic:
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
            Topic:
              | $:3
              | @:john
          NEW
        end
      end
    end

    context "with an empty line" do
      let(:content) do
        <<~CONTENT
          Topic:
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
            Topic:
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
            Topic:
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
            Topic:
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
          Topic:
            - [ ] Feed the dog
        CONTENT
      end

      it "adds the metadata symbol for <CR>" do
        with_file(content) do |file|
          vim.normal "2GA"
          vim.feedkeys '\<CR>Milk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
          Topic:
            - [ ] Feed the dog
            - [ ] Milk the cat
          NEW
        end
      end

      it "adds the metadata symbol for o" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys "oMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            Topic:
              - [ ] Feed the dog
              - [ ] Milk the cat
          NEW
        end
      end

      it "adds the metadata symbol for O" do
        with_file(content) do |file|
          vim.normal "2G$"
          vim.feedkeys 'OMilk the cat'
          vim.write

          expect(file.read).to eq(<<~NEW)
            Topic:
              - [ ] Milk the cat
              - [ ] Feed the dog
          NEW
        end
      end
    end

    context "with an empty line" do
      let(:content) do
        <<~CONTENT
          Topic:
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
            Topic:
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
            Topic:
              - [ ] Feed the dog

              Hello
          NEW
        end
      end

      it "adds the metadata symbol for O" do
        with_file(content) do |file|
          vim.normal "3G"
          vim.feedkeys "OMilk the cat"
          vim.write

          expect(file.read).to eq(<<~NEW)
            Topic:
              - [ ] Feed the dog
              - [ ] Milk the cat
              - [ ]
          NEW
        end
      end
    end
  end

  describe "list items" do

  end
end

RSpec.describe "syntax" do
  describe "topic levels" do
    let(:content) do
      <<~CONTENT
      - Milestone:
        | @:john
        - Epic:
          My description
          - Story:
            Description with -
      CONTENT
    end

    it "parses non-todo items" do
      with_file(content) do
        expect("Milestone").to have_highlight("tadaTopicTitle1")
        expect("Epic").to have_highlight("tadaTopicTitle2")
        expect("Story").to have_highlight("tadaTopicTitle3")
        expect("@:john").to have_highlight("tadaMetadata")
        expect("My description").to have_highlight("tadaDescription")
        expect("Description with -").to have_highlight("tadaDescription")
      end
    end
  end

  describe "todo items" do
    after do
      vim.command("unlet g:tada_todo_symbols")
      vim.command("unlet g:tada_todo_symbols_set")
    end

    context "with unicode symbols" do
      it "parses todo items" do
        content = <<~CONTENT
          - [ ] Todo item
          - [•] In progress item
          - [✔︎] Done item
          - [☒] Blocked item
        CONTENT

        with_file(content) do
          expect("\\[ ] Todo item").to have_highlight("tadaTodoItemBlank")
          expect("\\[•] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[✔︎] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[☒] Blocked item").to have_highlight("tadaTodoItemBlocked")
        end
      end
    end

    context "with ascii symbols" do
      it "parses todo items" do
        vim.command("let g:tada_todo_symbols_set = 'ascii'")

        content = <<~CONTENT
          - [ ] Todo item
          - [-] In progress item
          - [x] Done item
          - [o] Blocked item
        CONTENT

        with_file(content) do
          expect("\\[ ] Todo item").to have_highlight("tadaTodoItemBlank")
          expect("\\[\-] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[x] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[o] Blocked item").to have_highlight("tadaTodoItemBlocked")
        end
      end
    end

    context "with custom symbols" do
      it "parses todo items" do
        vim.command("let g:tada_todo_symbols = { 'todo': 'T', 'inProgress': 'I', 'done': 'D', 'blocked': 'B' }")

        content = <<~CONTENT
          - [T] Todo item
          - [I] In progress item
          - [D] Done item
          - [B] Blocked item
        CONTENT

        with_file(content) do
          expect("\\[T] Todo item").to have_highlight("tadaTodoItemBlank")
          expect("\\[I] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[D] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[B] Blocked item").to have_highlight("tadaTodoItemBlocked")
        end
      end
    end
  end
end

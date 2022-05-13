RSpec.describe "syntax" do
  describe "topic levels" do
    let(:content) do
      <<~CONTENT
      #{SIGIL} Milestone:
        | @:john
        #{SIGIL} Epic:
        # #{SIGIL} Commented:
          My description
          #{SIGIL} Story:
            Description with #{SIGIL}
          #{SIGIL} List item
            #{SIGIL} Level 4:
              #{SIGIL} Level 5:
                #{SIGIL} Level 6:
                  > Note
      CONTENT
    end

    it "parses non-todo items" do
      with_file(content) do
        expect("Milestone").to have_highlight("tadaTopicTitle1")
        expect("Epic").to have_highlight("tadaTopicTitle2")
        expect("Commented").to have_highlight("tadaComment")
        expect("Story").to have_highlight("tadaTopicTitle3")
        expect("Level 4").to have_highlight("tadaTopicTitle4")
        expect("Level 5").to have_highlight("tadaTopicTitle5")
        expect("Level 6").to have_highlight("tadaTopicTitle6")
        expect("@:john").to have_highlight("tadaMetadata")
        expect("My description").to have_highlight("tadaDescription")
        expect("Description with #{SIGIL}").to have_highlight("tadaDescription")
        expect("List item").to have_highlight("tadaListItem")
        expect("Note").to have_highlight("tadaNote")
      end
    end

    it "parses an empty list item" do
      content = <<~CONTENT
        #{SIGIL}
      CONTENT
      with_file(content) do
        expect("#{SIGIL}").to have_highlight("tadaListItem")
      end
    end

    it "parses a single character list item" do
      content = <<~CONTENT
        #{SIGIL} A
      CONTENT

      with_file(content) do
        expect("A").to have_highlight("tadaListItem")
      end
    end
  end

  describe "todo items" do
    context "with unicode symbols" do
      it "parses todo items" do
        content = <<~CONTENT
         #{SIGIL}[ ] Todo item 1
          #{SIGIL}[ ] Todo item 2
          #{SIGIL} [ ] Todo item 3
          #{SIGIL} [•] In progress item
          #{SIGIL} [✔] Done item
          #{SIGIL} [⚑] Flagged item
        CONTENT

        with_file(content) do
          expect("\\[ ] Todo item 1").to have_highlight("tadaTodoItemBlank")
          expect("\\[ ] Todo item 2").to have_highlight("tadaTodoItemBlank")
          expect("\\[ ] Todo item 3").to have_highlight("tadaTodoItemBlank")
          expect("\\[•] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[✔] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[⚑] Flagged item").to have_highlight("tadaTodoItemFlagged")
        end
      end
    end

    context "with ascii symbols" do
      it "parses todo items" do
        vim.command("let g:tada_todo_style = 'ascii'")

        content = <<~CONTENT
          #{SIGIL} [ ] Todo item
          #{SIGIL} [-] In progress item
          #{SIGIL} [x] Done item
          #{SIGIL} [O] Flagged item
        CONTENT

        with_file(content) do
          expect("\\[ ] Todo item").to have_highlight("tadaTodoItemBlank")
          expect("\\[\-] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[x] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[O] Flagged item").to have_highlight("tadaTodoItemFlagged")
        end
      end
    end

    context "with custom symbols" do
      it "parses todo items" do
        vim.command("let g:tada_todo_symbols = { 'blank': 'T', 'in_progress': 'I', 'done': 'D', 'flagged': 'B' }")

        content = <<~CONTENT
          #{SIGIL} [T] Todo item
          #{SIGIL} [I] In progress item
          #{SIGIL} [D] Done item
          #{SIGIL} [B] Flagged item
        CONTENT

        with_file(content) do
          expect("\\[T] Todo item").to have_highlight("tadaTodoItemBlank")
          expect("\\[I] In progress item").to have_highlight("tadaTodoItemInProgress")
          expect("\\[D] Done item").to have_highlight("tadaTodoItemDone")
          expect("\\[B] Flagged item").to have_highlight("tadaTodoItemFlagged")
        end
      end
    end

    context "with custom todo statuses" do
      it "parses todo items" do
        vim.command("let g:tada_todo_statuses = ['todo', 'doing', 'donezo']")
        vim.command("let g:tada_todo_symbols = { 'todo': 'T', 'doing': 'I', 'donezo': 'D', 'flagged': 'B' }")

        content = <<~CONTENT
          #{SIGIL} [T] Todo item
          #{SIGIL} [I] In progress item
          #{SIGIL} [D] Done item
          #{SIGIL} [B] Flagged item
        CONTENT

        with_file(content) do
          expect("\\[T] Todo item").to have_highlight("tadaTodoItemTodo")
          expect("\\[I] In progress item").to have_highlight("tadaTodoItemDoing")
          expect("\\[D] Done item").to have_highlight("tadaTodoItemDonezo")
          expect("\\[B] Flagged item").to have_highlight("")
        end
      end
    end
  end
end

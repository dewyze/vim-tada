RSpec.describe "syntax" do
  describe "topic levels" do
    specify "parses level 1 topic" do
      assert_correct_highlighting(<<~FILE, "Milestone", "tadaLevel1TopicTitle")
      - Milestone:
        - Epic:
          - Story:
      FILE
    end

    specify "parses level 2 topic" do
      assert_correct_highlighting(<<~FILE, "Epic", "tadaLevel2TopicTitle")
      - Milestone:
        - Epic:
          - Story:
      FILE
    end

    specify "parses level 3 topic" do
      assert_correct_highlighting(<<~FILE, "Story", "tadaLevel3TopicTitle")
      - Milestone:
        - Epic:
          - Story:
      FILE
    end
  end
end

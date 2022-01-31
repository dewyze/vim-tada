RSpec.describe "syntax" do
  describe "topic levels" do
    let(:content) do
      <<~CONTENT
      - Milestone:
        - Epic:
          - Story:
      CONTENT
    end

    it "parses the file" do
      with_file(content) do
        expect("Milestone").to have_highlight("tadaLevel1TopicTitle")
        expect("Epic").to have_highlight("tadaLevel2TopicTitle")
        expect("Story").to have_highlight("tadaLevel3TopicTitle")
      end
    end
  end
end

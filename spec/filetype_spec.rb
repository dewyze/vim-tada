RSpec.describe "filetype" do
  it "returns true for a '.tada' file" do
    with_file do
      expect(vim.echo("&filetype")).to eq("tada")
    end
  end
end

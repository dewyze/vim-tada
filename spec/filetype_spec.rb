RSpec.describe "filetype" do
  it "returns true for a '.tada' file" do
    Tempfile.create(%w[file .tada]) do |file|
      vim.edit file.path

      expect(vim.echo("&filetype")).to eq("tada")
    end
  end
end

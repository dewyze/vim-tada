RSpec.describe "config specs" do
  it "sets buffer variables from config lines" do
    content = <<~CONTENT
      Topic:
       - Thing

      @config.buffer_var = "value"
    CONTENT

    with_file(content) do |file|
      expect(vim.echo("b:tada_buffer_var")).to eq("value")
    end
  end
end

require "open3"
# require "origami"
# include Origami
RSpec.describe Tectonic do
  it "has a version number" do
    expect(Tectonic::VERSION).not_to be nil
  end

  it "PDF generation" do
    latex = <<-EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world!
      \\end{document}
    EOS
    # a.pdf
    Open3.capture2 "tectonic -", stdin_data: latex
    FileUtils.mv "texput.pdf", "a.pdf"
    # b.pdf
    pdf = Tectonic.latex_to_pdf latex
    bin = pdf.pack "C*"
    File.binwrite "b.pdf", bin
    # Compare
    #
    # Tectonic cannot generate same PDF
    # zeros = sprintf("%032d", 0) # Dummy R/ID
    # a_pdf = PDF.read "a.pdf"
    # a_pdf.trailer.ID = [zeros, zeros] # Set dummy R/ID
    # a_pdf.save "a.pdf"
    # b_pdf = PDF.read "b.pdf"
    # b_pdf.trailer.ID = [zeros, zeros] # Set dummy R/ID
    # b_pdf.save "b.pdf"
    # cmp = FileUtils.cmp "a.pdf", "b.pdf" 
    # We compare two files as png
    #
    system "gs", "-sDEVICE=png16m", "-o",  "a.png", "a.pdf"
    system "gs", "-sDEVICE=png16m", "-o",  "b.png", "b.pdf"
    cmp = FileUtils.cmp "a.png", "b.png" 
    expect(cmp).to eq true
    # Clean up
    FileUtils.rm_f ["a.pdf", "a.png", "b.pdf", "b.png"]
  end
end

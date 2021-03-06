require 'open3'
require 'origami'
include Origami

RSpec.describe Tectonic do
  it 'has a version number' do
    expect(Tectonic::VERSION).not_to be nil
  end

  it 'PDF generation' do
    latex = <<-CODE
      \\documentclass{article}
      \\begin{document}
      Hello, world!
      \\end{document}
    CODE
    # https://github.com/tectonic-typesetting/tectonic/issues/284
    # To be deterministic behavior, 
    ENV['SOURCE_DATE_EPOCH'] = '1456304492'
    # a.pdf
    Open3.capture2('tectonic -', stdin_data: latex)
    FileUtils.mv('texput.pdf', 'a.pdf')
    # b.pdf
    bin = Tectonic.latex_to_pdf(latex).pack('C*')
    File.binwrite('b.pdf', bin)
    # Normalize
    # Because R/ID in PDF is generated by pathname
    pdf = PDF.read('a.pdf')
    pdf.trailer.ID = ['0' * 32, '0' * 32]
    pdf.save('a.pdf')
    pdf = PDF.read('b.pdf')
    pdf.trailer.ID = ['0' * 32, '0' * 32]
    pdf.save('b.pdf')
    # Compare
    cmp = FileUtils.cmp('a.pdf', 'b.pdf')
    expect(cmp).to eq true
    # Clean up
    FileUtils.rm_f(['texput.tex', 'a.pdf', 'b.pdf'])
  end

  it 'Nil check' do
    latex = <<-CODE
      \\documentclass{article}
      \\begin{document}
      Hello, world!
    CODE
    # b.pdf
    expect(Tectonic.latex_to_pdf(latex)).to eq nil
  end

  it 'PDF generation with file' do
    latex = <<-CODE
      \\documentclass{article}
      \\begin{document}
      Hello, world!
      \\end{document}
    CODE
    File.write('texput.tex', latex)
    # https://github.com/tectonic-typesetting/tectonic/issues/284
    # To be deterministic behavior, 
    ENV['SOURCE_DATE_EPOCH'] = '1456304492'
    # a.pdf
    system('tectonic', 'texput.tex')
    FileUtils.mv('texput.pdf', 'a.pdf')
    # b.pdf
    Tectonic.convert_file('texput.tex', to_file: true)
    FileUtils.mv('texput.pdf', 'b.pdf')
    # Normalize
    # Because R/ID in PDF is generated by pathname
    pdf = PDF.read('a.pdf')
    pdf.trailer.ID = ['0' * 32, '0' * 32]
    pdf.save('a.pdf')
    pdf = PDF.read('b.pdf')
    pdf.trailer.ID = ['0' * 32, '0' * 32]
    pdf.save('b.pdf')
    # Compare
    cmp = FileUtils.cmp('a.pdf', 'b.pdf')
    expect(cmp).to eq true
    # Clean up
    FileUtils.rm_f(['texput.tex', 'a.pdf', 'b.pdf'])
  end

  it 'Nil check with file' do
    latex = <<-CODE
      \\documentclass{article}
      \\begin{document}
      Hello, world!
    CODE
    # b.pdf
    File.write('texput.tex', latex)
    expect(Tectonic.convert_file('texput.tex')).to eq nil
  end
end

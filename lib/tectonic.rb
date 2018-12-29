require "helix_runtime"
require "tectonic_ruby/native"
# Namespace for methods exported by tectonic_ruby/native
# @since 0.1.0
module Tectonic
    # Compile LaTeX text to a PDF
    # @author TANIGUCHI Masaya
    #
    # @see https://docs.rs/tectonic/0.1.11/tectonic/fn.latex_to_pdf.html
    #
    # @example Compile text
    # latex = <<-EOS
    # \usepackage{article}
    # \begin{document}
    # Hello, Tectonic!
    # \end{document}
    # EOS
    # pdf = Tectonic.latex_to_pdf(latex)
    #
    # @param [String] latex LaTeX text
    # @return [Array<Integer>, nil] Array of byte that represents a PDF
    def self.latex_to_pdf(latex)
        TectonicRuby.latex_to_pdf(latex)&.pack("L*")&.bytes
    end
end


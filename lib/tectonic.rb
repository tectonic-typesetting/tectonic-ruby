require "helix_runtime"
require "tectonic_ruby/native"
# Namespace for methods exported by tectonic_ruby/native
# @since 0.1.0
module Tectonic
    # Compile LaTeX text to a PDF
    # @author Tectonic Typesetting Team 
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
    # pdf = Tectonic.latex_to_pdf latex
    #
    # @param [String] latex LaTeX text
    # @return [Array<Integer>, nil] Array of byte that represents a PDF
    def self.latex_to_pdf latex
        pdf = TectonicRuby.latex_to_pdf latex
        bytes = pdf.pack("L*").bytes    # Convert uint32_t[] to uint8_t[]
        bytes[0..(bytes.rindex 0x0a)]   # Drop NULL in the last 4 bytes
        # Note: PDF file ends `%%EOF<LF>`
        # We use uint32_t[] in Rust and Ruby, because Helix (Rust to Ruby bridge) doesn't support uint8_t[]
    end
end


require "helix_runtime"
require "tectonic_ruby/native"

class BinData
    def bytes
        self.raw().pack("L*").bytes[0...self.capacity()]
    end
end

class Array
    def to_bindata
        raw = self.pack("C*").unpack("L*") 
        len = raw.length
        BinData.new raw, len
    end
end

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
        TectonicRuby.latex_to_pdf(latex)&.bytes
    end
end


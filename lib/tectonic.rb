require "helix_runtime"
require "tectonic_ruby/native"

# Class for an interaction to Rust.
# This class can convert to bytes with `bytes` method
class BinData
    # Convert to bytes
    # @author Tectonic Typesetting Team
    # @example
    #   latex = <<-EOS
    #   \usepackage{article}
    #   \begin{document}
    #   Hello, Tectonic!
    #   \end{document}
    #   EOS
    #   # TectonicRuby is an internal class exported by Helix
    #   TectonicRuby.latex_to_pdf(latex)&.bytes
    # @return [Array] bytes is an Array has uint8_t
    def bytes
        self.raw().pack("L*").bytes[0...self.capacity()]
    end
end

# Class is a builtin class added method `to_bindata`.
class Array
    # Convert to BinData
    # @author Tectonic Typesetting Team
    # @example
    #   [1,0,7].to_bindata
    # @return [BinData] An object for an interaction to Rust
    def to_bindata
        raw = self.pack("C*").unpack("L*") 
        len = self.length
        BinData.new raw, len
    end
end

# Namespace for methods exported by tectonic_ruby/native
# @since 0.1.0
module Tectonic
    # Compile LaTeX text to a PDF
    # @author Tectonic Typesetting Team 
    # @see https://docs.rs/tectonic/0.1.11/tectonic/fn.latex_to_pdf.html
    # @example Compile text
    #   latex = <<-EOS
    #   \usepackage{article}
    #   \begin{document}
    #   Hello, Tectonic!
    #   \end{document}
    #   EOS
    #   pdf = Tectonic.latex_to_pdf latex
    # @param [String] latex LaTeX text
    # @return [Array, nil] Array of byte that represents a PDF
    def self.latex_to_pdf latex
        TectonicRuby.latex_to_pdf(latex)&.bytes
    end
end


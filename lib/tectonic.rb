# frozen_string_literal: true

require 'helix_runtime'
require 'tectonic_ruby/native'

# Namespace for the communication between Rust and Ruby
# @since 0.2.0
module HelixBridge
  refine BinData do
    # Convert to bytes
    # @author The Tectonic Project
    # @example
    #   latex = <<-EOS
    #   \\usepackage{article}
    #   \\begin{document}
    #   Hello, Tectonic!
    #   \\end{document}
    #   EOS
    #   # TectonicRuby is an internal class exported by Helix
    #   TectonicRuby.latex_to_pdf(latex)&.bytes
    # @return [Array] bytes is an Array has uint8_t
    def bytes
      raw.pack('L*').bytes[0...capacity]
    end
  end

  refine Array do
    # Convert to BinData
    # @author The Tectonic Project
    # @example
    #   [1,0,7].to_bindata
    # @return [BinData] An object for an interaction to Rust
    def to_bindata
      v32 = pack('C*').unpack('L*')
      len = length
      BinData.new(v32, len)
    end
  end
end

# Namespace for methods exported by tectonic_ruby/native
# @since 0.1.0
module Tectonic
  using HelixBridge
  # Compile LaTeX text to a PDF
  # @since 0.1.0
  # @author The Tectonic Project
  # @see https://docs.rs/tectonic/0.1.11/tectonic/fn.latex_to_pdf.html
  # @example Compile text
  #   latex = <<-EOS
  #   \\usepackage{article}
  #   \\begin{document}
  #   Hello, Tectonic!
  #   \\end{document}
  #   EOS
  #   pdf = Tectonic.latex_to_pdf latex
  # @param [String] latex LaTeX text
  # @param [TrueClass, FalseClass] auto_create_config_file, Create tectonic config file automatically, since 0.2.0
  # @param [TrueClass, FalseClass] only_cached Use only cashed packages, since 0.2.0
  # @param [TrueClass, FalseClass] keep_logs Keep tectonic logs, since 0.2.0
  # @param [TrueClass, FalseClass] keep_intermediates Don't remove intermediates file, since 0.2.0
  # @param [TrueClass, FalseClass] print_stdout Print progress to stdout, since 0.2.0
  # @return [Array, nil] Array of byte that represents a PDF
  def self.latex_to_pdf(latex, auto_create_config_file: false, only_cached: false, keep_logs: false, keep_intermediates: false, print_stdout: false)
    option = LaTeXToPDFOption.new(auto_create_config_file, only_cached, keep_logs, keep_intermediates, print_stdout)
    TectonicRuby.latex_to_pdf(latex, option)&.bytes
  end

  # Compile LaTeX file to a PDF
  # @since 0.2.0
  # @author The Tectonic Project
  # @param [String] latex LaTeX file
  # @param [TrueClass, FalseClass] auto_create_config_file, Create tectonic config file automatically, 
  # @param [TrueClass, FalseClass] only_cached Use only cashed packages, 
  # @param [TrueClass, FalseClass] keep_logs Keep tectonic logs, 
  # @param [TrueClass, FalseClass] keep_intermediates Don't remove intermediates file, 
  # @param [TrueClass, FalseClass] print_stdout Print progress to stdout, 
  # @param [TrueClass, FalseClass] to_file Write the PDF to file
  # @return [Array, nil] Array of byte that represents a PDF
  def self.convert_file(filename, auto_create_config_file: false, only_cached: false, keep_logs: false, keep_intermediates: false, print_stdout: false, to_file: false)
    latex = File.read(filename)
    pdf = latex_to_pdf(latex, auto_create_config_file: auto_create_config_file, only_cached: only_cached, keep_logs: keep_logs, keep_intermediates: keep_intermediates, print_stdout: print_stdout)
    File.binwrite(filename.sub(/\.tex$/, '.pdf'), pdf.pack('C*')) if to_file && !pdf.nil?
    pdf
  end
end

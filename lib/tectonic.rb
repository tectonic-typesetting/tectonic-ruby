require "helix_runtime"
require "tectonic_ruby/native"

module Tectonic
    def self.latex_to_pdf(latex)
        TectonicRuby.latex_to_pdf(latex)
    end
end


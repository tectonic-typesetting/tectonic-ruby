require 'rubygems'
Gem.post_install do |installer|
  if installer.gem =~ /tectonic/ 
    Dir.chdir "#{__dir__}/.." do
      system "rake", "build"
    end
  end
end

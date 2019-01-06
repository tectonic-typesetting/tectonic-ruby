require 'rubygems'
require 'pp'
Gem.post_install do |installer|
  pp installer
  if installer.spec.name =~ /tectonic/ 
    Dir.chdir "#{__dir__}/.." do
      system "rake", "build"
    end
  end
end

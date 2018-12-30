require 'rubygems'
Gem.post_install do |installer|
  Dir.chdir "#{__dir__}/.." do
    system "rake", "build"
  end
end

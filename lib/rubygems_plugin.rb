require 'rubygems'
Gem.post_install do |installer|
  Dir.chdir "#{__dir__}/.." do
    #system "bundle install --path=#{__dir__}/../vendor/bundle"
    p `rake`
  end
end

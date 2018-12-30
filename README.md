# Tectonic-ruby

Tectonic binding for ruby, that is A modernized, complete, embeddable, TeX/LaTeX engine. 

## Installation

Add this line to your application's Gemfile:

```ruby
# gem 'tectonic-ruby' # Currently, we haven't pushed this gem to rubygems yet.
gem 'tectonic', github: "xtaniguchimasaya/tectonic-ruby"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tectonic-ruby

## Usage

```ruby
require 'tectonic'
latex = <<-EOS
\usepackage{article}
\begin{document}
Hello, Tectonic!
\end{document}
EOS
pdf = Tectonic.latex_to_pdf(latex)

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xtaniguchimasaya/tectonic-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

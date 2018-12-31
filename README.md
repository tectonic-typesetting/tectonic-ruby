# Tectonic-ruby

Tectonic binding for ruby, that is A modernized, complete, embeddable, TeX/LaTeX engine. 

## Installation

1. Install all the dev-dependencies of tectonic.
   See [Installing Tectonic](https://tectonic-typesetting.github.io/en-US/install.html).

2. Add this line to your application's Gemfile:

    ```ruby
    # gem 'tectonic' # Currently, we haven't pushed this gem to rubygems yet.
    gem 'tectonic', github: "tectonic-typesetting/tectonic-ruby"
    ```

3. And then execute:
    
    ```shell
    $ bundle
    ```

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

Bug reports and pull requests are welcome on GitHub at https://github.com/tectonic-typesetting/tectonic-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

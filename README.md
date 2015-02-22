# WithMotion
A RubyMotion gem that does away with needing to use `.alloc.init` to initialise Objective-C objects.

WithMotion allows you to transform this
```ruby
label = UILabel.alloc.initWithFrame([[50, 100], [100, 30]])
color = UIColor.alloc.initWithRed(0.5, green: 0.5, blue: 0.5, alpha: 0.9)
```

into this
```ruby
label = UILabel.with(frame: [[50, 100], [100, 30]])
color = UIColor.with(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
```

## Installation

Add this line to your application's Gemfile:

    gem 'WithMotion', :git => 'https://github.com/digitalfx/WithMotion.git'

And then execute:

    $ bundle

Start using and enjoy!
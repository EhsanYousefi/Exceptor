# Exceptor

Handle your exceptions with an elegant OO pattern.
## Introduction

With Exceptor handle all of your exceptions in one place, Don't repeat yourself! define a handler for your exception and use it all over the program.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exceptor', '~> 1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exceptor

## Usage

Let's define a handler for exceptions
```ruby
class ExceptionHandler < Exceptor::Base

  on(:default) do |context,error|
    # self is equal to instance which error raised on.
    # context is the closure binding
    # error contains error information such as message, exception and ...
    "#{@instance_var} #{context.local_var} raised #{error.class}"
  end

  on(StandardError) do |context,error|
    "#{@instance_var} #{context.local_var} raised StandardError"
  end

end
```
As you see, we can define a handler for all non-defined exceptions with `:default` argument.
Also inside the block you can directly access to the instance which error raised on, and you can access block binding too(from context argument).

Ok, Let's use our `ExceptionHandler`:

```ruby
class Foo
  include Exceptor::Safe
  default_exceptor ExceptionHandler

  def initialize
    @instance_var = "Foo"
  end

  def save
    local_var = "Bar"
    # Just put your dangerous code inside exceptor block, That's all
    exceptor do
      bar.save # For example bar.save is gonna raise StandardError
    end
  end

end

object = Foo.new.save
# => "Foo Bar raised StandardError"
```

As you see, you can define handler for your exceptions, and use it with `exceptor` closure! Also setting `default_exceptor` isn't required.

Also you can pass your handler like:

```ruby
exceptor(MyCustomHandler) do
  # put your dangerous code here
end
```

Exceptor is very handy, you can use it in your daily programming.

Exceptor is about 70-80 lines of code(It's small), so there isn't any performance issue.

You can use [specs](https://github.com/EhsanYousefi/Exceptor/blob/master/spec/exceptor_spec.rb) as example.

## Rails users

If you want to use Exceptor in a RoR application, [Check this out](https://github.com/EhsanYousefi/Exceptor/blob/master/ROR.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EhsanYousefi/Exceptor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# Integrate Exceptor with Rails
Exceptor is more flexible vs ActiveSupport::Rescuable & It's different in context.

There is a great pattern that fits with RoR.

At first we need to create a new directory inside the `app` directory:

    $ cd your-rails-app/app
    $ mkdir exceptions

After that, we need to paste below line inside `Application` class located in `config` directory to fix autoload problem.

```ruby
config.autoload_paths << Rails.root.join('app')
```

Imagine we want to use Exceptor in all of the controllers.

    $ cd your-rails-app/app/exceptions
    $ mkdir controllers
    $ touch application_controller.rb

Let's edit the new file `application_controller` like this:

```ruby
module Exceptions
  module Controllers
    class ApplicationController < Exceptor::Base
      on(:defualt) do |context,error|
        render json: { error: 'Something went wrong' }
      end
      on(ActiveRecord::RecordInvalid) do |context,error|
        render json: {
          errors: error.record.errors
        }  
      end
      # ...
    end
  end
end
```
The we need to edit `application_controller.rb` inside `app/controllers/` directory.

```ruby
class ApplicationController < ActionController::Base
  include Exceptor::Safe
  default_exceptor Exceptions::Controllers::ApplicatonController
end
```

You can use `exceptor` closure on all of the controllers now!

For example instead of:
```ruby
class UsersController < ApplicationController
  def create
    begin
      user.create!(user_params)
    rescue ActiveRecord::RecordInvalid
      render json: {
        errors: user.errors
      }
    end
  end
end
```
You can do:
```ruby
class UsersController < ApplicationController
  def create
    exceptor do
      user.create!(user_params)
    end
  end
end
```

That's all, It's useful isn't it?

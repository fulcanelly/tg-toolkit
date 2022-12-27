# tg toolkit

# Motivation 

I made it to simplify creation of chat bots. 

It was inspired by free monads. The main goal is make testing easier, and code more expressive.
And actually persistance also become easier.

todo

# How to use
 
```ruby
class SumNumbersState < BaseState
    def run 
        say "Enter first number:"
        first = expect_text()
        say "Enter second number:"
        second = expect_text()
        say "Result is #{first.to_i + second.to_i}"
        switch_state SumNumbersState.new()
    end
end

``` 

todo

# What it does


todo

# Depends on

* `rails`
* `colored`
* `recursive-open-struct`


# Config 

You can override config after loading library:

```ruby
Config.restore_state = true
Config.restore_actions = true
```

All available config options can be found in file src/config.rb [src/config.rb](src/config.rb)


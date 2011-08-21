require './forms'

class LoginForm < Form
  @@input = Field.new(:input, :foo)
end


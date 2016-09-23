require '../src/deberia'

class MockedMethod
  attr_accessor :name, :body

  def initialize(name, body)
    self.name = name # symbol
    self.body = body # unbound method
  end
end


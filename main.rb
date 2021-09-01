class Maker
  attr_reader :secret_code
  def initialize
    @secret_code=[]
  end
end

class Breaker

end

class HumanMaker < Maker

end

class HumanBreaker < Breaker
end

class ComputerMaker < Maker

end

class ComputerBreaker < Breaker

end

class Game

end

def main
  computer_maker = ComputerMaker.new
  computer_maker.create_code
end

main()
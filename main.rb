require_relative "string"

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
  def break_code(turn)
    puts "Turn ##{turn+1}: Type in four numbers (1-6) to guess the secret code."
    code = gets.chomp.split('')
    until code.all? {|digit| digit.to_i >=1 && digit.to_i<=6} && code.size==4
      puts "Your guess should be 4 digits between (1-6).".red
      code = gets.chomp.split('')
    end
    code
  end
end

class ComputerMaker < Maker
  def create_code
    4.times {@secret_code.push(rand(6)+1)}
  end
end

class ComputerBreaker < Breaker

end

class Game

end

def main
  # computer_maker = ComputerMaker.new
  # computer_maker.create_code
  human_breaker = HumanBreaker.new
  human_breaker.break_code(1)
end

main()
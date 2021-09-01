require_relative "string"

module Printable
  def print_one
    print "  1  ".bg_green.black
    print " "
  end

  def print_two
    print "  2  ".bg_brown.black
    print " "
  end

  def print_three
    print "  3  ".bg_blue.black
    print " "
  end

  def print_four
    print "  4  ".bg_magenta.black
    print " "
  end

  def print_five
    print "  5  ".bg_cyan.black
    print " "
  end

  def print_six
    print "  6  ".bg_gray.black
    print " "
  end

  def gray_peg
    print " ".bg_gray
    print " "
  end

  def red_peg
    print " ".bg_red
    print " "
  end

end

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
  include Printable
  def introduction
    puts "Welcome to mastermind"
    puts "This is a 1 player-game against the computer."
    puts "Here you can be either the breaker or the maker of the secret code."
    puts "There are six different number/color combinations."
    print_one; print_two; print_three; print_four; print_five; print_six
    puts 
    puts "The code maker will choose four number to create a 'secret code'. For example,"
    print_one; print_one; print_four; print_six
    puts
    puts "There can be more than one same number/color in the secret code."
    puts "To win, the code breaker needs to guess the 'secret code' in 12 or less turns."
    puts "Clues/Feedback: "
    puts "After each guess, the breaker will be given up to 4 clue to help them break the code."
    gray_peg; print "This clue means you have 1 correct number at the correct location.\n"
    red_peg; print "This clue means you have 1 correct number but at the wrong location.\n"
    puts "For example the secret code '1544' with the guess '4521' will result in the following feedback:"
    print_four; print_five; print_two; print_one;
    print "\t Clues: "
    gray_peg; red_peg; red_peg; puts
    puts "Based on the clue, this means that the guess has 1 number at the correct location and 2 number at the wrong location"
    puts "It's time to play!"
  end

end

def main
  # computer_maker = ComputerMaker.new
  # computer_maker.create_code
  # human_breaker = HumanBreaker.new
  # human_breaker.break_code(1)
  game = Game.new
  game.introduction
end

main()
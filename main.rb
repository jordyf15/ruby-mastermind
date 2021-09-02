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
  def create_code
    puts "Please typein four numbers (1-6) for your secret code."
    code = gets.chomp.split('')
    until code.all? {|digit| digit.to_i >=1 && digit.to_i<=6} && code.size==4
      puts "The secret code must be four number long and use numbers between 1-6.".red
      code = gets.chomp.split('')
    end
    @secret_code = code.map{|digit| digit.to_i}
  end
end

class HumanBreaker < Breaker
  def break_code(turn)
    puts "Turn ##{turn}: Type in four numbers (1-6) to guess the secret code."
    code = gets.chomp.split('')
    until code.all? {|digit| digit.to_i >=1 && digit.to_i<=6} && code.size==4
      puts "Your guess should be 4 digits between (1-6).".red
      code = gets.chomp.split('')
    end
    code.map {|digit| digit.to_i}
  end
end

class ComputerMaker < Maker
  def create_code
    4.times {@secret_code.push(rand(6)+1)}
  end
end

class ComputerBreaker < Breaker
  def initialize
    @possible_codes = [*1111..6666].reject {|code| code.to_s.include?('0') }
  end

  def remove_possible_codes(clues, guess_code)
    new_possible_codes = @possible_codes.select {|code| check_possible_code?(clues, guess_code,code)}
    @possible_codes = new_possible_codes
  end

  def check_possible_code?(clues, guess_code, possible_code)
    gray_peg_count = 0
    red_peg_count = 0
    duplicate_guess_code = guess_code.map{|digit| digit}
    duplicate_possible_code = possible_code.to_s.split('').map{|digit| digit.to_i}

    duplicate_possible_code.each_with_index do |digit, index|
      if digit == duplicate_guess_code[index]
        gray_peg_count +=1
        duplicate_possible_code[index] = nil
        duplicate_guess_code[index] = nil
      end
    end

    duplicate_possible_code.each_with_index do |digit, index|
      if digit != nil
        matched_guess_index = duplicate_guess_code.index(digit)
        if matched_guess_index !=nil
          red_peg_count+=1
          duplicate_possible_code[index]= nil
          duplicate_guess_code[matched_guess_index] = nil
        end
      end
    end

    if [gray_peg_count, red_peg_count] == clues
      true
    else
      false
    end
  end

  def break_code(turn)
    if turn == 1
      [1,1,2,2]
    else
      @possible_codes[0].to_s.split('').map{|digit| digit.to_i}
    end
  end
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

  def choose_gameplay
    puts "Would you like to be the MAKER or the BREAKER of the secret code?"
    puts "Enter 1 to be the 'MAKER'"
    puts "Enter 2 to be the 'BREAKER'"
    choice = gets.chomp.to_i
    until choice == 1 || choice == 2
      puts "Enter 1 to be the MAKER or 2 to be the BREAKER".red
      choice = gets.chomp.to_i
    end
    if choice == 1
      @human = HumanMaker.new
      @computer = ComputerBreaker.new
      maker_gameplay
    else
      @human = HumanBreaker.new
      @computer = ComputerMaker.new
      breaker_gameplay
    end
  end

  private
  def breaker_gameplay
    @computer.create_code
    puts "The computer has set it's secret code, and now you have to break it."
    12.times do |turn|
      breaker_code = @human.break_code(turn+1)
      maker_code = @computer.secret_code
      if breaker_code == maker_code
        puts "Congratulations you broke the code"
        print_breaker_code(breaker_code)
        puts
        return
      end
      give_clue(maker_code, breaker_code)
    end
    puts "Game over, you failed to break the code within 12 turns."
  end

  def maker_gameplay
    @human.create_code
    12.times do |turn|
      puts "Computer's turn ##{turn+1}: "
      breaker_code = @computer.break_code(turn+1)
      maker_code = @human.secret_code
      if breaker_code == maker_code
        print_breaker_code(breaker_code)
        puts
        puts "Game over, the computer broke your code."
        return
      else
        clues = give_clue(maker_code, breaker_code)
        @computer.remove_possible_codes(clues, breaker_code)
      end
    end
    puts "Congratulations You Win, the computer cannot break your code within 12 turns."
  end

  def give_clue(maker_code, breaker_code)
    gray_peg_count = 0 # grey peg means correct number and correct location
    red_peg_count = 0 # grey peg means correct number but wrong location
    duplicate_maker_code = maker_code.map {|digit| digit}
    duplicate_breaker_code = breaker_code.map {|digit| digit}

    duplicate_breaker_code.each_with_index do |digit, index|
      if digit == duplicate_maker_code[index]
        gray_peg_count +=1
        duplicate_breaker_code[index] = nil
        duplicate_maker_code[index] = nil
      end
    end

    duplicate_breaker_code.each_with_index do |digit, index|
      if digit != nil
        matched_maker_index = duplicate_maker_code.index(digit)
        if matched_maker_index !=nil
          red_peg_count+=1
          duplicate_breaker_code[index]= nil
          duplicate_maker_code[matched_maker_index] = nil
        end
      end
    end

    print_breaker_code(breaker_code)
    print "\t Clues: "
    gray_peg_count.times {gray_peg}
    red_peg_count.times {red_peg}
    puts
    [gray_peg_count, red_peg_count]
  end

  def print_breaker_code(breaker_code)
    breaker_code.each do |digit|
      if digit == 1
        print_one
      elsif digit == 2
        print_two
      elsif digit == 3
        print_three
      elsif digit == 4
        print_four
      elsif digit == 5
        print_five
      elsif digit == 6
        print_six
      end
    end
  end
end

def main
  play_again = true
  game = Game.new
  game.introduction
  until play_again == false
    game.choose_gameplay
    puts "Do you want to play again? Press 'y' for yes and 'n' for no."
    play_again_input = gets.chomp
    until play_again_input == 'y' || play_again_input=='n'
      puts "Please input 'y' to play again or 'n' for no".red
      play_again_input = gets.chomp
    end
    play_again=false if play_again_input=='n'
  end
  puts "Thank you for playing Mastermind, and have a nice day.."
end

main()
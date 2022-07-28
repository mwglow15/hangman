require 'csv'
require 'erb'
require 'yaml'

class Game
  @@wins = 0
  @@losses = 0

  def initialize(word)
    @word = word
    @word_array = word.split(//)
    @game_board = []
    @guesses = []
    @num_guess = 0
  end

  def play
    @game_board = @word_array.map { "-" }
    loop do
      puts "You have #{10 - @num_guess} guesses left"

      unless @guesses == []
        puts "Previous guesses:"
        p @guesses
      end

      puts "Please guess a letter"
      p @game_board
      @guesses[@num_guess] = gets.chomp.downcase
    
      @game_board = @word_array.map do |letter| 
        if @guesses.include?(letter)
          letter
        else
          "-"
        end
      end

      @game_done = end_game?

      @num_guess += 1

      @game_done = save_game

      break if @game_done      
    end
  end

  def end_game?
    if @game_board == @word_array
      puts "You won!"
      @@wins += 1
      true
    elsif @num_guess == 9
      puts "You've run out of guesses"
      @@losses += 1
      true
    else
      false
    end
  end

  def save_game
    puts "Would you like to save the game? yes/no"
    save = gets.chomp.downcase
    if save == 'yes'
      yaml = YAML::dump(self)
      game_file = File.open("./savedgame.yml",'w')
      game_file.puts yaml
      game_file.close
      return true
    end
  end

  attr_accessor :game_done
end

puts 'Welcome to Hangman!'

words = File.open('google-10000-english-no-swears.txt', 'r')
word_lines = words.readlines
num_words = word_lines.length

loop do
  word = word_lines[rand(num_words - 1)].chomp

  puts "The current word is #{word}"

  word_array = word.split(//)

  p word_array

  Game.new(word).play

  puts "Would you like to play again? yes/no"

  break if gets.chomp.downcase != 'yes'
end

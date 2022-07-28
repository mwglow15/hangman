require 'csv'
require 'erb'

class Game
  @@wins = 0
  @@losses = 0

  def initialize(name, word)
    @name = name
    @word = word
    @word_array = word.split(//)
    @game_board = []
    @guesses = []
    @num_guess = 0
  end

  def play
    @game_board = @word_array.map {|letter| "-"}
    loop do
      puts "You have #{10 - @num_guess} guesses left"
      
      unless @guesses == []
        puts "Previous guesses:"
        p @guesses
      end

      puts "Please guess a letter"
      p @game_board
      @guesses[@num_guess] = gets.chomp.downcase
    
      i = 0
      @game_board = @word_array.map do |letter| 
        if @guesses.include?(letter)
          letter
        else
          "-"
        end
      end

      @game_done = end_game?

      break if @game_done
    
      @num_guess += 1
    end
  end

  def end_game?
    if @game_board == @word_array
      puts "You won!"
      return true
    elsif @num_guess == 9
      puts "You've run out of guesses"
      return true
    else
      return false
    end

  end

  attr_accessor :game_done
end

puts 'Welcome to Hangman!'

words = File.open('google-10000-english-no-swears.txt','r')
word_lines = words.readlines
num_words = word_lines.length

word = word_lines[rand(num_words-1)].chomp

puts "The current word is #{word}"

word_array = word.split(//)

p word_array

puts "What's your name?"
name = gets.chomp

Game.new(name, word).play

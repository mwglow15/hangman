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
    @num_guesses = 0
    @incor_guesses = 6
  end

  def play
    @game_board = @word_array.map { "-" } if @game_board.empty?
    loop do
      puts "You have #{@incor_guesses} incorrect guesses left"

      unless @guesses == []
        puts "Previous guesses:"
        p @guesses
      end
      p @game_board
      puts "If you would like to save the game, enter 'save'."
      puts "Otherwise, enter your next guess!"
      guess = gets.chomp.downcase
      @game_done = save_game if guess == 'save'
      break if @game_done

      @guesses[@num_guesses] = guess

      @incor_guesses -= 1 unless @word_array.include?(guess)

      @game_board = @word_array.map do |letter|
        if @guesses.include?(letter)
          puts "Correct!"
          letter
        else
          puts "Incorrect"
          "-"
        end
      end

      @num_guesses += 1

      @game_done = end_game?

      break if @game_done
    end
  end

  def end_game?
    if @game_board == @word_array
      puts "You won!"
      @@wins += 1
      true
    elsif @incor_guesses == 0
      puts "You've run out of guesses"
      @@losses += 1
      true
    else
      false
    end
  end

  def save_game
    yaml = YAML::dump(self)
    game_file = File.open("./savedgame.yml",'w')
    game_file.puts yaml
    game_file.close
    puts 'Thank you for saving your game! You can find it in "savedgame.yml"'
    return true
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

  puts "Would you like to load a saved game? yes/no"
  answer = gets.chomp
  if answer == 'yes'
    item = YAML.load_file('savedgame.yml',permitted_classes: [Game])
    item.play
  else
    Game.new(word).play
  end

  puts "Would you like to play again? yes/no"

  break if gets.chomp.downcase != 'yes'
end

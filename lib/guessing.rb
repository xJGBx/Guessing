require 'csv'
require 'yaml'

class Guess

	def initialize
		@word = choose_word
		@displayed_word = []
		@counter = 0
		@word.length.times do
			@displayed_word << "_ "
		end 
	end

	def play
		if File.exist? ('savegame.yml')
			puts "Do you want to resume your game? (Y/N)"
			if gets.chomp.downcase == 'y'
				load_game
				display_word
			end
		end
		until @displayed_word.none?("_ ")
			if @counter >= 6
				puts "You lost!"
				File.delete 'savegame.yml'
				exit
			end

			letter = get_letter
		
			check_letter letter if letter != "0"

			display_word
		end
		puts "You win!"
		File.delete 'savegame.yml'
	end

	private
	def choose_word
  	dictionary = CSV.open("words.txt").read
  	word = ""
  	until word.length > 4 && word.length < 13
			word = dictionary[rand(dictionary.length)][0].downcase
		end
	
		word
	end

	def display_word 
		puts @displayed_word.join
	end

	def get_letter
		puts "Choose a letter! (0 to save)"
		letter = gets.chomp
		if letter == "0"
		  save_game
			puts "Game saved!"
			puts "Do you want to leave now? (Y/N)"
			exit if gets.chomp.downcase == "y"
		else
			until /[a-z]{1}/.match(letter).to_s == letter
				puts "Wrong format!"
				letter = gets.chomp
			end
		end
		letter
	end

	def check_letter letter
		right_letter = (0..@word.length).select do |index| 
			@word[index] == letter
		end
		@counter += 1 if right_letter.length == 0
		right_letter.each do |index|
			@displayed_word[index] = letter   
		end  
	end

	def save_game
	  data = {word: @word, displayed_word: @displayed_word, counter: @counter}
		file = File.open 'savegame.yml', 'w'
		file.puts YAML.dump(data)
		file.close
	end
	def load_game
		data = YAML.load(File.open('savegame.yml'))
		@word = data[:word]
		@displayed_word = data[:displayed_word]
		@counter = data[:counter]
	end
end


game = Guess.new
game.play
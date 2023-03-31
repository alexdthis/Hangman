module Hangman
    class Word_generator
        #Random number generator
        def random_number
            random_word = ((Random.rand() * 10000).round)
        end

        def random_word(random_number)
            chosen_word = ''
            line_count = 1
            File.open ('google-10000-english-no-swears.txt') do |file|
                file.each do |line|
                    if line_count == random_number
                        chosen_word = line
                    end
                    line_count += 1
                end
            end
            chosen_word.strip.split('')
        end
        
        def fetch_word
            random_number = self.random_number()
            random_word = self.random_word(random_number)
        end
    end

    class Game
        attr_accessor :turns
        attr_accessor :history
        attr_accessor :chosen_word
        attr_accessor :mystery
        attr_accessor :wrong_choices
    #Starts a new Game with either a new game option or load game option

        def initialize(loaded_state)
            @load_state = loaded_state
        end

    #check a new game is started, starts with all conditions initialized
    #check a game is loaded, starts with conditions from the specified text file

        def new_or_load
            case @load_state
            when 1
                @turns = 0
                @history = Array.new(0)
                @chosen_word = Word_generator.new.fetch_word
                @mystery = self.puzzle_gen
                @wrong_choices = 0
            when 2
                #present user with list of saves
                self.list_saves
                #prompt them to type in a number
                self.choose_save
                #assign variables from the file then put them in the game loop
                self.load_game
                self.assign_loaded_variables
            end
        end

#Takes the deserialized object and assigns the game parameters

        def assign_loaded_variables
            @turns = @save_state.turns
            @chosen_word = @save_state.chosen_word
            @history = @save_state.history
            @wrong_choices = @save_state.wrong_choices
            @mystery = @save_state.mystery
        end

    #generates a string containing only '_' of the same length as the chosen mystery word

        def puzzle_gen
            length_of_puzzle = @chosen_word.size
            Array.new(length_of_puzzle, '_')
        end

    #lists all saves in the saves directory

        def list_saves
            save_list = Dir.entries('./saves/')
            save_list.each do |file|
                if file.include?('Save')
                    puts file
                end
            end
        end

    #Function to save the game when the phrase is typed, Generates a text file containing the index number of the word
    #in the 10000 words text file along with turns remaining, played characters, and current representation of the underlines array

        def save_game
            file_number = 1
            while File.exist?("./saves/Save#{file_number}.yml") do
                file_number += 1
            end
            File.open("./saves/Save#{file_number}.yml", 'w') {|file| YAML.dump(self, file)}
        end

    #lets the user input a number to choose a save listed in the directory

        def choose_save
            @choice = ''
            until @choice =~ /[0-9]/ do
                @choice = gets.chomp
            end
        end

    #function to load the game

        def load_game
            @save_state = File.open("./saves/Save#{@choice}.yml") do |file| 
                YAML.unsafe_load(file)
            end
        end

    #function that takes in input, either as a single character or as 'save'

        def input_character
            @input = ''
            #Sanitize the input and check it either more than one character, special characters, or the special save phrase
            until (@input =~ /[a-zA-Z]/ && @input.size == 1) || (@input == 'save')
                puts "Enter a character or type in save to save your progress"
                @input = gets.strip.downcase.chomp
            end
            if @input == 'save'
                self.save_game
            else
                @turns += 1
            end
        end

    #Check the inputted character against the chosen word array
    #Store the character inside another array to represent characters already played
    #If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character

        def word_checker
            word_is_wrong = true
            if @input != 'save'
                @history.append(@input)
                word_is_wrong = true
                @chosen_word.each_index do |index|
                    if @chosen_word[index] == @input
                        @mystery[index] = @input
                        word_is_wrong = false
                    end
                end
            end
            if (word_is_wrong &&  @input != 'save')
                @wrong_choices += 1
            end
        end 

    #draws a visual of a hanged man, line by line

        def draw_hanged_man
            
            if @wrong_choices >= 1
                puts "   ___   "
            end
            if @wrong_choices >= 2
                puts "  /. .\\  "
            end
            if @wrong_choices >= 3
                puts "  | ~ |  "
            end
            if @wrong_choices >= 4
                puts "  \\___/  "
            end
            if @wrong_choices >= 5
                puts "    |    "
            end
            if @wrong_choices >= 6
                puts "   /|\\   "
            end
            if @wrong_choices >= 7
                puts "  / | \\  "
            end
            if @wrong_choices >= 8
                puts "    |    "
            end
            if @wrong_choices >= 9
                puts "    |    "
            end
            if @wrong_choices >= 10
                puts "   / \\   "
            end
            if @wrong_choices >= 11
                puts "  /   \\  "
            end
        end

    #checks the word has been guessed correctly

        def check_for_win
            if @mystery.none? {|character| character == '_'}
                @game_won = true
            end
        end

    #actual game function loop, this will be the source of the function calls

        def game
            @game_won = false
            self.new_or_load
            until ((@wrong_choices == 12) || @game_won)
                system 'clear'
                self.draw_hanged_man
                puts "Turn: #{@turns}"
                puts "Choices left until this man is hanged: #{12 - @wrong_choices}"
                puts "Word: #{@mystery.join(' ')}"
                puts "Characters played: #{@history.join('')}"
                self.input_character
                self.word_checker
                
                self.check_for_win
            end
            if @game_won
                puts "Your winner!!!!"
                puts "The answer was #{@chosen_word.join('')}"
            else
                puts "YOU LOSSSSS!!!!"
                puts "The answer was #{@chosen_word.join('')}"
            end
        end
    end
end
#game function loop
include Hangman
require 'yaml'

input = ''
until [1,2].include?(input)
    puts "Type 1 to start a new game or 2 to load a save"
    input = gets.chomp.to_i
end

Game.new(input.to_i).game
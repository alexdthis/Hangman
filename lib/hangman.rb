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
            load_game
            @turns = @save_state[0].to_i
            @chosen_word = @save_state[1].split('')
            @history = @save_state[2].split('')
            @wrong_choices = @save_state[3].to_i
            @mystery = self.puzzle_gen
        end
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
        while File.exist?('Save#{file_number}.txt')
            file_number += 1
        end
        File.open("./saves/Save#{file_number}.txt", 'w') do |file|
            file.puts @turns
            file.puts @chosen_word.join('')
            file.puts @history.join(' ')
            file.puts @wrong_choices.to_i
            file.puts "Created: #{Time.now}"
        end
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
        @save_state = Array.new(0)
        File.open("./saves/Save#{@choice}.txt", 'r') do |file|
            file.each do |line|
                @save_state.append(line)
            end
        end
        @save_state
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
            @input = ' '
        else
            @turns += 1
        end
    end

#Check the inputted character against the chosen word array
#Store the character inside another array to represent characters already played
#If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character

    def word_checker
        @history.append(@input)
        word_is_wrong = true
        @chosen_word.each_index do |index|
            if @chosen_word[index] == @input
                @mystery[index] = @input
                word_is_wrong = false
            end
        end
        if @input == 'save'
            word_is_wrong = false
        end
        if word_is_wrong
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
        until ((@wrong_choices == 11) || @game_won)
            system 'clear'
            self.draw_hanged_man
            puts "Turn: #{@turns}"
            puts "Choices left until this man is hanged: #{12 - @wrong_choices}"
            puts "Word: #{@mystery.join(' ')}"
            puts "Characters played: #{@history.join(' ')}"
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

#game function loop


input = ''
until [1,2].include?(input)
    puts "Type 1 to start a new game or 2 to load a save"
    input = gets.chomp.to_i
end

Game.new(input.to_i).game
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
                if line_count == random_word
                    chosen_word = line
                end
                line_count += 1
            end
        end
        chosen_word.split()
    end
    
    def fetch_word
        random_number = self.random_number()
        random_word = self.random_word(random_number)
    end
end

class Game

#Starts a new Game class with either a new game option or load game option

    def initialize(loaded_state)
        @load_state = loaded_state
    end

#if a new game is started, starts with all conditions initialized
#if a game is loaded, starts with conditions from the specified text file

    def new_or_load
        case @load_state
        when 1
            @turns = 11
            @history = Array.new(0)
            @chosen_word = Word_generator.new.fetch_word
            @mystery = self.puzzle_gen
        when 2
            #present user with list of saves
            self.list_saves
            #prompt them to type in a number
            self.choose_save
            #assign variables from the file then put them in the game loop
            load_game
            @turns = @save_state[0]
            @chosen_word = @save_state[1]
            @history = @save_state[2]
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

    def save_game(turns, random_word, history)
        file_number = 1
        while File.exist?('Save#{file_number}.txt')
            file_number += 1
        end
        File.open("./saves/Save#{file_number}.txt", 'w') do |file|
            file.puts @turns
            file.puts @random_word
            file.puts @history
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

    def input_character
        @history = Array.new(0)
        @input = ''
        #Sanitize the input and check it either more than one character, special characters, or the special save phrase
        until (@input =~ /[a-zA-Z]/ && @input.size == 1) || (@input == 'save')
            puts "Enter a character or type in save to save your progress"
            @input = gets.strip.downcase.chomp
        end
        if @input == 'save'
            self.save_game
        end
    end

#Check the inputted character against the chosen word array
#Store the character inside another array to represent characters already played
#If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character

    def word_checker
        @history.append(@input)
        @chosen_word.each_index do |index|
            if @chosen_word[index] == @input
                @mystery[index] = @input
            end
        end
    end 

#draws a visual of a hanged man, line by line

    def draw_hanged_man(turns)
        puts "Turns left: #{@turns}"
        if @turns <= 10
            puts "   ___   "
        end
        if @turns <= 9
            puts "  /. .\\  "
        end
        if @turns <= 8
            puts "  | ~ |  "
        end
        if @turns <= 7
            puts "  \\___/  "
        end
        if @turns <= 6
            puts "    |    "
        end
        if @turns <= 5
            puts "   /|\\   "
        end
        if @turns <= 4
            puts "  / | \\  "
        end
        if @turns <= 3
            puts "    |    "
        end
        if @turns <= 2
            puts "    |    "
        end
        if @turns <= 1
            puts "   / \\   "
        end
        if @turns == 0
            puts "  /   \\  "
        end
    end

#actual game function loop, this will be the source of the function calls in this class

    def game
        self.new_or_load
        while @turns != 0
            self.input_character
            self.word_checker
            self.draw_hanged_man
        end
    end
end

#game function loop

input = ''
until ['1','2'].include?(input)
    puts "Type 1 to start a new game or 2 to load a save"
    input = gets.chomp
end

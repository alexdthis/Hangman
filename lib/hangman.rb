class Word_generator
    #Random number generator
    def random_number
        random_word = ((Random.rand() * 10000).round)
    end

    def random_word(random_number)
        chosen_word = ''
        line_count = 1

        #open the text file
        File.open ('google-10000-english-no-swears.txt') do |file|
            file.each do |line|
                if line_count == random_word
                    chosen_word = line
                end
                line_count += 1
            end
        end
        chosen_word
    end
    
    #Store the word in an array and generate another string containing length of word underlines
    def word_processor
        chosen_word = chosen_word.split('')
        length_of_puzzle = chosen_word.size
        mystery = Array.new(length_of_puzzle, '_')
    end

    def fetch_word
        random_number = self.random_number()
        random_word = self.random_word(random_number)
        processed_word = self.word_processor(random_word)
    end
end
#Increment by one turn/Draw one line on the hanged man

turns -= 1
#draw hanged_man(turns)


        

#game function loop

input = ''
until ['1','2'].include?(input)
    puts "Type 1 to start a new game or 2 to load a save"
    input = gets.chomp
end

case input
when '1'
    Game.new(1)
when '2'
    Game.new(2)
end

class Game

    
    def initialize(loaded_state)
        @load_state = loaded_state
    end

    def new_or_load
        case @load_state
        when 1
            @turns = 11
            #new game
        when 2
            #present user with list of saves
            #prompt them to type in a number
            #assign variables from the file then put them in the game loop
        end
    end

    def game
        self.new_or_load
        while @turns != 0
            input_character
            word_checker
            draw_hanged_man
        end
    end

    def input_character
        @history = Array.new(0)
        #Sanitize the input and check it either more than one character, special characters, or the special save phrase
        until (@input =~ /[a-zA-Z] && @input.size == 1) || (@input == 'save')
            puts "Enter a character or type in save to save your progress"
            @input = gets.strip.downcase.chomp
        end
        if @input == 'save'
            #save function
            save_game(turns, random_word, history)
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

    #function to load the game

    def load_game(choice)
        save_state = Array.new(0)
        File.open("./saves/Save#{choice}.txt", 'r') do |file|
            file.each do |line|
                save_state.append(line)
            end
        end
        save_state
    end

    #Check the inputted character against the chosen word array
    #Store the character inside another array to represent characters already played
    #If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character
    def word_checker
        @history.append(input)
        chosen_word.each_index do |index|
            if chosen_word[index] == @input
                @mystery[index] = @input
            end
        end
    end 

    #function to assign variables when game is loaded
    def assign_var_on_load
        @turns = save_state[0]
        @random_word = save_state[1]
        @history = save_state[2]
    end

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
end

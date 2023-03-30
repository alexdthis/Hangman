#Random number generator
random_word = ((Random.rand() * 10000).round)
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

#Store the word in an array and generate another string containing length of word underlines

chosen_word = chosen_word.split('')
length_of_puzzle = chosen_word.size
mystery = Array.new(length_of_puzzle, '_')

#Prompt the user for a character

turns = 10
while turns != 0
    
    input = ''
    history = Array.new(0)
    #Sanitize the input and check if it either more than one character, special characters, or the special save phrase
    until (input =~ /[a-zA-Z] && input.size == 1) || (input == 'save')
        puts "Enter a character or type in save to save your progress"
        input = gets.strip.downcase.chomp
    end
    if input == 'save'
        #save function
    end

#Check the inputted character against the chosen word array
#Store the character inside another array to represent characters already played
#If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character

history.append(input)
chosen_word.each_index do |index|
    if chosen_word[index] == input
        mystery[index] = input
    end
end

#Increment by one turn/Draw one line on the hanged man

turns -= 1
#draw hanged_man(turns)

#Function to save the game when the phrase is typed, Generates a text file containing the index number of the word
#in the 10000 words text file along with turns remaining, played characters, and current representation of the underlines array

def save_game(turns, random_word, history)
    file_number = 1
    while File.exist?('Save#{file_number}.txt')
        file_number += 1
    end
    File.open("./saves/Save#{file_number}.txt", 'w') do |file|
        file.puts turns
        file.puts random_word
        file.puts history
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

#function to assign variables when game is loaded

turns = save_state[0]
random_word = save_state[1]
history = save_state[2]
#Function to draw the hanged man


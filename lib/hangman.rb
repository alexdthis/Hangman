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

puts chosen_word
#Select the word from the file

#Store the word in an array and generate another string containing length of word underlines

#Prompt the user for a character

#Sanitize the input and check if it either more than one character, special characters, or the special save phrase

#Check the inputted character against the chosen word array

#Store the character inside another array to represent characters already played

#If the character is in the mystery word, go through the underlines array and replace all corresponding indexes with the character

#Increment by one turn/Draw one line on the hanged man

#Function to save the game when the phrase is typed, Generates a text file containing the index number of the word
#in the 10000 words text file along with turns remaining, played characters, and current representation of the underlines array

#Function to draw the hanged man


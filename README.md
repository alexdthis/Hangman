# Hangman

Program flow

a. When the program is run, bring up a menu that allows the player to either start a new game
	or load a previous run.
b. At any time, the game can be saved.
	i. Typing in a special charactedr will generate a save file containing the index
	number of the chosen word, an array containing already played characters, and
	the number of turns left.
	ii. Choosing the load option will display the save directory listing out all saves
	iii. Loading the save will cause the program to load its previous state by
	running the saved values through functions in order to recreate the last saved state

1. Open the text document in the same directory.
2. Randomly generate a number between 1 to 10000.
	i. Using a random function.
3. Find the word that corresponds to this number.
	i. Slice out the word and store it into an array.
4. Store it in an array
5. Generate another string that contains only "_". Same number as length of the chosen word
	i. Use array length and then generate this new array using Array.new('_', number)
6. Prompt the user for one character, case insensitive. Inputs are sanitized.
	i. gets.chomp.lowercase.
	ii. then check for gets.size == 1 or the special save phrase
	iii. also check for other special characters.
	iv. prompt the user to enter another character if it is invalid.
7. Check to make sure it's one word, check length and check if it's a special character
8. If inputted character is in the chosen string, get the indexes of the character
	in the chosen word, then replace the corresponding underlines in the mystery
	word.
9. Every time a character is guessed, check if mystery word contains underlines, if it doesn't,
	the player wins the game.
	i. Use array.include?('_')
10. A representation of a man hanging will represent the number of turns left.
	i. separate function consisting of several puts with whitespaces
11. If the man is completely drawn, the player loses the game.


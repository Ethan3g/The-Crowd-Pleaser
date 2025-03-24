extends Node2D

@export var letters_panel: Panel  # Reference to LettersPanel
@export var max_attempts = 6  # Max incorrect guesses
@export var hangman_images: Array[Texture2D]  # Array to store hangman images (Textures)
var incorrect_guesses = 0  # Counter for incorrect guesses
var current_word = ""  # The word to guess
var guessed_letters = []  # List of correct guesses
var incorrect_letters = []  # List of incorrect guesses

var hangman_sprite: Sprite2D
var word_label: Label
var incorrect_label: Label
var attempts_label: Label

# List of all letters (A to Z)
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")

func _ready():
	# Get references to the nodes
	hangman_sprite = $HangManSprite
	word_label = $WordLabel
	incorrect_label = $IncorrectLabel
	attempts_label = $AttemptsLabel

	# Load hangman images (from hangman_man0.png to hangman_man6.png)
	for i in range(max_attempts + 1):  # Load 7 images (from 0 to 6)
		var texture = load("res://Images/Hangman_man" + str(i) + ".png")
		hangman_images.append(texture)

	# Start a new game
	generate_new_word()

# Function to generate a new word for the game (simple example with fixed word)
func generate_new_word():
	current_word = "HANGMAN"
	guessed_letters = []
	incorrect_letters = []
	incorrect_guesses = 0
	update_word_display()
	update_incorrect_label()
	update_attempts_label()
	update_hangman_sprite()

# Function to update the word display (with blanks for unguessed letters)
func update_word_display():
	var display_word = ""
	for letter in current_word:
		if letter in guessed_letters:
			display_word += letter + " "
		else:
			display_word += "_ "
	word_label.text = display_word.strip_edges()

# Function to update the incorrect guesses display
func update_incorrect_label():
	incorrect_label.text = "Incorrect: " + ", ".join(incorrect_letters)

# Function to update the attempts label
func update_attempts_label():
	attempts_label.text = "Attempts Remaining: " + str(max_attempts - incorrect_guesses)

# Function to update the hangman sprite based on incorrect guesses
func update_hangman_sprite():
	if incorrect_guesses <= max_attempts:
		hangman_sprite.texture = hangman_images[incorrect_guesses]

# Function to handle a letter press (guess)
func _on_letter_pressed(letter: String):
	if letter in guessed_letters or letter in incorrect_letters:
		return  # Ignore if letter was already guessed

	if letter in current_word:
		guessed_letters.append(letter)
		update_word_display()
		check_win_condition()
	else:
		incorrect_letters.append(letter)
		incorrect_guesses += 1
		update_incorrect_label()
		update_attempts_label()
		update_hangman_sprite()
		check_game_over()

# Function to check if the player has won
func check_win_condition():
	for letter in current_word:
		if letter not in guessed_letters:
			return  # Player hasn't guessed all letters yet
	word_label.text = "You Win!"
	disable_buttons()

# Function to check if the game is over
func check_game_over():
	if incorrect_guesses >= max_attempts:
		word_label.text = "Game Over! The word was: " + current_word
		disable_buttons()

# Function to disable all buttons after the game ends
func disable_buttons():
	for button in letters_panel.get_children():
		button.disabled = true

# Input handling (detecting keyboard input)
func _input(event):
	if event is InputEventKey and event.pressed:
		# Get the character of the pressed key and convert it to uppercase
		var letter = event.as_text().to_upper()

		# Check if the letter is in the alphabet and hasn't been guessed yet
		if letter in alphabet and letter not in guessed_letters and letter not in incorrect_letters:
			_on_letter_pressed(letter)

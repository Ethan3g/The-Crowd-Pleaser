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
var before_label: Label
var word_list = ["HANGMAN", "LAUGH", "SMILE", "GAMING", "BOOOOOOOO", "STINTENDO"]

# List of all letters (A to Z)
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")

# Boolean for when game has ended -> disables input
var fin = false;

# signal to tell stage.gd that game is done
signal gameDone


func _ready():
	# Get references to the nodes
	hangman_sprite = $HangManSprite
	word_label = $WordLabel
	incorrect_label = $IncorrectLabel
	attempts_label = $AttemptsLabel
	before_label = $BeforeLabel  # Ensure this label exists in your scene

	# Ensure before_label is hidden at the start of the Hangman game
	before_label.visible = false

	# Load hangman images (from hangman_man0.png to hangman_man6.png)
	for i in range(max_attempts + 1):  # Load 7 images (from 0 to 6)
		var texture = load("res://MiniGames/Hangman/HangmanArt/Hangman_man" + str(i) + ".png")
		hangman_images.append(texture)

	# Start a new game
	generate_new_word()

# Function to generate a new word for the game
func generate_new_word():
	current_word = word_list[randi() % word_list.size()]  # Pick a random word
	guessed_letters = []
	incorrect_letters = []
	incorrect_guesses = 0

	reveal_starting_letters()  # Reveal 1-2 letters at the start

	update_word_display()
	update_incorrect_label()
	update_attempts_label()
	update_hangman_sprite()

	# Show the message at the start of the game
	before_label.text = "Use the keyboard to play!"
	before_label.visible = true  # Make sure the label shows

	# Start a 5 second timer before hiding the label (using await)
	await get_tree().create_timer(5.0).timeout  # Wait for 5 seconds
	before_label.visible = false  # Hide after 5 seconds

# Function to reveal 1-2 random letters at the start
func reveal_starting_letters():
	var letters_to_reveal = randi() % 2 + 1  # Choose 1 or 2 letters
	var unique_letters = Array(current_word.split(""))  # Convert to standard Array
	
	# Remove duplicates and already guessed letters
	unique_letters = unique_letters.filter(func(l): return l not in guessed_letters and l != " ")  # Avoid duplicates

	while letters_to_reveal > 0 and unique_letters.size() > 0:
		var random_letter = unique_letters.pick_random()
		guessed_letters.append(random_letter)
		unique_letters.erase(random_letter)  # Ensure no duplicate reveals
		letters_to_reveal -= 1

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
		# Letter is Correct
		$CorrectSfx.play()
		guessed_letters.append(letter)
		update_word_display()
		check_win_condition()
	else:
		# Letter is Wrong 
		$WrongSfx.play()
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
	$WinSfx.play()
	word_label.text = "You Win!"
	disable_buttons()
	global.points += 1
	global.winstate = 1
	
	await get_tree().create_timer(3.0).timeout
	gameDone.emit()

# Function to check if the game is over
func check_game_over():
	if incorrect_guesses >= max_attempts:
		$LoseSfx.play()
		word_label.text = "Game Over! The word was: " + current_word
		disable_buttons()
		global.winstate = -1
		global.lives -= 1
		
		await get_tree().create_timer(3.0).timeout
		gameDone.emit()

# Function to disable all buttons after the game ends
func disable_buttons():
	fin = true;

# Input handling (detecting keyboard input)
func _input(event):
	if fin:
		return
	
	if event is InputEventKey and event.pressed:
		# Hide the 'before_label' after a key is pressed
		before_label.visible = false

		# Get the character of the pressed key and convert it to uppercase
		var letter = event.as_text().to_upper()

		# Check if the letter is in the alphabet and hasn't been guessed yet
		if letter in alphabet and letter not in guessed_letters and letter not in incorrect_letters:
			_on_letter_pressed(letter)

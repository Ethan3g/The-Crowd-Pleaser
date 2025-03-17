extends Control


# Export variables to manually set textures in the Godot editor
var rock_texture = preload("res://MiniGames/RPS/RPSart/OPPONENTRock.png")
var paper_texture = preload("res://MiniGames/RPS/RPSart/OPPONENTPaper.png")
var scissors_texture = preload("res://MiniGames/RPS/RPSart/OPPONENTScissors.png")

# Dictionary to store textures for Rock, Paper, and Scissors
var choice_textures = {}

@onready var opponent_icon = $OpponentChoiceIcon  # Reference to the TextureRect
@onready var result_label = $ResultLabel  # Label for win/loss result
@onready var rock_button = $HBoxContainer/RockButton
@onready var paper_button = $HBoxContainer/PaperButton
@onready var scissors_button = $HBoxContainer/ScissorsButton
@onready var timer_label = $TimerLabel  # Label to show remaining time
@onready var timer_node = $Timer  # Reference to the Timer node

var player_choice = ""  # Store player's choice when made
var opponent_choice = ""  # Store opponent's choice for the round

# Varible that says if game is playing or not
var game_done = false;
# Signal to let stage.gd that game has ended
signal gameDone

func _ready():
	# Initialize the dictionary with manually set textures
	choice_textures["Rock"] = rock_texture
	choice_textures["Paper"] = paper_texture
	choice_textures["Scissors"] = scissors_texture

	# Connect buttons to functions
	rock_button.pressed.connect(_on_rock_button_pressed)
	paper_button.pressed.connect(_on_paper_button_pressed)
	scissors_button.pressed.connect(_on_scissors_button_pressed)

	# Connect timer signal
	timer_node.timeout.connect(_on_timer_timeout)

	# Start the game by displaying the opponent's choice immediately
	#choose_and_display_opponent_choice()

func choose_and_display_opponent_choice():
	game_done = false;
	# Randomly select opponent's choice and display it immediately
	opponent_choice = choose_opponent_choice()
	if opponent_choice in choice_textures:
		opponent_icon.texture = choice_textures[opponent_choice]
	else:
		print("Error: Opponent choice texture not found!")

	# Show message for player to choose
	result_label.text = "AHHHH DO SOMETHING!"

	# Enable player's buttons immediately so they can choose
	rock_button.disabled = false
	paper_button.disabled = false
	scissors_button.disabled = false

	# Start the timer for the player to make a move (1.5 seconds)
	timer_node.start(1.5)  
	timer_label.text = "Time left: 1.5 seconds"

func _play_game(player_choice: String):
	print("Player chose:", player_choice)  # Debugging
	self.player_choice = player_choice  # Store the player's choice
	
	# Disable the buttons after the player makes their choice
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true

	# Display the game result
	result_label.text = determine_winner(player_choice, opponent_choice)

	# Restart the game after a delay
	await get_tree().create_timer(3.0).timeout
	game_done = true;
	gameDone.emit()
	#reset_game()

func reset_game():
	print("Resetting game...")  # Debugging

	# Clear player choice
	player_choice = ""

	# Reset opponent choice icon (optional, or leave it to show last move)
	opponent_icon.texture = null

	# Clear the result label
	result_label.text = "Choose an option!"

	# Start a new round (opponent picks first again)
	#choose_and_display_opponent_choice()

# Button presses
func _on_rock_button_pressed() -> void:
	print("Rock button clicked!")  # Debugging
	_play_game("Rock")  
	$ClickSfx.play()

func _on_paper_button_pressed() -> void:
	print("Paper button clicked!")  # Debugging
	_play_game("Paper")  
	$ClickSfx.play()

func _on_scissors_button_pressed() -> void:
	print("Scissors button clicked!")  # Debugging
	_play_game("Scissors")  
	$ClickSfx.play()

# Function to randomly choose an opponent's move
func choose_opponent_choice() -> String:
	var choices = ["Rock", "Paper", "Scissors"]
	return choices[randi() % choices.size()]

# Function to determine the winner
func determine_winner(player_choice: String, opponent_choice: String) -> String:
	if player_choice == opponent_choice:
		# Tied: No win
		$NoWinSfx.play()
		return "It's a tie!"
		#game_done = true
	elif ((player_choice == "Rock" and opponent_choice == "Scissors") or
		  (player_choice == "Scissors" and opponent_choice == "Paper") or
		  (player_choice == "Paper" and opponent_choice == "Rock")):
		# Win sound play
		$WinSfx.play()
		global.points += 1
		#game_done = true
		return "You Win!"
	else:
		# No Win sound play
		$NoWinSfx.play()
		global.lives -= 1
		#game_done = true
		return "You Lose!"

# Timer timeout function
func _on_timer_timeout() -> void:
	print("Timer Timeout!")  # Debugging
	if player_choice == "":
		# Player didn't make a move in time
		# Run out of time -> Looses
		$NoWinSfx.play()
		result_label.text = "You were too late!"
		global.lives -= 1
		await get_tree().create_timer(3.0).timeout  # Short delay before reset
		#reset_game()
		if game_done == false:
			gameDone.emit()
		
		game_done = true
		
	else:
		# The player made a move within the time limit
		result_label.text = "You made your choice in time!"
		await get_tree().create_timer(3.0).timeout
		#reset_game()
		if game_done == false:
			gameDone.emit()
		game_done = true
		
	

extends Panel

@export var button_size = Vector2(50, 50)  # Size of each button
@export var button_margin = 5  # Margin between buttons
var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

func _ready():
	create_letter_buttons()

# Function to dynamically create the letter buttons
func create_letter_buttons():
	var button_count = alphabet.size()
	var rows = 3  # Set the number of rows of buttons
	var columns = ceil(button_count / float(rows))  # Calculate columns based on number of rows
	var x_offset = 0
	var y_offset = 0
	
	# Create and position buttons
	for i in range(button_count):
		var letter = alphabet[i]
		var button = Button.new()
		button.text = letter  # Set the button text to the letter
		button.custom_minimum_size = button_size  # Set button size (Godot 4 syntax)
		button.position = Vector2(x_offset * (button_size.x + button_margin), y_offset * (button_size.y + button_margin))
		
		# Connect the button press signal to a function to handle the guess logic
		button.pressed.connect(self._on_letter_pressed.bind(letter))  # Corrected signal connection
		
		# Add the button to the LettersPanel
		add_child(button)
		
		# Move to next position in grid (row-wise)
		x_offset += 1
		if x_offset >= columns:
			x_offset = 0
			y_offset += 1

# Handle the letter button press
func _on_letter_pressed(letter: String):
	print("Letter pressed: " + letter)
	# Add your logic here to handle the player's guess

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Start the game
func _on_start_button_pressed() -> void:
	print("Start")
	# Waits to allow sound to play before scene changes (if not, causes error)
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_file("res://Scenes/bender_dragon.tscn")

# Button to access credits
func _on_credit_button_pressed() -> void:
	print("Credit")
	$StartButton.disabled = true;
	$CreditButton.disabled = true;
	$QuitButton.disabled = true;
	
	$Credits.visible = true;
	$Credits/ReturnButton.disabled = false;

# Quits the game
func _on_quit_button_pressed() -> void:
	print("Quit")
	get_tree().quit()

# When return button (on credit) is pressed; turns off the other buttons
func _on_return_button_pressed() -> void:
	print("Return")
	$StartButton.disabled = false;
	$CreditButton.disabled = false;
	$QuitButton.disabled = false;
	
	$Credits.visible = false;
	$Credits/ReturnButton.disabled = true;

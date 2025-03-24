extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	print("Start")
	get_tree().change_scene_to_file("res://Scenes/bender_dragon.tscn")


func _on_credit_button_pressed() -> void:
	print("Credit")
	$StartButton.disabled = true;
	$CreditButton.disabled = true;
	$QuitButton.disabled = true;
	
	$Credits.visible = true;
	$Credits/ReturnButton.disabled = false;


func _on_quit_button_pressed() -> void:
	print("Quit")
	get_tree().quit()


func _on_return_button_pressed() -> void:
	print("Return")
	$StartButton.disabled = false;
	$CreditButton.disabled = false;
	$QuitButton.disabled = false;
	
	$Credits.visible = false;
	$Credits/ReturnButton.disabled = true;

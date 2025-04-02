extends Node2D
# AUDIO MANAGER FOR THE MAIN MENU

func _ready() -> void:
	$MenuBG.play()


func _on_start_button_pressed() -> void:
	$ButtonClick.play()
	
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()
	$MenuBG.stop()


func _on_credit_button_pressed() -> void:
	$ButtonClick.play()
	
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()


func _on_return_button_pressed() -> void:
	$ButtonClick.play()
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()


func _on_quit_button_pressed() -> void:
	$ButtonClick.play()
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()


func _on_start_button_mouse_entered() -> void:
	$Hov.play()
	
func _on_credit_button_mouse_entered() -> void:
	$Hov.play()

func _on_return_button_mouse_entered() -> void:
	$Hov.play()

func _on_quit_button_mouse_entered() -> void:
	$Hov.play()

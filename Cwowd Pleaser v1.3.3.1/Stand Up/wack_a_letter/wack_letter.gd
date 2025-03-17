extends CanvasLayer

var expected_letter : int
var expect_input : bool = true
var hits
var key_map = [KEY_Q, KEY_W, KEY_E, KEY_A, KEY_S, KEY_D, KEY_Z, KEY_X, KEY_C]
var labels = []
var hold = false
var time_scale = 1.0
var is_game_over
var hits_to_win = 4
var letter_map = ["Q", "W", "E", "A", "S", "D", "Z", "X", "C"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labels = [$target0, $target1, $Label3, $Label4, $Label5, $Label6, $Label7, $Label8, $Label9]
	hits = 0
	expect_input = false
	is_game_over = false
	expected_letter = randi() % 9
	print("hello")
	# $HoldTimer.wait_time = 1.0
	# set all to blank
	clear_all_labels()
	#print("starting hold timer")
	$HoldTimer.start(1.0*time_scale)

func new_letter(old_letter) -> void:
	# pick random 1-8
	var temp = randi() % 8
	if old_letter <= temp:
		temp += 1
	expected_letter = temp
	if !is_game_over:
		#print("starting hold timer from newletter")
		$HoldTimer.start(1.0*time_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if expect_input:
		if event is InputEventKey:
			# problem is even if correct letter pressed, else also activates - fixed
			if event.pressed:
				if event.keycode == key_map[expected_letter]:
					$HitTimer.stop()
					#print(expected_letter)
					clear_all_labels()
					hits += 1
					if hits > hits_to_win:
						is_game_over = true
						end_game(true)
					else:
						#print(hits)
						expect_input = false
						new_letter(expected_letter)
				else: 
					print("why are you here")
					is_game_over = true
					end_game(false)

func clear_all_labels():
	labels[0].text = "[ ]"
	labels[1].text = "[ ]"
	labels[2].text = "[ ]"
	labels[3].text = "[ ]"
	labels[4].text = "[ ]"
	labels[5].text = "[ ]"
	labels[6].text = "[ ]"
	labels[7].text = "[ ]"
	labels[8].text = "[ ]"

func end_game(did_ya_win):
	expect_input = false
	$HoldTimer.stop()
	$HitTimer.stop()
	print("game done")
	clear_all_labels()
	if did_ya_win:
		pass #good effects
	else: 
		pass #bad effects
	$EndTimer.start(1.0*time_scale)


func _on_hit_timer_timeout() -> void:
	#expect_input = false
	#print("l")
	is_game_over = true
	end_game(false)


func _on_hold_timer_timeout() -> void:
	$HoldTimer.stop()
	#print("ok hold timer ended")
	if !is_game_over:
		labels[expected_letter].text = "[" + letter_map[expected_letter] + "]"
		#$HitTimer.start()
		$HitTimer.start(1.3*time_scale)
		#print("ok started hit timer")
		expect_input = true


func _on_end_timer_timeout() -> void:
	$EndTimer.stop()
	print("game over fr fr") # GAME ENDS

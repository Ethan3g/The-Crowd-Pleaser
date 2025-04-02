extends Node

var bendGoing = false

# Timer in the stage
@onready var timer_node = $StageTimer

# Nodes used to call methods within their scripts (triggering on and off game)
@onready var RPSnode = get_node("Control")
@onready var HANGnode = get_node("Hangman")
@onready var WACKnode = get_node("target_control/CanvasLayer")
@onready var TOMnode = get_node("TomatoGame")
@onready var BULnode = get_node("TomatoGame/BulletSpawner")
@export var timer_bar: TextureProgressBar
@export var max_time: float = 5.0 # Total duration of the timer

var time_left: float
var lives_Label: Label
var points_Label: Label
var timer_Label: Label
var random = 1
var stored = 0

# Go through each, trigger a minigame at each number
# 1 = RPS
# 2 = Hangman
# 3 = Dragon
# 4 = Wack
# 5 = Tomato
var minigame_amt = 5
var current_minig = 0

# Signals of games being done
@onready var RPS_signal = $Control
@onready var HANG_signal = $Hangman
@onready var WACK_signal = $target_control/CanvasLayer
@onready var TOM_signal = $TomatoGame

# seconds of timer
var timer_amt = 5

# used for light visuals
# 0 -> yellow, -1 -> red, 1 -> green
var progress_vals = [0, 0, 0, 0, 0]
@onready var neu_texture = load("res://Stage Assets/Yellow.tres")
@onready var point_texture = load("res://Stage Assets/Green.tres")
@onready var lost_texture = load("res://Stage Assets/Red.tres")
@onready var rng = RandomNumberGenerator.new()

@onready var LS0 = $Lights/Light0
@onready var LS1 = $Lights/Light1
@onready var LS2 = $Lights/Light2
@onready var LS3 = $Lights/Light3
@onready var LS4 = $Lights/Light4

var lightSprites: Array[Texture2D]

# Audio stuff
var isMuted = false
var muteNoIdle = load("res://Assets/NoMuteIdle.tres")
var muteNoHov = load("res://Assets/NoMuteHov.tres")
var muteIdle = load("res://Assets/MuteIdle.tres")
var muteHov = load("res://Assets/MuteHov.tres")

var audio_stage

# Using to disable 'K' input (during hangman)
var stageRunning = false
# Can probably have a 'if stageRunning == true and minigame completed = 5, trigger ending part
	# Sees if win or loose

func _ready() -> void:
	lives_Label = $Lives
	points_Label = $Points
	timer_Label = $TimerLabel
	randomizer()
	
	for i in range(minigame_amt):
		var lightSpr = "Node2D/Light " + str(i) + ""
		lightSprites.append(lightSpr)
	
	timer_node.timeout.connect(_on_timer_timeout)
	
	$"Instruction Panel".visible = true
	$"Instruction Panel/StartStage".disabled = false
	
	# Hehe more stuff for signals -> hooked up to methods
	RPS_signal.gameDone.connect(_on_RpsEnd)
	HANG_signal.gameDone.connect(_on_HangEnd)
	WACK_signal.gameDone.connect(_on_WackEnd)
	TOM_signal.gameDone.connect(_on_TomEnd)
	
	isMuted = false
	
	$NPCs/NPC1.position.x = -54
	$NPCs/NPC2.position.x = -36
	$NPCs/NPC3.position.x = -18
	$NPCs/NPC4.position.x = 0
	$NPCs/NPC5.position.x = 18
	$NPCs/NPC6.position.x = 36
	$NPCs/NPC7.position.x = 54
	
	#time_left = max_time
	#if timer_bar:
		#timer_bar.max_value = max_time
		#timer_bar.value = max_time
		#timer_bar.fill_mode = TextureProgressBar.FILL_TOP_TO_BOTTOM


func _process(delta: float) -> void:
	BenderDragonTimer()
	lives_Label.text = "Lives: " + str(global.lives)
	points_Label.text = "Points: " + str(global.points)
	timer_Label.text = "Time: " + str(ceil(timer_node.time_left))
	
	#if time_left > 0:
		#time_left -= delta
		#timer_bar.value = time_left
	#else:
		#timer_bar.value = 0  # Ensure it doesn't go negative

func _on_start_stage_pressed() -> void:
	print("Start")
	if stageRunning:
		return
		
	await get_tree().create_timer(0.25).timeout
	$"Instruction Panel".visible = false
	$"Instruction Panel/StartStage".disabled = true
	stageRunning = true
	stage_GO()
	$"Start Text".hide()

func _input(_ev):
	# Debugging stuff, not to be used in the actual game loop
	if Input.is_key_pressed(KEY_9):
		BenderDragonStart()
	
	# Start time -> Start the games
	if Input.is_key_pressed(KEY_K):
		pass
		#if stageRunning:
		#	return
		#stageRunning = true
		#stage_GO()
		#$"Start Text".hide()
		
	if Input.is_key_pressed(KEY_1):
		pass
		#RpsStart()
		
	if Input.is_key_pressed(KEY_2):
		pass
		#RpsEnd()
		
	if Input.is_key_pressed(KEY_3):
		pass
		#HangStart()
	
	if Input.is_key_pressed(KEY_4):
		pass
		#HangEnd()
		
	if Input.is_key_pressed(KEY_5):
		pass
		#WackStart()
	
	if Input.is_key_pressed(KEY_6):
		pass
		#WackEnd()
		
	if Input.is_key_pressed(KEY_7):
		pass
		#TomStart()
	
	if Input.is_key_pressed(KEY_8):
		pass
		#TomEnd()

# Calls the start of stage timer (will be more than just timer)
# Will also include later the start of the dialogue section
func stage_GO() -> void:
	# global winstate -> if 1, will be succeed, if -1, is lost
	$TimerLabel.visible = true
	print("Stage go")
	timer_node.start(timer_amt)

# When timer runs out, depending on the current minigame, next one is started
func _on_timer_timeout() -> void:
	
	$TimerLabel.visible = false
	
	current_minig = random
		
	if current_minig == 1:
		RpsStart()
	elif current_minig == 2:
		HangStart()
	elif current_minig == 3:
		BenderDragonStart()
	elif current_minig == 4:
		WackStart()
	elif current_minig == 5:
		TomStart()
		
# Called after each minigame is done -> goes to Audio Manager
func miniDone() -> void:
	var test = get_node("Audio Manager").get_script()
	$"Audio Manager"._mini_done()
	
	# Audience member leaves
	if global.winstate == -1:
		if global.lives == 4:
			var x = -54
			var y = -36
			var z = - 18
			
			while x > -90:
				x = x - 1
				y = y - 1.5
				z = z - 2
				$NPCs/NPC1.position.x = x
				$NPCs/NPC2.position.x = y
				$NPCs/NPC3.position.x = z
				await get_tree().create_timer(0.02).timeout
			
		if global.lives == 3:
			var x = 18
			var y = 36
			var z = 54
			
			while x < 90:
				x = x + 2
				y = y + 1.5
				z = z + 1
				$NPCs/NPC5.position.x = x
				$NPCs/NPC6.position.x = y
				$NPCs/NPC7.position.x = z
				await get_tree().create_timer(0.02).timeout
				
		if global.lives == 2:
			var x = 0
			
			while x > -90:
				x = x - 2.5
				$NPCs/NPC4.position.x = x
				await get_tree().create_timer(0.02).timeout
	#$NPCs/NPC1.position.x = -90

func BenderDragonStart() -> void:
	$Stage.self_modulate = Color(0.5, 0.5, 0.5)
	$Timer.start(5.0)
	bendGoing = true
	$BenderDragon.visible = true
	$BenderDragon/Item1.disabled = false
	$BenderDragon/Item2.disabled = false
	$BenderDragon/Item3.disabled = false
	$BenderDragon/Item4.disabled = false
	$BenderDragon/Item5.disabled = false

func BenderDragonEnd() -> void:
	$Stage.self_modulate = Color(1, 1, 1)
	$BenderDragon.visible = false
	$BenderDragon/Item1.disabled = true
	$BenderDragon/Item2.disabled = true
	$BenderDragon/Item3.disabled = true
	$BenderDragon/Item4.disabled = true
	$BenderDragon/Item5.disabled = true
	$BenderDragon/Item3/deadDragon.visible = false
	$BenderDragon/Item2/deadDragon.visible = false
	$BenderDragon/Item1/death.visible = false
	$BenderDragon/Item4/death.visible = false
	$BenderDragon/Item5/death.visible = false

func BenderDragonTimer() -> void:
	if bendGoing == true:
		if $Timer.is_stopped() == true and global.done == false:
			global.lives -= 1
			bendGoing = false
			BenderDragonEnd()
			print("dead")
			EnderEnd()
		elif $Timer.is_stopped() == true and global.done == true:
			bendGoing = false
			BenderDragonEnd()
			EnderEnd()

#------------------------------
# Methods without '_' in front (minus dragon), used in game. Non '_' methods used in debugging
func RpsStart() -> void:
	$Stage.self_modulate = Color(0.5, 0.5, 0.5)
	$Control.visible = true
	RPSnode.choose_and_display_opponent_choice()

func RpsEnd() -> void:
	$Control.visible = false

func _on_RpsEnd():
	$Control.visible = false
	$Stage.self_modulate = Color(1, 1, 1)
	print("end")
	miniDone()
	
	stage_GO()
	update_lights()

func HangStart() -> void:
	$Stage.self_modulate = Color(0.5, 0.5, 0.5)
	$Hangman.visible = true
	HANGnode.generate_new_word()

func HangEnd() -> void:
	$Hangman.visible = false
	miniDone()

func _on_HangEnd():
	$Stage.self_modulate = Color(1, 1, 1)
	$Hangman.visible = false
	print("hang END")
	miniDone()
	
	stage_GO()
	update_lights()

func EnderEnd():
	print("ender end")
	miniDone()
	
	stage_GO()
	update_lights()

func WackStart() -> void:
	$Stage.self_modulate = Color(0.5, 0.5, 0.5)
	WACKnode.visible = true
	WACKnode.startWack()

func WackEnd() -> void:
	WACKnode.visible = false

func _on_WackEnd():
	$Stage.self_modulate = Color(1, 1, 1)
	WACKnode.visible = false
	miniDone()
	
	stage_GO()
	update_lights()

# Tomato Game Functions
func TomStart() -> void:
	$Stage.self_modulate = Color(0.5, 0.5, 0.5)
	TOMnode.visible = true
	TOMnode.tomato_start()
	BULnode.spawn_start()
	print("Tomato minigame started")

func TomEnd() -> void:
	TOMnode.visible = false
	BULnode.spawn_end()
	print("Tomato minigame ended, waiting for next game...")

func _on_TomEnd():
	$Stage.self_modulate = Color(1, 1, 1)
	BULnode.spawn_end()
	print("Tomato Ended signal received")
	await get_tree().create_timer(3.0).timeout
	TOMnode.visible = false
	print("Tomato minigame visibility set to false")
	miniDone()
	
	update_lights()
	stage_GO()  # Start the next game

func randomizer() -> void:
	random = rng.randi_range(1, 5)
	if random == stored:
		random = rng.randi_range(1, 5)
	stored = random

func game_done() -> void:
	if global.prog == 5:
		$TimerLabel.visible = false
		
		if global.points >= 3:
			print("Winner!") #Todo: Make game end when either one happens.
			$StageTimer.set_paused(true)
			$WinorLose.text = "You're Winner!"
			$WinorLose.visible = true
		elif global.points <= 2:
			print("Loser!")
			$StageTimer.set_paused(true)
			$WinorLose.text = "You Have Died!"
			$WinorLose.visible = true

# Update progression lights
func update_lights() -> void:
	var current_light
	
	if global.prog < 5:
		current_light = global.prog
	else:
		global.prog = 0
		current_light = global.prog
	
	progress_vals[current_light] = global.winstate

	# Light 0
	if progress_vals[0] == 0:
		LS0.texture = neu_texture
	elif progress_vals[0] == 1:
		LS0.texture = point_texture
	elif progress_vals[0] == -1:
		LS0.texture = lost_texture

	# Light 1
	if progress_vals[1] == 0:
		LS1.texture = neu_texture
	elif progress_vals[1] == 1:
		LS1.texture = point_texture
	elif progress_vals[1] == -1:
		LS1.texture = lost_texture

	if progress_vals[2] == 0:
		LS2.texture = neu_texture
	elif progress_vals[2] == 1:
		LS2.texture = point_texture
	elif progress_vals[2] == -1:
		LS2.texture = lost_texture
		
	if progress_vals[3] == 0:
		LS3.texture = neu_texture
	elif progress_vals[3] == 1:
		LS3.texture = point_texture
	elif progress_vals[3] == -1:
		LS3.texture = lost_texture
		
	if progress_vals[4] == 0:
		LS4.texture = neu_texture
	elif progress_vals[4] == 1:
		LS4.texture = point_texture
	elif progress_vals[4] == -1:
		LS4.texture = lost_texture
	
	global.prog += 1
	randomizer()
	game_done()

func _on_return_main_pressed() -> void:
	print("Menu")
	global.points = 0
	global.lives = 5
	# Gives time for sound to play
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	global.points = 0;
	global.lives = 5;
	global.done = false; 
	global.prog = 0;
	global.winstate = 0;
	
# Flips the mute button states (to with no X and with X)
# Would have used toggle, but toggle doesn't support two hovers
func _on_mute_pressed() -> void:
	isMuted = !isMuted
	
	if isMuted:
		print("Mute")
		$"Buttons STAGE/Mute".texture_normal = muteIdle
		$"Buttons STAGE/Mute".texture_hover = muteHov
	else:
		print("UnMute")
		$"Buttons STAGE/Mute".texture_normal = muteNoIdle
		$"Buttons STAGE/Mute".texture_hover = muteNoHov

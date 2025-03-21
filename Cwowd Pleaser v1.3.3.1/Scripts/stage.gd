extends Node

var bendGoing = false;

#Timer in the stage
@onready var timer_node = $StageTimer;

#Nodes used to call methods within their scripts (triggering on and off game)
@onready var RPSnode = get_node("Control");
@onready var HANGnode = get_node("Hangman");
@onready var WACKnode = get_node("target_control/CanvasLayer");
@onready var TOMnode = get_node("TomatoGame");
@onready var BULnode = get_node("TomatoGame/BulletSpawner");

var lives_Label: Label
var points_Label: Label
var timer_Label: Label

# Go through each, trigger a minigame at each number
# 1 = RPS
# 2 = Hangman
# 3 = Dragon
# 4 = Wack
# 5 = Tomato
var minigame_amt = 5;
var current_minig = 0;

#Signals of games being done
@onready var RPS_signal = $Control;
@onready var HANG_signal = $Hangman;
@onready var WACK_signal = $target_control/CanvasLayer;
@onready var TOM_signal = $TomatoGame;

#seconds of timer
var timer_amt = 5;

#used for light visuals
#0 -> yellow, -1 -> red, 1 -> green
var progress_vals = [0, 0, 0, 0, 0]
@onready var neu_texture = load("res://Stage Assets/Yellow.tres")
@onready var point_texture = load("res://Stage Assets/Green.tres")
@onready var lost_texture = load("res://Stage Assets/Red.tres")

@onready var LS0 = $Lights/Light0
@onready var LS1 = $Lights/Light1
@onready var LS2 = $Lights/Light2
@onready var LS3 = $Lights/Light3
@onready var LS4 = $Lights/Light4

var lightSprites: Array[Texture2D]

func _ready() -> void:
	#var RPSnode = get_node("Control")
	#node.choose_and_display_opponent_choice()
	lives_Label = $Lives
	points_Label = $Points
	timer_Label = $TimerLabel
	BenderDragonEnd() #not sure why this is here, too scared to touch it
	
	for i in range(minigame_amt):
		var lightSpr = "Node2D/Light " + str(i) + ""
		lightSprites.append(lightSpr)
	
	timer_node.timeout.connect(_on_timer_timeout)
	
	#hehe more stuff for signals -> hooked up to methods
	RPS_signal.gameDone.connect(_on_RpsEnd)
	HANG_signal.gameDone.connect(_on_HangEnd)
	WACK_signal.gameDone.connect(_on_WackEnd)
	TOM_signal.gameDone.connect(_on_TomEnd)

func _process(delta: float) -> void:
	BenderDragonTimer()
	lives_Label.text = "Lives: " + str(global.lives)
	points_Label.text = "Points: " + str(global.points)
	
	timer_Label.text = "Time: " + str(ceil(timer_node.time_left))

func _input(_ev):
	#Debugging stuff, not to be used in the actual game loop
	if Input.is_key_pressed(KEY_9):
		BenderDragonStart()
	
	# Start time -> Start the games
	if Input.is_key_pressed(KEY_0):
		stage_GO()
		
	if Input.is_key_pressed(KEY_1):
		RpsStart()
		
	if Input.is_key_pressed(KEY_2):
		RpsEnd()
		
	if Input.is_key_pressed(KEY_3):
		HangStart()
	
	if Input.is_key_pressed(KEY_4):
		HangEnd()
		
	if Input.is_key_pressed(KEY_5):
		WackStart()
	
	if Input.is_key_pressed(KEY_6):
		WackEnd()
		
	if Input.is_key_pressed(KEY_7):
		TomStart()
	
	if Input.is_key_pressed(KEY_8):
		TomEnd()
		
# calls the start of stage timer (will be more than just timer)
# Will also include later the start of the dialouge section
func stage_GO() -> void:
	timer_node.start(timer_amt)
	
# When timer runs out, depending on the current minigame, next one is started
func _on_timer_timeout() -> void:
	current_minig = current_minig + 1;
	
	if current_minig > minigame_amt:
		print("No more Minigames")
		
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

func BenderDragonStart() -> void:
	$Timer.start(5.0)
	bendGoing = true;
	$BenderDragon.visible = true;
	$BenderDragon/Item1.disabled = false;
	$BenderDragon/Item2.disabled = false;
	$BenderDragon/Item3.disabled = false;
	$BenderDragon/Item4.disabled = false;
	$BenderDragon/Item5.disabled = false;
	
func BenderDragonEnd() -> void:
	$BenderDragon.visible = false;
	$BenderDragon/Item1.disabled = true;
	$BenderDragon/Item2.disabled = true;
	$BenderDragon/Item3.disabled = true;
	$BenderDragon/Item4.disabled = true;
	$BenderDragon/Item5.disabled = true;
	$BenderDragon/Item3/deadDragon.visible = false;
	$BenderDragon/Item2/deadDragon.visible = false;
	$BenderDragon/Item1/death.visible = false;
	$BenderDragon/Item4/death.visible = false;
	$BenderDragon/Item5/death.visible = false;

func BenderDragonTimer() -> void:
	if bendGoing == true:
		if $Timer.is_stopped() == true && global.done == false:
			global.lives -= 1;
			bendGoing = false;
			BenderDragonEnd()
			print("dead")
			EnderEnd()
	
		elif $Timer.is_stopped() == true && global.done == true:
			bendGoing = false;
			BenderDragonEnd()
			EnderEnd()
			
#------------------------------
#Methods without '_' in front (minus dragon), used in game. Non '_' methods used in debugging
func RpsStart() -> void:
	$Control.visible = true;
	RPSnode.choose_and_display_opponent_choice()
	#node.choose_and_display_opponent_choice()
	
func RpsEnd() -> void:
	$Control.visible = false;
	
func _on_RpsEnd():
	$Control.visible = false;
	print("end")
	stage_GO()
	update_lights()
	
func HangStart() -> void:
	$Hangman.visible = true;
	HANGnode.generate_new_word()

func HangEnd() -> void:
	$Hangman.visible = false;
	
func _on_HangEnd():
	$Hangman.visible = false;
	print("hang END")
	stage_GO()
	update_lights()
	
func EnderEnd():
	print("ender end")
	stage_GO()
	update_lights()
	
func WackStart() -> void:
	WACKnode.visible = true;
	WACKnode.startWack()

func WackEnd() -> void:
	WACKnode.visible = false;

func _on_WackEnd():
	WACKnode.visible = false;
	stage_GO()
	update_lights()
	
func TomStart() -> void:
	TOMnode.visible = true;
	TOMnode.tomato_start()
	BULnode.spawn_start()
	
func TomEnd() -> void:
	TOMnode.visible = false;
	BULnode.spawn_end()

func _on_TomEnd():
	BULnode.spawn_end()
	await get_tree().create_timer(3.0).timeout
	TOMnode.visible = false;
	update_lights()

#Update progression lights
func update_lights() -> void:
	var current_light = current_minig - 1;
	
	# Probably easier way to do this, but I am severly sleep deprived

	progress_vals[current_light] = 1;

	#var LS0 = $Node2D/Light0
	#var LS1 = $Node2D/Light1
	#var LS2 = $Node2D/Light2
#	var LS3 = $Node2D/Light3
#	var LS4 = $Node2D/Light4
	
	#Light 0
	if progress_vals[0] == 0:
		LS0.texture = neu_texture
	elif progress_vals[0] == 1:
		LS0.texture = point_texture
	elif progress_vals[0] == -1:
		LS0.texture = lost_texture
	
	#Light 1
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
	

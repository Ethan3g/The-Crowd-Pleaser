extends Node2D
# AUDIO MANAGER FOR THE STAGE

var isMute = false;
# Default values of the background music
var StageMusVol = -20
var MiniMusVol = -28

func _ready() -> void:
		isMute = false
		$StageBGMusic.volume_db = StageMusVol
		$MiniGameBG.volume_db = MiniMusVol
		$StageBGMusic.play()


func _on_return_main_pressed() -> void:
	$ButtonClick.play()
	
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()
	$StageBGMusic.stop()


func _on_return_main_mouse_entered() -> void:
	$Hov.play()


func _on_mute_pressed() -> void:
	isMute = !isMute
	$ButtonClick.play()
	
	if isMute:
		Musc_off()
	else:
		Musc_default()

func Musc_off() -> void:
	$StageBGMusic.volume_db = -100
	$MiniGameBG.volume_db = -100

func Musc_default() -> void:
	$StageBGMusic.volume_db = StageMusVol
	$MiniGameBG.volume_db = MiniMusVol


func _on_mute_mouse_entered() -> void:
	$Hov.play()	

func test() -> void:
	print("test from audio")
	
func _on_stage_timer_timeout() -> void:
	$Stinger.play()
	
	if !isMute:
		$StageBGMusic.volume_db = -30
		$MiniGameBG.play(1.0)
	else:
		Musc_off()
		
# Called from the stage.gd
func _mini_done() -> void:
	print(global.winstate)
	
	# Win
	if global.winstate == 1:
		$Stinger.play()
		$MiniGameBG.stop()
		
		await get_tree().create_timer(0.25).timeout
		$WinAudio.play()
		
		await get_tree().create_timer(0.4).timeout
		if !isMute:
			$StageBGMusic.volume_db = StageMusVol
	#Lost
	elif global.winstate == -1:
		$Stinger.play()
		$StageBGMusic.stream_paused = true
		$MiniGameBG.stop()
		
		await get_tree().create_timer(0.25).timeout
		$LostAudio.play()
		
		await get_tree().create_timer(2.3).timeout
		$StageBGMusic.stream_paused = false
		
		if !isMute:
			$StageBGMusic.volume_db = StageMusVol


func _on_start_stage_pressed() -> void:
	$ButtonClick.play()
	
	await get_tree().create_timer(0.1).timeout
	$Stinger.play()

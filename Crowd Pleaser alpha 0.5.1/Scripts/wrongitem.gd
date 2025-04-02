extends TextureButton

func _pressed() -> void:
	$death.visible = true;
	$LoseSfx.play()
	print("L bozo")
	$"../Item2".disabled = true;
	$"../Item1".disabled = true;
	$"../Item4".disabled = true;
	$"../Item5".disabled = true;
	$"../Item3".disabled = true;
	global.done = true;
	global.lives -= 1;
	global.winstate = -1
	print(global.lives);

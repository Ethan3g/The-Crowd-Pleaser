extends TextureButton

func _pressed() -> void:
	$deadDragon.visible = true;
	$WinSfx.play()
	print("W bozo")
	$"../Item2".disabled = true;
	$"../Item1".disabled = true;
	$"../Item4".disabled = true;
	$"../Item5".disabled = true;
	$"../Item3".disabled = true;
	global.points += 1;
	global.winstate = 1
	global.done = true;
	print(global.points);

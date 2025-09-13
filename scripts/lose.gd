extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.GameWin == false:
		$Title.text = "你死了"
		$Introduce.text = "经警方调查，现场除了一滩血渍以外似乎什么都没有，遂放弃。"
		$HBoxContainer/Goon/ColorRect.color = Color(1, 0, 0, 1)
	if GameManager.GameWin == true:
		$Title.text = "你出来了"
		$Introduce.text = "所有警察都已在房间门口等你，你被救出来了，因此你暂时逃过一劫。"
		$HBoxContainer/Goon/ColorRect.color = Color(0, 1, 0, 0.35)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_leave_pressed() -> void:
	SceneManager.change_scene("uid://gk5a8awxsh3w")


func _on_mapchoice_pressed() -> void:
	SceneManager.change_scene("uid://bnon0tlkdtljx")

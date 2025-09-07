extends Control

func _ready() -> void:
	GameManager.play_bgm("main") # 播放 Bgm

func _on_begin_pressed() -> void:
	# 开始游戏（也就是选择地图）按钮被点击
	SceneManager.change_scene("uid://bnon0tlkdtljx")


func _on_exit_game_pressed() -> void:
	# 退出游戏按钮被点击
	get_tree().quit()

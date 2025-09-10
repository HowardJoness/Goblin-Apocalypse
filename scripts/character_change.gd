extends Control


var total_character: int = 2
var now_character: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	now_character = GameManager.charactor_id
	match now_character:
		1:
			$Name.text = "沉雷"
			$AnimatedSprite2D.animation = "run_1"
		2:
			$Name.text = "些微"
			$AnimatedSprite2D.animation = "run_2"
		
	
# 读取 charactor_id（如果不存在就新建并写默认值 1）
func load_charactor_id(default_id: int = 1) -> int:
	var config = ConfigFile.new()
	var err = config.load("user://savegame.cfg")
	
	if err != OK:
		# 文件不存在 -> 新建文件并写入默认值
		config.set_value("player", "charactor_id", default_id)
		config.save("user://savegame.cfg")
		return default_id
	
	# 文件存在 -> 直接读取，如果没有则返回默认值
	return int(config.get_value("player", "charactor_id", default_id))


# 保存 charactor_id（修改或新建）
func save_charactor_id(charactor_id: int) -> void:
	var config = ConfigFile.new()
	var err = config.load("user://savegame.cfg")

	# 无论文件是否存在都能安全覆盖
	config.set_value("player", "charactor_id", charactor_id)
	config.save("user://savegame.cfg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if now_character == 1:
		$Left.visible = false
	else:
		$Left.visible = true
	
	if now_character == total_character:
		$Right.visible = false
	else:
		$Right.visible = true
	
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_scene("uid://gk5a8awxsh3w")
		

func _on_left_pressed() -> void:
	if now_character != 1:
		now_character -= 1
	set_character()


func _on_right_pressed() -> void:
	if now_character != total_character:
		now_character += 1
	set_character()

func set_character() -> void:
	save_charactor_id(now_character)
	GameManager.charactor_id = now_character
	match now_character:
		1:
			$Name.text = "沉雷"
			$AnimatedSprite2D.animation = "run_1"
		2:
			$Name.text = "些微"
			$AnimatedSprite2D.animation = "run_2"
		

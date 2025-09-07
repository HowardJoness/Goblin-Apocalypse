extends Control
# 暴露变量，编辑器里可以直接修改
@export var map_name: String = "默认地图名"
@export var map_image_path: String = "res://icon.svg"
@export var map_description: String = "这里是地图简介"
@export var target_scene_path: String = ""
@export var difficuty: int = 1 # 1:新手 2:普通 3:专家 4:史诗

# 假设场景里有节点：Label(map_name_label), TextureRect(map_image), Label(map_description_label)
@onready var map_name_label = $Panel/MapName
@onready var map_image = $Panel/TextureRect
@onready var map_description_label = $Panel/MapIntroduce

func _process(delta: float) -> void:
	# 更新UI节点
	map_name_label.text = map_name
	
	# 加载图片并赋值
	var texture = load(map_image_path)
	if texture:
		map_image.texture = texture
	else:
		print("图片加载失败: ", map_image_path)
	
	map_description_label.text = map_description
	await get_tree().create_timer(0.01).timeout
	match difficuty:
		1:
			$Panel/MapDifficuty.modulate = Color(0.478, 0.835, 0.839)
			$Panel/MapDifficuty.text = "新手"
		2:
			$Panel/MapDifficuty.modulate = Color(0, 1, 0)
			$Panel/MapDifficuty.text = "普通"
		3:
			$Panel/MapDifficuty.modulate = Color(1, 0, 0)
			$Panel/MapDifficuty.text = "专家"
		4:
			$Panel/MapDifficuty.modulate = Color(0.478, 0, 0.839)
			$Panel/MapDifficuty.text = "史诗"
		
	
	
func go_to_target_scene():
	# 切换到指定场景
	var scene = load(target_scene_path)
	if scene:
		get_tree().change_scene_to(scene)
	else:
		print("场景加载失败: ", target_scene_path)


func _on_startmap_pressed() -> void:
	GameManager.pause_bgm()
	SceneManager.change_scene(target_scene_path)

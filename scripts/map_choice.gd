extends Control
var MapChoiceScene = preload("uid://baqbutxerw8lw")

func add_map():
	var item_instance = MapChoiceScene.instantiate()
	var hbox = $ScrollContainer/HBoxContainer
	hbox.add_child(item_instance)
	
	# ✅ 设置实例化对象的属性
	item_instance.map_name = "州音街 805号"
	item_instance.map_description = "欢迎光临！这里是你家楼下的小卖部。你可以在这里买到各种好玩的好吃的好用的，我们承诺提供最优惠的价格！你可能需要先签订一份生死状。"
	item_instance.target_scene_path = "uid://di7tdmhpolkqj"
	item_instance.map_image_path = "res://srcs/images/容器 20@1x.png"
	item_instance.difficuty = 1

func add_map2():
	var item_instance = MapChoiceScene.instantiate()
	var hbox = $ScrollContainer/HBoxContainer
	hbox.add_child(item_instance)
	
	# ✅ 设置实例化对象的属性
	item_instance.map_name = "州音街 502号"
	item_instance.map_description = "我们收容，我们控制，我们保护。你好，这里是教学管理处，我们收容一些不听话的学生。包括，你。"
	item_instance.target_scene_path = "uid://btb3qq41j5jv8"
	item_instance.map_image_path = "res://srcs/images/容器 21@1x.png"
	item_instance.difficuty = 3

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_scene("uid://gk5a8awxsh3w")
		
func _ready() -> void:
	# 进入地图选择场景后的准备工作
	add_map()
	add_map2()

extends Node2D

@export var follow_speed: float = 30.0
@export var follow_distance: float = 10.0

# 调用这个函数就开始让 Goblin 跟随 player
var follow_player: Node2D = null  # 当前跟随的玩家
var GoblinIsOn: bool = false
var ToolPointThing: Array = ["FlashLight", "Door", "DoorKey"] # 道具点内容
var player_bag: Array = [] # 玩家物品栏
const player_camera_zoom: float = 10.0 # 玩家初始相机大小
const player_flashelight_scale: float = 1.17 # 玩家初始手电筒大小

# 调用这个函数开始让 Goblin 跟随 player
func goblin_follow_player(player: Node2D) -> void:
	follow_player = player
	$Goblin.set_process(true)  # 确保 Goblin 会调用 _process
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# 布置道具点
	ToolPointThing.shuffle() # 随机分布物品
	match ToolPointThing[0]:
		"FlashLight":
			$ToolPoint_1/AnimatedSprite2D.frame = 0
			print(1)
		"Door":
			$ToolPoint_1/AnimatedSprite2D.frame = 1
		"DoorKey":
			$ToolPoint_1/AnimatedSprite2D.frame = 2
			
	match ToolPointThing[1]:
		"FlashLight":
			$ToolPoint_2/AnimatedSprite2D.frame = 0
		"Door":
			$ToolPoint_2/AnimatedSprite2D.frame = 1
		"DoorKey":
			$ToolPoint_2/AnimatedSprite2D.frame = 2
	match ToolPointThing[2]:
		"FlashLight":
			$ToolPoint_3/AnimatedSprite2D.frame = 0
		"Door":
			$ToolPoint_3/AnimatedSprite2D.frame = 1
		"DoorKey":
			$ToolPoint_3/AnimatedSprite2D.frame = 2
	
		
	
	
	await get_tree().create_timer(1).timeout
	$Player._flashlighton()
	_goGoblin()
	_GoblinSpeed()
	
	
func _GoblinSpeed():
	await get_tree().create_timer(12).timeout
	follow_speed += 10

func _goGoblin():
	await get_tree().create_timer(5).timeout
	for i in range(10):
		$CanvasLayer/Tips.set_tip("哥布林还有 " + str(10 - (i+1)) + " 秒到达战场")
		await get_tree().create_timer(1).timeout
	$Goblin.visible = true
	$Goblin/AudioStreamPlayer2D.play()
	goblin_follow_player($Player)
	GoblinIsOn = true
	$CanvasLayer/Tips.set_tip("哥布林已就绪")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_player == null:
		return
	
	var dir = follow_player.global_position - $Goblin.global_position
	if dir.length() > follow_distance:
		$Goblin.global_position += dir.normalized() * follow_speed * delta
	
	
	# 更新雷达数据
	$CanvasLayer/SubViewportContainer/SubViewport/RaderMap.player_pos = $Player.position
	if GoblinIsOn == true:
		$CanvasLayer/SubViewportContainer/SubViewport/RaderMap.enemy_pos = $Goblin.position
	else:
		$CanvasLayer/SubViewportContainer/SubViewport/RaderMap.enemy_pos = Vector2(-1, -1)
	
func _input(event):
	if event.is_action_pressed("RaderOn"):
		if "rader_normal" in player_bag:
			$CanvasLayer/SubViewportContainer.visible = true
		else:
			$CanvasLayer/Tips.set_tip("你没有雷达")
		
	elif event.is_action_released("RaderOn"):
		$CanvasLayer/SubViewportContainer.visible = false
	
	
	if event.is_action_pressed("FlashLightOn"):
		if "FlashLight" in player_bag:
			player_bag.pop_at(player_bag.find("FlashLight"))
			_onStrongFlashLight()
			
		else:
			$CanvasLayer/Tips.set_tip("你没有强光手电筒")
		
	elif event.is_action_released("FlashLightOn"):
		$CanvasLayer/SubViewportContainer.visible = false

func _onStrongFlashLight():
	$CanvasLayer/Tips.set_tip("你启用了强光手电筒 续航：25 s")
	$Player.camera_zoom = 6.5
	$Player.FlashLightScale = 2.8
	await get_tree().create_timer(15).timeout
	$CanvasLayer/Tips.set_tip("强光手电筒电量电量低")
	await get_tree().create_timer(5).timeout
	$CanvasLayer/Tips.set_tip("强光手电筒电量即将耗尽")
	await get_tree().create_timer(2).timeout
	$CanvasLayer/Tips.set_tip("强光手电筒已关闭")
	$Player.camera_zoom = player_camera_zoom
	$Player.FlashLightScale = player_flashelight_scale
	

func _on_touch_ToolPointRader(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CanvasLayer/Tips.set_tip("你捡到了便携式雷达！按下鼠标右键以打开")
		player_bag.append("rader_normal")
		$ToolPoint_Rader.queue_free()

func _ToolPointHandler(ToolPointID: int, toolpoint: Area2D):
	# 从道具点获得道具逻辑
	if ToolPointThing[ToolPointID - 1] == "FlashLight":
		$CanvasLayer/Tips.set_tip("你捡到了强光手电筒！按下 F 键以打开")
		player_bag.append("FlashLight")
		toolpoint.queue_free()
		
	if ToolPointThing[ToolPointID - 1] == "Door":
		if "DoorKey" in player_bag:
			$CanvasLayer/Tips.set_tip("门开了")
			GameManager.GameWin = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			SceneManager.change_scene("uid://cqif4267fxo6k")
		else:
			$CanvasLayer/Tips.set_tip("你目前无法开门，你没有钥匙")
	
	if ToolPointThing[ToolPointID - 1] == "DoorKey":
		$CanvasLayer/Tips.set_tip("你捡到了一把门的钥匙！")
		player_bag.append("DoorKey")
		toolpoint.queue_free()
		



func _on_touch_ToolPoint1(body: Node2D) -> void:
	if body.is_in_group("player"):
		_ToolPointHandler(1, $ToolPoint_1)


func _on_touch_ToolPoint2(body: Node2D) -> void:
	if body.is_in_group("player"):
		_ToolPointHandler(2, $ToolPoint_2)


func _on_touch_ToolPoint3(body: Node2D) -> void:
	if body.is_in_group("player"):
		_ToolPointHandler(3, $ToolPoint_3)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Player.FlashLightScale = 0
		$KillSound.play()
		await get_tree().create_timer(1).timeout
		GameManager.GameWin = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		SceneManager.change_scene("uid://cqif4267fxo6k")
		

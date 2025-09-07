extends CharacterBody2D

@export var SPEED: float = 100.0
@export var DECELERATION: float = 3000.0  # 松开按键时减速

@export var camera_limit_left: int = 0
@export var camera_limit_right: int = 1024
@export var camera_limit_top: int = 0
@export var camera_limit_bottom: int = 768
@export var camera_zoom: float = 10.0
@export var FlashLightScale: float = 1.17

func _process(delta: float) -> void:
	var cam = $Camera2D
	cam.limit_left = camera_limit_left
	cam.limit_right = camera_limit_right
	cam.limit_top = camera_limit_top
	cam.limit_bottom = camera_limit_bottom
	$Camera2D.zoom = Vector2(camera_zoom,camera_zoom)
	$PointLight2D.texture_scale = FlashLightScale

func _flashlighton() -> void:
	for i in range(4):
		$PointLight2D.visible = false
		await get_tree().create_timer(0.02).timeout
		$PointLight2D.visible = true
		await get_tree().create_timer(0.02).timeout

func _flashlightoff() -> void:
	for i in range(4):
		$PointLight2D.visible = true
		await get_tree().create_timer(0.02).timeout
		$PointLight2D.visible = false
		await get_tree().create_timer(0.02).timeout
		

func _physics_process(delta: float) -> void:
	# 读取输入
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")

	# 归一化，防止斜向加速过快
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity = input_dir * SPEED
		$AnimatedSprite2D.play("run")  # 播放走路动画
		if not($AudioStreamPlayer2D.playing):
			$AudioStreamPlayer2D.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
		$AnimatedSprite2D.play("idle")  # 播放待机动画
		$AudioStreamPlayer2D.stop()
	# 镜像处理
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true  # 往左走镜像
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false  # 往右走不镜像

	# 移动
	move_and_slide()

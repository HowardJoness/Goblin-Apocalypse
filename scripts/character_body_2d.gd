extends CharacterBody2D

@export var SPEED: float = 300.0
@export var DECELERATION: float = 600.0  # 减速速率

func _physics_process(delta: float) -> void:
	# 获取输入方向
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	input_dir = input_dir.normalized()  # 防止斜方向加速过快

	# 水平和垂直速度处理
	if input_dir != Vector2.ZERO:
		# 有输入就直接加速度
		velocity = input_dir * SPEED
	else:
		# 没输入就减速到 0
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)

	# 移动
	move_and_slide()

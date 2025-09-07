extends Control

@export var radar_size: Vector2 = Vector2(400, 300)
@export var min_scale: float = 0.3
@export var world_to_radar_scale: float = 0.5
@export var player_pos: Vector2 = Vector2.ZERO
@export var enemy_pos: Vector2 = Vector2(-1, -1) # 默认不显示

func _process(delta):
	queue_redraw()

func _draw():
	var radar_half = radar_size / 2

	# 玩家固定在中心
	draw_circle(radar_half, 5, Color.GREEN)

	# 敌人不显示时直接返回
	if enemy_pos == Vector2(-1, -1):
		return

	# 世界坐标映射到雷达
	var offset = (enemy_pos - player_pos) * world_to_radar_scale
	var scale_factor = 1.0

	# 判断是否超出雷达边界
	if abs(offset.x) > radar_half.x or abs(offset.y) > radar_half.y:
		var scale_x = radar_half.x / abs(offset.x)
		var scale_y = radar_half.y / abs(offset.y)
		scale_factor = min(scale_x, scale_y)
		scale_factor = max(scale_factor, min_scale)

	var radar_offset = offset * scale_factor
	var enemy_radar_pos = radar_half + radar_offset

	draw_circle(enemy_radar_pos, 5, Color.RED)

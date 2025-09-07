extends Control

@onready var label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var hide_timer: Timer
var is_showing: bool = false  # 标记提示是否正在显示

func _ready() -> void:
	label.text = ""
	if anim_player.has_animation("Reset"):
		anim_player.play("Reset")

	hide_timer = Timer.new()
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_hide_timeout)
	add_child(hide_timer)


func set_tip(tip: String, duration: float = 5.0) -> void:
	duration = clamp(duration, 0.1, 300.0)

	# 如果已经在显示，不再重新播放 TextOn 动画
	if is_showing:
		label.text = tip
		hide_timer.stop()
		hide_timer.start(duration)
		return

	# 否则首次显示
	label.text = tip
	is_showing = true
	hide_timer.stop()

	if anim_player.has_animation("TextOn"):
		anim_player.play("TextOn")

	hide_timer.start(duration)


func _on_hide_timeout() -> void:
	if anim_player.has_animation("TextOff"):
		anim_player.play("TextOff")
	is_showing = false

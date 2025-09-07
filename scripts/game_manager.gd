extends Node

var bgm_player: AudioStreamPlayer
var GameWin = true
# 在这里管理所有 BGM
var bgm_dict = {
	"main": preload("res://srcs/sounds/bgm1.mp3")
}

func _ready():
	bgm_player = $AudioStreamPlayer
	## 创建 AudioStreamPlayer 节点
	#bgm_player = AudioStreamPlayer.new()
	#add_child(bgm_player)
	bgm_player.bus = "Music"
	bgm_player.autoplay = false

# 播放 BGM，根据 key
# 播放 BGM，根据 key
func play_bgm(key: String, loop: bool = true):
	if not bgm_dict.has(key):
		push_warning("BGM key '%s' 不存在！" % key)
		return

	var bgm = bgm_dict[key]

	# 如果已经在播放同样的 BGM，就不重新播放
	if bgm_player.stream == bgm and bgm_player.playing:
		return

	# 设置 BGM
	bgm_player.stream = bgm
	bgm_player.play()
	bgm_player.stream.loop = loop  # 设置是否循环


# 停止 BGM
func pause_bgm():
	bgm_player.stop()

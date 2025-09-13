extends Node

var bgm_player: AudioStreamPlayer
var GameWin = true
var LastRoomUID = ""
# 在这里管理所有 BGM
var bgm_dict = {
	"main": preload("res://srcs/sounds/bgm1.mp3")
}
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

var charactor_id: int = int(load_charactor_id())

func _ready():
	print(charactor_id)
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

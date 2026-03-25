extends Object
class_name VideoExtention


static var vsync_dict: Dictionary = {
	"Disabled" = Callable(DisplayServer, "window_set_vsync_mode").bind(DisplayServer.VSYNC_DISABLED),
	"Enabled" = Callable(DisplayServer, "window_set_vsync_mode").bind(DisplayServer.VSYNC_ENABLED),
	"Adaptive" = Callable(DisplayServer, "window_set_vsync_mode").bind(DisplayServer.VSYNC_ADAPTIVE),
	"Fast" = Callable(DisplayServer, "window_set_vsync_mode").bind(DisplayServer.VSYNC_MAILBOX),
}

static var window_size_dict: Dictionary = {
	"1024 x 768 (4:3) XGA" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1024,768)),
	"1152 x 648" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1152,648)),
	"1280 x 720 (16:9) HD" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1280,720)),
	"1200 x 800" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1200,800)),
	"1280 x 1080 (16:9) Full HD" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1280,1080)),
	"1440 x 1080 (16:9) Full HD" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1440,1080)),
	"1920 x 1080 (16:9) Full HD" = Callable(DisplayServer, "window_set_size").bind(Vector2i(1920,1080)),
}

static var window_mode_dict: Dictionary = {
	"Full-screen" = Callable(VideoExtention, "set_full_screen"),
	"Window" = Callable(VideoExtention, "set_window"),
}


#static func string_to_vector2i(string:String) -> Vector2i


static func set_full_screen() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	


static func set_window() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

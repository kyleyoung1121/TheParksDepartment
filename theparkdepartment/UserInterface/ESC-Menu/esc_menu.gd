extends Control

func _on_continue_pressed() -> void:
	$PanelContainer.visible = false;
	$VBoxContainer.visible = false;
	$Options.visible = false;

func _on_settings_pressed() -> void:
	$Options.visible = true;
	$VBoxContainer.visible = false;

func _on_quit_to_menu_pressed() -> void:
	pass # not sure how we're going to redirect back to main menu

func _on_exit_game_pressed() -> void:
	get_tree().quit()

const FPS_DICT = {
	0: 30,
	1: 60,
	2: 120,
	3: 144,
	4: 240,
	5: "Custom"
}

var master_bus = AudioServer.get_bus_index("Master")

const RES_DICT = {
	0:Vector2i(3840, 2160),
	1:Vector2i(2560, 1080),
	2:Vector2i(1920, 1080),
	3:Vector2i(1280, 720),
	4:Vector2i(800, 600)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Options.visible = false;

func _on_close_button_pressed() -> void:
	$Options.visible = false;
	$VBoxContainer.visible = true;

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)

func _on_res_button_item_selected(index: int) -> void:
	get_window().set_size(RES_DICT[index])

func _on_screen_type_item_selected(index: int) -> void:
	match index:
		0: #Windowed
			get_window().set_size(RES_DICT[4])
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Borderlses Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

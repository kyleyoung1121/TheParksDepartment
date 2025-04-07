extends Control

signal menu_toggled(is_open: bool)

const FPS_DICT = {
	0: 30,
	1: 60,
	2: 120,
	3: 144,
	4: 240,
	5: "Custom"
}
const RES_DICT = {
	0:Vector2i(3840, 2160),
	1:Vector2i(2560, 1080),
	2:Vector2i(1920, 1080),
	3:Vector2i(1280, 720),
	4:Vector2i(800, 600)
}

var master_bus = AudioServer.get_bus_index("Master")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	is_open = false
	$Options.visible = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_menu()


func toggle_menu():
	if is_open:
		menu_toggled.emit(false)
		visible = false
		is_open = false
	else:
		menu_toggled.emit(true)
		visible = true
		is_open = true
		# Mouse must be free once the menu is open! (if not already)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 


func _on_continue_pressed() -> void:
	toggle_menu()


func _on_settings_pressed() -> void:
	$Options.visible = true
	$VBoxContainer.visible = false


func _on_quit_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UserInterface/Main Menu/MainMenu.tscn")


func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_close_button_pressed() -> void:
	$Options.visible = false
	$VBoxContainer.visible = true


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)


func _on_res_button_item_selected(index: int) -> void:
	get_window().set_size(RES_DICT[index])

func centre_window():
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)

func _on_screen_type_item_selected(index: int) -> void:
	match index:
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			get_window().set_size(RES_DICT[3])
			centre_window()
		2: #Borderlses Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			get_window().set_size(RES_DICT[2])
			centre_window()
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func _on_fps_item_selected(index: int) -> void:
	match index:
		0:
			Engine.max_fps = 30
		1:
			Engine.max_fps = 60
		2:
			Engine.max_fps = 120
		3:
			Engine.max_fps = 144
		4:
			Engine.max_fps = 240

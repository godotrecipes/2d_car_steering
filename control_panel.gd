extends Control

@export var player_path : NodePath
@onready var player = get_node(player_path)
@onready var container = $Panel/MarginContainer/VBoxContainer
var setting_slider = preload("res://setting_slider.tscn")

var car_settings = [
	"traction_fast", "traction_slow", "engine_power", "braking", "friction",
	"drag", "slip_speed", "steering_angle"
]

var ranges = {
	'traction_fast': [0, 10, 0.1],
	'traction_slow': [0, 10, 0.1],
	'engine_power': [500, 2000, 10],
	'braking': [-1000, -100, 10],
	'friction': [-1.0, -0.01, 0.01],
	'drag': [-0.1, 0, 0.001],
	'slip_speed': [100, 1500, 10],
	'steering_angle': [0, 45, 1]
}


func _ready():
	for setting in car_settings:
		var ss = setting_slider.instantiate()
		ss.name = setting
		container.add_child(ss)
		ss.get_node("Slider").min_value = ranges[setting][0]
		ss.get_node("Slider").max_value = ranges[setting][1]
		ss.get_node("Slider").step = ranges[setting][2]
		ss.get_node("Slider").value = player.get(setting)
		ss.get_node("Label").text = setting
		ss.get_node("Value").text = str(player.get(setting))
		ss.get_node("Slider").value_changed.connect(_on_value_changed.bind(ss))
		
func _on_value_changed(value, node):
	player.set(node.name, value)
	node.get_node("Value").text = str(value)
	
	
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		visible = !visible
		

func _process(delta):
	container.get_node("Speedometer/Speed").text = "%4.1f" % player.velocity.length()

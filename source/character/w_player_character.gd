extends FPSController3D
class_name WPlayerCharacter

## This script is a copy of the expressobits controller, because there's really no reason to
## reinvent the wheel

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
#@export var input_sprint_action_name := "move_sprint"
#@export var input_jump_action_name := "move_jump"
#@export var input_crouch_action_name := "move_crouch"
#@export var input_fly_mode_action_name := "move_fly_mode"

@onready var dodge_ability : WDodgeAbility3D = $WDodgeAbility3D
@onready var camera_ref : Marker3D = $Head

#this should be set automatically but who really cares
@export var ztarget : Node3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	setup()
	_abilities.append(dodge_ability)
	#emerged.connect(_on_controller_emerged.bind())
	#submerged.connect(_on_controller_subemerged.bind())


func _physics_process(delta):
	# rotate head to face z target
	var forward = -transform.basis.z
	var dir_to_target = (ztarget.global_position - global_position).normalized()
	dir_to_target.y = 0.0
	var rotate_dir = (dir_to_target - forward)
	if(dir_to_target.dot(forward) != 1.0):
		rotate_head(Vector2(rotate_dir.x, rotate_dir.y) * 100.0)
	
	var is_valid_input := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if is_valid_input:
		var input_axis = Input.get_vector(input_left_action_name, input_right_action_name, input_back_action_name, input_forward_action_name)
		move(delta, input_axis, false, false, false, false, false)
	else:
		move(delta)

"""
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.screen_relative)
"""

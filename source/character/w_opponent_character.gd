extends FPSController3D
class_name WOpponentCharacter

## This script is a copy of the player copy of the expressobits controller
## because there's really no reason to have a robust inheretence system in a game
## that'll be done before the week is out

signal opponent_slain()

@export var max_hp : int = 100

@onready var dodge_ability : WDodgeAbility3D = $WDodgeAbility3D
@onready var camera_ref : Marker3D = $Head
# the wheel handles its own input, we only need to respond to it. praise be.
#@onready var wheel : Wheel = $Control/Wheel
#@onready var debug_label : Label = $Control/Label
@onready var col_handler : CollisionHandler = $CollisionHandler

@onready var hp : int = max_hp

#this should be set automatically but who really cares
@export var ztarget : Node3D
#@export var show_debug_values : bool = true

var current_stance_direction : int
var lock_movement : bool = false


func _ready():
	setup()
	_abilities.append(dodge_ability)
	


func _physics_process(delta):
	# rotate head to face z target
	var forward = -transform.basis.z
	var dir_to_target = (ztarget.global_position - global_position).normalized()
	dir_to_target.y = 0.0
	var rotate_dir = (dir_to_target - forward)
	if(dir_to_target.dot(forward) != 1.0):
		rotate_head(Vector2(rotate_dir.x, rotate_dir.y) * 100.0)
	
	# need to decide how AI does inputs
	if false and not lock_movement:
		var input_axis #= Input.get_vector(input_left_action_name, input_right_action_name, input_back_action_name, input_forward_action_name)
		move(delta, input_axis, false, false, false, false, false)
	else:
		move(delta)


func receive_strike(hit_pos: Vector3, incoming_damage : int) -> void:
	col_handler.resolve_strike(position, hit_pos, current_stance_direction, true, incoming_damage)


# We might simulate a wheel for the opponent character? but it will need
# to be handled differently so it isn't tied to input. I'll do that later,
# once we have a more concrete idea of what inputs do what and what about
# the wheel needs to be simulated. If needed, wheel methods can just be copied
# from the player

func _on_collision_handler_strike_taken(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		opponent_slain.emit()
		lock_movement = true


func _on_collision_handler_strike_blocked() -> void:
	pass # Replace with function body.

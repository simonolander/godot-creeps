extends CharacterBody3D

signal squashed

@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_position, player_position):
	var speed = randi_range(min_speed, max_speed)
	look_at_from_position(start_position, player_position)
	rotate_y(randf_range(-PI/4, PI/4))
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()

extends CharacterBody3D

signal hit

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_forward"):
		direction.z += -1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider == null:
			continue
		if collider.is_in_group("mob") and Vector3.UP.dot(collision.get_normal()) > 0.1:
			collider.squash()
			target_velocity.y = bounce_impulse
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	elif target_velocity.y < 0:
		target_velocity.y = min(target_velocity.y + fall_acceleration * delta * 2, 0)
	
	velocity = target_velocity
	
	$Pivot.rotation.x = PI/6 * velocity.y / jump_impulse
	
	move_and_slide()


func _on_mob_detector_body_entered(_body):
	hit.emit()
	queue_free()

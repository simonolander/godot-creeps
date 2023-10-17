extends Node

@export var mob_scene: PackedScene
@export var mob_spawn_location: PathFollow3D

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position, $Player.position)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	add_child(mob)


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

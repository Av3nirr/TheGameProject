extends RigidBody2D

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var mob = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(mob)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

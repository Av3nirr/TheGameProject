extends RigidBody2D

func _ready():
	$AnimatedSprite2D.play("shield")




func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

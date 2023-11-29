extends Area2D
signal hit
signal boost

@export var SPEED = 400

var screenSize
var walk
var up
func _ready():
	walk = "walk"
	up = "up"
	screenSize = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1 
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED;
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screenSize)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = walk
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = up


func _on_body_entered(body):
	print(body.name)
	if body.name == "boosts":
		boost.emit()
		print("boost activé")
		walk = "walk_shield"
		up = "up_shield"
		$AnimatedSprite2D.play(walk)
		$BoostTimer.start()
		$CollisionShape2D.set_deferred("disabled", true)
		await $BoostTimer.timeout
		$CollisionShape2D.set_deferred("disabled", false)
		walk = "walk"
		up = "up"
		$AnimatedSprite2D.play(walk)
		print("boost desactivé")
	elif body.name == "ennemys":
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)


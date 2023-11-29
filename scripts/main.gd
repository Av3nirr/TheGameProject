extends Node

@export var mob_scene: PackedScene
@export var boost_scene: PackedScene
@export var levels = [[3.0, 2.7, 2.3, 2.0, 1.5, 1.0, 10], [2.5, 2.0, 1.5, 1.0, 0.7, 15], [2.0, 1.5, 1.0, 0.5, 0.3, 0.2, 20]]

var level
var score
var best_score
var timer_default

# Called when the node enters the scene tree for the first time.
func _ready():
	best_score = 0
	timer_default = levels[0][0]
	



func game_over():
	$BackgroundMusic.stop()
	$GameOverSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BoostTimer.stop()
	$HUD.show_game_over()
	if score > best_score:
		best_score = score
		$HUD.update_best_score(best_score);
	

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prépares toi !")
	
	$BackgroundMusic.play()
	
func _on_start_timer_timeout():
	$MobTimer.start()
	$BoostTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	level = $HUD.level_id
	$BoostTimer.wait_time = levels[level][6]
	if score == 10:
		timer_default = levels[level][1]
	elif score == 30:
		timer_default = levels[level][2]
	elif score == 50:
		timer_default = levels[level][3]
	elif score == 60:
		timer_default = levels[level][4]
	elif score > 80:
		timer_default = levels[level][5]
	print(levels[level][6])
	$MobTimer.wait_time = timer_default
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("MobsPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2;
	mob.position = mob_spawn_location.position;
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
	



	


	
	


func _on_boost_timer_timeout():
	var boost = boost_scene.instantiate()
	var boost_spawn_location = get_node("MobsPath/MobSpawnLocation")
	boost_spawn_location.progress_ratio = randf()
	var boost_direction = boost_spawn_location.rotation + PI / 2;
	boost.position = boost_spawn_location.position;
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	boost.linear_velocity = velocity.rotated(boost_direction)
	add_child(boost)


func _on_player_boost():
	$boosts.queue_free()

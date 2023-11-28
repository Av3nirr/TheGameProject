extends CanvasLayer

signal start_game

@export var level_id = 0


func _ready():
	$LevelMenu.get_popup().id_pressed.connect(level_menu)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over !")
	await $MessageTimer.timeout
	
	$MessageLabel.text = "Evite les ennemis !"
	$MessageLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$LevelMenu.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_best_score(best_score):
	$BestScoreLabel.text = "Meilleur: " + str(best_score)
	$BestScoreLabel.show()

	
	
func _on_message_timer_timeout():
	$MessageLabel.hide()

func level_menu(id):
	match id:
		0:
			level_id = 0
			$LevelLabel.text = "Niveau: Facile"
			$LevelLabel.show()
		1:
			level_id = 1
			$LevelLabel.text = "Niveau: Moyen"
			$LevelLabel.show()
		2:
			level_id = 2
			$LevelLabel.text = "Niveau: Difficile"
			$LevelLabel.show()

func _on_start_button_pressed():
	start_game.emit()
	$LevelMenu.hide()
	$StartButton.hide()

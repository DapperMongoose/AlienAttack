extends Node2D

var lives = 3
var score = 0

@onready var player = $Player
@onready var hud = $UI/HUD
@onready var ui = $UI

var game_over_screen = preload("res://scenes/game_over_screen.tscn")

func _ready():
	hud.set_score_label(score)
	hud.set_lives(lives)

func _on_deathzone_area_entered(area):
	area.queue_free()


func _on_player_took_damage():
	lives -= 1
	if lives == 0:
		player.die()
		await get_tree().create_timer(1.5).timeout
		var game_over_instance = game_over_screen.instantiate()
		game_over_instance.set_score(score)
		ui.add_child(game_over_instance)
	else:
		hud.set_lives(lives)


func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("enemy_died", _on_enemy_died)
	add_child(enemy_instance)
	
	
func _on_enemy_died():
	score += 100
	hud.set_score_label(score)

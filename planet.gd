extends Node2D

@export var mass = 0
@export var velocity = Vector2.ZERO
@export var fixed: bool = false
@onready var seta = $Line2D

var accumulated_acceleration = Vector2.ZERO

func _process(delta):
	$"Polygon2D/Line-Vel".points = [Vector2.ZERO, velocity]
	#Seta que está indicando a velocidade
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color.WHITE, true, 0, true)

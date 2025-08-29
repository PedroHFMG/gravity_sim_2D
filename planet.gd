extends Node2D

@export var mass = 0
@export var velocity = Vector2.ZERO
@export var fixed: bool = false
@onready var seta = $Line2D

var accumulated_acceleration = Vector2.ZERO

func _process(delta):
	#Seta que está indicando a velocidade
	$"Polygon2D/Line-Vel".points = [Vector2.ZERO, velocity]

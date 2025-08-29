extends Node2D

var planets = []
const G = 5000
@export var camera_centralizado : bool

#Variáveis p/ criação de planetas novos
var pos = Vector2.ZERO
var planet_scene = load("res://planet.tscn")
var new_planet = null

func _ready() -> void:
	planets = $Planetas.get_children()
	
func _process(delta: float) -> void:
	if new_planet:
		queue_redraw()
	
func _physics_process(delta: float) -> void:
	#Parte necessária para somar a aceleração de todos os planetas, e não somente do
	#último par, para ser mostrada na linha rosa
	for planet in planets:
		planet.accumulated_acceleration = Vector2.ZERO

	#Calcula a gravidade em PARES sem repetição!!!!
	#Planeta principal do loop:
	for i in range(planets.size()):
		 #Planetas que terão os cálculos feitos com base no planeta principal:
		for j in range(i + 1, planets.size()):
			#Aplicando a função gravidade com os planetas dos índices acima:
			gravidade(planets[i], planets[j])
	
	for planet in planets:
		planet.velocity += planet.accumulated_acceleration * delta
		planet.position += planet.velocity * delta
		planet.get_node("Line2D").points = [Vector2.ZERO, planet.accumulated_acceleration]
		
	#Indica a posição do centro de massa
	$Centro.position = center_of_mass()
	
	if camera_centralizado == true:
		$Camera2D.enabled = true
		$Camera2D.position = $Centro.position

func gravidade(p1, p2):
	#Distância entre os dois planetas (vetor)
	var vect_distance = p2.position - p1.position
	#Equação de Newton (length calcula a distância somente, a hipotenusa), possui limitador pra evitar velocidades absurdas
	var newton_eq = G * (p1.mass * p2.mass) / (vect_distance.length_squared() + 15)
	#Direção da força, sem a intensidade (somente a direção)
	var force_direction = (p2.position - p1.position).normalized()
	
	#Força = massa * aceleração
	#Logo: aceleração = força / massa
	#Calcula a aceleração em relação a cada planeta
	var acceleration1 = force_direction * newton_eq / p1.mass
	var acceleration2 = -force_direction * newton_eq / p2.mass
	
	p1.accumulated_acceleration += acceleration1
	p2.accumulated_acceleration += acceleration2

func center_of_mass():
	#Váriaveis que armazenam o somatório dos parâmetros dos planetas presentes
	var somatorio_massa = 0.0
	var coordenadas = Vector2.ZERO
	
	for planet in planets:
		#Posições de todos os planetas presentes
		coordenadas = coordenadas + (planet.mass * planet.position)
		#Somatório de todas as massas dos planetas presentes
		somatorio_massa = somatorio_massa + planet.mass
	
	#Equação do centro de massa (média das posições pela massa total)
	var coord_final = coordenadas/somatorio_massa
	
	#Retorna a posição
	return coord_final

func _input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				#queue_redraw()
				new_planet = planet_scene.instantiate()
				new_planet.position = get_global_mouse_position()
				new_planet.mass = 10
				
				var line = Line2D.new()
				line.name = "Line2D"
				line.width = 2
				line.default_color = Color('#ec00ad')
				new_planet.add_child(line)
				
				$Planetas.add_child(new_planet)
			else:
				if new_planet:
					var velocity_new_planet = (new_planet.position - get_global_mouse_position()) 
					new_planet.velocity = velocity_new_planet
					planets.append(new_planet)
					new_planet = null
					queue_redraw()

func _draw() -> void:
	if new_planet:
		draw_line(new_planet.position, new_planet.position + (new_planet.position - get_global_mouse_position()), Color.RED, 1, false)

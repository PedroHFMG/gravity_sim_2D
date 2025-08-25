extends Node2D

var planets = []
const G = 11000

func _ready() -> void:
	planets = $Planetas.get_children()
	
func _physics_process(delta: float) -> void:
	#Calcula a gravidade em PARES >>sem repetição<<:
	#Planeta principal do loop:
	for i in range(planets.size()):
		 #Planetas que terão os cálculos feitos com base no planeta principal:
		for j in range(i + 1, planets.size()):
			#Aplicando a função gravidade com os planetas dos índices acima:
			gravidade(planets[i], planets[j], delta)
	
	for planet in planets:
		if planet.get("fixed") == true:
			planet.velocity = Vector2.ZERO
		planet.position += planet.velocity * delta
		
	#Indica a posição do centro de massa
	$Centro.position = center_of_mass()

func gravidade(p1, p2, delta):
	#Distância entre os dois planetas (vetor)
	var vect_distance = p2.position - p1.position
	#Equação de Newton (length calcula a distância somente, a hipotenusa)
	var newton_eq = G * (p1.mass * p2.mass) / (vect_distance.length_squared() + 15)
	#Direção da força, sem a intensidade (somente a direção)
	var force_direction = (p2.position - p1.position).normalized()
	
	#Força = massa * aceleração
	#Logo: aceleração = força / massa
	#Calcula a aceleração em relação a cada planeta
	var acceleration1 = force_direction * newton_eq / p1.mass
	var acceleration2 = -force_direction * newton_eq / p2.mass
	
	#Movimentação dos planetas, com a aceleração
	p1.velocity += acceleration1 * delta
	p2.velocity += acceleration2 * delta
	
	#Linhas indicando aceleração e puxão gravitacional. Ajustar futuramente
	p1.get_node("Line2D").points = [Vector2.ZERO, acceleration1]
	p2.get_node("Line2D").points = [Vector2.ZERO, acceleration2]

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

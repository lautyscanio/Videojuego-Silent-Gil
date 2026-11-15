extends Area2D
#caja de bengalas. La primera vez (da_pistola) tambien te da la pistola
@export var cantidad = 3
@export var da_pistola = false
@export_multiline var texto_pistola = "Una pistola de bengalas. Con E disparas una bengala: pega mas fuerte que una piedra y ilumina la zona. Las bengalas son pocas, asi que cada tiro cuenta. Se ve cuantas te quedan con T."

var id_objeto = ""

func _ready() -> void:
	id_objeto = str(get_path())
	if Inventario.ya_recogido(id_objeto):
		queue_free()

#se agarra solo al pasar por encima
func _physics_process(delta: float) -> void:
	for cuerpo in get_overlapping_bodies():
		if cuerpo.is_in_group("jugador"):
			recoger()
			return

func recoger() -> void:
	Inventario.marcar_recogido(id_objeto)
	Inventario.bengalas += cantidad
	if da_pistola and not Inventario.pistola:
		Inventario.pistola = true
		Tutorial.mostrar_texto("PISTOLA DE BENGALAS", texto_pistola)
	else:
		Inventario.mostrar_mensaje("Bengalas: +" + str(cantidad))
	queue_free()

class_name EffectPrint
extends Effect

@export var text: String = ""

func effect(p_target: Entity = null) -> void:
	print(text)

class_name EffectModifyStat
extends Effect

@export var stat: String = ""

@export var amount: int = 0

func effect(p_target: Entity = null) -> void:
	if p_target != null:
		p_target.data.stats.modify_stat(stat, amount)

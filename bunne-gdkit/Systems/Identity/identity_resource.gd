class_name IdentityResource
extends Resource

## The identity of the resource.
@export var identity: Identity = null

func _init(p_identity: Identity = identity) -> void:
	identity = p_identity

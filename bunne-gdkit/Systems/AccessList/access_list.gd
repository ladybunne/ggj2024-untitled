class_name AccessList
extends Resource

@export var allow_list: Array[String]

@export var deny_list: Array[String]

## Validates an element to ensure it's allowed and not denied.
func validate(p_element: String) -> bool:
	var allowed = allow_list.is_empty() or allow_list.has(p_element)
	var denied = deny_list.has(p_element)
	return allowed and not denied

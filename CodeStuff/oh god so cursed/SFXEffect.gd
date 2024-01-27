class_name SFXEffect extends RichTextEffect

var bbcode = "sfx"

var sfx_name_cache: String = ""

func _process_custom_fx(char_fx):
	if char_fx.elapsed_time == 0.0 and char_fx.relative_index == 0:
		sfx_name_cache = ""
	
	var sfx_name = char_fx.env.get("name", "")
	if sfx_name != sfx_name_cache:
		AudioManager.play_sfx(sfx_name)
		sfx_name_cache = sfx_name
		#print(sfx_name)
	return true

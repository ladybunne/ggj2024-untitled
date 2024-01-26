class_name EncyclopediaPage

# And much like an encyclopedia has pages, a page has entries.
#
# Entries are just "this is a thing", presumably a stored custom resource,
# along with some metadata like "has the player seen this?".

var entries: Array[EncyclopediaEntry]

var path: String

func _init(p_path: String = path):
	path = p_path
	# Use DirAccess to get all the resources and put them as entries??
#	DirAccess

func debug_print():
	print(entries.reduce(func(acc: String, entry: EncyclopediaEntry): return entry.resource.identity.name + "\n", ""))

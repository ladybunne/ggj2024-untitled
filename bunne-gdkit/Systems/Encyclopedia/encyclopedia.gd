class_name Encyclopedia
extends Node

# The way I see this working... it has a number of "pages" which all correspond
# to specific types of "things". That's obviously defined by the game itself,
# but stuff like weapons, armour, enemies, spells, etc.
#
# My mental model for this is like... Slay the Spire's card/relic list, or
# One Step From Eden's card/artifact list.
#
# So a page needs to have type constraining, or just get generated from a folder
# of resources that comply with the Identity thing, I guess? I would like the
# construction of encyclopedias to be completely automatic from a systems
# perspective, which should help in the case of updates and the like.
#
# Pages actually need to have a custom thing for how they want to render their
# details, probably.
# 
# Thinking about how this thing is going to get its data, it probably needs to
# be stored on the save file, and then given to the encyclopedia on startup.

var pages: Array[EncyclopediaPage]

func _ready():
	var page = EncyclopediaPage.new()
	pages = [page]
	

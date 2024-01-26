class_name Identity
extends Resource

## The name of the resource.
@export var name: String = "Unnamed"

## The icon of the resource.
@export var icon: Texture = null

## The category of the resource. Can be used by slots to constrain what can go in them.
@export var category: String = "Uncategorised"

## The tags of the resource. 
@export var tags: Array[String] = []

@export_group("Descriptions")

## The description of the resource. This should pretty much always be present.
## Usually this would be something to describe mechanical significance, or just
## "this is what this thing does".
@export_multiline var description: String = ""

## A shorter description for cases where the regular-length description would be
## unsuitable.
@export_multiline var short_description: String = ""

## A longer description for when you really want to go ham.
@export_multiline var long_description: String = ""

## Flavour text, for little quips on a thing.
@export_multiline var flavour_text: String = ""

## Lore text, for things like in-game encyclopedias.
@export_multiline var lore_text: String = ""

@export_group("Meta")

## I also want a "meta" field that's for developer notes.
@export_multiline var dev_notes: String = "" 

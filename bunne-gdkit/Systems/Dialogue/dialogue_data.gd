## A data class for the Dialogue system. Contains a number of String lines.
class_name DialogueData
extends Resource

@export var left_speaker: DialogueSpeaker = null
@export var right_speaker: DialogueSpeaker = null

@export var lines: Array[String] = []

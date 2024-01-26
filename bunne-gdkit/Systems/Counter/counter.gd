class_name Counter
extends Node

const COUNTING_INTERVAL = 1000 # 1 second represented as 1000 milliseconds

var counting: bool = false
var currentNumber: int = 0
var targetNumber: int = 10
var countingStartTimestamp: int = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	countTo(10)

func countTo(number: int) -> void:
	counting = true
	currentNumber = 0
	targetNumber = max(1, number)
	countingStartTimestamp = Time.get_ticks_msec()
	print("Counting to {target}...".format({"target": targetNumber}))

func countingProgress() -> int: 
	return floori((Time.get_ticks_msec() - countingStartTimestamp) / 1000.0)

func announce() -> void:
	print(currentNumber)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if not counting:
		return
	if currentNumber >= targetNumber:
		print("Finished counting!")
		counting = false
		return
	if countingProgress() > currentNumber:
		currentNumber = countingProgress()
		announce()

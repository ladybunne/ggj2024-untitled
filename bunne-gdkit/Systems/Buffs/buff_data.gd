class_name BuffData
extends IdentityResource

## The type of buff.
## e.g. BUFF, DEBUFF, MECHANIC, etc.
## Do I want this to be externally customisable?
## If no, easy enough to define some types here and adhere to them.
## If yes, logic to handle different buff types needs to be extensible.
## Though, all a buff type really determines is presentation and grouping.
@export var buff_type: String = ""

## What the effect of the buff is.
@export var effect: String = ""

## The duration of the buff, if it's timed.
@export var duration: String = ""

## Whether the buff should be visible on buff bars.
## I hate that I'm writing this. INFORMATION SHOULD BE FREE!
@export var visible: bool = true

class_name Death
extends Node2D

@export var message_bubble_node : Node2D
@export var quote_node : Label
@export var arrow_node : Sprite2D

@export var message_bubble_on : bool = false:
	set(value):
		message_bubble_on = value
		message_bubble_node.modulate.a = float(message_bubble_on)
		arrow_node.active = false
		if !get_tree():
			return
		var tween = get_tree().create_tween()
		if message_bubble_on:
			tween.tween_property(message_bubble_node, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
			tween.tween_property(arrow_node, "active", true, 0.0)
		else:
			tween.tween_property(message_bubble_node, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)		
			death_moves(Vector2(0, -2000))
			
@export var quote : String = "You must be my new temporary employee.":
	set(value):
		if quote == value:
			return
		quote = value
		if quote_node:
			quote_node.text = quote
enum QUOTE_SETS {first_meeting, getting_crows, generic_death, pit_death, toxic_gas_death, spikes_death, skull_death, giant_ghost_death, spider_death, zero_stars, one_star, two_stars, three_stars, four_stars, five_stars}
@export_enum("first_meeting", "getting_crows", "generic_death", "pit_death", "toxic_gas_death", "spikes_death", "skull_death", "giant_ghost_death", "spider_death", "zero_stars", "one_star", "two_stars", "three_stars", "four_stars", "five_stars") var quote_set:
	set(value):
		if quote_set == value:
			return
		quote_set = value
		update_current_quote_array()
		quote = current_quote_array[quote_index]
@export var quote_index : int = 0:
	set(value):
		if quote_index == value:
			return
		quote_index = max(value, 0)
		if current_quote_array:
			quote_index = min(quote_index, current_quote_array.size() - 1)
			quote = current_quote_array[quote_index]

var current_quote_array : Array[String]


func death_moves(destination : Vector2, time : float = 5.0):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", destination, time)



#DIALOGUE

var first_meeting : Array[String] = [
	"You must be my new temporary employee.",
	"Many ghosts have recently gone astray.",
	"I need you to collect them for me.",
	"These markers will help you find them.",
	"But be quick about it! Time is money!"
]

var getting_crows : Array[String] = [
	"Having trouble getting up there, mortal?",
	"Here. These magic crows will help you.",
	"You can now jump in the middle of the air...",
	"...as long as the crows are there to help!",
	"Don't say I never did anything for you."
]

var generic_death : Array[String] = [
	"I am not angry. I am disappointed.",
	"You died? Good thing I'm an expert on the subject.",
	"I can't take you anywhere!",
	"I thought the agency said you were qualified...",
	"'Don't hire mortals,' they said. I should have listened to them!",
	"I didn't say catch your OWN ghost!",
	"I guess I'll have to spare your life... for now...",
	"This is the last time I hire a temp to do a reaper's job."

]

var pit_death : Array[String] = [
	"(no pit death quotes yet)"
]

var toxic_gas_death : Array[String] = [
	"(no toxic gas death quotes yet)"
]

var spikes_death : Array[String] = [
	"(no spikes death quotes yet)"
]

var skull_death : Array[String] = [
	"(no skull death quotes yet)"
]

var giant_ghost_death : Array[String] = [
	"Giant ghosts?!? You're imagining things. Giant ghosts don't exist.",
	"I've never even heard of giant ghosts before. It's certainly not any of MY doing.",
	"That's silly. There's no such thing as giant ghosts. Believe me, I should know!",
	"Let me guess... you're going to blame these imaginary 'giant ghosts' again.",
	"Don't tell anybody about the giant ghosts. They wouldn't believe you anyway.",
	"Temps always complain. 'Long hours! Low pay! Giant ghosts keep eating me!'",
	"Giant ghosts? Where?!? I don't see any.",
	"Giant... blah blah blah... Ghosts... blah blah blah...",
	"I'll bring you back to life if you promise not to tell your union about any 'giant ghosts'.",
	"I suppose maybe someone COULD make giant ghosts with the right... experiments...",
	"I hope you don't keep asking about giant ghosts... like the last temp did.",
	"Your make-believe stories about this giant ghost army are starting to get annoying.",
	"You just catch the regular ghosts. Don't worry your little mortal head about the giant ones.",
	"Who said anything about an army of giant ghosts? Not me!",
	"I'm Death. Why would I even NEED an army of giant ghosts? That's preposterous.",
	"I wouldn't even know how to CONTROL an army of giant ghosts. I mean... theoretically.",
	"Suppose someone DID lose control of a giant ghost army... what then? Asking for a friend."
]

var spider_death : Array[String] = [
	"(no spider death quotes yet)"
]

var zero_stars : Array[String] = [
	"(no zero stars quotes yet)"
]

var one_star : Array[String] = [
	"Have you ever seen me when I'm hungry? Work faster.",
	"Faster next time! I may be immortal, but I don't have all day.",
	"You get 1 star. But only because zero stars isn't an option.",
	"I asked the temp agency for a REAPER, not a sleeper.",
	"Oh that was you? I thought I was watching paint dry."
]

var two_stars : Array[String] = [
	"I've seen worse. Although... I've also seen better...",
	"I suppose that will do... for a temp, that is.",
	"If I told you you're doing a good job, could you do it faster?",
	"The key to catching ghosts quickly is to catch them faster."	
]

var three_stars : Array[String] = [
	"When I was your age, I gathered souls uphill both ways!",
	"You know how much it costs for a decent robe these days?",
	"My whole family is immortal. Have you met my cousin Taxes?"
]

var four_stars : Array[String] = [
	"I'd give you 5 stars, but infinity divided by 5 would still be zero.",
	"If you keep that up, you might get promoted to full time in 1000 years or so."
]

var five_stars : Array[String] = [
	"It is about time! It is always about time.",
	"Best job I've seen since we hired those Ghostblaster guys back in the 80s!",
	"I never thought a mortal could earn 5 Stars. But look at that..."
]

func update_current_quote_array():
	if quote_set == QUOTE_SETS.first_meeting:
		current_quote_array = first_meeting 
	elif quote_set == QUOTE_SETS.getting_crows:
		current_quote_array = getting_crows 
	elif quote_set == QUOTE_SETS.generic_death:
		current_quote_array = generic_death
	elif quote_set == QUOTE_SETS.pit_death:
		current_quote_array = pit_death 
	elif quote_set == QUOTE_SETS.toxic_gas_death:
		current_quote_array = toxic_gas_death 
	elif quote_set == QUOTE_SETS.spikes_death:
		current_quote_array = spikes_death 
	elif quote_set == QUOTE_SETS.skull_death:
		current_quote_array = skull_death 
	elif quote_set == QUOTE_SETS.spider_death:
		current_quote_array = spider_death 
	elif quote_set == QUOTE_SETS.zero_stars:
		current_quote_array = zero_stars 
	elif quote_set == QUOTE_SETS.one_star:
		current_quote_array = one_star
	elif quote_set == QUOTE_SETS.two_stars:
		current_quote_array = two_stars
	elif quote_set == QUOTE_SETS.three_stars:
		current_quote_array = three_stars
	elif quote_set == QUOTE_SETS.four_stars:
		current_quote_array = four_stars
	elif quote_set == QUOTE_SETS.five_stars:
		current_quote_array = five_stars
												

extends Node
class_name textboxHandler 

enum State {
	IDLE,
	TYPING,
	FINISHED
}

@onready var textbox_container = get_node("TextboxUI/TextboxContainer") as MarginContainer
@onready var textbox_ui = get_node("TextboxUI") as Control
@onready var end_symbol = get_node("TextboxUI/TextboxContainer/Panel/HBoxContainer/endSymbol") as Label
@onready var text = get_node("TextboxUI/TextboxContainer/Panel/HBoxContainer/RichTextLabel") as RichTextLabel
@onready var timer: Timer = get_node("TextboxUI/Timer") as Timer
@onready var audio_stream_player = get_node("TextboxUI/AudioStreamPlayer") as AudioStreamPlayer

var TEXT_SPEED: float = 0.03
var text_queue: Array[String] = []
var total_chars: int
var duration: float
var is_active: bool = false
var current_state: State = State.IDLE
var tween: Tween


func _ready():
	text_queue.clear()
	if Global.text.size() == 0:
		textbox_ui.hide()
		return
	
	if typeof(Global.text[0]) == TYPE_STRING: # for strings
		text_queue = Global.text.duplicate()
	else: # for arrays
		for entry in Global.text:
			if typeof(entry) == TYPE_ARRAY and entry.size() > 0 and typeof(entry[0]) == TYPE_STRING:
				var path = entry[0]

				var loaded_text = Global.load_dialogue(path)

				for line in loaded_text:
					if typeof(line) == TYPE_STRING:
						text_queue.append(line)

				#text_queue.append(entry[0])
	timer.timeout.connect(_on_timer_timeout)

	# text effects
	text.bbcode_enabled = true
	text.visible_characters_behavior = TextServer.VisibleCharactersBehavior.VC_CHARS_AFTER_SHAPING

	is_active = false
	text.text = ""
	text.visible_characters = 0
	end_symbol.text = ""
	textbox_ui.hide()

func _process(_delta):
	match current_state:
		State.IDLE:
			if text_queue != null and text_queue.size() > 0:
				display_text(text_queue[0])
				text_queue = text_queue.slice(1)
				end_symbol.text = ""
		State.TYPING:
			if Input.is_action_just_pressed("ui_accept"):
				text.visible_characters = text.get_total_character_count()
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if text_queue.size() == 0:
					hide_textbox()
				current_state = State.IDLE

func show_textbox() -> void:
	is_active = true
	if textbox_ui != null:
		textbox_ui.show()

func hide_textbox() -> void:
	is_active = false
	text.text = ""
	text.visible_characters = 0
	end_symbol.text = ""
	textbox_ui.hide()
	
	Global.persist_player.unpause()
	uiManager.remove_ui(self)

func display_text(next_text: String) -> void:
	show_textbox()

	current_state = State.TYPING
	text.text = next_text
	total_chars = text.get_total_character_count()
	text.visible_characters = 0

	start_timer()

func start_timer() -> void:
	# manipulates wait time
	timer.wait_time = TEXT_SPEED
	timer.start()

func _on_timer_timeout() -> void:
	text.visible_characters += 1
	if text.visible_characters <= total_chars:
		textbox_sfx()
		start_timer()
	else:
		end_symbol.text = "*"
		end_symbol.show()
		current_state = State.FINISHED

func textbox_sfx() -> void:
	if "abcdefghijklmnopqrstuvwxyz123456789".contains(text.get_parsed_text()[text.visible_characters - 1]):
		audio_stream_player.pitch_scale = randf_range(0.98, 1.02)
		audio_stream_player.play()
	elif ".,!?-".contains(text.get_parsed_text()[text.visible_characters - 1]):
		pass

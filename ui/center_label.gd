extends Label
class_name CenterLabel


var tween_size: Tween
var tween_modulate: Tween


func tween_text(text: String):
	tween_size = create_tween()
	tween_modulate = create_tween()
	#tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	self.text = text
	label_settings.font_size = 600
	modulate.a = 0
	
	tween_size.tween_property(label_settings, "font_size", 150, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_modulate.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

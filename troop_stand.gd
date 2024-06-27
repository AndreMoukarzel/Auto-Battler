extends Node3D


func launch():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 0.0, .2)
	tween.tween_property(self, "position:y", -0.2, .3)
	tween.tween_property(self, "position:y", 6, .3).set_trans(Tween.TRANS_BACK)
	await tween.finished
	hide()

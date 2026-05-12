extends Node2D

func play(sprite : String):
	for s in get_children():
		s.play(sprite)

extends Node

var arrow: Arrow
var particles: CPUParticles2D

func _ready():
	arrow = get_parent()
	if arrow.whichAttackType == "light": return
	
	particles = arrow.get_child(2)
	particles.emitting = true
	arrow.arrow_rotation.connect(receivedAngle)
	
	

func receivedAngle(angle):
	rotateParticles(-angle)


func rotateParticles(angle: float) -> void:
	particles.angle_max = angle
	particles.angle_min = angle

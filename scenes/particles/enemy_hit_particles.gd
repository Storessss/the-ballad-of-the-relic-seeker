extends CPUParticles2D

var follow

func _ready():
	emitting = true
func _process(_delta):
	if is_instance_valid(follow):
		global_position = follow.global_position

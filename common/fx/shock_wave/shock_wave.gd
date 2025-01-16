extends Node2D

@export var _shock_particle: GPUParticles2D

func _ready() -> void:
	_shock_particle.restart()

func _on_gpu_particles_2d_finished() -> void:
	queue_free()

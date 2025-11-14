extends TextureRect

var hit_thrust: Vector2 = Vector2(1000, 0)
var hit_torque: int = 25000

func _input(input: InputEvent) -> void:
	if input.is_action_pressed("leftclick"):
		var space_state = get_world_2d().direct_space_state
		var g_mouse_position = get_global_mouse_position()
		var raycast_query = PhysicsRayQueryParameters2D.create(global_position, g_mouse_position)
		var raycast_result = space_state.intersect_ray(raycast_query)
		
		if raycast_result:
			$Laser.global_position = raycast_result.position
			if raycast_result.collider.get_class() == "RigidBody2D":
				var hit_direction: float = raycast_result.position.angle_to_point(raycast_result.collider.position)
				raycast_result.collider.apply_force(hit_thrust.rotated(hit_direction))
				var laser_direction = global_position.angle_to_point(g_mouse_position)
				var rotation_direction: float = (hit_direction - laser_direction)/TAU
				raycast_result.collider.apply_torque(hit_torque * rotation_direction)
		else:
			$Laser.global_position = g_mouse_position
			
		var middle_position: Vector2 = global_position+(size/2)
		$Laser.rotation = $Laser.global_position.angle_to_point(middle_position) - (PI/2)
		$Laser.size.y = $Laser.global_position.distance_to(middle_position)
		
		$Laser.visible = true
		$Laser/Timer.start()

func _on_timer_timeout() -> void:
	$Laser.visible = false

Camera = {}
Camera.__index = Camera

function Camera.reset()	
	Camera.x = 0
	Camera.y = 0
	Camera.x_speed = 0
	Camera.y_speed = 0
end

function Camera.update(dt)
	local map = GameController.world.current_map
	local player_pos = GameController.player.position
	local player_center_x = GameController.player.position.x + GameController.player.sprite_border + (GameController.player.width/2)
	local player_center_y = GameController.player.position.y + (GameController.player.height/2)
	local max_x = math.max(0, (Constants.MapUnitToPixelRatio*#map[1]) - 1280)
	local max_y = math.max(0, (Constants.MapUnitToPixelRatio*#map) - 720)
	
	local dx = max_x*player_center_x/(Constants.MapUnitToPixelRatio*#map[1])
	local dy = max_y*player_center_y/(Constants.MapUnitToPixelRatio*#map)
	
	Camera.x = -dx
	Camera.y = -dy
end

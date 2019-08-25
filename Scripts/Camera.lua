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
	local max_x = 20*Constants.MapUnitToPixelRatio*#map[1] - 1280
	local max_y = 20*Constants.MapUnitToPixelRatio*#map - 720
end

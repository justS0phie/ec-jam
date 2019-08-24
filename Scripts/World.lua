World = {}
World.__index = World

function World.new()	
	local world = {
		images = {
		},
		timer = 0,
	}
	
	setmetatable(world, World)
	
	return world
end

function World:load_map(map_id)
	self.current_map = Map.load(map_id)
	self.current_map:begin_loading()
	self.timer = 0
end

function World:update(dt)
	if GameController.player.rewind then
		self:update_time_platforms(-dt/5)
	elseif GameController.player.forward then
		self:update_time_platforms(dt/5)
	end
	
	GameController.player:update_position(dt)
end

function World:keypress()
	if MyLib.key_list.escape then
		MyLib.FadeToColor(0.3,{"LuaCall>GameController.go_to_main_menu()"},{},"fill",{0,0,0,1},true)
	else
		if GameController.state == Constants.EnumGameState.IN_GAME then
			if MyLib.key_list.up then GameController.player.jump_timer = 1/12 end
		else
			GameController.state = Constants.EnumGameState.IN_GAME
		end
	end
end

function World:draw()
	love.graphics.translate(self.current_map.origin.x, self.current_map.origin.y)
	
	self.current_map:draw()
	
	love.graphics.translate(-self.current_map.origin.x, -self.current_map.origin.y)
end

function World:update_time_platforms(dt)
	self.timer = math.max(self.timer + dt, 0)
	self.timer = math.min(self.timer, 1)
	local time_platform_timer
	
	for index, time_platform in ipairs(self.current_map.time_platforms) do
		time_platform_timer = (self.timer - time_platform.initialTime) / (time_platform.finalTime - time_platform.initialTime)
		
		if time_platform.finalTime < self.timer then time_platform_timer = 1 end
		if time_platform.initialTime > self.timer then time_platform_timer = 0 end
		
		if time_platform.type == "mv_platform" then
			local dx = time_platform.position.x
			local dy = time_platform.position.y

			time_platform.position.x = time_platform.initialPosition.x * 20 + (time_platform.finalPosition.x - time_platform.initialPosition.x ) * 20 * Utils.smooth( (time_platform_timer * time_platform.numberOfCycles) % 2)
    		time_platform.position.y = time_platform.initialPosition.y * 20 + (time_platform.finalPosition.y - time_platform.initialPosition.y ) * 20 * Utils.smooth( (time_platform_timer * time_platform.numberOfCycles) % 2)
			
			dx = time_platform.position.x - dx
			dy = time_platform.position.y - dy
			
			local feet_pos = GameController.player.position.y + GameController.player.height
			if feet_pos > time_platform.position.y and feet_pos < time_platform.position.y - dy then
				local px = GameController.player.position.x
				if px > time_platform.position.x - 35 and px < time_platform.position.x + time_platform.width*20 - 5 then
					self.on_floor = true
					self.on_platform = index
					GameController.player.position.y = time_platform.position.y - GameController.player.height
				end
			end
			
			if index == GameController.player.on_platform then
				GameController.player:update_position_on_platform({x = dx, y = dy}, dt)
			end
		end
	end
end

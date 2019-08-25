World = {}
World.__index = World

function World.new()	
	local world = {
		images = {
		},
		timer = 0
	}
	
	setmetatable(world, World)
	
	return world
end

function World:load_map(map_id)
	self.current_map = Map.load(map_id)
	self.current_map.image = love.graphics.newCanvas()
	self.current_map:begin_loading()
	GameController.player:reset_position()
	self.timer = 0
end

function World:update(dt)
	if GameController.player.rewind then
		self:update_objects(-dt/5)
	elseif GameController.player.forward then
		self:update_objects(dt/5)
	end
	
	self:update_jam_collision()
	
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

function World:update_jam_collision()
	for _, object in ipairs(self.current_map.objects) do
		if object.type == "jam" then
			local py = GameController.player.position.y + GameController.player.sprite_border
			local px = GameController.player.position.x + GameController.player.sprite_border
			local ox = object.position.x*Constants.MapUnitToPixelRatio
			local oy = object.position.y*Constants.MapUnitToPixelRatio + object.dy

			if px + GameController.player.width > ox and px < ox + 2*Constants.MapUnitToPixelRatio then
				if py < oy + 2*Constants.MapUnitToPixelRatio and GameController.player.position.y + GameController.player.height > oy then
					GameController.next_level()
				end
			end
		end
	end
end

function World:update_objects(dt)
	self.timer = math.max(self.timer + dt, 0)
	self.timer = math.min(self.timer, 1)
	local object_timer
	
	for index, object in ipairs(self.current_map.objects) do
		
		if object.type ~= "jam" then
			object_timer = (self.timer - object.initialTime) / (object.finalTime - object.initialTime)
		
			if object.finalTime < self.timer then object_timer = 1 end
			if object.initialTime > self.timer then object_timer = 0 end
		else
			object.dy = math.sin(math.pi*((self.timer*10)%10))*10
		end

		if object.type == "disappearing_platform" then
			local cycle_time = (object.finalTime - object.initialTime) / object.numberOfCycles
			local visible_cycle_time = object.visibleTimePercentage * cycle_time
			object_timer = self.timer % cycle_time

			if self.timer < object.initialTime or self.timer > object.finalTime or object_timer > visible_cycle_time then
				object.visible = false
			else
				object.visible = true
			end
		end
		
		if object.type == "mv_platform" then
			local dx = object.position.x
			local dy = object.position.y

			object.position.x = ( object.initialPosition.x + (object.finalPosition.x - object.initialPosition.x ) * Utils.smooth( (object_timer * object.numberOfCycles) % 2) ) * Constants.MapUnitToPixelRatio
    		object.position.y = (object.initialPosition.y + (object.finalPosition.y - object.initialPosition.y ) * Utils.smooth( (object_timer * object.numberOfCycles) % 2) ) * Constants.MapUnitToPixelRatio
			
			dx = object.position.x - dx
			dy = object.position.y - dy
			
			local feet_pos = GameController.player.position.y + GameController.player.height
			if feet_pos > object.position.y and feet_pos < object.position.y - dy then
				if (GameController.player.position.x + GameController.player.width + GameController.player.sprite_border > object.position.x
					and GameController.player.position.x + GameController.player.sprite_border < object.position.x + object.width*Constants.MapUnitToPixelRatio) then
					self.on_floor = true
					self.on_platform = index
					GameController.player.position.y = object.position.y - GameController.player.height
				end
			end
			
			if index == GameController.player.on_platform then
				GameController.player:update_position_on_platform({x = dx, y = dy}, dt)
			end
		end
	end
end

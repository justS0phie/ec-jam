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
	GameController.player:update_position(dt)
	
	if GameController.player.rewind then
		self:update_objs(-dt/5)
	elseif GameController.player.forward then
		self:update_objs(dt/5)
	end
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

function World:update_objs(dt)
	self.timer = math.max(self.timer + dt, 0)
	self.timer = math.min(self.timer, 1)
	local obj_timer
	
	for index, obj in ipairs(self.current_map.objects) do
		obj_timer = (self.timer- obj.To) / (obj.Ti - obj.To)
		
		if obj.Ti < self.timer then obj_timer = 1 end
		if obj.To > self.timer then obj_timer = 0 end
		
		if obj.type == "mv_platform" then
			local dx = obj.x
			local dy = obj.y
			obj.x = obj.Xo*20 + (obj.Xi - obj.Xo)*20*Utils.smooth((obj_timer*obj.F)%2)
			obj.y = obj.Yo*20 + (obj.Yi - obj.Yo)*20*Utils.smooth((obj_timer*obj.F)%2)
			
			dx = obj.x - dx
			dy = obj.y - dy
			
			if index == GameController.player.on_platform then
				GameController.player.next_coord.x = GameController.player.position.x + dx
				GameController.player.next_coord.y = GameController.player.position.y + dy
				GameController.player:check_collision(dt)
				GameController.player.position.x = GameController.player.next_coord.x
				GameController.player.position.y = GameController.player.next_coord.y
			end
		end
	end
end

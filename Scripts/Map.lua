Map = {}
Map.__index = Map

function Map.load(map_id)	
	local map = love.filesystem.load("Levels/Level_"..map_id.."/data.lua")()
	map.id = map_id
	
	local x = math.max(0, 64-#map[1])
	local y = math.max(0, 34-#map)
	
	map.origin = {x=10*x,y=10*y}
	
	setmetatable(map, Map)
	
	map:load_objects()
	
	return map
end

function Map:begin_loading()
	table.insert(QueueManager.queues, {id = Constants.EnumQueues.MAP, map_id = self.id})
end

function Map:load_objects()
	self.objects = {}
	for _, obj_data in ipairs(self.obj) do
		new_obj = {type = obj_data[1]}
		
		if new_obj.type == "mv_platform" then
			new_obj.Xo = obj_data[2]
			new_obj.Yo = obj_data[3]
			new_obj.Xi = obj_data[4]
			new_obj.Yi = obj_data[5]
			new_obj.To = obj_data[6]
			new_obj.Ti = obj_data[7]
			new_obj.F = obj_data[8]
			new_obj.width = obj_data[9]
			
			new_obj.x = obj_data[2]*20
			new_obj.y = obj_data[3]*20
		end
		table.insert(self.objects, new_obj)
	end
end

function Map:draw()
	View.draw(self.image,0,0)
	
	for _, obj in ipairs(self.objects) do		
		if obj.type == "mv_platform" then
			love.graphics.setColor(0,0,1)
			love.graphics.rectangle("fill", obj.x, obj.y, obj.width*20, 20)
			love.graphics.setColor(1,1,1)
		end
	end
	
	GameController.player:draw()
end
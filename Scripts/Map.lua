Map = {}
Map.__index = Map

function Map.load(map_id)	
	local map = love.filesystem.load("Levels/Level_"..map_id.."/data.lua")()
	map.id = map_id
	
	local x = math.max(0, 64-#map[1])
	local y = math.max(0, 34-#map)
	
	map.origin = {x=10*x,y=10*y}
	
	setmetatable(map, Map)
	
	map:load_time_platforms()
	
	return map
end

function Map:begin_loading()
	table.insert(QueueManager.queues, {id = Constants.EnumQueues.MAP, map_id = self.id})
end

function Map:load_time_platforms()
	for _, time_platform in ipairs(self.time_platforms) do
		if time_platform.type == "mv_platform" then
			new_time_platform  = time_platform
			
			new_time_platform.position = {
				x = new_time_platform.initialPosition.x * Constants.MapUnitToPixelRatio,
				y = new_time_platform.initialPosition.y * Constants.MapUnitToPixelRatio
			}
		end
	end
end

function Map:draw()
	View.draw(self.image,0,0)
	
	for _, time_platform in ipairs(self.time_platforms) do		
		if time_platform.type == "mv_platform" then
			love.graphics.setColor(0,0,1)
			love.graphics.rectangle("fill", time_platform.position.x, time_platform.position.y, time_platform.width * Constants.MapUnitToPixelRatio, 20)
			love.graphics.setColor(1,1,1)
		end
	end
	
	GameController.player:draw()
end
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
	
	GameController.level_no = map_id
	
	return map
end

function Map:begin_loading()
	table.insert(QueueManager.queues, {id = Constants.EnumQueues.MAP, map_id = self.id})
end

function Map:load_objects()
	for _, object in ipairs(self.objects) do
		if object.type == "mv_platform" or object.type == "disappearing_platform" then
			object.position = {
				x = object.initialPosition.x * Constants.MapUnitToPixelRatio,
				y = object.initialPosition.y * Constants.MapUnitToPixelRatio
			}
		elseif object.type == "jam" then
			object.dy = 0
		end
	end
end

function Map:draw()

	love.graphics.setShader(Shaders.grayscale)
	Shaders.grayscale:send("factor", 1-GameController.world.color_factor)
	
	View.draw(self.image,0,0)
	
	for _, object in ipairs(self.objects) do		
		if object.type == "mv_platform" or ( object.type == "disappearing_platform" and object.visible ) then
			love.graphics.setColor(0,0,1)
			love.graphics.rectangle("fill", object.position.x, object.position.y, object.width * Constants.MapUnitToPixelRatio, Constants.MapUnitToPixelRatio)
			love.graphics.setColor(1,1,1)
		elseif object.type == "jam" then
			local rotation = math.sin(math.pi*(((0.7+GameController.world.timer)*50)))
			love.graphics.setColor(1,0,0)
			love.graphics.draw(World.jam, Constants.MapUnitToPixelRatio*object.position.x, Constants.MapUnitToPixelRatio*object.position.y + object.dy, rotation/7,1,1,20,20)
			love.graphics.setColor(1,1,1)
		end
	end
	
	love.graphics.setShader()
	
	GameController.player:draw()
end

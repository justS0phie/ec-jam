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
	
	pcall(function() map.obj_tile = love.graphics.newImage("Levels/Level_"..GameController.level_no.."/Obj.png") end)
	if not map.obj_tile then map.obj_tile = love.graphics.newImage("Levels/Level_"..GameController.level_no.."/Floor.png") end
	
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
			for i=1, object.width do
				love.graphics.draw(self.obj_tile, object.position.x + (i-1)*Constants.MapUnitToPixelRatio, object.position.y)
			end
		elseif object.type == "jam" then
			local rotation = math.sin(math.pi*(((0.7+GameController.world.timer)*50)))
			love.graphics.draw(World.jam, Constants.MapUnitToPixelRatio*object.position.x, Constants.MapUnitToPixelRatio*object.position.y + object.dy, rotation/7,1,1,20,20)
		end
	end
	
	love.graphics.setShader()
	
	love.graphics.setColor(1,1,1)
	GameController.player:draw()
end

function Map.draw_bg(canvas, w, h, sprite)
	love.graphics.setCanvas(canvas)
	local x_offset = 0
	local y_offset = 0
	
	while y_offset < h do
		while x_offset < w do
			View.draw(sprite, x_offset, y_offset)
			x_offset = x_offset + 512
		end
		y_offset = y_offset + 512
		x_offset = 0
	end
	love.graphics.setCanvas()
end

function Map:wall_matrix()
	for i=1,#self do
		for j=1,#self[i] do
			if self[i][j] == 1 then
				View.rectangle("fill", Constants.MapUnitToPixelRatio*(j-1), Constants.MapUnitToPixelRatio*(i-1), Constants.MapUnitToPixelRatio, Constants.MapUnitToPixelRatio)
			end
		end
	end
end

function Map:generate_map()
	local w,h = #self[1]*Constants.MapUnitToPixelRatio,#self*Constants.MapUnitToPixelRatio
	local bg = love.graphics.newCanvas(w,h)
	local fg_canvas = love.graphics.newCanvas(w,h)
	local fg = love.graphics.newCanvas(w,h)
	
	local bg_img = love.graphics.newImage("Levels/Level_"..GameController.level_no.."/BG.png")
	local fg_img = love.graphics.newImage("Levels/Level_"..GameController.level_no.."/FG.png")
	local tile_img = love.graphics.newImage("Levels/Level_"..GameController.level_no.."/Floor.png")
		
	Map.draw_bg(bg, w, h, bg_img)
	
	love.graphics.setCanvas(fg_canvas)
	self:wall_matrix()
	
	love.graphics.setBlendMode("multiply", "premultiplied")
	Map.draw_bg(fg_canvas, w, h, fg_img)
	
	love.graphics.setCanvas(fg)
	love.graphics.setBlendMode("alpha")
	View.draw(fg_canvas, 0, 0)
	
	love.graphics.setCanvas(self.image)
	
	View.draw(bg,0,0)
	View.draw(fg,0,0)
	
	for i=2,#self do
		for j=1,#self[i] do
			if self[i][j] == 1 and self[i-1][j] ~= 1 then
				View.draw(tile_img, Constants.MapUnitToPixelRatio*(j-1), Constants.MapUnitToPixelRatio*(i-1.5))
			end
			if self[i][j] == 2 then
				View.draw(tile_img, Constants.MapUnitToPixelRatio*(j-1), Constants.MapUnitToPixelRatio*(i-1.5))
			end
		end
	end
	
	love.graphics.setCanvas()
end

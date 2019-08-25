QueueManager = {queues = {}}
QueueManager.__index = QueueManager

QueueManager.load_functions = {
	[Constants.EnumQueues.MAP] = function (queue, index) QueueManager.load_map(queue, index) end,
}

function QueueManager.load()
	if #QueueManager.queues > 0 then
		QueueManager.is_loading = true
		for index, queue in ipairs(QueueManager.queues) do
			QueueManager.load_functions[queue.id](queue, index)
		end
	else QueueManager.is_loading = false end
end

function QueueManager.load_map(queue, index)
	--GameController.world.current_map.image = love.graphics.newImage("Levels/Level_"..queue.map_id.."/Image.png")
	local map = GameController.world.current_map
	map.image = love.graphics.newCanvas(#map[1]*Constants.MapUnitToPixelRatio, #map*Constants.MapUnitToPixelRatio)
	love.graphics.setCanvas(map.image)
	
	love.graphics.setColor(0.5,0.5,0.5)
	love.graphics.rectangle("fill", 0, 0, #map[1]*20, #map*20)
	love.graphics.setColor(1,1,1)
	for y, row in ipairs(map) do
		for x, cell in ipairs(row) do
			if cell == 1 then
				love.graphics.rectangle("fill", 20*(x-1), 20*(y-1), 20, 20)
			elseif cell == 2 then
				love.graphics.line(20*(x-1), 20*(y-1), 20*x, 20*(y-1))
			end
		end
	end
	love.graphics.setCanvas()
	table.remove(QueueManager.queues, index)
end

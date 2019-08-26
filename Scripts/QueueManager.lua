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
	local map = GameController.world.current_map
		
	map.image = love.graphics.newCanvas(#map[1]*Constants.MapUnitToPixelRatio, #map*Constants.MapUnitToPixelRatio)
	map:generate_map()
	
	table.remove(QueueManager.queues, index)
end

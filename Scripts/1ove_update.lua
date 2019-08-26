function love.update(dt)
	if dt > 0.1 then return end
	QueueManager.load()
		
	if GameController.state == Constants.EnumGameState.MENU then 
		GameController.menu:update(dt)
	elseif GameController.state == Constants.EnumGameState.IN_GAME then
		GameController.world:update(dt)
	end
	
end

function love.keypressed (key)
	if GameController.state == Constants.EnumGameState.MENU then 
		GameController.menu:keypress()
	elseif GameController.state >= Constants.EnumGameState.IN_GAME then
		GameController.world:keypress(key)
	end
end

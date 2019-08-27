function love.draw(dt)

	View.set_draw_size()

	if not QueueManager.is_loading then
		if GameController.state == Constants.EnumGameState.MENU then
			GameController.menu:draw() 
		elseif GameController.state >= Constants.EnumGameState.IN_GAME then
			GameController.world:draw()
		end
	end

	collectgarbage('collect')
end

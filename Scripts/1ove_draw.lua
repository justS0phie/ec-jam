function love.draw(dt)

	View.set_draw_size()

	if not QueueManager.is_loading then
		if GameController.state == Constants.EnumGameState.MENU then
			GameController.menu:draw() 
		elseif GameController.state >= Constants.EnumGameState.IN_GAME then
			GameController.world:draw()
		end
	end
	
	View.print('Memory actually used: '..math.ceil(collectgarbage('count')).." kB", 10,10)
	if GameController.world then 
		View.print('Timer: '..GameController.world.timer, 10,40) 
		View.print('Stamina: '..GameController.player.stamina, 10,70) 
	end
	collectgarbage('collect')
end

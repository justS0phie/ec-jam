-- Configuration
function love.conf(t)
	t.title = "Zoey the Jam Seeker"     -- The title of the window the game is in (string)
	t.window.width = 1280
	t.window.height = 720
	
	t.modules.joystick = false
    t.modules.physics = false

	t.console = false
end

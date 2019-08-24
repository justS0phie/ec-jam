MyLib.lock_controls = false

function MyLib.MyLibSetup()
	local loveUpdate = love.update
	if loveUpdate then
		love.update = function(dt)
			MyLib.ApplyFades(dt)
			loveUpdate(dt)
			MyLib.KeyRefresh()
		end
	end

	local loveDraw = love.draw
	if loveDraw then
		love.draw = function(dt)
			loveDraw(dt)
			MyLib.DrawFades()
		end
	end

	local loveKeyPress = love.keypressed
	if loveKeyPress then
		love.keypressed = function(key)
			if MyLib.lock_controls then
				return
			end
			MyLib.key_list = MyLib.KeyPress(key)
			loveKeyPress(key)
		end
	end

	local loveMousePress = love.mousepressed
	if loveMousePress then
		love.mousepressed = function(X, Y, K)
			if MyLib.lock_controls then
				return
			end
			loveMousePress(X, Y, K)
		end
	end

	local loveTextInput = love.textinput
	if loveTextInput then
		love.textinput = function(text)
			if MyLib.lock_controls then
				return
			end
			loveTextInput(text)
		end
	end
end

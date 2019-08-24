View = {}

function View.adjust_window(user_data)
	-- TODO: Fix this Shit
	love.window.setMode(1280, 720, {fullscreen = true})

	local draw_size = 1
	local XOri, YOri, SXSc, SYSc = 0, 0, 1, 1
	
	if user_data.draw_size then
		View.SX, View.SY = love.graphics.getDimensions()
		SXSc = View.SX / 1280
		SYSc = View.SY / 720
		draw_size = math.min(SXSc, SYSc)
		if SXSc == draw_size then
			YOri = (View.SY - 720) / 2
		else
			XOri = (View.SX - 1280) / 2
		end
	end
	
	View.scale =  draw_size
	View.XOri = XOri
	View.YOri = YOri
end

function View.set_draw_size()
	love.graphics.scale(View.scale, View.scale)
	love.graphics.translate(View.XOri, View.YOri)
end

function View.draw(...)
	local params = {...}
	love.graphics.draw(unpack(params))
end

function View.print(...)
	local params = {...}
	love.graphics.print(unpack(params))
end

function View.printf(...)
	local params = {...}
	love.graphics.printf(unpack(params))
end

function View.rectangle(...)
	local params = {...}
	love.graphics.rectangle(unpack(params))
end

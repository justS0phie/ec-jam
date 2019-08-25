function MainMenu:update_submenu(dt)
	local update_functions = {
		[Constants.EnumMainSubmenu.MAIN] = function(dt) self:main_update(dt) end,
		[Constants.EnumMainSubmenu.OPTIONS] = function(dt) self:options_update(dt) end,
	}
	
	if update_functions[self.submenu] then update_functions[self.submenu](dt) end
end

function MainMenu:main_update(dt)
	self.timer = (self.timer + dt) % 10
end

function MainMenu:options_update(dt)
	love.audio.setVolume(self.volume/100)
	
	if MyLib.isKeyDown('right','d') and self.option == 1 then
		if self.volume < 100 then
			self.volume = self.volume + 60*dt
		end
	elseif MyLib.isKeyDown('left','a') and self.option == 1 then
		if self.volume > 0 then
			self.volume = self.volume - 60*dt
		end
	end
end

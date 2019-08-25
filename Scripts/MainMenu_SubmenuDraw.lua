function MainMenu:draw_submenu()
	local draw_functions = {
		[Constants.EnumMainSubmenu.MAIN] = function() self:main_menu_draw() end,
		[Constants.EnumMainSubmenu.OPTIONS] = function() self:options_draw() end,
	}
	
	if draw_functions[self.submenu] then draw_functions[self.submenu]() end
end

function MainMenu:main_menu_draw()
	local displace_zoey = self.timer*math.pi/5
	local displace_jam = displace_zoey + 3*math.pi/7
	local displace_zoey_sprite = displace_zoey + 6*math.pi/7
	
	View.draw(self.images.jam_name, 30, 330 + math.sin(displace_jam)*30)
	View.draw(self.images.zoey_name, 30, 60 + math.sin(displace_zoey)*30)
	View.draw(self.images.zoey, 700, 150 + math.sin(displace_zoey_sprite)*70)

	View.draw(self.images.select_img, 650, 300 + 73*self.option)
	
	View.print("Begin", 750, 383)
	View.print("Options", 750, 456)
	View.print("Credits", 750, 529)
	View.print("Exit", 750, 602)
	View.print("Begin", 750, 383)
	View.print("Options", 750, 456)
	View.print("Credits", 750, 529)
	View.print("Exit", 750, 602)
	
end

function MainMenu:options_draw()
	if not (self.option == 1) then
		View.draw(self.images.select_img, 500, self.option*95+180)
		love.graphics.setColor(0.5,0.5,0.5)
	end
	local rot = math.pi*(self.volume)/50
	View.draw(self.images.volume_img, 440+400*(self.volume/100), 265, rot, 1, 1, 30, 30)
	love.graphics.setColor(1,1,1)
end

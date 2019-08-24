function MainMenu:draw_submenu()
	local draw_functions = {
		[Constants.EnumMainSubmenu.MAIN] = function() self:main_menu_draw() end,
		[Constants.EnumMainSubmenu.OPTIONS] = function() self:options_draw() end,
	}
	
	if draw_functions[self.submenu] then draw_functions[self.submenu]() end
end

function MainMenu:main_menu_draw()
	View.draw(self.images.select_img, 540, 157 + 73*self.option)
end

function MainMenu:options_draw()
	if not (self.option == 1) then
		View.draw(self.images.select_img, 300, self.option*95+180)
		love.graphics.setColor(0.5,0.5,0.5)
	end
	View.draw(self.images.select_img, 400+350*(self.volume/100), 235)
	love.graphics.setColor(1,1,1)
end

function MainMenu:keypress_submenu()
	local keypress_functions = {
		[Constants.EnumMainSubmenu.MAIN] = function() self:main_menu_keypress() end,
		[Constants.EnumMainSubmenu.OPTIONS] = function() self:options_keypress() end,
		[Constants.EnumMainSubmenu.CREDITS] = function() self:credits_keypress() end,
	}
	
	if keypress_functions[self.submenu] then keypress_functions[self.submenu]() end
end

function MainMenu:fade_to_submenu(submenu, option)
	local option = option or 1
	MyLib.FadeToColor(0.3,{"LuaCall>GameController.menu:set_submenu("..submenu..","..option..")"},{},"fill",{0,0,0,1},true)
	MyLib.KeyRefresh()
end

function MainMenu:set_submenu(submenu, option)
	self.option = option
	self.submenu = submenu
end

function MainMenu:esc_goes_to(submenu, option)
	if MyLib.key_list.escape then
		self:fade_to_submenu(submenu, option)
	end
end

function MainMenu:menu_controls(max_option)
	if MyLib.key_list.up then
		self.option=(self.option - 2) % max_option + 1
	elseif MyLib.key_list.down then
		self.option=(self.option % max_option) + 1
	end
end

function MainMenu:main_menu_keypress()
	if MyLib.key_list.escape then
		love.event.push('quit')
	end
	self:menu_controls(4)
	if MyLib.key_list.confirm then
		if self.option == 4 then
			love.event.push('quit')
		elseif self.option == 1 then
			MyLib.FadeToColor(0.3,{"LuaCall>GameController.menu.music:stop() GameController.start_new_game()"},{},"fill",{0,0,0,1},true)
		else
			self:fade_to_submenu(self.option)
		end
	end
end

function MainMenu:options_keypress(dt)
	self:esc_goes_to(Constants.EnumMainSubmenu.MAIN, Constants.EnumMainSubmenu.OPTIONS)
	self:menu_controls(2)
	
	if MyLib.key_list.confirm then
		if self.option == 2 then
			self:fade_to_submenu(Constants.EnumMainSubmenu.MAIN, Constants.EnumMainSubmenu.OPTIONS)
		end
	end
end

function MainMenu:credits_keypress()
	if MyLib.key_list.btn ~= '' then self:fade_to_submenu(Constants.EnumMainSubmenu.MAIN, Constants.EnumMainSubmenu.CREDITS) end
end

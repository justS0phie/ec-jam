MainMenu = {}
MainMenu.__index = MainMenu

require ('MainMenu_SubmenuDraw')
require ('MainMenu_SubmenuKeyPress')
require ('MainMenu_SubmenuScripts')

function MainMenu.new()
	local _,_,mode = love.window.getMode()
		
	local menu = {
		submenu = Constants.EnumMainSubmenu.MAIN, 
		option = 1,
		volume = 100*love.audio.getVolume(),
		full_screen = mode.fullscreen,
	}
	
	setmetatable(menu, MainMenu)
	menu:load_imgs()
	
	return menu
end


function MainMenu:load_imgs()
	self.images = {
		select_img = love.graphics.newImage('Graphics/Misc/Selecao.png'),
	}
		
	for _, menu in pairs(Constants.EnumMainSubmenu) do
		self.images[menu] = love.graphics.newImage('Graphics/Misc/Menu '..menu..'.png')
	end
end

function MainMenu:back_to_main(option)
	local option = option or 1
	self.option = option
	self.volume = 100*love.audio.getVolume()
end

function MainMenu:draw()
	View.draw(self.images[self.submenu], 0, 0)
	self:draw_submenu()
end

function MainMenu:update(dt)
	self:update_submenu(dt)
end

function MainMenu:keypress(dt)
	self:keypress_submenu(dt)
end

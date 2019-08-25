DataManager = {}
DataManager.__index = DataManager

function DataManager.save(data)
	
end

function DataManager.load_files()

	GameController.menu.loaded_chars = {}

	for i=1,3 do
	
		GameController.menu.loaded_chars[i] = false
		if (love.filesystem.getInfo("Save00"..i..".lua")) then
			GameController.menu.loaded_chars[i] = love.filesystem.load("Save00"..i..".lua")()
		end
		
	end
end

function DataManager.save_user_data()
	local _,_,Mode = love.window.getMode()
	local FileText = ""
	FileText = FileText .. "return{\n"
	FileText = FileText .. "volume = "..tostring(love.audio.getVolume()*100)..",\n"
	FileText = FileText .. "scale = 1.5,\n"
	FileText = FileText .. "full_screen = "..tostring(Mode.fullscreen)..",\n"
	FileText = FileText .. "}"
	
	love.filesystem.write("Userdata.lua", FileText)
end

function DataManager.load_user_data()
	local user_data = nil
	if (love.filesystem.getInfo("Userdata.lua")) then
		user_data = love.filesystem.load("Userdata.lua")()
	else
		user_data = {
			volume = 100,
		}
	end
	
	love.audio.setVolume(user_data.volume/100)
	View.adjust_window(user_data)
end

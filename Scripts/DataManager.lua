DataManager = {}
DataManager.__index = DataManager

function DataManager.save(character)
	local MetaData = {}
	
	if GameController.world then
		MetaData = {
			id = GameController.world.area.active_map.id,
			area = GameController.world.area.id,
			pos_x = character.Pxgrid,
			pos_y = character.Pygrid,
		}
	end
	
	if character.MetaData then
		MetaData.ItemsGot = character.MetaData.ItemsGot
	end
	
	local FileText = ""
	FileText = FileText .. "return{\n"
	FileText = FileText .. "gold = "..character.gold..",\n"
	FileText = FileText .. "level = "..character.level..",\n"
	FileText = FileText .. "gender = '"..character.gender.."',\n"
	FileText = FileText .. "name = '"..character.name.."',\n"
	if character.looks then
		FileText = FileText .. "looks = {Hair = "..character.looks.Hair..",\n"
		FileText = FileText .. "Face = "..character.looks.Face..",\n"
		FileText = FileText .. "CTop = "..character.looks.CTop..",\n"
		FileText = FileText .. "CBot = "..character.looks.CBot..",},\n"
	end
	FileText = FileText .. "Inventory = "..Utils.table_to_string(character.Inventory)..",\n"
	FileText = FileText .. "MetaData = "..Utils.table_to_string(MetaData)..",\n"
	FileText = FileText .. "ClearedEvents = "..Utils.table_to_string(character.ClearedEvents)..",\n"
	FileText = FileText .. "SeenDialogs = "..Utils.table_to_string(character.SeenDialogs)..",\n"
	FileText = FileText .. "Day = "..character.Day..",\n"
	FileText = FileText .. "Time = "..Utils.table_to_string(character.Time)..",\n"
	FileText = FileText .. "}"
	
	love.filesystem.write("Save00"..GameController.save_slot..".lua", FileText)
	
	DataManager.load_files()
end

function DataManager.load_files()

	GameController.menu.loaded_chars = {}

	for i=1,3 do
	
		GameController.menu.loaded_chars[i] = false
		if (love.filesystem.exists("Save00"..i..".lua")) then
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
	if (love.filesystem.exists("Userdata.lua")) then
		user_data = love.filesystem.load("Userdata.lua")()
	else
		user_data = {
			volume = 100,
		}
	end
	
	love.audio.setVolume(user_data.volume/100)
	View.adjust_window(user_data)
end

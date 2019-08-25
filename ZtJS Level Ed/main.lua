curr_x = 0
curr_y = 0
opt = 1

object_properties = {
	mv_platform = {
		{key = "type", name = "Type"},
		{key = "dx", name = "Dx"},
		{key = "dy", name = "Dy"},
		{key = "initialTime", name = "InitTime"},
		{key = "finalTime", name = "EndTime"},
		{key = "numberOfCycles", name = "NoCycles"},
		{key = "width", name = "Width"},
	},
}

object_types = {
	"mv_platform"
}

function love.load(arg)
	map = {
		{1,1,1,1,1,1,1,1,1},
		{1,0,0,0,0,0,0,0,1},
		{1,0,0,0,0,0,0,0,1},
		{1,0,0,0,0,0,0,0,1},
		{1,0,0,0,0,0,0,0,1},
		{1,0,0,0,0,0,0,0,1},
		{1,1,1,1,1,1,1,1,1},
		
		objects = {
			{type = "jam", position = {x = 6, y = 3}},
		},
		start_position = {x=3,y=3}
	}
	
	curr_obj = {type = "mv_platform"}
	curr_type_index = 1
	
	x_ori = 7
	y_ori = 0
end

function love.draw(dt)
	love.graphics.setColor(0.2,0.2,0.2)
	love.graphics.rectangle("fill", 20*(x_ori + 1), 20*(y_ori + 1), 20*#map[1], 20*#map)
	love.graphics.setColor(1,1,1)
	
	for i=1,#map do
		map[i] = map[i] or {}
		for j=1,#map[1] do
			map[i][j] = map[i][j] or 0
			if map[i][j] == 1 then
				love.graphics.rectangle("fill", 20*(j + x_ori), 20*(i + y_ori) , 20, 20)
			elseif map[i][j] == 2 then
				love.graphics.line(20*(j + x_ori), 20*(i + y_ori) , 20*(j + x_ori) + 20, 20*(i + y_ori))
			end
		end
	end
	
	for _, object in ipairs(map.objects) do
		if object.type == "mv_platform" then
			love.graphics.setColor(0,0,1)
			local position = object.initialPosition
			love.graphics.rectangle("fill", 20*(position.x + x_ori), 20*(position.y + y_ori), 20*object.width, 20)
			
			love.graphics.setColor(0,0,1,0.5)
			local position_final = object.finalPosition
			love.graphics.rectangle("line", 20*(position_final.x + x_ori), 20*(position_final.y + y_ori), 20*object.width, 20)
			love.graphics.rectangle("fill", 20*(position_final.x + x_ori), 20*(position_final.y + y_ori), 20*object.width, 20)
			
			love.graphics.setColor(0,0,1,1)
			love.graphics.line(20*(position.x+x_ori) + object.width*10, 20*(position.y + y_ori) + 10, 20*(position_final.x+x_ori) + object.width*10, 20*(position_final.y + y_ori) + 10)
			
		elseif object.type == "jam" then
			love.graphics.setColor(1,0,0,1)
			local position = object.position
			love.graphics.rectangle("fill", 20*(position.x + x_ori), 20*(position.y + y_ori), 40, 40)
		end
	end
	
	love.graphics.setColor(0.5,0,0.7,1)
	love.graphics.rectangle("fill", 20*(map.start_position.x + x_ori), 20*(map.start_position.y + y_ori), 40, 40)
	
	love.graphics.setColor(0.5,0.5,0.5, 0.5)
	love.graphics.rectangle("fill", 0, 0, 150, 600)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("x:"..curr_x, 5, 5)
	love.graphics.print("y:"..curr_y, 5, 25)
	love.graphics.print("w:"..#map[1], 5, 45)
	love.graphics.print("h:"..#map, 5, 65)
	love.graphics.print(opt, 55, 45)
	
	love.graphics.setColor(0,0,0, 0.5)
	love.graphics.rectangle("fill", 0, 100, 150, 30)
	
	love.graphics.setColor(0,1,0,1)
	love.graphics.rectangle("fill", 0 + 30*(opt-1), 100, 30, 30)
	
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("fill", 5, 105, 20, 20)
	love.graphics.rectangle("fill", 35, 105, 20, 2)
	love.graphics.setColor(1,0,0)
	love.graphics.rectangle("fill", 65, 105, 20, 20)
	love.graphics.setColor(0,0,1)
	love.graphics.rectangle("fill", 95, 105, 20, 20)
	love.graphics.setColor(0.5,0,0.7)
	love.graphics.rectangle("fill", 125, 105, 20, 20)
	
	love.graphics.setColor(1,1,1)
	
	if opt == 4 then
		love.graphics.printf("Object properties", 0, 150, 150, "center")
		
		for index, property in ipairs(object_properties[curr_obj.type]) do
			love.graphics.printf(property.name, 0, 140 + 50*index, 150, "center")
			love.graphics.printf("<                          >", 0, 150 + 50*index, 150, "center")
			love.graphics.printf(curr_obj[property.key], 0, 160 + 50*index, 150, "center")
		end
	end
end

function love.update(dt)
	local x , y = love.mouse.getPosition()
	
	if x < 150 then
		return
	else
		local i = math.ceil(y/20)
		local j = math.ceil(x/20)
		
		i = i - 1 - y_ori
		j = j - 1 - x_ori
		
		curr_y = i
		curr_x = j
			
		if love.mouse.isDown(1) and opt <= 2 then		
			for n=1,i do
				map[n] = map[n] or {}
			end
			
			for n=1,j do
				map[1][n] = map[1][n] or 0
			end
			
			map[i][j] = opt
		end
		
		if love.mouse.isDown(2) then
			local index = find_obj(i,j)
			if index then
				table.remove(map.objects,index)
			end
			if (not map[i]) or (not map[i][j]) then 
				return
			end
			map[i][j] = 0
		end
	end
end

function love.mousepressed(x,y,k)
	if x < 150 and x > 0 then
		if y > 100 and y < 130 then
			opt = math.ceil(5*x/150)
			reset_obj()
		end
		
		if y > 190 and opt == 4 then
			local next_opt = 1
			if x < 100 then next_opt = 0 end
			if x < 50 then next_opt = -1 end
			
			local property_index = math.ceil((y-190)/50)
			
			if property_index <= #object_properties[curr_obj.type] then
			
				local property_key = object_properties[curr_obj.type][property_index].key
				
				if property_key == "type" then
					curr_type_index = (curr_type_index + next_opt)
					if curr_type_index > #object_types then curr_type_index = 1 end
					if curr_type_index == 0 then curr_type_index = #object_types end
					curr_obj.type = object_types[curr_type_index]
				end
				
				if property_key == "dx" or property_key == "dy" then
					curr_obj[property_key] = curr_obj[property_key] + next_opt
				end
				
				if property_key == "initialTime" then
					curr_obj[property_key] = math.max(0,math.min(curr_obj["finalTime"],curr_obj[property_key] + next_opt/10))
				end
				
				if property_key == "finalTime" then
					curr_obj[property_key] = math.max(curr_obj["initialTime"],math.min(1,curr_obj[property_key] + next_opt/10))
				end
				
				if property_key == "numberOfCycles" then
					curr_obj[property_key] = math.max(0,curr_obj[property_key] + next_opt)
				end
				
				if property_key == "width" then
					curr_obj[property_key] = math.max(1,curr_obj[property_key] + next_opt)
				end
			end
		end
	else
		local i = math.ceil(y/20)
		local j = math.ceil(x/20)
		
		i = i - 1 - y_ori
		j = j - 1 - x_ori
		
		curr_y = i
		curr_x = j
			
		if k==1 then		
			if opt == 3 then
				map.objects[1].position = {x=j,y=i}
			elseif opt == 4 then
			
				if curr_obj.type == "mv_platform" then
					curr_obj.initialPosition = {x=j, y=i}
					curr_obj.finalPosition = {x=j + curr_obj.dx, y=i + curr_obj.dy}
					
					curr_obj.dx = nil
					curr_obj.dy = nil
				end
				
				table.insert(map.objects, deep_copy(curr_obj))
				reset_obj()
			elseif opt == 5 then
				map.start_position = {x=j,y=i}
			end
		end
	end
end

function reset_obj()
	curr_obj = {type=curr_obj.type}
	for _, property in ipairs(object_properties[curr_obj.type]) do
		if property.key == "type" then
			
		elseif property.key == "finalTime" or property.key == "width" then
			curr_obj[property.key] = 1
		else
			curr_obj[property.key] = 0
		end
	end
end

function love.keypressed(k)
	if k == "escape" then
		love.event.push("quit")
	
	elseif k == "left" then
		x_ori = x_ori + 1
		dir = k
	elseif k == "right" then
		x_ori = x_ori - 1
		dir = k
	elseif k == "down" then
		y_ori = y_ori - 1
		dir = nil
	elseif k == "up" then
		if dir and not (string.sub(dir, 1,1) == "u") then dir = "up-"..dir end
		y_ori = y_ori + 1
	
	elseif k == "space" then
		save_map()
	
	elseif k == "c" then
		for i=1, #map do map[i][#map[1]] = nil end
	elseif k == "v" then
		table.remove(map,#map)
		
	elseif k ==  "q" then
		for i=1, #map do 
			map[i][#map[1] - 1] = 1
			map[i][#map[1]] = 1
			map[i][1] = 1
			map[i][2] = 1
		end
		
		for i=1, #map[1] do 
			map[1][i] = 1
			map[2][i] = 1
			map[#map][i] = 1
			map[#map - 1][i] = 1
		end
	
	elseif k == "n" or k == "r" then
		love.load()
	end
end

function find_obj(i,j)
	for index, obj in ipairs(map.objects) do
		if obj.type == "mv_platform" then
			if i == obj.initialPosition.y then
				if j >= obj.initialPosition.x and j <= obj.initialPosition.x + obj.width - 1 then
					return index
				end
			end
		elseif obj.type == "jam" then
			--Do nothing
		end
	end
end

function deep_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deep_copy(orig_key)] = deep_copy(orig_value)
        end
        setmetatable(copy, deep_copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function save_map()
	text_file = "return "..table_to_string(map)
	
	love.filesystem.write("level.lua", text_file)
	return text_file
end

function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
		elseif type(k) == "number" then
			result = result.."["..k.."]".."="
        end

        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        elseif type(v) == "number" then
			result = result..v
		elseif type(v) == "userdata" then
			result = result.."\"Image\""
		else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    if result ~= "{" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

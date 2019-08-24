MyLib.key_list = {btn = ""}

for k, _ in ipairs({"confirm","escape","up","down","left","right"}) do
	MyLib.key_list[k] = false
end

function MyLib.KeyPress(btn)

	MyLib.key_list.btn = btn

	if (btn =="space" or btn == "return" or btn == "z") then
		MyLib.key_list["confirm"] = true
	end

	if (btn == "escape") then
		MyLib.key_list["escape"] = true
	end

	if (btn == "up" or btn == "w") then
		MyLib.key_list["up"] = true
	end

	if (btn == "down" or btn == "s") then
		MyLib.key_list["down"] = true
	end

	if (btn == "left" or btn == "a") then
		MyLib.key_list["left"] = true
	end

	if (btn == "right" or btn == "d") then
		MyLib.key_list["right"] = true
	end
	
	return MyLib.key_list

end

function MyLib.KeyRefresh()

	MyLib.key_list = {btn = ""}

	for k, _ in ipairs({"confirm","escape","up","down","left","right"}) do
		MyLib.key_list[k] = false
	end

end

function MyLib.isKeyDown(...)
	if not MyLib.lock_controls then
		return love.keyboard.isDown(...)
	end
	return false
end
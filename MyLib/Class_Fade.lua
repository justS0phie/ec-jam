MyLib.FadeClass = {}
MyLib.FadeClass.__index = MyLib.FadeClass
MyLib.FadeClass.Last_Id = 0

MyLib.Fades = {}

function MyLib.FadeClass.create(Time, Variables, Values, Type, Fill, Mirror, X, Y)	
	local new_fade = {}
	
	local X = X or nil
	local Y = Y or nil
	MyLib.FadeClass.Last_Id = MyLib.FadeClass.Last_Id + 1
	
	new_fade = {
		Time = Time,
		Variables = Variables,
		Values = Values,
		Type = Type,
		Fill = Fill,
		Mirror = Mirror,
		TimeLimit = Time,
		Time = Time,
		X = X,
		Y = Y,
		id = MyLib.FadeClass.Last_Id
	}
	
	setmetatable(new_fade,MyLib.FadeClass)
	
	MyLib.Fades[new_fade.id] = new_fade
	
	return new_fade
end

function MyLib.FadeClass:draw()
	local Color

	if self.Type == "Img" then
		Color = {1,1,1,1}
	else
		Color = {unpack(self.Fill)}
	end
	
	Color[4] = (Color[4]*self.Time)/self.TimeLimit

	if self.Mirror then
		Color[4] = 1 - Color[4]
		love.graphics.setColor(unpack(Color))
	else
		love.graphics.setColor(unpack(Color))
	end
	
	if self.Type == "fill" then
		View.rectangle("fill", 0, 0, 1280, 720)
	elseif self.Type == "Img" then
		View.draw(self.Fill, self.X, self.Y)
	end

end

function MyLib.FadeClass:update(dt)

	self.Time=self.Time - dt
	
	if self.Time<=0 then
		self:resolve()
	end
end

function MyLib.FadeClass:resolve()
	for key, variable in ipairs(self.Variables) do
		if variable:sub(1,8) == "LuaCall>" then
			loadstring(variable:sub(9))()
		else
			_G[variable] = self.Values[key]
		end
	end
			
	if self.Mirror and self.Type ~= "Img" then
		MyLib.FadeClass.create(self.TimeLimit,{},{}, self.Type, self.Fill, false)
	end
	
	MyLib.Fades[self.id] = nil
end

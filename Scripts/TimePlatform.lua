TimePlatform = {}
TimePlatform.__index = TimePlatform

function TimePlatform:update_position(timer) 
    self.position.x = self.initialPosition.x * 20 + (self.finalPosition.x - self.initialPosition.x ) * 20 * Utils.smooth( (timer * self.numberOfCycles) % 2)
    self.position.y = self.initialPosition.y * 20 + (self.finalPosition.y - self.initialPosition.y ) * 20 * Utils.smooth( (timer * self.numberOfCycles) % 2)
end
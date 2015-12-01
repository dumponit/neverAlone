World = class("World")

function World:initialize()
	self:clear()
end

function World:update(dt)
	-- Update the world simulation
	self.world:update(dt)
end

function World:getObjectAt(x, y)
	for k,v in pairs(self.worldObjects) do
		local r = v.body:getAngle()
		local tx, ty = v.body:getX(), v.body:getY()
		local s = v.shape
		if s:testPoint(tx, ty, r, x, y) then return v end
	end
end

function World:draw()
	love.graphics.setColor(colors.white)
	-- Draw all the bodies
	for k,v in pairs(self.worldObjects) do
		self:drawSingle(v)
	end
end

function World:drawSingle(obj)
	if obj.shape.getPoints then
		love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
	else
		love.graphics.circle("line", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
	end
end

-- clear the world
function World:clear()
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81*64, true)
	self.worldObjects = {}
end

-- add an object
function World:addObject(x, y, w, h, r, shape, dynamic)
	local obj = {}
	
	obj.body = love.physics.newBody(self.world, x, y, dynamic and "dynamic")
	if shape == "rectangle" then
		obj.shape = love.physics.newRectangleShape(w, h)
	elseif shape == "circle" then
		obj.shape = love.physics.newCircleShape(w)
	end
	obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
	obj.body:setAngle(r)
	
	table.insert(self.worldObjects, obj)
	return obj
end 

-- destroy an object
function World:destroyObject(obj)
	for k,v in pairs(self.worldObjects) do
		if v == obj then
			table.remove(self.worldObjects, k)
			v.fixture:destroy()
			return
		end
	end
end
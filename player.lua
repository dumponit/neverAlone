Player = class("Player")

local butts = {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
	start = 5,
	back = 6,
	ls = 7,
	rs = 8,
	lb = 9,
	rb = 10,
	a = 11,
	b = 12,
	x = 13,
	y = 14
}

local butts2 = {
	"up", "down", "left", "right", "start", "back", "ls", "rs", "lb", "rb", "a", "b", "x", "y"
}

local axes = {
	lx = 1,
	ly = 2,
	rx = 3,
	ry = 4,
	lt = 5,
	rt = 6,
}

local shapes = {
	"rectangle", "circle"
}

function Player:initialize(label, color, hudX, hudY, stick, world)
	-- referencing other things
	self.world = world
	
	-- used for input
	self.stick = stick
	
	-- just for display and drawing
	self.label = label
	self.color = color
	self.hudX = hudX
	self.hudY = hudY
	
	-- crosshair clicky cursor
	self.cursorX = scrw()/2
	self.cursorY = scrh()/2
	
	-- settings for newly spawned object
	self.newWidth = 32
	self.newHeight = 32
	self.newRotation = 0
	self.newDynamic = true
	self.newShape = 1
	
	-- state
	self.state = "cursor" -- "cursor" "possessing" "grabbing"
	
	--drawing
	self.drawing = false
	
	-- mouseJoint
	self.mj = nil
	self.grabObj = nil
end

function Player:update(dt)
	local dx = self.stick:getAxis(axes.lx)
	local dy = self.stick:getAxis(axes.ly)
	local dlt = self.stick:getAxis(axes.lt)
	local drt = self.stick:getAxis(axes.rt)
	if self.state == "cursor" then
		-- move the cursor
		if math.abs(dx) > .1 then self.cursorX = self.cursorX + dx*10 end
		if math.abs(dy) > .1 then self.cursorY = self.cursorY + dy*10 end
		if math.abs(dlt) > .1 then self.newRotation = self.newRotation + dlt end
		if math.abs(drt) > .1 then self.newRotation = self.newRotation + drt end
		
		if self.mj then
			self.mj:setTarget(self.cursorX, self.cursorY)
		end
		
		if self.stick:isGamepadDown('a') and not self.mj then
			self.grabObj = self.world:getObjectAt(self.cursorX, self.cursorY)
			if self.grabObj then
				self.mj = love.physics.newMouseJoint(self.grabObj.body, self.cursorX, self.cursorY)
			end
		elseif self.stick:isGamepadDown('b') then
			local obj = self.world:getObjectAt(self.cursorX, self.cursorY)
			while(obj) do
				self.world:destroyObject(obj)
				obj = self.world:getObjectAt(self.cursorX, self.cursorY)
			end
		elseif self.stick:isGamepadDown('y') and not self.mj then
			local obj = self.world:getObjectAt(self.cursorX, self.cursorY)
			if obj then
				self.grabObj = obj
				self.state = "possessing"
			end
		end
	elseif self.state == "possessing" then
		local vx, vy = self.grabObj.body:getLinearVelocity()
		local vel = 100
		local force = 1000
		if math.abs(dx) > .1 then self.grabObj.body:applyForce(dx*force, 0) end
		if math.abs(dy) > .1 then self.grabObj.body:applyForce(0, dy*force) end
		if self.stick:isGamepadDown('dpright') then
			self.grabObj.body:setLinearVelocity(vel, vy)
		elseif self.stick:isGamepadDown('dpleft') then
			self.grabObj.body:setLinearVelocity(-vel, vy)
		end
		--if math.abs(dlt) > .2 then self.grabObj.body:applyTorque(dlt*force) end
		--if math.abs(drt) > .2 then self.grabObj.body:applyTorque(drt*force) end
	end
end

function Player:draw()
	love.graphics.setColor(self.color)
	
	if self.state == "cursor" then
		if not self.newDynamic then
			love.graphics.print("fixed", self.cursorX + 8, self.cursorY)
		end
		love.graphics.setLineWidth(1)
		love.graphics.circle("line", self.cursorX, self.cursorY, 6)
		love.graphics.line(self.cursorX, self.cursorY - 8, self.cursorX, self.cursorY + 8)
		love.graphics.line(self.cursorX - 8, self.cursorY, self.cursorX + 8, self.cursorY)
		
		if self.drawing then
			self.newWidth = self.cursorX - self.ox
			self.newHeight = self.cursorY - self.oy
			if shapes[self.newShape] == "rectangle" then	
				love.graphics.rectangle("line", self.ox, self.oy, self.newWidth, self.newHeight)
			elseif shapes[self.newShape] == "circle" then
				self.newWidth = math.max(self.newWidth, self.newHeight)
				self.newHeight = math.max(self.newWidth, self.newHeight)
				love.graphics.circle("line", self.ox, self.oy, self.newWidth)
			end
		end
	elseif self.state == "possessing" then
		self.world:drawSingle(self.grabObj)
	end
end

function Player:gamepadpressed(stick, button)
	if stick == self.stick then
		-- spawn something
		if button == 'x' then
			-- add shape to world
			self.drawing = true
			self.ox = self.cursorX
			self.oy = self.cursorY
		elseif button == 'rightshoulder' then
			self.newShape = self.newShape + 1
			if self.newShape > #shapes then self.newShape = 1 end
		elseif button == 'leftshoulder' then
			self.newShape = self.newShape - 1
			if self.newShape < 1 then self.newShape = #shapes end
		elseif button == 'leftstick' then
			self.newDynamic = not self.newDynamic
		elseif self.state == "possessing" then
			if button == 'y' then
				self.state = "cursor"
				self.grabObj = nil
			elseif button == 'a' then
				local vx, vy = self.grabObj.body:getLinearVelocity()
				self.grabObj.body:setLinearVelocity(vx, -200)
			end
		end
	end
end

function Player:gamepadreleased(stick, button)
	if stick == self.stick then
		if self.state == "possessing" then
			if button == 'dpleft' or button == 'dpright' then
				local vx, vy = self.grabObj.body:getLinearVelocity()
				self.grabObj.body:setLinearVelocity(0, vy)
			end
		elseif button == 'a' then
			if self.mj then
				self.mj:destroy()
				self.mj = nil
				self.grabObj = nil
			end
		elseif button == 'x' then
			if self.drawing then
				if self.newWidth == 0 or self.newHeight == 0 then return end
				if shapes[self.newShape] == "rectangle" then	
					if self.newWidth < 0 then
						self.ox = self.ox + self.newWidth
						self.newWidth = -self.newWidth
					end
					if self.newHeight < 0 then
						self.oy = self.oy + self.newHeight
						self.newHeight = -self.newHeight
					end
					self.world:addObject(self.ox + self.newWidth/2, self.oy + self.newHeight/2, self.newWidth, self.newHeight, 0, shapes[self.newShape], self.newDynamic)
				elseif shapes[self.newShape] == "circle" then	
					self.world:addObject(self.ox, self.oy, self.newWidth, self.newHeight, 0, shapes[self.newShape], self.newDynamic)
				end
				self.drawing = false
			end
		end
	end
end
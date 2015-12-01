Camera = class("Camera")

function Camera:initialize()
self.layers = {}
self.x = 0
self.y = 0
self.scaleX = 1
self.scaleY = 1
self.rotation = 0
self.objectDistance = 0
self.x1 = 0
self.x2 = 0
self.y1 = 0
self.y2 = 0
end

function Camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end


function Camera:lookAt(obj)
	self.x = obj.x + obj.w/2 - love.window.getWidth()/2
	self.y = obj.y + obj.h/2 - love.window.getHeight()/2
end

function Camera:lookAtSmash(obj1, obj2)

  self.smashScale(obj1, obj2)

  self.objectDistance, self.x1, self.x2, self.y1, self.y2 = love.physics.getDistance(obj1, obj2)


  midX =  (self.x1 + self.x2)/2

  midY = (self.y1 + self.y2)/2

  self.x = midX
  self.y = midY


end


---Currently struggling between using this camera library or the really fancy one done in hump

function Camera:smashScale(obj1, obj2)

  ---Get distance between player entities.
  newDistance, self.x1, self.x2, self.y1, self.y2 = love.physics.getDistance(obj1, obj2)


  ---If player distance has increased, zoom out
  if( math.abs(newDistance) > math.abs(self.objectDistance) ) then
    self.scale(1.05)
  ---If player distance has decreased, zoom in
  else if( math.abs(newDistance) < math.abs(self.objectDistance) ) then
    self.scale(.95)
  end

end
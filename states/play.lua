------------------------------------------------------------------------------
--[[ Play Gamestate ]]-------------------------------------------------------
------------------------------------------------------------------------------

local state = {}
local players
local world

------------------------------------------------------------------------------
-- When the gamestate is entered
------------------------------------------------------------------------------
function state:enter()
	world = World()
	players = {}
	for k,v in pairs(love.joystick.getJoysticks()) do
		table.insert(players, Player("P1", playerColors[k], 0, 0, v, world))
	end
end


------------------------------------------------------------------------------
-- Update the state
-- @param dt (number) Delta time between calls
------------------------------------------------------------------------------
function state:update(dt)
	world:update(dt)
	for k,v in pairs(players) do
		v:update(dt)
	end
end


------------------------------------------------------------------------------
-- Draw the state
------------------------------------------------------------------------------
function state:draw()
	world:draw()
	for k,v in pairs(players) do
		v:draw()
	end
end


------------------------------------------------------------------------------
-- Key pressed at the state
-- @param key (string) The name of the key pressed
-- @param isRepeat (boolean) True if the event fired due to key held down
------------------------------------------------------------------------------
function state:keypressed(key, isRepeat)

end


------------------------------------------------------------------------------
-- Joystick pressed at the state
-- @param joystick (joystick) The joystick object that fired the event
-- @param button (number) The button ID pressed that fired the event
------------------------------------------------------------------------------
function state:gamepadpressed(joystick, button)
	for k,v in pairs(players) do
		v:gamepadpressed(joystick, button)
	end
end

function state:gamepadreleased(joystick, button)
	for k,v in pairs(players) do
		v:gamepadreleased(joystick, button)
	end
end

return state
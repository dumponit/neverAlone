------------------------------------------------------------------------------
--[[ Main Setup Code ]]-------------------------------------------------------
------------------------------------------------------------------------------

-- OOP library
require "middleclass"
require "middleclass-commons"

-- assets
require "funcs"
require "assets"

-- classes
require "world"
require "player"

-- Actual game
require "game"


------------------------------------------------------------------------------
-- Called when the game first loads
------------------------------------------------------------------------------
function love.load()
	StartGame()
end


------------------------------------------------------------------------------
-- Update the game
-- @param dt (number) Delta time between calls
------------------------------------------------------------------------------
function love.update(dt)
	
end

------------------------------------------------------------------------------
-- Draw the game
------------------------------------------------------------------------------
function love.draw()
	
end

------------------------------------------------------------------------------
-- Key pressed at any point during the game
-- @param key (string) The name of the key pressed
-- @param isRepeat (bool) True if the event fired due to key held down
------------------------------------------------------------------------------
function love.keypressed(key, isRepeat)
	-- Quit game by pressing escape
	if key == "escape" then
		love.event.push("quit")
	end
end


------------------------------------------------------------------------------
-- Called when window is resized
-- @param w (number) The new width of the window
-- @param h (number) The new height of the window
------------------------------------------------------------------------------
function love.resize(w, h)

end
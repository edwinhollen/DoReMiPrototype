io.stdout:setvbuf('no')

require('util')
local doremi = require('doremi')

function love.load()
	local puzzle = doremi:getPuzzle(1)
	print('solution', table.tostring(puzzle.solution))
	print('pieces', table.tostring(puzzle.pieces))

	-- doremi:playSequence(120, 'c2', 'd2', 'e2')
	doremi:playChord('c2', 'eb2', 'f2', 'c3')
end

function love.update(dt)
	doremi:update(dt)
end

function love.draw()

end

function love.keypressed(key, isrepeat)
end
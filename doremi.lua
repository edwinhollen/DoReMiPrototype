local chance = require('chance')
chance:seed(love.timer.getTime())

return {
	loadedNotes = nil,
	notesToPlay = {},
	availableNotes = {'c2', 'c#2', 'd2', 'eb2', 'e2', 'f2', 'f#2', 'g2', 'ab2', 'a2', 'bb2', 'b2', 'c3'},
	loadNoteSounds = function(self)
		self.loadedNotes = {}
		for noteKey, note in ipairs(self.availableNotes) do
			self.loadedNotes[note] = love.sound.newSoundData('sounds/'..note..'.mp3')
		end
	end,
	playNote = function(self, note)
		if loadedNotes == nil then self:loadNoteSounds() end
		love.audio.newSource(self.loadedNotes[note]):play()
	end,
	playChord = function(self, ...)
		for k,v in ipairs({...}) do
			self:playNote(v)
		end
	end,
	playSequence = function(self, bpm, ...)
		for noteToPlayKey, noteToPlay in ipairs({...}) do
			table.insert(self.notesToPlay, {
				note = noteToPlay, 
				at = love.timer.getTime() + ((60 / bpm)*noteToPlayKey)
			})
		end
	end,
	update = function(self, dt)
		for noteToPlayKey, noteToPlay in ipairs(self.notesToPlay) do
			if noteToPlay ~= nil and love.timer.getTime() >= noteToPlay.at then
				self:playNote(noteToPlay.note)
				noteToPlay.removeable = true
			end
		end

		for i=#self.notesToPlay, 1, -1 do
			if self.notesToPlay[i].removeable then
				table.remove(self.notesToPlay, i)
			end
		end
	end,
	getPuzzle = function(self, difficulty)
		local pool
		local solution
		local allPieces = {}

		if difficulty == 1 then
			-- easiest difficulty is an arpegio (single octave)
			pool = {'c2', 'e2', 'g2', 'c3'}
		elseif difficulty == 2 then
			-- medium difficulty is a major scale (single octave)
			pool = {'c2', 'd2', 'e2', 'f2', 'g2', 'a2', 'b2', 'c3'}
		else
			-- hardest difficulty is all possible notes
			pool = self.availableNotes
		end

		local shuffledPool = chance:shuffle(pool)
		-- add solution
		local solution = {}
		for i=1, 4 do
			local solutionNote = shuffledPool[i]
			table.insert(solution, solutionNote)
			table.insert(allPieces, solutionNote)
		end
		-- add extra notes
		for i=1, 4 do
			local nowAvailable = {}
			for availableNoteKey, availableNote in ipairs(self.availableNotes) do
				if not (table.contains(solution, availableNote) or table.contains(allPieces, availableNote)) then
					table.insert(nowAvailable, availableNote)
				end
			end
			table.insert(allPieces, chance:pick(nowAvailable))
		end
		return {
			solution = solution,
			pieces = chance:shuffle(allPieces)
		}
	end
}
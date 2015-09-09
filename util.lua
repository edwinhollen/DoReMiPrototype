function table.contains(haystack, needle)
	for k,v in ipairs(haystack) do
		if v == needle then return true end
	end
	return false
end

function table.tostring(tbl)
	local str = ''
	for k,v in ipairs(tbl) do
		str = str .. tostring(v)
		if k ~= #tbl then
			str = str .. ', '
		end
	end
	return str
end
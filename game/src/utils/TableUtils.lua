local TableUtils = {};

TableUtils.countKeys = function(t)
	local count = 0;
	for _, _ in pairs(t) do
		count = count + 1;
	end
	return count;
end

TableUtils.shallowCopy = function(t)
	local out = {};
	for k, v in pairs(t) do
		out[k] = v;
	end
	return out;
end

TableUtils.contains = function(t, value)
	for k, v in pairs(t) do
		if v == value then
			return true;
		end
	end
	return false;
end

--http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
TableUtils.spairs = function (t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

return TableUtils;

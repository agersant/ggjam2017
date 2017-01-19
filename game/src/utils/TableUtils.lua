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

return TableUtils;

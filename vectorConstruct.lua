V = {}
V.__index = V;


function V.vectorize(table)-->>Takes input as a table-indexed-array, return a formated table with a count for dimmensions and a confirm that the table is the factor
	vectorTable = table;
	if vectorTable.ISVECTOR then
		error(tostring(vectorTable).."is already vectorized!");
	end
	local dimCount = 0
	
	for k,v in ipairs(vectorTable) do
		if not(type(v)=='number') then
			error(tostring(vectorTable).."contains a non-number value!");
			dimCount = dimCount+1;
		end
	
		dimCount = dimCount+1
	end
	
	vectorTable.ISVECTOR = true
	vectorTable.DIMCOUNT = dimCount;
	setmetatable(vectorTable,V);
	return vectorTable;
end

function V.__add(op1,op2)-->>add vectors
	local value = {};
	if not(getmetatable(op1)==getmetatable(op2)) then error("Both tables must be vector-formated! [V.vectorize("..tostring(op1)..")]") end --check both vectors
	if not(op1.DIMCOUNT==op2.DIMCOUNT) then error("Tables do not have equal dimmensions!"); end
	for i=1,op1.DIMCOUNT do
		value[i] = op1[i]+op2[i]; --add each
	end
	return V.vectorize(value);--vectorize table
end

function V.__sub(op1,op2)-->>subtract vectors
	local value = {};
	if not(getmetatable(op1)==getmetatable(op2)) then error("Both tables must be vector-formated! [V.vectorize("..tostring(op1)..")]") end
	if not(op1.DIMCOUNT==op2.DIMCOUNT) then error("Tables do not have equal dimmensions!"); end
	for i=1,op1.DIMCOUNT do
		value[i] = op1[i]-op2[i];
	end
	return V.vectorize(value);
end

function V.__mul(op1,op2)-->>multiply vectors by vector/scalar
	local value = {};
	if type(op2)=='number' then --scalar
		for i=1,op1.DIMCOUNT do
			value[i] = op1[i]*op2
		end
		return V.vectorize(value);
	elseif type(op1)=='number' then --scalar
		for i=1,op2.DIMCOUNT do
			value[i] = op2[i]*op1
		end
		return V.vectorize(value);
	elseif getmetatable(op1)==getmetatable(op2) then
		if not(op1.DIMCOUNT==op2.DIMCOUNT) then error("Tables do not have equal dimmensions!"); end
		for i=1,op1.DIMCOUNT do
			value[i] = op1[i]*op2[i];
		end
		return V.vectorize(value);
	end
end

function V.__div(op1,op2)-->>divide vectors/scalar
	local value = {};
	if type(op2)=='number' then
		for i=1,op1.DIMCOUNT do
			value[i] = op1[i]/op2;
		end
		return V.vectorize(value);
	elseif type(op1)=='number' then
		for i=1,op2.DIMCOUNT do
			value[i] = op2[i]/op1;
		end
		return V.vectorize(value);
	elseif getmetatable(op1)==getmetatable(op2) then
		if not(op1.DIMCOUNT==op2.DIMCOUNT) then error("Tables do not have equal dimmensions!"); end
		for i=1,op1.DIMCOUNT do
			value[i] = op1[i]/op2[i];
		end
		return V.vectorize(value);
	end
end

function V.norm(self)-->>normalize vector
	return (self/self:getMagnitude());--sad.
end

function V.getMagnitude(self)
	local magnitude = 0;
	for i=1, self.DIMCOUNT do
		magnitude = magnitude + math.pow(self[i],2); --recursively add
	end
	magnitude = math.sqrt(magnitude); --take root, dist. formula
	return magnitude;
end
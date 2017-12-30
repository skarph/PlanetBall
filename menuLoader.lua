MENU = {};
MENU.currentMenu = {};

function MENU.load(string)
	--MENU.currentMenu = string;
	local data = JSON.decode(string);
	for i,obj in ipairs(data) do
		for k,v in pairs(obj) do
			if type(v)=="string" and not(k == "title" or k=="type" or k=="varStr") then
				obj[k] = load("return "..v)();
			end
		end
		MENU.currentMenu[i] = _G[obj.type].new(obj.pos,obj.val,obj.varStr,obj.fntSCL,obj.title);
	end
end

function MENU.unload()-->> unloads data
	MENU.currentMenu = {};
end

function MENU.render()
	for i,obj in ipairs(MENU.currentMenu) do
		obj:render();
	end
end

function MENU.update()
	for i,obj in ipairs(MENU.currentMenu) do
		obj:update();
	end
end

function MENU.find(title)
	for i,obj in ipairs(MENU.currentMenu) do
		if obj.title == title then
			return MENU.currentMenu[i];
		end
	end
end
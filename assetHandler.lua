ASSET = {};
ASSET.__dir = "assets";

ASSET.__SOUND_EXT = "(wav)(mp4)(ogg)";
ASSET.__GRAPHIC_EXT = "(png)(jpg)";
ASSET.__FONT_EXT = "(ttf)";
ASSET.__LEVEL_EXT = "(json)";

function ASSET.load(p,upTable)--recursively loads all assets in path or main directory. Leave upTable nil, used for recursive calling
	
	local path = p or ASSET.__dir;
	local dirList = love.filesystem.getDirectoryItems(path);
	local upTable = upTable or ASSET;
	
	for k, rPath in ipairs(dirList) do
		
		if love.filesystem.isDirectory(path.."/"..rPath) then
			upTable[rPath] = {}
			ASSET.load(path.."/"..rPath,upTable[rPath]);--go one folder down
		else
			
			local ext = rPath:sub(rPath:find('%.')+1,rPath:len());
			local indexName = rPath:sub(1,rPath:find('%.')-1);	
			--Determine/Load asset
			if ext:match(ASSET.__SOUND_EXT) then
				upTable[indexName] = love.sound.newSoundData(path.."/"..rPath);
			elseif ext:match(ASSET.__GRAPHIC_EXT) then
				upTable[indexName] = rPath:sub(1,rPath:find('%.',-1));
			elseif ext:match(ASSET.__FONT_EXT) then
				upTable[indexName] = love.graphics.newFont(path.."/"..rPath);
			elseif ext:match(ASSET.__LEVEL_EXT) then
				upTable[indexName] = love.filesystem.read(path.."/"..rPath);
			end
			
		end
	end
	
end
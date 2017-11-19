LEVEL = {};

LEVEL.currentLevel = nil;

function LEVEL.load(string)

	LEVEL.currentLevel = JSON.decode(string);-->> creates a new ball relative to center with the provided json string
	
	for i,v in ipairs(LEVEL.currentLevel) do
		n = BALL.new(LEVEL.currentLevel[i].pos.x+(winW/2),LEVEL.currentLevel[i].pos.y+(winH/2),
		LEVEL.currentLevel[i].rad,LEVEL.currentLevel[i].mass,
		{LEVEL.currentLevel[i].color[1],LEVEL.currentLevel[i].color[2],LEVEL.currentLevel[i].color[3],LEVEL.currentLevel[i].color[4]}
		,LEVEL.currentLevel[i].lock);
		
		BALL.list[n].vel = V.vectorize({LEVEL.currentLevel[i].vel.x,LEVEL.currentLevel[i].vel.y});--give velocity to the ball
	end

end

function LEVEL.unload()-->> unloads LEVEL.currentLevel
	
	for i=1,BALL.lastIndex do
		BALL.list[i] = nil;
	end
	
	LEVEL.currentLevel = nil;
	BALL.lastIndex = 1;
end
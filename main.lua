GTIME = 0; --global timer

function love.load()
	love.window.setMode(1040,780);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	love.graphics.setCanvas(canvas);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	require("vectorConstruct");
	JSON = require("json");	
	require("ball");
	require("gui");
	require("assetHandler");
	require("levelLoader");
	require("menuLoader");
  	require("playerInterface");
	ASSET.load();--loads all assets
	
	love.graphics.setFont(ASSET.fonts.JosefinSans.BoldItalic);--sets font. All assets are acessed through the assets folder and its subdirectories
	
	math.randomseed(os.time());
	
	LEVEL.load(ASSET.levels.circle);--loads the example level (example.json)
	MENU.load(ASSET.menus.alphaMenu);
	----
	doUpdate = false; --do updates for balls
	love.keyboard.setKeyRepeat(true);

	timeMult = 1;
	touchMass = 500; --mass of invisible ball spawned upon click
	----	
end
 
function love.update(dt)
	BALL.approachBallCenter(dt)
	dtime = dt * timeMult --time delta used for updating balls
	PINTER.coolTime = PINTER.coolTime - 1
	MENU.update();
	if doUpdate then
		GTIME = GTIME + dtime; --update global timer
    	update(-0.01,PINTER.getInteractions());
	end
	
	PINTER.doKeyJobs();
end

function love.draw()
	love.graphics.setCanvas(canvas);

	love.graphics.setBlendMode("subtract", "alphamultiply");
	love.graphics.setColor(0x7F,0x7F,0x7F,0x02);
	love.graphics.rectangle('fill',0,0,winW,winH);
	
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	if doUpdate then
		for i=1, BALL.lastIndex do
			err,msg = pcall(BALL.drawTrail,BALL.list[i]);--incase BALL[i]==nil
		end
	end

	love.graphics.setColor(255,255,255,255);
	love.graphics.setCanvas();
	
	love.graphics.setBlendMode("alpha", "premultiplied");
	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	love.graphics.draw(canvas);

	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	MENU.render();
	
	for i=1, BALL.lastIndex do
		err,msg = pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
	end
	
end

function love.keyreleased( key )
	if(PINTER.getKeyAssignment(key)) then
		PINTER.getKeyAssignment(key).callback(false,true,love.keyboard.isDown(key));
	end
end

function love.keypressed( key, scancode, isrepeat ) --update toggle
	if(PINTER.getKeyAssignment(key)) then
		PINTER.getKeyAssignment(key).callback(true,false,love.keyboard.isDown(key));
	end
end

function update(dtime,touches)
	local touchBalls = {};--variable holding indecies for the gravity points
	for k,v in ipairs(touches) do
		local xC = (touches[k][1] - BALL.ballCenter[1]) / BALL.ballScale ;
      	local yC = (touches[k][2]- BALL.ballCenter[2]) / BALL.ballScale ;
		touchBalls[k] = BALL.new(xC,yC,0,touchMass);
	end
	BALL.grav(); --solve gravity
	
	for k,v in ipairs(touches) do
		BALL.list[touchBalls[k]] = nil;
	end
	
	BALL.doCollisions(); --solve any collisions
	
	for i=1, BALL.lastIndex do --updating solved per ball. May be useful when deciding to 'speed up' some balls.
		if BALL.list[i] then
			BALL.list[i]:update(dtime);
		end
	end
end

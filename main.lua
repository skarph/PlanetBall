GTIME = 0; --global timer

function love.load()
	love.window.setMode(1400,1000);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	love.graphics.setCanvas(canvas);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	JSON = require("json");	
	require("ball");
	require("vectorConstruct");
	require("gui");
	require("assetHandler");
	require("levelLoader");
	require("menuLoader");
	ASSET.load();--loads all assets
	
	love.graphics.setFont(ASSET.fonts.JosefinSans.BoldItalic);--sets font. All assets are acessed through the assets folder and its subdirectories
	
	math.randomseed(os.time());
	
	LEVEL.load(ASSET.levels.circle);--loads the example level (example.json)
	MENU.load(ASSET.menus.alphaMenu);
	----
	doUpdate = false; --do updates for balls
	camMoving = false;
	love.keyboard.setKeyRepeat(true);

	timeMult = 1;
	touchMass = 500; --mass of invisible ball spawned upon click
	----	
end
 
function love.update(dt)
	dtime = dt * timeMult --time delta used for updating balls
	MENU.update();
	if doUpdate then
		GTIME = GTIME + dtime; --update global timer
		local xC,yC;
		if love.mouse.isDown(1) then
			xC = (love.mouse.getX() / BALL.ballScale) - BALL.ballCenter[1];
			yC = (love.mouse.getY() / BALL.ballScale) - BALL.ballCenter[2];
		end
		update(dtime,xC,yC);
	end
end

function love.draw()
	love.graphics.setCanvas(canvas);

	love.graphics.setBlendMode("subtract", "alphamultiply");
	love.graphics.setColor(0x7F,0x7F,0x7F,0x02);
	love.graphics.rectangle('fill',0,0,winW,winH);
	
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	if doUpdate then
		for i=1, BALL.lastIndex do
			err,msg = pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
		end
	end

	love.graphics.setColor(255,255,255,255);
	love.graphics.setCanvas();
	
	love.graphics.setBlendMode("alpha", "premultiplied");
	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	love.graphics.draw(canvas);

	love.graphics.setColor(0xFF,0xFF,0x1F,0xFF);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	MENU.render();
	
	for i=1, BALL.lastIndex do
		err,msg = pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
	end
	love.graphics.setColor(0xFF,0xFF,0x1F,0xFF);
	love.graphics.print(GTIME,0,0);
	
end

function love.keypressed( key, scancode, isrepeat ) --update toggle
	
	if key == "space" and not isrepeat then
		doUpdate = not doUpdate
		
	end
	
	if key == "up" then
		BALL.ballCenter[2] = BALL.ballCenter[2] - 5;
		camMoving = true;
	elseif key == "down" then
		BALL.ballCenter[2] = BALL.ballCenter[2] + 5;
		camMoving = true;
	end
	
	if key == "right" then
		BALL.ballCenter[1] = BALL.ballCenter[1] + 5;
	elseif key == "left" then
		BALL.ballCenter[1] = BALL.ballCenter[1] - 5;
		camMoving = true;
	end


	if key == "=" then
		BALL.ballScale = BALL.ballScale + 0.01;
		camMoving = true;
	elseif key == "-" then
		BALL.ballScale = BALL.ballScale - 0.01;
		camMoving = true;
	end
end

function update(dtime,xC,yC)
	
	local touch;--variable holding index for touch ball
	if xC and yC then --creates an intangible ball for other balls to gravitate to
		touch = BALL.new(xC,yC,1,touchMass);
	end
	BALL.grav(); --solve gravity
	if touch then
		BALL.list[touch] = nil;
	end
	BALL.doCollisions(); --solve any collisions
	
	for i=1, BALL.lastIndex do --updating solved per ball. May be useful when deciding to 'speed up' some balls.
		if BALL.list[i] then
			BALL.list[i]:update(dtime);
		end
	end
	
end
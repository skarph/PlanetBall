GTIME = 0; --global timer

function love.load()
	love.window.setMode(1560,780);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	
	require("vectorConstruct");
	JSON = require("json");	
	require("ball");
  	require("playerInterface");
	require("gui");
	require("assetHandler");
	require("levelLoader");
	require("menuLoader");
	ASSET.load();--loads all assets
	
	math.randomseed(os.time());

	MENU.load(ASSET.menus.alphaMenu);
	ASSET.sound.mus_test:play()
	
end
 
function love.update(dt)
	update(dt);
end

function love.draw()
	BALL.tailLen =  BALL.tailLen % 256;
	
	love.graphics.setCanvas(canvas);
	love.graphics.setBlendMode("subtract", "alphamultiply");
	love.graphics.setColor(0xFF,0xFF,0xFF,BALL.tailLen);
	love.graphics.rectangle('fill',0,0,winW,winH);
	
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	if BALL.doPhysUp then
		BALL.tailLen = 0x01;
	else
		if BALL.tailLen < 0xFF then
			BALL.tailLen = BALL.tailLen + 1;
		end
	end
	
	
	for i=1, BALL.lastIndex do
			err,msg = pcall(BALL.drawTrail,BALL.list[i]);--incase BALL[i]==nil
	end
	love.graphics.setColor(255,255,255,255);
	love.graphics.setCanvas();
	
	love.graphics.setBlendMode("alpha", "premultiplied");
	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	love.graphics.draw(canvas);

	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	for i=1, BALL.lastIndex do
		err,msg = pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
	end
	
	MENU.render();
	
	--DEBUG AHEAD
	--[[
	love.graphics.print("FUpS:\t"..string.format("%.0f",1/(dtime/BALL.pTimeMult)).."\nTime: "..string.format("%0.1f",GTIME));
	local vec = ((BALL.ballCenter-V.vectorize({winW/2,winH/2})))+V.vectorize({winW/2,winH/2});
	love.graphics.setColor(0xFF,0xFF,0x00,0x7F);
	love.graphics.circle("fill",BALL.ballCenter[1],BALL.ballCenter[2],5);
	love.graphics.line(winW/2,winH/2,vec[1],vec[2]);
	love.graphics.setColor(0x00,0xFF,0xFF,0x7F);
	local vec2 = 
	(((BALL.cenTar-V.vectorize({winW/2,winH/2}))))+V.vectorize({winW/2,winH/2});
	love.graphics.circle("fill",BALL.cenTar[1],BALL.cenTar[2],7);
	love.graphics.line(winW/2,winH/2,vec2[1],vec2[2]);
	love.graphics.setColor(0xFF,0x00,0xFF,0x7F);
	love.graphics.print("\n\n"..vec[1].."\t"..vec[2]);
	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	]]--

end

function love.keyreleased( key )
	if (PINTER.getKeyAssignment(key)) then
		PINTER.getKeyAssignment(key).callback(false,true,love.keyboard.isDown(key));
	end
end

function love.keypressed( key, scancode, isrepeat ) --update toggle
	if(PINTER.getKeyAssignment(key)) then
		PINTER.getKeyAssignment(key).callback(true,false,love.keyboard.isDown(key));
	end
end

function update(dt)
	BALL.approachBallCenter(dt)
	dtime = dt * BALL.pTimeMult --time delta used for updating balls
	PINTER.doInteractions();
	MENU.update();
	if BALL.doPhysUp then
		GTIME = GTIME + dtime; --update global timer
    	physUpdate(dt*BALL.pTimeMult,TOUCHES);
	end
	PINTER.doKeyJobs();
end

function physUpdate(dtime,touches)
	local touchBalls = {};--variable holding indecies for the gravity points
	for k,v in ipairs(touches) do
		local xC = (touches[k][1] - BALL.ballCenter[1]) / BALL.ballScale ;
      	local yC = (touches[k][2]- BALL.ballCenter[2]) / BALL.ballScale ;
		touchBalls[k] = BALL.new(xC,yC,0,BALL.touchMass);
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
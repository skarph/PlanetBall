GTIME = 0; --global timer

function love.load()
	love.window.setMode(1400,1000);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	love.graphics.setCanvas(canvas);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	
	require("ball");
	require('vectorConstruct');
	require('gui');
	
	math.randomseed(os.time());
	
	local bC = 25 -- count of bodies
	local DfC = 50 --radius from center of bodies
	
	for i=1, bC do
		local id = BALL.new((winW/2)+(DfC*math.cos(math.pi*2*(i/bC))),(winH/2)+(DfC*math.sin(math.pi*2*(i/bC))),5,100); --spawn balls
		BALL.list[id].vel = V.vectorize({math.cos( math.pi*2*(i/bC) + (math.pi/2) ),math.sin(math.pi*2*(i/bC) + (math.pi/2))}):norm() * math.sqrt(BALL.G* 25 * 50 / 50); --set speed for semistable orbit
	end
	
	--[[idPar = BALL.new(winW/2,winH/2,50,50000)
	idSat = BALL.new(winW/2+150,winH/2,5,50)
	BALL.list[idSat].vel = V.vectorize({0,1}) * 
	math.sqrt(BALL.G*BALL.list[idPar].mass / ( BALL.list[idSat].pos - BALL.list[idPar].pos ):getMagnitude());]]
	--Uncoment for singular orbit
	
	doUpdate = false; --do updates for balls
	love.keyboard.setKeyRepeat(false);

	slide = SLIDER.new({200,50,400,100},-10,10,BALL.G,{nil,nil},"G CONST");--create new slider
	toggle = TOGGLE.new({winW - 100, winH - 100, winW, winH }, true, {nil,nil}, "Pause");--create new toggle
	timeMult = 1;
	touchMass = 500; --mass of invisible ball spawned upon click
	love.graphics.setCanvas(canvas);
	
end

function love.update(dt)
	slide:update();
	toggle:update();
	
	BALL.G = slide.value;
	
	doUpdate = not toggle.value;
	
	dtime = dt * timeMult --time delta used for updating balls
	
	if doUpdate then
		GTIME = GTIME + dtime; --update global timer
		local xC,yC;
		if love.mouse.isDown(1) then
			xC = love.mouse.getX();
			yC = love.mouse.getY();
		end
		update(dtime,xC,yC);
	end
end

function love.draw()
	
	love.graphics.setCanvas(canvas);
	--love.graphics.draw(canvas);
	for i=1, BALL.lastIndex do
		pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
	end
		
	love.graphics.setColor(255,255,255,255);
	
	love.graphics.setCanvas();
	
	love.graphics.setColor(0x00,0x00,0x00,0x1F);
	love.graphics.rectangle('fill',0,0,winW,winH);
	love.graphics.setBlendMode("alpha", "alphamultiply");
	love.graphics.setColor(0xFF,0xFF,0xFF,0x0F);
	love.graphics.draw(canvas);
	love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
	slide:render();
	toggle:render();

	for i=1, BALL.lastIndex do
		pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
	end
	
	love.graphics.print(GTIME,0,0);
	
end

function love.keypressed( key, scancode, isrepeat ) --update toggle
	
	if key == "space" and not isrepeat then
		toggle.value = not toggle.value; --toggle toggle value
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
GTIME = 0; --global timer

function love.load()
	
	require("ball");
	require('vectorConstruct');
	love.window.setMode(1400,1000);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	
	math.randomseed(os.time());
	idPar = BALL.new(winW/2,winH/2,50,50000)
	idSat = BALL.new(winW/2+150,winH/2,5,50)
	BALL.list[idSat].vel = V.vectorize({0,1}) * 
	math.sqrt(BALL.G*BALL.list[idPar].mass / ( BALL.list[idSat].pos - BALL.list[idPar].pos ):getMagnitude());
	doUpdate = false;
end

function love.update(dt)
	
	if doUpdate then
		GTIME = GTIME + dt; --update global timer
		err,msg = pcall(update,dt);
	end
	canvas:renderTo(function() --draw balls to canvas
		love.graphics.setColor(0x00,0x00,0x00,0x0F);
		love.graphics.rectangle('fill',0,0,winW,winH);
		for i=1, BALL.lastIndex do
			pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
		end
	end);
	
	if love.keyboard.isDown("space") then
		doUpdate = false
	else
		doUpdate = true
	end
end

function love.draw()
	love.graphics.setColor(255,255,255,255);
	love.graphics.draw(canvas);
	love.graphics.print(GTIME,0,0);
end

function update(dt)
	BALL.grav(); --solve gravity
	BALL.doCollisions(); --solve any collisions
	
	for i=1, BALL.lastIndex do --updating solved per ball. May be useful when deciding to 'speed up' some balls.
		if BALL.list[i] then
			BALL.list[i]:update(dt);
			print(GTIME.."|UPDATE> ".."BALL"..i..".vel= {"..BALL.list[i].vel[1]..","..BALL.list[i].vel[2] .."}\n\tBALL"..i..".acc= {"..BALL.list[i].acc[1]..","..BALL.list[i].acc[2].."}");
			print('\n');
		end
	end
	print('\n');
end
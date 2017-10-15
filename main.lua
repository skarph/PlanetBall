GTIME = 0; --global timer

function love.load()
	
	require("ball");
	require('vectorConstruct');
	love.window.setMode(1400,1000);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	
	math.randomseed(os.time());
	DfC = 300 --ball's spawn distance from center (form in circle)
	bC = 10 --ball count
	
	for i=1, bC do
		BALL.new((winW/2)+(DfC*math.cos(math.pi*2*(i/bC))),(winH/2)+(DfC*math.sin(math.pi*2*(i/bC))),5,100);
	end
	
end

function love.update(dt)
	GTIME = GTIME + dt; --update global timer
	
	BALL.grav(); --solve gravity
	BALL.doCollisions(); --solve any collisions
	
	for i=1, BALL.lastIndex do --updating solved per ball. May be useful when deciding to 'speed up' some balls.
		if BALL.list[i] then
			BALL.list[i]:update(dt);
		end
	end
	
	canvas:renderTo(function() --draw balls to canvas
		love.graphics.setColor(0x00,0x00,0x00,0x0F);
		love.graphics.rectangle('fill',0,0,winW,winH);
		for i=1, BALL.lastIndex do
			pcall(BALL.draw,BALL.list[i]);--incase BALL[i]==nil
		end
	end);
	
end

function love.draw()
	love.graphics.setColor(255,255,255,255);
	love.graphics.draw(canvas); 
end
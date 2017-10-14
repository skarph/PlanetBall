GTIME = 0; --global timer
function love.load()
	require("ball");
	require('vectorConstruct');
	love.window.setMode(1400,1000);
	winW , winH = love.graphics.getDimensions();
	canvas = love.graphics.newCanvas(winW,winH);
	rCheck = 0.0;
	math.randomseed(os.time());
	id1 = BALL.new(winW/2,(winH/2)-50,5,100);
	id2 = BALL.new((winW/2),(winH/2)+50,5,100);
	id3 = BALL.new((winW/2)+50,(winH/2),5,100);
	print(id1,id2,id3);
	print('=============================');
end

function love.update(dt)
	GTIME = GTIME + dt;
	math.randomseed(os.time());
	
	BALL.doCollisions();
	BALL.grav();
	for i=1, BALL.lastIndex do
		if BALL.list[i] then
			BALL.list[i]:update(dt);
		end
	end
	canvas:renderTo(function()
		love.graphics.setColor(0xFF,0xFF,0xFF,0x0F);
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
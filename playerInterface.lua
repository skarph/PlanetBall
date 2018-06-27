PINTER = {};
COMMAND = {};
COMMAND.PANUP = {key = "up"};
COMMAND.PANDOWN = {key = "down"};
COMMAND.PANLEFT = {key = "left"};
COMMAND.PANRIGHT = {key = "right"};
COMMAND.ROTCW = {key = "."};
COMMAND.ROTCCW = {key = ","};
COMMAND.ZOOMIN = {key = "="};
COMMAND.ZOOMOUT = {key = "-"};
COMMAND.PAUSE = {key = "space"};
COMMAND.ASSIGN = {key = "escape"};

TOUCHES = {};

function PINTER.doInteractions()
  returnTable = {};
  touches = love.touch.getTouches();
  local mouse = 0;
  if(love.mouse.isDown(1)) then
    returnTable[1] = {};
    returnTable[1][1] = love.mouse.getX();
    returnTable[1][2] = love.mouse.getY();
    returnTable[1] = V.vectorize(returnTable[1])
    mouse = 1;
  end
  for k, v in ipairs(touches) do
    returnTable[k+mouse] = {};
    returnTable[k+mouse][1] , returnTable[k+mouse][2] = love.touch.getPosition(touches[k]);
    returnTable[k+mouse] = V.vectorize(returnTable[k+mouse]);
  end
	
  for k,v in ipairs(returnTable) do
    local i=k+1
    while(not(returnTable[i]==nil)) do
		dist = returnTable[k]:distTo(returnTable[i]);
		if(dist<100) then
			local midpoint = (returnTable[k]+returnTable[i-1])/2;
			BALL.cenTar = BALL.cenTar + (midpoint-BALL.cenTar);
			table.remove(returnTable,k);
			table.remove(returnTable,i);
		end
		i = i + 1;
	end
  end
  TOUCHES = returnTable;
end

function PINTER.getKeyAssignment(key)
	for k,v in pairs(COMMAND) do
		if COMMAND[k].key == key then
			return COMMAND[k];
		end
	end
	return nil;
end

function PINTER.doKeyJobs()
	for job,v in pairs(COMMAND) do
  	  	if(love.keyboard.isDown(COMMAND[job].key)) then
			
			COMMAND[job].callback(false,false,true);
    	end
	end
end
------------------------------------------------------------------------------
---------------------------BUTTON CALLBACKS START!----------------------------
------------------------------------------------------------------------------

function COMMAND.PANUP.callback(pressed,released,held)
  if(not pressed and not released) then
    BALL.cenTar[2] = BALL.cenTar[2] - 5;
  end
end

function COMMAND.PANDOWN.callback(pressed,released,held)
	if(not pressed and not released) then
    BALL.cenTar[2] = BALL.cenTar[2] + 5;
  end
end

function COMMAND.PANLEFT.callback(pressed,released,held)
  if(not pressed and not released) then
	  BALL.cenTar[1] = BALL.cenTar[1] - 5;
  end
end

function COMMAND.PANRIGHT.callback(pressed,released,held)
  if(not pressed and not released) then
	  BALL.cenTar[1] = BALL.cenTar[1] + 5;
  end
end

function COMMAND.ZOOMIN.callback(pressed,released,held)
	 if(not pressed and not released) then
		BALL.ballScale = BALL.ballScale + 0.01*BALL.ballScale;
		BALL.cenTar = BALL.cenTar + ((BALL.cenTar-V.vectorize({winW/2,winH/2})) * 0.01);
		BALL.ballCenter = BALL.ballCenter + ((BALL.ballCenter-V.vectorize({winW/2,winH/2})) * 0.01);
	end
end
function COMMAND.ZOOMOUT.callback(pressed,released,held)
	 if(not pressed and not released) then
		BALL.ballScale = BALL.ballScale - 0.01*BALL.ballScale;
		BALL.cenTar = BALL.cenTar - ((BALL.cenTar-V.vectorize({winW/2,winH/2})) * 0.01);
		BALL.ballCenter = BALL.ballCenter - ((BALL.ballCenter-V.vectorize({winW/2,winH/2})) * 0.01);
	end
end

function COMMAND.PAUSE.callback(pressed,released,held)
	if(released and not BALL.doPhysUp and not(COMMAND.PAUSE.wasHeld)) then
		BALL.doPhysUp = true;
	elseif(pressed and BALL.doPhysUp ) then
		BALL.doPhysUp = false;
		COMMAND.PAUSE.wasHeld = true;
	end
	if(released) then
		COMMAND.PAUSE.wasHeld = false;
	end
end

function COMMAND.ASSIGN.callback(pressed,released,held)
end
PINTER = {};
COMMAND = {};
PINTER.COOLCONST = 0;
PINTER.coolTime = PINTER.COOLCONST;
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

function PINTER.getInteractions()
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
		if(dist<75 and PINTER.coolTime < 0) then
			print(BALL.cenTar[1],BALL.cenTar[2]);
			local midpoint = (returnTable[k]+returnTable[i-1])/2;
			BALL.cenTar = BALL.cenTar + (midpoint-BALL.cenTar);
			print(BALL.cenTar[1],BALL.cenTar[2]);
			PINTER.coolTime = PINTER.COOLCONST;
			return {};	
		end
		i = i + 1;
	end
  end
  return returnTable;
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

function COMMAND.ROTCW.callback(pressed,released,held)
	
end

function COMMAND.ROTCCW.callback(pressed,released,held)
	
end

function COMMAND.ZOOMIN.callback(pressed,released,held)
	BALL.ballScale = BALL.ballScale + 0.01;
end

function COMMAND.ZOOMOUT.callback(pressed,released,held)
	BALL.ballScale = BALL.ballScale - 0.01;
end

function COMMAND.PAUSE.callback(pressed,released,held)
	if(released and not doUpdate and not(COMMAND.PAUSE.wasHeld)) then
		doUpdate = true;
	elseif(pressed and doUpdate ) then
		doUpdate = false;
		COMMAND.PAUSE.wasHeld = true;
	end
	if(released) then
		COMMAND.PAUSE.wasHeld = false;
	end
end

function COMMAND.ASSIGN.callback(pressed,released,held)
end
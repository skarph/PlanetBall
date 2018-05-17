PINTER = {}

function PINTER.getInteractions()
  returnTable = {};
  touches = love.touch.getTouches();
  if(love.mouse.isDown(1)) then
    returnTable[1] = {};
    returnTable[1].x = love.mouse.getX();
    returnTable[1].y = love.mouse.getY();
  end
  for k, v in ipairs(touches) do
    returnTable[k].x , returnTable[k].y = love.touch.getPosition();
  end
  return returnTable;
end

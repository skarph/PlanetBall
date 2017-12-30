----------------------------------------------------------------------
SLIDER = {}
SLIDER.__index = SLIDER;
	
	function SLIDER.new(dim,range,varStr,scale,title)
		local self = {};

		if dim[1] > dim[3] then
			self.x2 = dim[1]
			self.x1 = dim[3]
		else
			self.x1 = dim[1]
			self.x2 = dim[3]
		end
	
		if dim[2] > dim[4] then
			self.y2 = dim[2];
			self.y1 = dim[4];
		else
			self.y1 = dim[2];
			self.y2 = dim[4];
		end
		
		local parentTab = _G;
		local lastIndex = 0;
		local finalIndex = "";
		
		if type(varStr)=="table" then
			if varStr[2] then --variable is a child of another table
				for k,v in ipairs(varStr) do
					if varStr[k+1] then
						parentTab = parentTab[varStr[k]];
						lastIndex = lastIndex + 1;
					else
						finalIndex = varStr[k];
						break;
					end
				end
			else
				parentTab = _G;
				finalInex = varStr[1];
			end
		else
		
		--Variable is a child of global
		parentTab = _G;
		finalIndex = varStr;
		
		end
	
		self.parentTable = parentTab
		self.varIndex = finalIndex;
		
		self.textScale = scale; --scale for text
		
		self.slideMin = range[1] or 1;
		self.slideMax = range[2] or 10;
		self.parentTable[self.varIndex] = range[3] or self.parentTable[self.varIndex]; 
		self.slideX = self.x1; --slider circle thingy
		self.slideY = (self.y1+self.y2)/2;
	
		self.title = title; --used to display value along with value
		self.lock = false; --if true, value canno be changed
		self.label = self.title -- display value
		setmetatable(self,SLIDER);
		self:update(); --updates table
		--renders tabl
		return self;
	end

	function SLIDER.render(self)
			love.graphics.print(self.label,self.x1,self.y1,0,self.textScale[1],self.textScale[2]);--prints label
			love.graphics.line(self.x1,(self.y1+self.y2)/2,self.x2,(self.y1+self.y2)/2);--draws slide
			love.graphics.circle("fill",self.slideX,self.slideY,3);--draws slider
	end

	function SLIDER.update(self)
		self.label = self.title.."; "..self.parentTable[self.varIndex]; --sets value initially so return; checks don't interrupt update
		self.slideX = ( (self.parentTable[self.varIndex] - self.slideMin) * math.abs(self.x2-self.x1) ) / math.abs(self.slideMax-self.slideMin) + self.x1;
	
		if self.lock then return; end
		
		if not love.mouse.isDown(1) then return; end
		local inbounds = 
			self.x1<=love.mouse.getX() and
			self.y1<=love.mouse.getY() and
			self.x2>=love.mouse.getX() and
			self.y2>=love.mouse.getY();
		if not inbounds then return; end
		
		self.slideX =  love.mouse.getX()
		
		if self.slideX<self.x1 then
			self.slideX = self.x1;
		elseif self.slideX>self.x2 then
			self.slideX = self.x2;
		end
		
		self.parentTable[self.varIndex] = (( math.abs(self.slideMax-self.slideMin) / math.abs(self.x2-self.x1) ) * (self.slideX - self.x1) + self.slideMin); --sets value from position
		
		if self.parentTable[self.varIndex]>self.slideMax then
			self.parentTable[self.varIndex] = self.slideMax; --caps out value
		end
	end
----------------------------------------------------------------------
DISPLAY = {}
----------------------------------------------------------------------
TOGGLE = {}
TOGGLE.__index = TOGGLE
	
	function TOGGLE.new(dim,value,varStr,scale,title)
		local self = {};
		
		if dim[1] > dim[3] then
			self.x2 = dim[1]
			self.x1 = dim[3]
		else
			self.x1 = dim[1]
			self.x2 = dim[3]
		end
	
		if dim[2] > dim[4] then
			self.y2 = dim[2];
			self.y1 = dim[4];
		else
			self.y1 = dim[2];
			self.y2 = dim[4];
		end
	
		local parentTab = _G;
		local lastIndex = 0;
		local finalIndex = "";
		
		if type(varStr)=="table" then
			if varStr[2] then --variable is a child of another table
				for k,v in ipairs(varStr) do
					if varStr[k+1] then
						parentTab = parentTab[varStr[k]];
						lastIndex = lastIndex + 1;
					else
						finalIndex = varStr[k];
						break;
					end
				end
			else
				parentTab = _G;
				finalInex = varStr[1];
			end
		else
		
		--Variable is a child of global
		parentTab = _G;
		finalIndex = varStr;
		
		end
	
		self.parentTable = parentTab
		self.varIndex = finalIndex;
	
		self.parentTable[self.varIndex] = value;
		self.title = title;
		self.lock = false;
		self.label = self.title
		self.scale = scale;
		self.held = false; --boolean on whether or not the button is being held
		setmetatable(self,TOGGLE);
	
		self.label = self.title.."; "..tostring(self.parentTable[self.varIndex]);
		return self;
	end

	function TOGGLE.render(self)
		if not self.parentTable[self.varIndex] then
			love.graphics.rectangle("line",self.x1,self.y1,self.x2,self.y2);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
		else
			love.graphics.rectangle("fill",self.x1,self.y1,self.x2,self.y2);
			local oldC = {love.graphics.getColor()};
			love.graphics.setColor(255-oldC[1],255-oldC[2],255-oldC[3],oldC[4]);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
			love.graphics.setColor(oldC);
		end
	end
	
	function TOGGLE.update(self)
		self.label = self.title.."; "..tostring(self.parentTable[self.varIndex]);
	
		if not love.mouse.isDown(1) then
			self.held = false;
			return;
		end
	
		if self.lock or self.held then return; end	
		
		local inbounds = 
			self.x1<=love.mouse.getX() and
			self.y1<=love.mouse.getY() and
			self.x2>=love.mouse.getX() and
			self.y2>=love.mouse.getY();
		
		if not inbounds then return; end
		
		self.held = true;
		
		self.parentTable[self.varIndex] = not self.parentTable[self.varIndex];
	end

----------------------------------------------------------------------
BUTTON = {}
BUTTON.__index = BUTTON
	
	function BUTTON.new(dim,func,varStr,scale,title)
		self = {};
	
		if dim[1] > dim[3] then
			self.x2 = dim[1]
			self.x1 = dim[3]
		else
			self.x1 = dim[1]
			self.x2 = dim[3]
		end
	
		if dim[2] > dim[4] then
			self.y2 = dim[2];
			self.y1 = dim[4];
		else
			self.y1 = dim[2];
			self.y2 = dim[4];
		end
		
		self.textScale = scale;
		self.func = func;
		self.scale = scale;
		self.title = title;
		self.lock = false;
		self.label = self.title
	
		self.held = false; --boolean on whether or not the button is being held
		setmetatable(self,BUTTON);
	
		self.label = self.title;
		return self;
	end

	function BUTTON.render(self)
		if not self.held then
			love.graphics.rectangle("line",self.x1,self.y1,self.x2,self.y2);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
		else
			love.graphics.rectangle("fill",self.x1,self.y1,self.x2,self.y2);
			local oldC = {love.graphics.getColor()};
			love.graphics.setColor(255-oldC[1],255-oldC[2],255-oldC[3],oldC[4]);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
			love.graphics.setColor(oldC);
		end
	end
	
	function BUTTON.update(self)
		self.label = self.title;
	
		if not love.mouse.isDown(1) then
			self.held = false;
			return;
		end
	
		if self.lock or self.held then return; end	
		
		local inbounds = 
			self.x1<=love.mouse.getX() and
			self.y1<=love.mouse.getY() and
			self.x2>=love.mouse.getX() and
			self.y2>=love.mouse.getY();
		
		if not inbounds then return; end
		
		self.held = true;
		self.func();
	end

-------------------------------------------------------------------------------------
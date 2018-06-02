----------------------------------------------------------------------
SLIDER = {}
SLIDER.__index = SLIDER;
	
	function SLIDER.new(dim,range,varStr,font,scale,title,img,quads)
		local self = {};

		self.x1 = dim[1];
		self.dX = dim[3];
	
		self.y1 = dim[2];
		self.dY = dim[4];
		
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
		self.slideY = (self.y1+self.dY)*0.5;
	
		self.title = title; --used to display value along with value
		self.lock = false; --if true, value canno be changed
		self.label = self.title -- display value
		self.font= font or love.graphics.getFont() or love.graphics.getFont();
		self.img = img;
		self.quads = quads or {
			love.graphics.newQuad(0,0,self.img:getWidth(),self.img:getHeight()*0.25,self.img:getDimensions()),
			love.graphics.newQuad(0,self.img:getHeight()*0.25,self.img:getWidth(),self.img:getHeight()*0.25,self.img:getDimensions()),
			love.graphics.newQuad(0,self.img:getHeight()*0.5,self.img:getWidth()*0.25,self.img:getHeight()*0.5,self.img:getDimensions()),
			love.graphics.newQuad(self.img:getWidth()*0.75,self.img:getHeight()*0.5,self.img:getWidth()*0.25,self.img:getHeight()*0.5,self.img:getDimensions())
			}
		self.held = false;
		setmetatable(self,SLIDER);
		self:update(); --updates table
		--renders tabl
		return self;
	end

	function SLIDER.render(self)
		local oldFont = love.graphics.getFont();
		love.graphics.setFont(self.font);
		
		love.graphics.print(self.label,self.x1,self.y1,0,self.textScale[1],self.textScale[2]);--prints label
	
		if self.held then
			love.graphics.draw(self.img,self.quads[1],self.x1,((self.y1+self.dY)*0.5)-(self.img:getWidth()*0.0625),nil,self.dX/self.img:getWidth(),1);
			love.graphics.draw(self.img,self.quads[4],self.slideX-(self.img:getWidth()*0.0625),((self.y1+self.dY)*0.5)-(self.img:getWidth()*0.125));--draws slider	
		
		else
			love.graphics.draw(self.img,self.quads[2],self.x1,((self.y1+self.dY)*0.5)-(self.img:getWidth()*0.0625),nil,self.dX/self.img:getWidth(),1);
			love.graphics.draw(self.img,self.quads[3],self.slideX-(self.img:getWidth()*0.125),((self.y1+self.dY)*0.5)-(self.img:getWidth()*0.125));--draws slider
		end
		love.graphics.setFont(oldFont);
	end

	function SLIDER.update(self)
		self.label = self.title.."; "..self.parentTable[self.varIndex]; --sets value initially so return; checks don't interrupt update
		self.slideX = (self.dX*((self.parentTable[self.varIndex]-self.slideMin)/(self.slideMax-self.slideMin)))+self.x1;
		self.held = false;
		if self.lock then return; end
		
		local acts = PINTER.getInteractions();
		if not acts[1] then return; end
		local inbounds;
		for k,v in ipairs(acts) do
			if(self.x1<=acts[k][1] and self.y1<=acts[k][2] and self.dX+self.x1>=acts[k][1] and self.dY+self.y1>=acts[k][2]) then
				inbounds = k;
			end
		end
	
		if not inbounds then return; end
		self.held = true;
		self.slideX = acts[inbounds][1];
		self.parentTable[self.varIndex] = (self.slideMax-self.slideMin)*((self.slideX-self.x1)/self.dX) + self.slideMin;
	end
----------------------------------------------------------------------
DISPLAY = {}
----------------------------------------------------------------------
TOGGLE = {}
TOGGLE.__index = TOGGLE
	
	function TOGGLE.new(dim,value,varStr,font,scale,title,img,quads)
		local self = {};
		
		self.x1 = dim[1];
		self.dX = dim[3];
	
		self.y1 = dim[2];
		self.dY = dim[4];
	
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
		self.img = img;
		self.quads = quads or {
			love.graphics.newQuad(0,0,self.img:getWidth(),self.img:getHeight()*0.5,self.img:getDimensions()),
			love.graphics.newQuad(0,self.img:getHeight()*0.5,self.img:getWidth(),self.img:getHeight()*0.5,self.img:getDimensions())
			}
		self.parentTable[self.varIndex] = value;
		self.title = title;
		self.lock = false;
		self.label = self.title
		self.scale = scale;
		self.held = false; --boolean on whether or not the button is being held
		setmetatable(self,TOGGLE);
		self.font = font or love.graphics.getFont();
		self.label = self.title.."; "..tostring(self.parentTable[self.varIndex]);
		return self;
	end

	function TOGGLE.render(self)
		local oldFont = love.graphics.getFont();
		love.graphics.setFont(self.font);
		
		if not self.parentTable[self.varIndex] then
			love.graphics.draw(self.img,self.quads[2],self.x1,self.y1,nil,self.dX/self.img:getWidth(),self.dY/(self.img:getHeight()*0.5));
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
		else
			love.graphics.draw(self.img,self.quads[1],self.x1,self.y1,nil,self.dX/self.img:getWidth(),self.dY/(self.img:getHeight()*0.5));
			local oldC = {love.graphics.getColor()};
			love.graphics.setColor(255-oldC[1],255-oldC[2],255-oldC[3],oldC[4]);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
			love.graphics.setColor(oldC);
		end
	
		love.graphics.setFont(oldFont);
	end
	
	function TOGGLE.update(self)
		self.label = self.title.."; "..tostring(self.parentTable[self.varIndex]);
		local acts = PINTER.getInteractions();
		if not acts[1] then
			self.held = false;
			return;
		end
	
		if self.lock or self.held then return; end	
		
		if not acts[1] then return; end
		local inbounds;
		for k,v in ipairs(acts) do
			if(self.x1<=acts[k][1] and self.y1<=acts[k][2] and (self.dX+self.x1)>=acts[k][1] and (self.dY+self.y1)>=acts[k][2]) then
				inbounds = k;
			end
		end
		
		if not inbounds then return; end
		
		self.held = true;
		
		self.parentTable[self.varIndex] = not self.parentTable[self.varIndex];
	end

----------------------------------------------------------------------
BUTTON = {}
BUTTON.__index = BUTTON
	
	function BUTTON.new(dim,func,varStr,font,scale,title,img,quads)
		self = {};
		self.x1 = dim[1];
		self.dX = dim[3];
	
		self.y1 = dim[2];
		self.dY = dim[4];
		
		self.textScale = scale;
		self.func = func;
		self.scale = scale;
		self.title = title;
		self.lock = false;
		self.label = self.title
	
		self.held = false; --boolean on whether or not the button is being held
		setmetatable(self,BUTTON);
		
		self.label = self.title;
		
		self.img = img;
		self.quads = quads or {
			love.graphics.newQuad(0,0,self.img:getWidth(),self.img:getHeight()*0.5,self.img:getDimensions()),
			love.graphics.newQuad(0,self.img:getHeight()*0.5,self.img:getWidth(),self.img:getHeight()*0.5,self.img:getDimensions())
			}
		self.font= font or love.graphics.getFont();
		return self;
	end

	function BUTTON.render(self)
		local oldFont = love.graphics.getFont();
		love.graphics.setFont(self.font);
		if not self.held then
			love.graphics.draw(self.img,self.quads[2],self.x1,self.y1,nil,self.dX/self.img:getWidth(),self.dY/(self.img:getHeight()*0.5));
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
		else
			love.graphics.draw(self.img,self.quads[1],self.x1,self.y1,nil,self.dX/self.img:getWidth(),self.dY/(self.img:getHeight()*0.5));
			local oldC = {love.graphics.getColor()};
			love.graphics.setColor(255-oldC[1],255-oldC[2],255-oldC[3],oldC[4]);
			love.graphics.print(self.label,self.x1,self.y1,0,self.scale[1],self.scale[2]);
			love.graphics.setColor(oldC);
		end
		love.graphics.setFont(oldFont);
	end
	
	function BUTTON.update(self)
		self.label = self.title;
		local acts = PINTER.getInteractions();
		if not acts[1] then
			self.held = false;
			return;
		end
	
		if self.lock then return; end	
		
		local acts = PINTER.getInteractions();
		if not acts[1] then return; end
		local inbounds;
		for k,v in ipairs(acts) do
			if(self.x1<=acts[k][1] and self.y1<=acts[k][2] and (self.dX+self.x1)>=acts[k][1] and (self.dY+self.y1)>=acts[k][2]) then
				inbounds = k;
			end
		end
		
		if not inbounds then return; end
		
		self.func(self.held);
		self.held = true;
	end

-------------------------------------------------------------------------------------
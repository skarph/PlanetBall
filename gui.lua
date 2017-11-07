----------------------------------------------------------------------
SLIDER = {}
SLIDER.__index = SLIDER;
	
	function SLIDER.new(dim,min,max,init,scale,title)
		local self = {};
		self.x1 = dim[1];--left bound
		self.y1 = dim[2];--bottom bound
		self.x2 = dim[3];--right bound
		self.y2 = dim[4];--top bound

		self.textScale = scale; --scale for text
		self.value = init; -- initial value
		self.slideMin = min or 1;
		self.slideMax = max or 10;

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
		self.label = self.title.."; "..self.value; --sets value initially so return; checks don't interrupt update
		self.slideX = ( (self.value - self.slideMin) * math.abs(self.x2-self.x1) ) / math.abs(self.slideMax-self.slideMin) + self.x1;
	
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
		
		self.value = (( math.abs(self.slideMax-self.slideMin) / math.abs(self.x2-self.x1) ) * (self.slideX - self.x1) + self.slideMin); --sets value from position
		
		if self.value>self.slideMax then
			self.value = self.slideMax; --caps out value
		end
	end
----------------------------------------------------------------------
DISPLAY = {}
----------------------------------------------------------------------
TOGGLE = {}
TOGGLE.__index = TOGGLE
	
	function TOGGLE.new(dim,value,scale,title)
		local self = {};
		self.x1 = dim[1];
		self.y1 = dim[2];
		self.x2 = dim[3];
		self.y2 = dim[4];

		self.textScale = scale;
		self.value = value;
		
		self.scale = scale or {1,10};
		self.title = title;
		self.lock = false;
		self.label = self.title
	
		self.held = false; --boolean on whether or not the button is being held
		setmetatable(self,TOGGLE);
	
		self.label = self.title.."; "..tostring(self.value);
		return self;
	end

	function TOGGLE.render(self)
		if not self.value then
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
		self.label = self.title.."; "..tostring(self.value);
	
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
		
		self.value = not self.value;
	end

----------------------------------------------------------------------
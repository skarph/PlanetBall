
BALL = {}

BALL.list={}-->>table that contains all balls

BALL.lastIndex=0;--Last index of BALL.list

BALL.G = 1 -->>Gravititational constant

function BALL.getNewID() -->>gets a new id for a new ball 'obj'
	local returnVal = 1;
	for i=1,BALL.lastIndex+1 do
		if not BALL.list[i] then returnVal = i end
		BALL.lastIndex = i;
	end
	return returnVal;
end

function BALL.doCollisions() -->>does collision check for all balls
	for i=1, BALL.lastIndex do
		for j=i+1, BALL.lastIndex do
			if BALL.list[i] and BALL.list[j] then
				if (not(BALL.list[i].colCheck[j] and BALL.list[j].colCheck[i])) and (BALL.list[i].iFrames==0 and BALL.list[j].iFrames==0)  then --AAAAAAAAAAAAAAAAAAAAAAAAAAAA
					--If the balls have not colided and neither ball has invincibility, although they shouldn'tve collieded. *shrug*
					if (BALL.list[i].pos-BALL.list[j].pos):getMagnitude()<0.75*(BALL.list[i].rad+BALL.list[j].rad) then --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
						BALL.list[i].colCheck[j] = true;
						BALL.list[j].colCheck[i] = true;
						BALL.eat(BALL.list[i],BALL.list[j]);
					end
				end
			end
		end
	end
end

function BALL.new(x,y,rad,mass,color) -->> creates a new ball object, stores object in BALL.list, returns id of ball
	local self = {};
	setmetatable(self,{__index=BALL});
	self.id = BALL.getNewID();
	self.pos = V.vectorize({x,y});
	self.rad = rad; --radius
	self.mass = mass; --mass, arb. unit
	self.color = color or {math.ceil(math.random()*0xFF),math.ceil(math.random()*0xFF),math.ceil(math.random()*0xFF),0xFF} --color or random
	self.dir = 0; --radians
	self.vel = V.vectorize({0,0});--units/sec
	self.acc = V.vectorize({0,0}); --units/sec^2
	self.spin = 0;--quantum unit, jk, not used as of now
	self.colCheck = {}--collision check litt
	self.hasCol = {};--post-solve list
	self.iFrames = 0;--time where colls don't count
	BALL.list[self.id] = self;
	return self.id;
end

function BALL.update(self,dt)--UPDATE
	if self==nil then return; end
	self.colCheck = {};
	self.hasCol = {};
	self.pos = self.pos + (dt*self.vel);
	print(GTIME..'> UPDATE: '..self.id..".acc == "..self.acc[1]..","..self.acc[2]);
	self.vel = self.vel + (dt*self.acc);
	self.rad = self.rad+(self.spin*0.25)--increase/decrease radius based on spin. quadratic (0,0)->(1,1), vertex (0.25,-0.125)
	
	if not(self.iFrames==0) then --update invincibility
		self.iFrames=self.iFrames-dt
	end
end

function BALL.eat(ball1,ball2)-->>adds all of the properties of the greater radius ball to lesser radius, destroys lesser
	
	if ball2.rad>ball1.rad then
		ball2.rad = ball2.rad+ball1.rad
		--ball2.spin = ball2.spin+ball1.spin + math.abs(((ball2.vel-ball1.vel)/ball2.vel):getMagnitude())
		ball2.vel = (ball2.vel * (ball2.mass/(ball2.mass+ball1.mass))) + (ball1.vel * (ball1.mass/(ball2.mass+ball1.mass)));--upadte vel on percent weight
		ball2.mass = ball2.mass+ball1.mass;--add mass
		ball2.color = {(ball2.color[1]+ball1.color[1])*0.5,(ball2.color[2]+ball1.color[2])*0.5,(ball2.color[3]+ball1.color[3])*0.5,(ball2.color[4]+ball1.color[4])*0.5}; --mix color, fix later
		ball2.acc = V.vectorize({0,0});--nerf acceleration
		BALL.list[ball1.id]=nil;--destroy other
	else
		ball1.rad = ball1.rad+ball2.rad; --ditto
		--ball1.spin = ball1.spin+ball2.spin + math.abs(((ball1.vel-ball2.vel)/ball1.vel):getMagnitude())
		ball1.vel = (ball1.vel * (ball1.mass/(ball1.mass+ball2.mass))) + (ball2.vel * (ball2.mass/(ball1.mass+ball2.mass)));
		ball1.mass = ball1.mass+ball2.mass;
		ball1.color = {(ball2.color[1]+ball1.color[1])*0.5,(ball2.color[2]+ball1.color[2])*0.5,(ball2.color[3]+ball1.color[3])*0.5,(ball2.color[4]+ball1.color[4])*0.5};
		ball1.acc = V.vectorize({0,0});
		BALL.list[ball2.id]=nil;
	end
end

function BALL.draw(self)
	local mR,mG,mB,mA = love.graphics.getColor();
	love.graphics.setColor(self.color);
	love.graphics.circle('fill',self.pos[1],self.pos[2],self.rad);--draw self *shrug*
	love.graphics.setColor(mR,mG,mB,mA);
end

function BALL.grav() -->>similar to doCollisions, does not play nice when integrated with doCollisions
	for i=1, BALL.lastIndex do
		for j=i+1, BALL.lastIndex do
			if BALL.list[i] and BALL.list[j] then
				
				BALL.list[i].acc = BALL.list[i].acc + ((BALL.G*BALL.list[i].mass*BALL.list[j].mass)/((BALL.list[i].pos - BALL.list[j].pos)*(BALL.list[i].pos - BALL.list[j].pos))/BALL.list[i].mass)
				--applies force divided by mass (acceleration)
				BALL.list[j].acc = BALL.list[j].acc + (-1*((BALL.G*BALL.list[i].mass*BALL.list[j].mass)/((BALL.list[i].pos - BALL.list[j].pos)*(BALL.list[i].pos - BALL.list[j].pos))/BALL.list[j].mass))
				--inverts for opposite vector
				print(GTIME..'> GRAV: '..i..'>'..j)
				print(GTIME..'> GRAV: '..i..'<'..j)
			end
		end
	end
	print('\n');
end
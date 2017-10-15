# Planet Ball 
## Version 0.0.2 PRE-ALPHA
### *A planetary golf-like game built on LÖVE 0.10.2*

Comments in the code attempt to explain any functions. Contact for clarification/updating comments.

#### OVERVIEW:
A golf game. A player must combine all 'balls' on screen in order to win.
Balls are naturally attracted to eachother, and may start orbits around eachother.
Players can click/touch on the screen to create gravity wells to which the balls are attracted to.
Lower time spent using/creating these wells will result in a higher score.

##### IMPORTANT TODO:

- [x] Objective Ball System
- [x] Collision System:
- [x] Gravity :exclamation: FIX :exclamation:
- [ ] (Re)Implement spin mechanic
- [ ] Creation of ball objects in game (GUI)
- [ ] Make collisions more realistic (see example included, resulting 'ball' off-center
##### SLIGHTLY LESS IMPORTANT TODO:

- [ ] Fix canvas burn
- [ ] Make rudimentary debug system
- [ ] Find a way to combine collision checking and gravity
- [ ] Rudimentary GUI

##### LONG TERM GOALS:
1. Make game visually appealing
1. Add pause function
1. Levels, progression
1. Level Designer [?]

#### SPECIFICS:
Balls have their own:
* Color
* Mass
* Radius
* Position
* Velocity
* Acceleration
	
A player can create an invisible 'ball' upon interaction with the game.
It has no color, velocity, acceleration, or radius, and has a constant mass; This is to encourage planning of the use of one's clicking.
	
Powerups [Ideas]:
* Mass-of-Click upgrade/downgrade	
* Speedup/Slowdown for individual balls
* 'God Mode': allows for the immediate stop of any ball upon click/interaction
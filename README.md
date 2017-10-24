# Planet Ball 
## Version 0.0.2a PRE-ALPHA
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
- [x] Gravity
- [ ] (Re)Implement spin mechanic
- [ ] Creation of ball objects in game (GUI) :exclamation:
##### SLIGHTLY LESS IMPORTANT TODO:

- [ ] Fix canvas burn :exclamation:
- [ ] Make rudimentary debug system :exclamation:
- [ ] Find a way to combine collision checking and gravity
- [ ] Rudimentary GUI :exclamation:

##### LONG TERM GOALS:
* Make game visually appealing
* Add pause function
* Levels, progression
* Level Designer [?]

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

#### RELEASE HISTORY:

0.0.0: initial collision/physics work, never released

0.0.1: removed spin mechanic, fixed collisions crashing game; code cleaning

0.0.2: fixed bug where gravity did not properly attract; code cleaning

|a: fixed other gravity bug
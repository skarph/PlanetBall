# Planet Ball 
## Version 0.3.0 BETA-DEMO
### *A planetary golf-like game built on LÖVE 0.10.2*

Comments in the code attempt to explain any functions. Contact for clarification/updating comments.

#### OVERVIEW:
A golf game. A player must combine all 'balls' on screen in order to win.
Balls are naturally attracted to each other, and may start orbits around each other.
Players can click/touch on the screen to create gravity wells to which the balls are attracted to.
Lower time spent using/creating these wells will result in a higher score.

##### FEATURES
- [x] Objective Ball System
- [x] Collision System
- [x] Adjustable Gravity
- [x] Two whole levels
- [x] Level select
- [x] Menus
- [x] Some good design
- [x] Trails
- [x] Touch controls
- [x] Camera Panning and zooming
- [x] fancy-smanshy graphics
- [x] Level Loader system (Make your own! Maybe!)
- [x] Menu Loader system (Make your own menus?)
- [x] General-Purpose loader system (Make your own... something)
- [x] Hmmm
- [x] AND MAYBE SOME MORE!
##### CONTROLS: 
* Click/touch        : Player attracts balls
* Up/Down/Left/Right : Pan the Camera
* -/+                : Zoom the Camera
* Space Bar          : Pause/Unpause the simulation
###### In-Game Buttons
* Gravity Slider     : Adjust the Gravitational Constant-- negative values repel!
* Level Cycle        : Cycle through playing one of the two levels
* Moving             : Pause/Unpause the simulation
* -/+                : Zoom the Camera
#### RELEASE HISTORY:

0.0.0: initial collision/physics work, never released


0.0.1: removed spin mechanic, fixed collisions crashing game; code cleaning


0.0.2: fixed bug where gravity did not properly attract; code cleaning

|a: fixed other gravity bug


0.0.3: Added rudimentary GUI, added pause function, fixed combining, made trails better.


0.0.4: Added levels and JSON support for levels, added asset handler


0.1.0: 
      Fixed and added JSON support for menus, buttons now execute functions.
	  
	  Also fixed screen burn issue with balls, they now fade appropriately
	  
	  Fixed Phenomenon where ball would rocket to high speeds when mouse clicked inside it
	  
	  Made collision detection slightly smoother
	  
	  Officially in BETA :D (Shouldn't be long, just have to cobble together assets)


0.1.1: Added Rudimentary Camera, fixed screen burning phenomenon
 
 |a: fixed compatibility with windows


0.2.0: 
      Finished the Camera
	  
	  Added touch control.
	  
	  Improved UI.
	  
	  Added a function to get absolute distance between two vector-valued tables
	  
	  
0.3.0: 
	  Added (some) support for sprites
	  
	  Also added Sprites
	  
	  Improved trails
	  
	  Final fix to UI
	  
	  Also probably final update (except for bug fixes). This is officially a demo now!
	  
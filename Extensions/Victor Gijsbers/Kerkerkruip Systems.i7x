Kerkerkruip Systems by Victor Gijsbers begins here.

Use authorial modesty.


Volume - Systems

Test score is a number that varies.
Test result is a truth state that varies.
The test subject is a person that varies.
The test room is a room that varies.
The test object is an object that varies.



Part - Properties of rooms

[Standard set of properties:
X is connectable.
X is not connection-inviting.
X is placeable.
X is habitable.
X is treasurable.
X is vp-agnostic.
X is not consecrated.
X is civilised/religious/barren/deathly/elemental/magical/alchemical]


Section - Placement properties

A room can be connectable. A room is usually connectable. [Additional connections can be made in the last stage of making the map.]

A room can be connection-inviting. A room is usually not connection-inviting. [If connection-inviting (and connectable), all possible connections to this room will be made.]

A room can be placeable. A room is usually placeable. [Not placeable rooms are not considered during the normal dungeon creation.]

A room can be habitable. A room is usually habitable. [Monsters can be placed in it.]

A room can be treasurable. A room is usually treasurable. [Treasures can be placed in it.]

A room can be extra-accepting. A room is usually extra-accepting. [Extras can be placed in it.]

A room can be nogo. A room is usually not nogo. [Nogo rooms are not listed in exits and remember commands.]

Section - Vertical placement

[This section defines properties of rooms that affect how deep in the dungeon they are placed. It also contains the necessary rules for doing this.]

[vp-agnostic: standard
vp-underground: only underground
vp-likely-underground: probably underground
vp-above-ground: only above ground (z =>0)
vp-high: only above ground level (z>0)
vp-likely-high: more likely above ground]

Vertical placement is a kind of value. The vertical placements are vp-agnostic, vp-underground, vp-likely-underground, vp-above-ground, vp-high, and vp-likely-high.

A room has a vertical placement. The vertical placement of a room is usually vp-agnostic.

[A room can be underground or not underground. A room is usually not underground. [Underground rooms can only be placed underground, and are more likely than other rooms to be placed so.]]

A placement possible rule (this is the vertical placement possible rule):
	if considered room is vp-underground:
		if the considered-z is not less than 0:
			rule fails;
	if considered room is vp-above-ground:
		if the considered-z is less than 0:
			rule fails;
	if considered room is vp-high:
		if the considered-z is not greater than 0:
			rule fails.

A placement scoring rule (this is the vertical placement scoring rule):
	if considered room is vp-underground or considered room is vp-likely-underground:
		if the considered-z is less than 0:
			increase current room score by 0 - considered-z;
	if considered room is vp-high or considered room is vp-likely-high:
		if the considered-z is greater than 0:
			increase current room score by considered-z.
			
Section - Mood

[Mood is used during generation of the dungeon. Rooms with the same mood are more often placed together, and treasures are often placed in a room with fits their mood.]

Mood is a kind of value. The moods are civilised, religious, barren, deathly, elemental, magical, alchemical and non-mood.
A room has a mood. The mood of a room is usually barren.

A placement scoring rule (this is the link rooms with the same mood rule):
	if the mood of considered room is the mood of original room:
		[say "([considered room] has same mood as [original room])";]
		increase current room score by 2.

Section - Consecration

[Temples should be consecrated. Some powers -- such as extra praying abilities -- will only work in non-consecrated rooms.]

A room can be consecrated. A room is usually not consecrated.



Section - Collapse

First carry out going (this is the collapse rule):
	if the room noun of location collapses location:
		let X be room noun of location;
		change the noun exit of location to nothing;
		let reverse be the opposite of noun;
		change the reverse exit of X to nothing;
		say "With a huge crash, the [if noun is up or noun is down]staircase[otherwise]corridor[end if] [bold type]collapses[roman type] behind you!";
		[wait 4000 milliseconds before continuing;]
		now the retreat location is X;
		now X does not collapse location;
		now location does not collapse X.

Section - Tunnels

Tunnel is a kind of room. "A fairly nondescript tunnel." A tunnel is usually not placeable. A tunnel is usually not habitable. There is 35 tunnels.

[Note: we cannot use Dynamic Objects to create new tunnels without disabling fast route finding. (Fast route finding uses a table of rooms, and fails messily when we add new rooms to the game.) So I'm just starting out with 25 tunnels. We don't want the player to dig hundreds of tunnels anyway.]


Section - Digging and extra rooms

Digging is an action applying to one object.
Understand "dig [direction]" as digging.

Check digging (this is the dig in a direct rule):
	if noun is not a cardinal direction:
		say "You can only dig north, south, west, east, up, or down." instead.

A thing can be a digging tool. A thing is usually not a digging tool.

Check digging (this is the can only dig when carrying a digging tool rule):
	unless the player has a digging tool:
		say "You need a suitable tool to dig." instead.

Check digging (this is the only dig in connectable rooms rule):
	unless location is connectable:
		say "A magical force prevents you from digging." instead.

Carry out digging:
	let x be the x noun of location;
	let y be the y noun of location;
	let z be the z noun of location;
	if the space at x by y by z is free:
		if there is at least one not placed tunnel:
			let item be a random not placed tunnel;
			place item from location at x by y by z;
			say "You magically create a tunnel [noun].";
			do the dig move;
		otherwise:
			say "The laws of this place prevent further digging.";
	otherwise:
		let item be the room at x by y by z;
		if item is the room noun from the location: 
			say "There already is a passage there.";
			take no time;
		otherwise:
			if item is connectable:
				change the noun exit of the location to item; 
    				let reverse be the opposite of noun; 
    				change the reverse exit of item to the location;
				say "You magically create a tunnel [noun].";
				do the dig move;
			otherwise:
				say "A magical force prevents you from digging.".

To do the dig move:
	if the combat status is not peace and the player is not hidden:
		now the player is runner;
		repeat with X running through alive persons in the location:
			now X does not press the player;
			now the player does not press X;
			if the player is alive:
				if the faction of X hates the faction of the player:
					try X hitting the player;
			now concentration of X is 0;
		now the player is not runner;
	if the player is alive:
		let place be the room noun of location;
		now retreat location is location;
		move the player to place;
		now the take no time boolean is false.

Last carry out looking when the location is a tunnel (this is the hint about other rooms rule):
	let K be a list of directions;
	let m be 0;
	repeat with way running through cardinal directions:
[		say "testing [way] ";]
		let x be the x way of location;
		let y be the y way of location;
		let z be the z way of location;
		if not the space at x by y by z is free:
			let place be room at x by y by z;
[			say "[place] is [way] of [location] ";]
			unless place is the room way from location:
				unless place is a tunnel:
					increase m by 1;
					add way to K;
	if m is greater than 0:
		say "There seems to be somewhat different stone [K].".




Section - Collapsing passages

Collapsing is an action applying to one object.
Understand "collapse [direction]" as collapsing.

Check collapsing (this is the collapse in a direct rule):
	if noun is not a cardinal direction:
		say "You can only collapse a passage to the north, south, west, east, up, or down." instead.

A thing can be a collapsing tool. A thing is usually not a collapsing tool.

Check collapsing (this is the can only collapse when carrying a collapsing tool rule):
	unless the player has a collapsing tool:
		say "You need a suitable tool to collapse passages." instead.

Check collapsing:
	let place be the room noun from location;
	unless place is a room:
		take no time;
		say "There is no passage there to collapse." instead;
	otherwise:
		if the location is not connectable or place is not connectable:
			take no time;
			say "A magical force prevents you from collapsing that passage." instead.

Carry out collapsing:
	let place be room noun of location;
	change the noun exit of location to nothing;
	let reverse be the opposite of noun;
	change the reverse exit of place to nothing;
	say "With a huge crash, the [if noun is up or noun is down]staircase[otherwise]corridor[end if] collapses!".

















Book - Monsters

A monster is usually hostile.
A monster is usually neuter.




Chapter - Emotionless

[Some persons have no emotions, and are immune to, for instance, being dominated.]

A person can be emotionless. A person is usually not emotionless.


Chapter - Non-attacker

[Has no influence on the AI (which you will want to customise anyway), but ensures that the person strikes no blow against the player when the player is retreating / running.]

A person can be non-attacker. A person is usually not non-attacker.


Chapter - Weapon user

[Weapon users can ready new weapons.]

A person can be a weapon user. A person is usually not a weapon user.

An AI action selection rule for a person (called P) when the chosen weapon is not readied and the running AI is not weapon user (this is the non weapon users never ready rule):
	choose row with an Option of the action of P readying the chosen weapon in the Table of AI Action Options;
	decrease the Action Weight entry by 1000.



Chapter - Size

Size is a kind of value. The sizes are tiny, small, medium, large, huge and gargantuan.

A thing has a size. A thing is usually medium.

Understand the size property as describing a thing.

Before printing the name of a weapon (called item):
	if item is not medium:
		say "[size of item] ".

Status rule (this is the size status rule):
	if player is not medium:
		say "Your current size is [bold type][size of the player][roman type].[line break][run paragraph on]".


[Note: sizes of a person are meant to reflect how big they themselves are. Sizes of objects are meant to reflect for what size person they were meant. Thus, a 'medium dagger' is much smaller than a 'medium bed': both are normal-sized objects as they are made for normal-sized humans. A huge dagger might be about the same size as a medium sword -- it would just be hard to handle for a medium person, because the hilt would be too big to grip with a hand!]

To decide which number is the size difference of (a - a thing) and (b - a thing):
	if a is medium and b is medium: [most common case, just to speed things up]
		decide on 0;
	let n be 0;
	if a is tiny:
		increase n by 2;
	if a is small:
		increase n by 1;		
	if a is large:
		decrease n by 1;
	if a is huge:
		decrease n by 2;	
	if a is gargantuan:
		decrease n by 3;
	if b is tiny:
		decrease n by 2;
	if b is small:
		decrease n by 1;		
	if b is large:
		increase n by 1;
	if b is huge:
		increase n by 2;	
	if b is gargantuan:
		increase n by 3;
	decide on n.
	
[The resulting number lies between +5 (a is tiny, b is gargantuan) and -5 (a is gargantuan, b is tiny)]

Section - Size and combat

An attack modifier rule (this is the size attack modifier rule):
	if the global defender is not medium:
		if the global defender is tiny:
			say " - 2 (defender tiny)[run paragraph on]";
			decrease the attack strength by 2;
		if the global defender is small:
			say " - 1 (defender small)[run paragraph on]";
			decrease the attack strength by 1;		
		if the global defender is large:
			say " + 1 (defender large)[run paragraph on]";
			increase the attack strength by 1;
		if the global defender is huge:
			say " + 2 (defender huge)[run paragraph on]";
			increase the attack strength by 2;
		if the global defender is gargantuan:
			say " + 3 (defender gargantuan)[run paragraph on]";
			increase the attack strength by 3.

Chance to win rule when the global defender is not medium (this is the CTW defender size bonus rule):
	if the global defender is tiny:
		decrease the chance-to-win by 2;
	if the global defender is small:
		decrease the chance-to-win by 1;		
	if the global defender is large:
		increase the chance-to-win by 1;
	if the global defender is huge:
		increase the chance-to-win by 2;
	if the global defender is gargantuan:
		increase the chance-to-win by 3.

A damage modifier rule (this is the weapon size damage modifier rule):
	if the global attacker is not medium or the global attacker weapon is not medium:
		if the global attacker weapon is not size-agnostic:
			if the size of the global attacker is:
				-- tiny:
					if the numbers boolean is true, say " - 2 (tiny attacker)[run paragraph on]";
					decrease the attack damage by 2;			
				-- small:
					if the numbers boolean is true, say " - 1 (small attacker)[run paragraph on]";
					decrease the attack damage by 1;
				-- large:
					if the numbers boolean is true, say " + 1 (large attacker)[run paragraph on]";
					increase the attack damage by 1;
				-- huge:
					if the numbers boolean is true, say " + 2 (huge attacker)[run paragraph on]";
					increase the attack damage by 2;
				-- gargantuan:
					if the numbers boolean is true, say " + 4 (gargantuan attacker)[run paragraph on]";
					increase the attack damage by 4;

An attack modifier rule (this is the weapon size attack modifier rule):
	if global attacker weapon is not size-agnostic:
		if the global attacker weapon is not a natural weapon part of the global attacker:
			let n be the size difference of the global attacker and the global attacker weapon;
			if n is less than 0:
				now n is 0 minus n;
			unless n is 0:
				let n be n times 2;
				if the numbers boolean is true, say " - [n] (weapon size)[run paragraph on]";
				decrease the attack strength by n.

[No chance to win rule: monsters who start using over- or undersized weapons probably deserve being clumsy.]

Section - Size of weapons

[These operations are not reversible. Better not have the player play with them!]

To increase the size of (item - a weapon):
	unless the size of item is gargantuan:
		now the size of item is the size after the size of item;
		unless item is size-agnostic:
			increase weapon damage bonus of item by 1;
			increase damage die of item by 1;
			if a random chance of 1 in 2 succeeds:
				if passive parry max of item is greater than 1:
					decrease passive parry max of item by 1;
				increase dodgability of item by 1.
	
To decrease the size of (item - a weapon):
	unless the size of item is tiny:
		now the size of item is the size before the size of item;
		unless item is size-agnostic:
			if weapon damage bonus of item is greater than 0:
				decrease weapon damage bonus of item by 1;
			if damage die of item is greater than 1:
				decrease damage die of item by 1;
			if a random chance of 1 in 2 succeeds:
				increase passive parry max of item by 1;
				if dodgability of item is greater than 0:
					decrease dodgability of item by 1.
	
A dungeon interest rule (this is the change weapon sizes rule):
	repeat with item running through not off-stage not non-treasure not carried not size-agnostic weapons:
		if a random chance of 1 in 30 succeeds:
			decrease the size of item;
			if a random chance of 1 in 5 succeeds:
				decrease the size of item;
			if generation info is true, say "* Now [item] is [size of item].";
		otherwise:
			if a random chance of 1 in 10 succeeds:
				increase the size of item;
				if a random chance of 1 in 2 succeeds:
					increase the size of item;
					if a random chance of 1 in 2 succeeds:
						increase the size of item;
				if generation info is true, say "* Now [item] is [size of item].".

Chapter - Powers

A power is a kind of object.

A power can be granted. A power is usually not granted.
A power has a number called the power level. The power level of a power is usually 1.
A power has some text called the command text. The command text of a power is usually "".

Granting relates one monster to one power. The verb to grant (he grants, they grant, he granted, it is granted, he is granting) implies the granting relation.

Killing rule (this is the grant powers when a monster is slain rule):
	if the killer-guy is the player:
		do the absorption with killed-guy.

Every turn (this is the remove all killed monsters from play rule):
	repeat with guy running through dead not off-stage persons:
		unless guy is the player:
			do the absorption with guy.

To do the absorption with (guy - a person):
	increase score by level of guy;
	now test subject is guy;
	unless absorption is stopped:
		do power transferral with the guy;
		heal fully because the guy is slain;
	have the guy disappear;
	do achievement awarding for the guy.

To do power transferral with (guy - a person):
	repeat with X running through powers:
		if guy grants X:
			follow the absorbing rules for X;
			now X is granted;
			let n be the power level of X;
			let Z be a list of powers;
			repeat with Y running through granted powers:
				unless X is Y:
					unless power level of Y is greater than the power level of X:
						add Y to Z;
						follow the repelling rules for Y;
						now Y is not granted;
			if the number of entries in Z is greater than 0:
				say "The violence of the absorption drives [Z with definite articles] out of your body. ";
			grant a faculty increase of n.

To heal fully because (guy - a person) is slain:
	if the level of guy is greater than 0 and the level of guy is not 10:
		unless the player is undead:
			say "Absorbing a soul has [bold type]fully healed[roman type] you.";
			fully heal the player;
		otherwise:
			say "Absorbing a soul has [bold type]restored some of your health[roman type].";
			let n be 8 times level of guy;
			heal the player for n health;
	if the level of guy is 10:
		do the level 10 victory with guy.

To have (guy - a person) disappear:
	let X be the holder of guy;
	unless X is nothing:
		repeat with Y running through things had by guy:
			move Y to X;
			if Y is a weapon:
				now Y is not readied;
	remove guy from play.


To do achievement awarding for (guy - a person):
	if level of guy is 1:
		award achievement assistant dungeoneer;
	if level of guy is 2:
		award achievement adventurer;
	if level of guy is 3:
		award achievement hunter;
	if level of guy is 4:
		award achievement destroyer.


Absorbing is a power based rulebook.
Repelling is a power based rulebook.

Section - Greatest power of the player

To decide which number is the greatest power of the player:
	let m be 0;
	if at least one power is granted:
		repeat with X running through granted powers:
			if power level of X is greater than m:
				now m is power level of X;
	decide on m.

Section - Whether absorption is stopped

The absorption stopping rules are a rulebook.

To decide whether absorption is stopped:
	consider the absorption stopping rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.




Chapter - Flying

[Some persons have flight, which makes them immune to some effects.]

A person can be a flyer. A person is usually not a flyer.

The flying rules are a rulebook.

To decide whether (guy - a person) is flying:
	now test subject is guy;
	consider the flying rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.

A flying rule (this is the flyers fly rule):
	if test subject is flyer:
		rule succeeds.

Status rule (this is the flying status rule):
	if player is flying:
		say "You are [bold type]flying[roman type].[line break][run paragraph on]".



Chapter - Blindness

A person can be blinded. A person is usually not blinded. [Blinded is a property that makes you blind. It can be cured.]

A person can be eyeless. A person is usually not eyeless. [An eyeless person is blind but not negatively affected by blindness.]

The blindness rules are a rulebook.

To decide whether (guy - a person) is blind:
	now test subject is guy;
	consider the blindness rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.

A blindness rule (this is the blind if blinded rule):
	if test subject is blinded:
		rule succeeds.

A blindness rule (this is the blind if eyeless rule):
	if test subject is eyeless:
		rule succeeds.
		
Status rule (this is the blindness status rule):
	if player is blind:
		say "You are [bold type]blind[roman type].[line break][run paragraph on]".

An attack modifier rule (this is the blindness attack modifier rule):
	if the global attacker is blind and the global attacker is not eyeless:
		say " - 3 (blindness)[run paragraph on]";
		decrease the attack strength by 3;

An attack modifier rule (this is the blindness defence modifier rule):
	if the global defender is blind and the global defender is not eyeless:
		say " + 2 (defender blind)[run paragraph on]";
		increase the attack strength by 2;

[TODO FIX]
[Chance to win rule (this is the CTW blindness bonus rule):
	if the global attacker is blind and the global attacker is not eyeless:
		decrease the chance-to-win by 3;
	if the global defender is blind and the global defender is not eyeless:
		increase the chance-to-win by 2.]

[A perception test rule (this is the blindness affects perception rule):
	if the test subject is blind and the test subject is not eyeless:
		decrease test score by 3;
		say " - 3 (blindness)[run paragraph on]".]


Chapter - Healing

[This is an action that monsters can take.]

Healing is an action applying to nothing. [Obviously, it will apply to someone, but our simple AI cannot handle it that way.]

A person has a number called the heal power. The heal power of a person is usually 0.
A person has a number called the heal cooldown. The heal cooldown of a person is usually 3.
A person has a number called the current heal cooldown. The current heal cooldown of a person is usually 0.
			
First AI action selection rule for a person (called P) (this is the consider healing rule):
	if the heal power of P is greater than 0 and the current heal cooldown of P is less than 1:
		let someone needs healing be false;
		let greatest injury be 0;
		repeat with X running through alive persons enclosed by the location not opposed by P:
			let injury be permanent health of X minus health of X; 
			if injury is greater than 0:
				now someone needs healing is true;
				if greatest injury is less than injury:
					now greatest injury is injury;
		if someone needs healing is true:
			if greatest injury is greater than heal power of the running AI:
				now greatest injury is heal power of the running AI; [now m becomes the maximum amount of damage the global attacker can heal]
			choose a blank Row in the Table of AI Action Options;
			now the Option entry is the action of P healing;
			now the Action Weight entry is 5 plus greatest injury;

Carry out an actor healing:
	let m be 0;
	let chosen one be the actor;
	repeat with guy running through alive persons enclosed by the location:
		if the faction of guy does not hate the faction of the actor and guy is not the actor:
			let n be permanent health of guy minus health of guy; 
			if n is greater than 0:
				if m is less than n:
					now chosen one is guy;
					now m is n;
	if m is greater than heal power of the actor:
		now m is heal power of the actor;
	say "[The actor] casts a spell of magical healing on [the chosen one], removing [m] points of damage.";
	heal chosen one for m health;
	now current heal cooldown of the actor is heal cooldown of the actor. 

Every turn (this is the reduce heal cooldown of the main actor rule):
	if the current heal cooldown of the main actor is greater than 0:
		decrease the current heal cooldown of the main actor by 1.




Chapter - Teleportation

[As a monster action.]

Teleporting is an action applying to nothing.

A person has a number called the teleport amount. The teleport amount of a person is usually 0. [Number of times the monster can teleport. -1 means infinitely.]
A person has a number called the teleport eagerness. The teleport eagerness of a person is usually 10. [percentage chance of serious consideration]
A person can be a spontaneous teleporter. A person is usually not a spontaneous teleporter. [A spontaneous teleporter will also teleport when the player is not present. Best used with a teleport amount of -1.]

A room can be teleportable. A room is usually teleportable. [A teleportable room is one you can teleport TO.]

[We have teleport rules which check whether a person can teleport.]
The teleport impossible rules are a rulebook.

To decide whether teleportation is impossible for (guy - a person):
	now test subject is guy;
	consider the teleport impossible rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.

[Finally, it need not be obvious to a person that teleportation is impossible. If a person is a teleport impossible aware, he does.]

A person can be teleport impossible aware. A person is usually not teleport impossible aware.

[AI rules]

First AI action selection rule for an at-Act person (called P) (this is the consider teleporting rule):
	choose a blank Row in the Table of AI Action Options;
	now the Option entry is the action of P teleporting;
	if the teleport amount of P is 0:
		now the Action Weight entry is -1000;
	otherwise:
		if P is teleport impossible aware:
			now the Action Weight entry is -100;
		otherwise:
			now the Action Weight entry is -20.

An AI action selection rule for an at-Act person (called P) (this is the teleport eagerness rule):
	let n be the teleport eagerness of P;
	if a random chance of n in 100 succeeds:
		choose row with an Option of the action of P teleporting in the Table of AI Action Options;
		increase the Action Weight entry by 35.

Every turn (this is the spontaneous teleport rule):
	repeat with guy running through spontaneous teleporter not off-stage persons:
		if teleport amount of guy is not 0:
			let n be the teleport eagerness of guy;
			if a random chance of n in 100 succeeds:
				try guy teleporting. 

Check an actor teleporting (this is the teleport impossible rule):
	if teleportation is impossible for the actor:
		now the actor is teleport impossible aware;
		say "[The actor] tries to teleport away, but something makes this impossible!" instead.

Carry out an actor teleporting (this is the standard monster teleport rule):
	now teleportation-from is the location of the actor; [see teleportation Event]
	now teleportation-guy is the actor;
	choose a teleportation destination;
	let see-arriving be false;
	let see-going be false;
	if location of the actor is the location:
		now see-going is true;
	if teleportation-destination is the location:
		now see-arriving is true;
	move actor to teleportation-destination;
	now concentration of actor is 0;
	unless teleport amount of actor is -1 or teleport amount of actor is 0:
		decrease teleport amount of actor by 1;
	[ TODO: change these to report rules ]
	if teleportation-from is the location of the player and teleportation-destination is the location of the player:
		say "[The actor] teleports away, but reappears in the exact same spot.";
	otherwise:
		if see-going is true:
			say "[The actor] suddenly teleports away!";
		if see-arriving is true:
			say "[The actor] suddenly teleports into the room!";
	have a teleportation event.


To choose a teleportation destination:
	let destination be a random placed placeable teleportable room;
	while destination is the location of teleportation-guy:
		let destination be a random placed placeable teleportable room;
	now teleportation-destination is destination;
	consider the special teleportation destination rules.

The special teleportation destination rules are a rulebook. [Can intervene on the destination.]


To teleport the player:
	now teleportation-from is the location of the player; [see teleportation Event]
	now teleportation-guy is the player;
	choose a teleportation destination;
	say "A sickening feeling, and then you find yourself in --[paragraph break]";
	now retreat location is teleportation-destination;
	consider the sudden combat reset rules;
	move player to teleportation-destination;
	now the take no time boolean is false.

Every turn (this is the teleport impossible awareness expires rule):
	repeat with guy running through teleport impossible aware persons:
		unless teleportation is impossible for guy:
			now guy is not teleport impossible aware.


Chapter - Ray of disintegration

[Our implementation is simple in the sense that the AI has no preference for destroying one object over another. Making this more interesting would be a good project for the future.]

Disintegrating is an action applying to nothing.

A person has a number called the disintegrate power. The disintegrate power of a person is usually 0.
A person has a number called the disintegrate cooldown. The disintegrate cooldown of a person is usually 5.
A person has a number called the current disintegrate cooldown. The current disintegrate cooldown of a person is usually 0.
		
First AI action selection rule for a person (called P) (this is the consider disintegrating rule):
	if the disintegrate power of P is greater than 0 and the current disintegrate cooldown of the P is less than 1:
		repeat with guy running through alive persons enclosed by the location opposed by P:
			if guy has at least one[ corruptible] thing:
				choose a blank Row in the Table of AI Action Options;
				now the Option entry is the action of P disintegrating;
				now the Action Weight entry is disintegrate power of P;
				if a random chance of 1 in 10 succeeds:
					increase Action Weight entry by 10;
				stop;

Carry out an actor disintegrating (this is the standard disintegrate rule):
	let boolean be false;
	let guy be the actor;
	let item be the non-thing;
	while boolean is false:
		now guy is a random alive person enclosed by the location;
		if the actor opposes the guy:
			if guy has at least one[ corruptible] thing:
				now item is a random[ corruptible] thing had by guy;
				now boolean is true;
	let n be the disintegrate power of the actor;
	if item is minor or item is non-treasure:
		now n is n times 6;
	if item is major:
		now n is n times 4;
	if item is epic:
		now n is n times 2;
	if item is incorruptible:
		now n is 0;
	if a random chance of n in 100 succeeds:
		say "[The actor] casts a ray of disintegration at [the item], destroying the object!";
		remove item from play;
		ready natural weapons;
	otherwise:
		say "[The actor] casts a ray of disintegration at [the item], but the object resists!";
	now current disintegrate cooldown of the actor is disintegrate cooldown of the actor.

Every turn (this is the reduce disintegrate cooldown of the main actor rule):
	if the current disintegrate cooldown of the main actor is greater than 0:
		decrease the current disintegrate cooldown of the main actor by 1.
		


Chapter - Followers

[Followers consider the follower rules. If these do not fail, they attempt to move one room towards the player.]

A person can be a follower. A person is usually not a follower.
A person has a number called the follower percentile chance. The follower percentile chance of a person is usually 100.

The followers rules are a rulebook.

Every turn (this is the have followers follow rule):
	if main actor is the player:
		repeat with guy running through alive not off-stage follower persons:
			if the location of guy is not the location of the player:
				now test subject is guy;
				consider the followers rules;
				unless rule failed:
					let the way be the best route from the location of guy to the location of the player;
					if way is a direction, try guy going the way.

A followers rule (this is the follower percentile chance rule):
	let n be the follower percentile chance of the test subject;
	unless a random chance of n in 100 succeeds:
		rule fails.

A followers rule (this is the follower cannot follow hidden person rule):
	if player is hidden and test subject is not unnaturally aware and test subject is not unnaturally aware follower:
		rule fails.


[OK, we need to tear apart factions and type.]

Chapter - Monster types

Type is a kind of value. The types are living, undead, demonic, horrific.

A person has a type. The type of a person is usually living.

Status rule (this is the undead status rule):
	if the player is undead:
		say "You are [bold type]undead[roman type]: other undead are your allies; other potential allies may be your enemies instead; absorbing a soul may heal you only partially.[line break][run paragraph on]".


Chapter - New factions

[Undead attack everyone, except for other undead. Horrors attack everyone. Demonic doesn't hate demonic or hostile.]

undead-faction is a faction.
horrific-faction is a faction.
mindslug-enslaved is a faction.
player-enslaved is a faction.
insane is a faction.

Definition: a person is enslaved if its faction is mindslug-enslaved or its faction is player-enslaved.

When play begins (this is the set factions rule):
	now mindslug-enslaved hates friendly;
	now friendly hates mindslug-enslaved;
	repeat with X running through factions:
		now horrific-faction hates X;
		now X hates horrific-faction;
		now insane hates X;
		now X hates insane;
		unless X is undead-faction:
			now undead-faction hates X;
			now X hates undead-faction;
		if friendly hates X:
			now player-enslaved hates X;
		if X hates friendly:
			now X hates player-enslaved.

[And now some stuff we need because horrors might attack themselves.]

The standard hate rule is not listed in any rulebook.

Hate rule (this is the nonstandard hate rule):
	if the player is friendly and at least one hostile alive person is enclosed by the location:
		if friendly hates hostile:
			rule succeeds; [This is only here for speed. It is the most common case where we decide yes.]
	repeat with X running through alive not passive persons enclosed by the location:
		repeat with Y running through alive persons enclosed by the location:
			if the faction of X hates the faction of Y and X is not Y:
				rule succeeds;
	rule fails.

[An AI target selection rule for a person (called target) (this is the do not target yourself rule):
	if target is the running AI:
		decrease the Weight entry by 2000.]

Every turn when the player is undead (this is the undead follow undead rule):
	repeat with guy running through undead not follower persons in the location:
		now guy is follower;
		if follower percentile chance of guy is less than 50:
			now follower percentile chance of guy is 50.


Chapter - Insanity

A Standard AI rule for an insane person (called P) (this is the insane people attack themselves rule):
	if P is at-Act:
		if a random chance of 1 in 6 succeeds:
			try P attacking P;
			rule succeeds.

An AI target selection rule (this is the insane randomise the target result rule):
	if the running AI is insane:
		increase the Weight by a random number between 0 and 700.

Last AI action selection rule (this is the insane randomise the action result rule):
	if the running AI is insane:
		repeat through the Table of AI Action Options:
			increase the Action Weight entry by a random number between 0 and 700.

A damage modifier rule (this is the insane people sometimes get insane damage bonus rule):
	if global attacker is insane and global attacker weapon is not size-agnostic:
		if a random chance of 1 in 5 succeeds:
			if the numbers boolean is true, say " + 10 (insane burst of strength)[run paragraph on]";
			increase the attack damage by 10.


Chapter - Ranged weapons

[Some specials should or should not happen for ranged weapons. For instance, a heated ranged weapon does not deal extra damage.]
	
A weapon can be ranged. A weapon is usually not ranged.

Chapter - Armour-stoppable

[Armour should only reduce the damage of some weapons. For instance, armour doesn't help against a lightning bolt or dragon's fire.]

A weapon can be armour-stoppable. A weapon is usually armour-stoppable.

Chapter - Size-agnostic

[Some weapons are not dependent on the user's size for their damage output.]

A weapon can be size-agnostic. A weapon is usually not size-agnostic.


Chapter - Materials

Material is a kind of value. [The materials are other-material, iron, silver, paper, cloth, wood, glass, leather, flesh, dragon skin, stone, radiance, adamant. ][Understand "wooden" as wood.]
[
A material has some text called the material-adjective.
A material has a number called the destroying heat.
A material has a number called the corrosion resistance. [Percentile chance, because we are working with some small probabilities here -- they come up every turn, and get large quickly.]]
Heat-behaviour is a kind of value. The heat-behaviours are burner and melter. [A material has a heat-behaviour.]

The materials are defined by the Table of Materials.

Table of Materials
material	material-adjective	destroying heat	heat-behaviour	corrosion resistance
other-material	"nondescript"	5	burner	950					
iron	"iron"	10	melter	995
silver	"silver"	7	melter	985
paper	"paper"	1	burner	950
cloth	"cloth"	1	burner	950
wood	"wooden"	3	burner	970
leather	"leather"	3	burner	980
flesh	"flesh"	2	burner	900
glass	"glass"	6	melter	999
stone	"stone"	15	melter	998
dragon skin	"dragon skin"	20	burner	999
radiance	"radiant"	99	melter	1000
adamant	"adamantine"	999	melter	1000
vapour	"vapourous"	999	burner	1000

Understand the material property as describing a thing.
[Understand the material-adjective property as describing a material.]
Understand "wooden" as wood.
Understand "radiant" as radiance.
Understand "adamantine" as adamant.
Understand "vapourous" and "vapor" and "vaporous" as vapour.

A thing has a material. The material of a thing is usually other-material.
The material of a person is usually flesh.

A thing has a material called the original material.

When play begins (this is the set original material rule):
	repeat with item running through things:
		now the original material of item is the material of item.

When play begins (this is the set incorruptibility based on material rule):
	repeat with item running through things:
		if the material of item is adamant or the material of item is radiance:
			now item is incorruptible.

Before printing the name of a thing (called item):
	if material of item is not original material of item:
		if item is not proper-named:
			say "[material-adjective of material of item] ".

First after printing the name of a thing (called item):
	if material of item is not original material of item:
		if item is proper-named:
			say " (now [material-adjective of material of item])".


[Section - Test other-material - Not for Release

Last when play begins:
	repeat with item running through other-material things:
		say "WARNING: [item] doesn't have a material.".
]

Section - Silver

A damage modifier rule (this is the silver damage rule):
	if the global attacker weapon is silver:
		if the global defender is not undead and the global defender is not demonic:
			say " - 2 (silver weapon)[run paragraph on]";
			decrease the attack damage by 2;
		otherwise:
			say " + 4 (silver weapon)[run paragraph on]";
			increase the attack damage by 4;




Chapter - Doing risky things

[Sometimes, the player can do a risky thing which should allow his enemy to make an attack of opportunity. But we do not want this to be a good way of making your enemy attack before his concentration is high enough -- so we are going to give the enemy a big to-hit bonus when the player is doing something risky.] 

[I don't think we are actually using this right now.]

A person can be risky. A person is usually not risky.

An attack modifier rule (this is the defender is doing something risky rule):
	if the global defender is risky:
		say " + 6 (defender taking risky action)[run paragraph on]";
		increase the attack strength by 6.

Chance to win rule when the global defender is risky (this is the CTW risky bonus rule):
	increase the chance-to-win by 6.


Chapter - Beloved of Aite

The beloved of Aite rules are a rulebook.

To decide whether (guy - a person) is beloved of Aite:
	now test subject is guy;
	consider the beloved of Aite rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.

A person can be Aite-loved. A person is usually not Aite-loved.

A beloved of Aite rule (this is the Aite-loved rule):
	if test subject is Aite-loved:
		rule succeeds.



Chapter - Heat

[The heat system currently supports hotness for things. However, giving a hotness to persons is _not_ truly supported, and will lead to unwanted behaviour.]

[Much of the heat system has been turned off. It was too unituitive and punishing. Perhaps also too computation intensive?]

Section - Basics

A thing has a number called the heat strength. The heat strength of a thing is usually 0.

Definition: a thing is hot if its heat strength is greater than 0. 


Section - Feedback

Not-mentioning-hotness is a truth state that varies. Not-mentioning-hotness is false.
Not-mentioning-flaming is a truth state that varies. Not-mentioning-flaming is false.

To turn off mentioning hotness:
	now not-mentioning-hotness is true;
	now not-mentioning-flaming is true.

To turn on mentioning hotness:
	now not-mentioning-hotness is false;
	now not-mentioning-flaming is false.

Before printing the name of hot not flaming thing (called item):
	unless not-mentioning-hotness is true:
		if heat strength of item is less than 3:
			say "hot [run paragraph on]";
		otherwise if heat strength of item is less than 6:
			say "very hot [run paragraph on]";
		otherwise:
			say "blazingly hot [run paragraph on]".
		
Understand "hot" as a thing when the heat strength of the item described is greater than 0.	
Understand "very hot" as a thing when the heat strength of the item described is greater than 2.
Understand "blazingly" as a thing when the heat strength of the item described is greater than 5.		

Last carry out examining a hot thing:
	now not-mentioning-hotness is true;
	say "[The noun] is ";
	now not-mentioning-hotness is false;	
	if heat strength of noun is less than 3:
		say "hot.";
	otherwise if heat strength of noun is less than 6:
		say "very hot.";
	otherwise:
		say "blazingly hot.".

First attack modifier rule:
	turn off mentioning hotness.

Last attack modifier rule:
	turn on mentioning hotness.

First damage modifier rule:
	turn off mentioning hotness.

Last damage modifier rule:
	turn on mentioning hotness.


Section - Temperatures and flaming

A thing can be flaming. A thing is usually not flaming.
Understand the flaming property as describing a thing. Understand "burning" as flaming.

Every turn (this is the flaming items burn away rule):
	repeat with item running through flaming not off-stage corruptible things:
		if a random chance of 1 in 4 succeeds or destroying heat of material of item + 2 is not greater than heat strength of item:
			now heat strength of item is 0;
			now item is not flaming;
			turn off mentioning hotness;			
			if item is visible, say "[The item] [if material of item is melter]melts[otherwise if material of item is not flesh]burns[otherwise]chars[end if] away.";
			turn on mentioning hotness;			
			remove the item from play.
			
Before printing the name of a flaming thing (called item):
	unless not-mentioning-flaming is true:
		say "burning [run paragraph on]".

Every turn (this is the heat destroys items rule):
	repeat with item running through hot not flaming not off-stage corruptible things:
		let n be heat strength of item;
		let m be destroying heat of the material of item;
		if m is not greater than n:
			if material of item is burner and m + 2 is greater than n:
				now item is flaming;
				turn off mentioning hotness;
				if item is visible, say "[The item] catches fire!";
				turn on mentioning hotness;				
			otherwise:
				turn off mentioning hotness;
				if item is visible, say "[The item] [if material of item is melter]melts[otherwise if material of item is not flesh]burns[otherwise]chars[end if] away.";
				turn on mentioning hotness;				
				remove the item from play.



Section - Weapons

A damage modifier rule (this is the heat increases damage rule):
	if the global attacker weapon is hot and the global attacker weapon is not ranged:
		let n be heat strength of the global attacker weapon;
		decrease n by heat resistance of global defender;
		if n greater than 0:
			say " + [n] (heat)[run paragraph on]";
			increase the attack damage by n.

An aftereffects rule (this is the heat can cause weapons to break rule):
	let n be heat strength of the global attacker weapon;
	let m be heat strength of the global defender weapon;
	if n is greater than 0 and global attacker weapon is not ranged:
		if the global attacker weapon is corruptible:
			if the attack damage is greater than 0 or defender is at parry:
				if a random chance of n in 50 succeeds:
					turn off mentioning hotness;			
					say "[The global attacker weapon], weakened by being heated, is [bold type]destroyed[roman type]!";
					turn on mentioning hotness;				
					remove global attacker weapon from play;
	if the attack damage is less than 0 and the defender is at parry:
		if m is greater than 0:
			if the global defender weapon is corruptible:
				if a random chance of n in 50 succeeds:
					turn off mentioning hotness;			
					say "[The global defender weapon], weakened by being heated, is [bold type]destroyed[roman type]!";
					turn on mentioning hotness;				
					remove global defender weapon from play.


Section - Heat resistance

Temp-heat is a number that varies.
The heat resistance rules are a rulebook.

To decide what number is the heat resistance of (guy - a person):
	now test subject is guy;
	now temp-heat is 0;
	consider the heat resistance rules;
	decide on temp-heat.

Heat resistance rule (this is the material heat resistance rule):
	increase temp-heat by destroying heat of the material of the test subject - 1.

A person has a number called the intrinsic heat resistance. The intrinsic heat resistance of a person is usually 0.

Heat resistance rule (this is the intrinsic heat resistance rule):
	increase temp-heat by intrinsic heat resistance of the test subject.

[
Section - Being damaged by hot objects

Every turn when a hot object is enclosed by the location (this is the hot objects deal damage rule):
	repeat with guy running through alive persons enclosed by the location:
		if guy has a hot object:
			let K be a list of things;
			let m be 0;
			repeat with item running through things had by guy:
				if item is hot and item is not a readied weapon:
					let n be heat strength of item;
					decrease n by heat resistance of guy;
					if n greater than 0:
						add item to K;
						increase m by n;
			if m is greater than 0:
				decrease health of guy by m;
				turn off mentioning hotness;
				say "Because of [if number of entries in K is not greater than 1]its[otherwise]their[end if] extreme heat, [K with definite articles] deal[if number of entries in K is not greater than 1]s[end if] [m] damage to [the guy][if guy is killed and guy is player], killing you[otherwise if guy is killed], killing it[end if].";
				turn on mentioning hotness.]

Section - Internal heat

A thing has a number called the internal heat. The internal heat of a thing is usually 0.

Definition: a thing (called the item) is internally-heated if the internal heat of item is greater than 0.

When play begins:
	follow the internal heat rule.

Last every turn (this is the internal heat rule):
	repeat with item running through internally-heated things:
		if heat strength of item is less than internal heat of item:
			now heat strength of item is internal heat of item.

Section - Cooling

A thing can be a cooler. A thing is usually cooler. [If a burn check was made for an item, it will become not cooler than 1, and therefore will not cool down this turn. This stops us from having many repeated messages about something cooling down completely.]

Last every turn (this is the cooling rule):
	repeat with item running through hot not flaming things:
		unless item is not cooler and heat strength of item is 1:
			if heat strength of item is greater than internal heat of item:
				if a random chance of 1 in 2 succeeds:
					decrease heat strength of item by 1;
					if heat strength of item is 0 and item is visible:
						if item is a readied weapon: [EASY way to stop too many messages; but it is what we want??]
							say "[The item] has cooled down completely.";
		now item is cooler.


[
Section - Hot items heat up other items

Every turn (this is the hot things heat up other things rule):
	repeat with item running through hot things enclosed by the location:
		if item is held by a container:
			let X be a random container holding item;
			do the burn check with X and strength heat strength of item;
			repeat with item2 running through things held by X:
				do the burn check with item2 and strength heat strength of item;
		if item is a container:
			repeat with item2 running through things held by item:
				do the burn check with item2 and strength heat strength of item;
		if item is held by a person and item is not a readied weapon:
			let X be a random person holding item;
			repeat with item2 running through things held by X:
				if item2 is not part of X:
					do the burn check with item2 and strength heat strength of item.

To do the burn check with (item - a thing) and strength (n - a number):
	if n is greater than heat strength of item:
		let m be n - heat strength of item;
		if a random chance of m in 3 succeeds and a random chance of 1 in 3 succeeds:
			increase heat strength of item by 1;
			now item is not cooler.
]




Chapter - Rust

Section - The property

A thing can be rusted. A thing is usually not rusted.
Understand "rusted" as a thing when the item described is rusted.

Not-mentioning-rust is a truth state that varies. Not-mentioning-rust is false.

To turn off mentioning rust:
	now not-mentioning-rust is true.

To turn on mentioning rust:
	now not-mentioning-rust is false.

Before printing the name of a rusted thing:
	if not-mentioning-rust is false, say "rusted [run paragraph on]".

First attack modifier rule:
	turn off mentioning rust.

Last attack modifier rule:
	turn on mentioning rust.

First damage modifier rule:
	turn off mentioning rust.

Last damage modifier rule:
	turn on mentioning rust.


Section - Weapon penalty

A damage modifier rule (this is the rust decreases damage rule):
	if the global attacker weapon is rusted:
		say " - 2 (rust)[run paragraph on]";
		decrease the attack damage by 2.

Section - Rusted monster penalty

A damage modifier rule (this is the rusted monster decreases damage rule):
	if the global attacker is rusted:
		say " - 2 (rust)[run paragraph on]";
		decrease the attack damage by 2.

An attack modifier rule (this is the rusted monster decreases attack rule):
	if the global attacker is rusted:
		say " - 2 (rust)[run paragraph on]";
		decrease the attack strength by 2.

Chance to win rule when the global attacker is rusted (this is the CTW rusted monster penalty rule):
	decrease the chance-to-win by 2.


Section - Rust spores

A room can be rust-spored. A room is usually not rust-spored.

Rust spores is a backdrop. Rust spores is everywhere. Rust spores is plural-named. Understand "brown" and "moss" and "spore" as rust spores.

Instead of doing anything with rust spores:
	if the location is not rust-spored:
		say "This place is blessedly free of rust spores.".

Instead of examining rust spores when the location is rust-spored:
	say "These small brown flaked look innocent enough, but they corrode iron faster than one would think possible.".

Instead of taking rust spores when the location is rust-spored:
	say "You attempt to take some of the rust spores, but they are blown out of your hand as you close it.".



Section - Rust spores rust iron items

Every turn (this is the rust spores rust iron rule):
	repeat with place running through rust-spored rooms:
		repeat with item running through iron not rusted corruptible things enclosed by place: [iron mentioned for speed]
			unless item is enclosed by a closed container:
				if item can rust:
					if a random chance of 1 in 6 succeeds:
						now item is rusted;
						if player can see item:
							turn off mentioning rust;
							say "As rust spores whirl around the room, [the item] rust[unless item is plural-named][s][end if].";
							turn on mentioning rust.


Section - Rusting rules

The rusting rules are a rulebook.

To decide whether (item - a thing) can rust:
	now test object is item;
	consider the rusting rules;
	if rule failed:
		decide no;
	otherwise:
		decide yes.

A rusting rule (this is the hot items cannot rust rule):
	if heat strength of test object is greater than 1:
		rule fails.

A rusting rule (this is the only iron items can rust rule):
	if material of test object is not iron:
		rule fails.


Section - Spreading of the rust

A room can be a rust-spored-candidate.

Every turn when at least one placed room is rust-spored (this is the spread rust spores rule):
	repeat with place running through placed not rust-spored rooms:
		if at least one rust-spored room is adjacent to place:
			if a random chance of 1 in 10 succeeds:
				now place is rust-spored-candidate;
	repeat with place running through rust-spored-candidate rooms:
		now place is rust-spored;
		now place is not rust-spored-candidate;
		if player is enclosed by place:
			say "Clouds of [bold type]rust spores[roman type] drift into the room.".

[Every turn when at least one placed room is fungi-killer (this is the kill the rust spores rule):
	repeat with place running through placed rust-spored fungi-killer rooms:
		now place is not rust-spored;
		if place is location:
			say "All the rust spores blacken and wither.".]



Section - Starting with a rusting room

A dungeon interest rule (this is the add rust to the dungeon rule):
	if a random chance of 1 in 50 succeeds:
		let place be a random placed room;
		now place is rust-spored;
		if generation info is true:
			say "* [Place] is full of rust spores.".

Section - Containers which release rust spores

A container can be rust-releasing. A container is usually not rust-releasing.

Every turn when at least one rust-releasing container is not off-stage (this is the rust the contents of rust-releasing containers rule):
	repeat with item running through rust-releasing not off-stage containers:
		if item contains at least one thing:
			repeat with item2 running through things contained by item:
				if item2 can rust:
					now item2 is rusted.

Last report opening a rust-releasing container (called the item):
	now item is not rust-releasing;
	now location is rust-spored;
	say "As you open the container, a large cloud of rust spores drifts out of it.".

[Next rule is "last" because we want to remove treasure packs first.]
Last dungeon finish rule (this is the sometimes containers release rust rule):
	if a random chance of 1 in 10 succeeds:
		if at least one closed openable container is not off-stage:
			let item be a random closed openable  not off-stage container;
			if location of item is placed:
				now item is rust-releasing;
				if generation info is true, say "Made [item] rust-releasing.".





Chapter - Corrosion

[Corrosion does two things: it completely destroys items with a certain chance; and it degrades weapons.]

To corrode (item - a thing):
	if item corrodes:
		if item is visible:
			say "[The item] dissolve[if item is not plural-named]s[end if].";
		remove item from play;
	otherwise if item is a weapon:
		if item corrodes:
			decrease weapon attack bonus of item by 1;
		if item corrodes:
			decrease weapon attack bonus of item by 1;			
		if item corrodes:
			decrease damage die of item by 1;
			if damage die of item is less than 1:
				now damage die of item is 1.


The corroding rules are a rulebook.

To decide whether (item - a thing) corrodes:
	now test object is item;
	consider the corroding rules;
	if rule succeeded:
		decide yes;
	otherwise:
		decide no.

[Two types of resistance: based on the material, and based on the item itself.]

A thing has a number called the personal corrosion resistance. The personal corrosion resistance of a thing is usually 0.

A corroding rule (this is the incorruptible things do not corrode rule):
	if test object is incorruptible:
		rule fails.

A corroding rule (this is the corroding resistances rule):
	let m be the corrosion resistance of the material of test object;
	let n be a random number between 1 and 1000;
	if n is greater than m:
		let m be the personal corrosion resistance of test object;
		let n be a random number between 1 and 1000;
		if n is greater than m:
			rule succeeds.



Chapter - Environmental messages

[currently: smoke and rust spores]

Before printing the locale description of a room (this is the environmental effects rule):
	if the smoke penalty of the location is greater than 0:
		say "[if smoke penalty of the location is greater than 2]Thick[otherwise]Thin[end if] [bold type]clouds of smoke[roman type][if location is rust-spored] and tiny brown spores of the [bold type]rust moss[roman type][end if] fill the room.";
	if the location is rust-spored and the smoke penalty of the location is less than 1:
		say "The air is full of the tiny brown spores of the [bold type]rust moss[roman type].".


Chapter - Sudden combat reset

[After teleportation, and other sudden move actions of the player, concentration and so on ought to be reset. They work on the location of the player, so should be called _before_ the move.]

The sudden combat reset rules are a rulebook.

A sudden combat reset rule (this is the sudden concentration reset rule):
	repeat with guy running through alive persons enclosed by the location:
		now concentration of guy is 0.

A sudden combat reset rule (this is the reset the player to at-Inactive rule):
	now the player is at-Inactive;


Chapter - Impeded movement

[In some circumstances, you cannot move. This affects stuff like falling into the lava or jumping down the staircase -- though not reading a scroll of teleportation. We make one universal silent check. We are not using it for going, entering and so on: in such cases, we probably want to print special prose. We do check it after the retreat-induced attacks, though, because these may have stopped us from retreating.]

The impeded movement rules are a rulebook.

To decide whether (guy - a person) can move:
	now test subject is the guy;
	consider the impeded movement rules;
	if rule failed:
		decide no;
	decide yes.


Chapter - Forced action

Forced-action is a truth state that varies. Forced-action is false. [When it is true, we don't say anything about a player's motivation. Currently used for the boots of wandering.]

Every turn (this is the remove forced action rule):
	now forced-action is false.



Chapter - Physical damage reduction

The physical damage reduction rules are a rulebook. [To be used by all physical damage effects which should be stopped by stuff like armour.]

The pdr is a number that varies.

To calculate the pdr for (guy - a person):
	now pdr is 0;
	now test subject is guy;
	consider the physical damage reduction rules.



Chapter - Death blessing and death curse

[This is a SECRET status that the player can receive -- for instance, by reading the symbols of death.]

A person can be death-blessed.
A person can be death-cursed.

A damage modifier rule (this is the death-blessed rule):
	if the global defender is death-blessed:
		if a random chance of 1 in 10 succeeds:
			say " - 10 (blessing of life)[run paragraph on]";
			decrease the attack damage by 10;
			if a random chance of 1 in 2 succeeds:
				now the global defender is not death-blessed.

A damage modifier rule (this is the death-cursed rule):
	if the global defender is death-cursed:
		if a random chance of 1 in 20 succeeds:
			say " + 10 (curse of death)[run paragraph on]";
			increase the attack damage by 10;
			if a random chance of 1 in 2 succeeds:
				now the global defender is not death-cursed.



Chapter - Falling

[First, we implement a falling check. Default outcome is that a person can fall.]

Falling-test-person is a person that varies.

To decide whether (guy - a person) can fall:
	now falling-test-person is guy;
	consider the falling-test rules;
	if rule succeeded:
		decide no;
	otherwise:
		decide yes.

The falling-test rules are a rulebook.

A falling-test rule (this is the fliers cannot fall rule):
	if falling-test-person is flying:
		rule succeeds.

A falling-test rule (this is the non-moving persons cannot fall rule):
	unless falling-test-person can move:
		rule succeeds.

A falling-test rule (this is the ethereal persons cannot fall rule):
	if falling-test-person is ethereal:
		rule succeeds.

[Now we calculate the destination, if any.]

Falling destination rule (this is the standard falling destination rule):
	now falling-destination is the room down from falling-place;
	unless falling-destination is a room:
		now falling-destination is the location of falling-guy.

[Triggered by the falling event in Kerkerkruip Events.

Fall begins.
Stage 1: Does anything want to prevent us from falling? PREEMPT FALLING RULE
Stage 2: Does something in the current room want to give a custom effect to falling? FIRST FALLING RULE
Stage 3: Does something in the destination room want to give a custom effect to falling? FALLING RULE
Stage 4: Otherwise, we apply standard damage in the LAST FALLING RULE.]

Falling rule (this is the move the falling person to the destination rule):
	if falling-test-person is the player:
		consider the sudden combat reset rules;
	move falling-test-person to falling-destination.

Last falling rule (this is the standard deal falling damage rule):
	unless falling-test-person is flying:
		unless falling-test-person is ethereal:
			let m be a random number between 2 and 5;
			if falling-reason is 2:
				decrease m by 1; [small bonus for voluntary jumping]
			if a random chance of 1 in 4 succeeds:
				increase m by 5;
			calculate the pdr for falling-guy;
			decrease m by pdr;
			if m is less than 0:
				now m is 0;
			if falling-test-person is the player:
				say "With a loud smack, you land in [the location], [if m is 0]receiving no damage[otherwise]receiving [bold type][m] damage[roman type][end if].";
				decrease health of player by m;
				now concentration of player is 0;
				now the take no time boolean is false;
				if player is dead:
					end the story saying "Your death was not particularly heroic.";
			otherwise:
				decrease the health of the falling-test-person by m;
				now concentration of the falling-test-person is 0;
				if the location of falling-test-person is the location of the player and m is not 0:
					say "[The falling-test-person] receives [m] damage from the fall.".



Chapter - Player forms

[The player can take on different forms: human-form, ghoul, vampire, vampire bat, ...

The variabel "current form" contains the current player form.

In addition, forms are either form-active or not form-active. Active forms are those that a player can switch to -- assuming we have built te code to do so, of course.]

Player form is a kind of value.

The player forms are defined by the Table of Forms.

Table of Forms
player form
human-form
ghoul-form
vampire-form
vampirebat-form

Table of Form Properties
player form		turn-text									turn type			special rule
human-form		"You turn back into a normal human being."	living			the turn-living rule
ghoul-form		"You turn into a loathsome ghoul!"			undead			the turn-undead rule
vampire-form		"You turn into a vampire!"					undead			the turn-undead rule
vampirebat-form	"You turn into a vampire bat!"				undead			the turn-undead rule

Current form is a player form that varies.
Current form is human-form.

A player form can be form-active. A player form is usually not form-active.
Human-form is form-active.

This is the turn-living rule:
	now undead-faction hates friendly;
	now friendly hates undead-faction;
	now undead-faction hates player-enslaved;
	now player-enslaved hates undead-faction.
	
This is the turn-undead rule:
	now undead-faction does not hate friendly;
	now friendly does not hate undead-faction;
	now undead-faction does not hate player-enslaved;
	now player-enslaved does not hate undead-faction.




Section - Trumping relation

[Trumping: if A trumps B, and A is active, then when the player would turn into B, she turns into A instead. For instance, ghoul form trumps human form. If the player were to switch from vampire form back to human form, but ghoul form is active, she'll return to being a ghoul instead.]

Trumping relates various player forms to various player forms.

The verb to trump (he trumps, they trump, he trumped, it is trumped, he is trumping) implies the trumping relation. 

Ghoul-form trumps human-form.
Vampire-form trumps human-form.
Vampire-form trumps ghoul-form.
Vampirebat-form trumps human-form.
Vampirebat-form trumps ghoul-form.

[Please don't make circular trumping relations. This will lead to infinite loops.]



Section - Changing form

Target form is a player form that varies.

To find the trump of (Y - a player form):
	now target form is Y;
	repeat with X running through player forms:
		if X is form-active and X trumps target form:
			unless current form trumps target form and X is not current form: [Prefer staying the same. Works only one level deep; can be changed if necessary, but would be costly and useless at the moment.]
				now target form is X;
	unless target form is Y:
		find the trump of target form.

To turn the player into (X - a player form):
	find the trump of X;
	unless target form is current form:
		choose row with a player form of target form in Table of Form Properties;
		now current form is target form;
		now type of the player is turn type entry;
		consider the special rule entry;
		say turn-text entry;
		say "[line break]";
	otherwise:
		say "You don't seem to change.".



Section - Human




Section - Ghoul

To ghoulify the player:
	now ghoul-form is form-active;
	turn the player into ghoul-form.

An attack modifier rule (this is the ghoul has less chance to hit rule):
	if the global attacker is the player and current form is ghoul-form:
		say " - 1 (ghoul)[run paragraph on]";
		decrease the attack strength by 1.

A damage modifier rule (this is the ghoul gives damage resistance rule):
	if the global attacker is the player and current form is ghoul-form:
		say " - 1 (you are a ghoul)[run paragraph on]";
		decrease the attack damage by 1.

A physical damage reduction rule (this is the ghoul damage reduction rule):
	if the test subject is the player and the current form is ghoul-form:
		increase the pdr by 1.

Status rule (this is the ghoul status rule):
	if current form is ghoul-form:
		say "You are a [bold type]ghoul[roman type]: -1 attack; +1 damage resistance.[line break][run paragraph on]".

To unghoulify the player:
	now ghoul-form is not form-active;
	turn the player into human-form.


Section - Vampire


To vampirise the player:
	now vampire-form is form-active;
	now vampirebat-form is form-active;
	turn the player into vampire-form.

This is the turn-vampire rule:
	say "".

Status rule (this is the vampire status rule):
	if current form is vampire-form:
		say "You are a [bold type]vampire[roman type]: +2 willpower, +1 attack, -2 defence, modest bonus to hiding, can turn into a [italic type]bat[roman type].[line break][run paragraph on]".

A faculty bonus rule (this is the mind bonus of vampire rule):
	if tested faculty is mind:
		if the test subject is the player and the current form is vampire-form:
			increase test score by 2;
			[say " + 2 (vampire)[run paragraph on]"].

An attack modifier rule (this is the vampire has more chance to hit rule):
	if the global attacker is the player and current form is vampire-form:
		say " + 1 (vampire)[run paragraph on]";
		increase the attack strength by 1.

An attack modifier rule (this is the vampire has more chance to be hit rule):
	if the global defender is the player and the current form is vampire-form:
		say " + 2 (you are a vampire)[run paragraph on]";
		increase the attack strength by 2.

Chance to win rule when the global defender is the player and current form is vampire-form (this is the CTW versus vampire rule):
	increase the chance-to-win by 2.
		
Detection rule (this is the vampire detection rule):
	if the current form is vampire-form:
		decrease the detection probability by 5.

To unvampirise the player:
	now the faction of the player is friendly;
	now current form is human-form.


Section - Vampire bat

This is the turn-vampire-bat rule:
	say "".

Status rule (this is the vampire bat status rule):
	if current form is vampirebat-form:
		say "You are a [bold type]vampire bat[roman type]: +2 defence, -2 attack, large bonus to hiding, bonus to running away, flying, cannot use weapons or clothing, can turn back into a [italic type]vampire[roman type].[line break][run paragraph on]".

An attack modifier rule (this is the vampire bat has less chance to be hit rule):
	if the global defender is the player and current form is vampirebat-form:
		say " - 2 (bat form)[run paragraph on]";
		decrease the attack strength by 2.

Chance to win rule when the global defender is the player and current form is vampirebat-form (this is the CTW versus vampire bat rule):
	decrease the chance-to-win by 2.
		
An attack modifier rule (this is the vampire bat has less chance to hit rule):
	if the global attacker is the player and current form is vampirebat-form:
		say " - 2 (bat form)[run paragraph on]";
		decrease the attack strength by 2.		

Detection rule (this is the vampire bat detection rule):
	if the current form is vampirebat-form:
		decrease the detection probability by 20.

A flying rule (this is the vampire bat flies rule):
	if test subject is player and the current form is vampirebat-form:
		rule succeeds.

An attack modifier rule (this is the vampire bat grants better retreat rule):
	if the global defender is the player and current form is vampirebat-form and the global defender is retreater:
		say " - 2 (bat form retreat bonus)[run paragraph on]";
		decrease the attack strength by 2;
	if the global defender is the player and current form is vampirebat-form and the global defender is runner:
		say " - 2 (bat form retreat bonus)[run paragraph on]";
		decrease the attack strength by 2.	

Check readying (this is the vampire bat cannot ready a weapon rule):
	if the current form is vampirebat-form:
		take no time;
		say "In bat form, you cannot use weapons." instead.

Check wearing (this is the vampire bat cannot wear clothing rule):
	if the current form is vampirebat-form:
		take no time;
		say "In bat form, you cannot wear clothing." instead.

Every turn when the current form is vampirebat-form (this is the unready readied weapons when bat rule):
	if the player encloses at least one readied weapon:
		repeat with X running through readied weapons enclosed by the player:
			unless X is a natural weapon:
				say "Your claws cannot effectively wield [the X].";
				now X is not readied.

Section - Commands for turning into vampire and vampire bat

Turning vampire is an action applying to nothing. Understand "vampire" and "turn vampire" as turning vampire.

Check turning vampire:
	if vampire-form is not form-active:
		take no time;
		say "You do not possess that power." instead;
	if the current form is vampire-form:
		say "You already are in vampire form." instead;

Carry out turning vampire:
	turn the player into vampire-form.

Turning bat is an action applying to nothing. Understand "bat" and "bat form" and "vampire bat" as turning bat.

Check turning bat:
	if vampirebat-form is not form-active:
		take no time;
		say "You do not possess that power." instead;
	if the current form is vampirebat-form:
		say "You already are in vampire bat form." instead;

Carry out turning bat:
	turn the player into vampirebat-form;
	repeat with X running through weapons enclosed by the player:
		now X is not readied;
	repeat with X running through clothing enclosed by the player:
		now the player carries X.


Kerkerkruip Systems ends here.
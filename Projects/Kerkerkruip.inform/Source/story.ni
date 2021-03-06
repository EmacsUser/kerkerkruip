"Kerkerkruip" by Victor Gijsbers

The story headline is "An IF roguelike".
The story genre is "dungeon crawl".
The release number is 9.
Release along with [cover art and] a file of "Gargoyle config file" called "Kerkerkruip.ini".



Section - 3rd Party Inclusions

[ Check https://github.com/i7/extensions if the I7 site only has older versions ]

[Include version 1/131215 of Alternative Startup Rules by Dannii Willis.]
	
Include Basic Screen Effects by Emily Short. 
Include Numbered Disambiguation Choices by Aaron Reed.
Include version 10/140201 of Glulx Entry Points by Emily Short.
Include version 7/130712 of Dynamic Objects by Jesse McGrew.
Include Fixed Point Maths by Michael Callaghan.
Include Questions by Michael Callaghan.



Section - Graphics and Windows

[ Testing with Glimmr installed will be slower, due to compilation and graphics, so commits to story.ni would generally best be made with it commented out. It is not necessary to comment out Flexible Windows when Glimmr is commented in. ]

Include version 13/131208 of Flexible Windows by Jon Ingold.

[Include Kerkerkruip Glimmr Additions by Erik Temple.]

Include version 1/131214 of Menus by Dannii Willis.
Include Kerkerkruip Windows by Erik Temple.

[Include Extended Debugging by Erik Temple.]



Section - Include ATTACK

[ Get the latest ATTACK at https://github.com/i7/ATTACK ]
Include version 5/140131 of Inform ATTACK by Victor Gijsbers.



Section - Include all the Kerkerkruip extensions

Include Kerkerkruip Permadeath by Victor Gijsbers.
Include Kerkerkruip Persistent Data by Victor Gijsbers.
Include Kerkerkruip Dungeon Generation by Victor Gijsbers.
Include Kerkerkruip Events by Victor Gijsbers.
Include Kerkerkruip ATTACK Additions by Victor Gijsbers.
Include Kerkerkruip Monster Abilities by Victor Gijsbers.
Include Kerkerkruip Systems by Victor Gijsbers.
Include Kerkerkruip Systems - Hiding Smoke Ethereal by Victor Gijsbers.
Include Kerkerkruip Actions and UI by Victor Gijsbers.
Include Kerkerkruip Items by Victor Gijsbers.
Include Kerkerkruip Religion by Victor Gijsbers.
Include Kerkerkruip Locations by Victor Gijsbers.
Include Kerkerkruip Scenery by Victor Gijsbers.
Include Kerkerkruip Monsters by Victor Gijsbers.
Include Kerkerkruip Events and Specials by Victor Gijsbers.
Include Kerkerkruip Dreams by Victor Gijsbers.
Include Kerkerkruip Ugly Special Cases by Victor Gijsbers.
Include Kerkerkruip Start and Finish by Victor Gijsbers.
Include Kerkerkruip Tests by Victor Gijsbers.
Include Kerkerkruip Final Declarations by Victor Gijsbers.
Include Kerkerkruip Help and Hints by Victor Gijsbers.


Section - Increase memory settings

Use MAX_PROP_TABLE_SIZE of 800000.
Use MAX_OBJ_PROP_COUNT of 256.
Use MAX_STATIC_DATA of 500000.
Use MAX_OBJECTS of 1000.
Use MAX_SYMBOLS of 30000.
Use MAX_ACTIONS of 250.
Use MAX_LABELS of 20000.
Use ALLOC_CHUNK_SIZE of 32768.



Section - Score

The maximum score is 18. [1 + 1 + 2 + 2 + 3 + 4 + 5 = 18]
The notify score changes rule is not listed in any rulebook.



Section - Generation info

Generation info is a truth state that varies. Generation info is [true]false.



Section - Testing - Not for release


[Last when play begins:
	move Fafhrd to Entrance Hall;
	now Fafhrd is asleep.]

[Last when play begins:
	Now every medium banquet-dining person is seen;

Every turn:
	if Banquet is dreamable:
		Now Banquet is current-test-dream;
	otherwise:
		now Banquet is not current-test-dream;]

[Dream of Tungausy Shaman is current-test-dream.]


Section - Flexible Windows relisting

[Kerkerkruip's when play begin rules don't fire until after the menu is cleared. This means that extension such as Flexible Windows that have critical startup code in when play begins need to be adjusted. Due to weaknesses in Inform's extension interactions, this has to be in story.ni rather than the Kerkerkruip Glimmr Additions extension.]

The allocate rocks rule is not listed in the when play begins rules. The allocate rocks rule is listed before the show the title screen rule in the startup rules.
The initial hyperlink request rule is not listed in the when play begins rules. The initial hyperlink request rule is listed before the show the title screen rule in the startup rules.

Section - Relist rock validation rule (not for release)

The rock validation rule is not listed in the when play begins rules. The rock validation rule is listed before the show the title screen rule in the startup rules.



Section - Defining perform syntax (not for use with Glimmr Canvas Animation by Erik Temple)

To say perform/@ (ph - phrase): (- if (0==0) {ph} -).



Section - Plurality fix

[Let's see whether this works.]

To decide whether (item - an object) acts plural: 
	if the item is plural-named:
		yes;
	no.




Chapter - Questions fixes

[This needs a lot of tweaks!]

Section - Rules for menu questions (in place of Section 3 - Rules for menu questions in Questions by Michael Callaghan)

Menu question rules is a rulebook.

The menu question rules have outcomes exit (success), retry (failure), menu (failure) and parse (failure).

The first menu question rule (this is the invalid menu reply rule):
	if the player's command matches "help" or the player's command matches "menu" or the player's command matches "hint" or the player's command matches "info":
		if closed question mode is true and menu question mode is true:
			menu;		
	if the player's command does not match "[number]":
		if closed question mode is true:
			retry;
		if closed question mode is false:
			parse;
	if the number understood is less than 1:
		retry;
	if the number understood is greater than the number of entries in the current question menu:
		retry.

The last menu question rule (this is the default menu question rule):
	exit.

	
Section - Questions fix (in place of Section 4 - Processing menu questions in Questions by Michael Callaghan)

[We need to end the turn after a menu, otherwise no rules run.]

Repeat-question is a truth state that varies. Repeat-question is false.

After reading a command when menu question mode is true:
	follow the menu question rules;
	if the outcome of the rulebook is the menu outcome:	
		now repeat-question is true;
	if the outcome of the rulebook is the exit outcome:
		deactivate menu question mode;
		follow the every turn rules;
		follow the advance time rule;
		change the text of the player's command to "dontparse";
	if the outcome of the rulebook is the retry outcome:
		reject the player's command;
	if the outcome of the rulebook is the parse outcome:
		deactivate menu question mode.
		
Dontparsing is an action applying to nothing. Understand "dontparse" as dontparsing.

Carry out dontparsing:
	do nothing instead.

Section - Another Questions fix (in place of Section 4 - Phrase used to ask questions in closed mode in Questions by Michael Callaghan)

The saved question prompt is text that varies.

To ask a closed question, in number mode, in menu mode, in yes/no mode, in gender mode or in text mode:
	now closed question mode is true;
	now saved prompt is the command prompt;
	if in number mode:
		now the command prompt is the closed number prompt;
		now number question mode is true;
	if in menu mode:
		now the command prompt is the closed menu prompt;
		now menu question mode is true;
	if in yes/no mode:
		now the command prompt is the closed yes/no prompt;
		now yes/no question mode is true;
	if in gender mode:
		now the command prompt is the closed gender prompt;
		now gender question mode is true;
	if in text mode:
		now the command prompt is the closed text prompt;
		now text question mode is true;
	if current question is not "":
		say "[current question][line break]";
	now saved question prompt is the command prompt;
	if in menu mode:
		repeat with counter running from 1 to the number of entries in the current question menu:
			say "[counter] - [entry counter of the current question menu][line break]".






	
Section - Numbered Disambiguation Fix

[Not sure if this is necessary, but it won't do any harm!]

Definition: an object (called item) is still-disambiguable if disambiguation ID of item > 0.

Before looking or taking inventory (this is the reset disambiguation IDs rule):
	repeat with item running through still-disambiguable things:
		now disambiguation ID of item is 0.

Section - Auto-transcript while testing (not for release)

Last when play begins:
	try switching the story transcript on;
	try asking status;
	try taking inventory.
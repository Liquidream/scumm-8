pico-8 cartridge // http://www.pico-8.com
version 8
__lua__

-- scumm-8
-- paul nicholas

-- debugging
show_debuginfo = true
show_collision = false
show_perfinfo = true
enable_mouse = true

-- game verbs (used in room definitons and ui)
verbs = {
	--verb, name, bounds{},
	{"open", "open"},
	{"close", "close"},
	{"give", "give"},
	{"pickup", "pick-up"},
	{"lookat", "look-at"},
	{"talkto", "talk-to"},
	{"push", "push"},
	{"pull", "pull"},
	{"use", "use"}
}
verb_default = {"walkto", "walk to"} -- verb to use when just clicking aroung (e.g. move actor)


-- object states
state_closed = "closed"
state_off = "off"
state_here = "here"
state_open = "open"
state_on = "on"
state_gone = "gone"

-- object classes
class_untouchable = "untouchable" -- will not register when the cursor moves over it. the object is invisible to the user.
class_pickupable = "pickupable"   -- can be placed in actor inventory



-- #######################################################
-- actor definitions
-- #######################################################

main_actor = { 				-- initialize the sprite object
	x = 127/2 - 16, -- sprites x position
	y = 127/2, 	-- sprites y position
	spr = 3, 				-- sprite starting frame
	sprw = 1,
	sprh = 4,
	flp = false, 			-- used for flipping the sprite
	col = 12,				-- speech text colour
	speed = 1,  			-- walking speed
	moving = 0, 			-- 0=stopped, 1=walking, 2=arrived
	tmr = 1, 				-- internal timer for managing animation
	inventory = {
		-- object1,
		-- object2
	}
}

-- set which actor the player controls by default
selected_actor = main_actor

-- #######################################################
-- room definitions
-- #######################################################
first_room = {
	map = {
		x = 0,
		y = 0,
		w = 16,	-- default these?
		h = 8	-- 
	},
	--sounds = {},
	--costumes = {},
	enter = function()
		-- animate fireplace
		while true do		
			set_state("fire", "frame1")
			break_time(8)
			set_state("fire", "frame2")
			break_time(8)
			set_state("fire", "frame3")
			break_time(8)
		end
	end,
	exit = function()
		-- todo: anything here?
	end,
	lighting = 0, -- state of lights in current room
	scripts = {	  -- scripts that are at room-level
		move_bozo = function()
			while true do		
				set_state("bozo", "frame1")
				break_time(8)
				set_state("bozo", "frame2")
				break_time(8)
				set_state("bozo", "frame1")
				break_time(8)
				set_state("bozo", "frame3")
				break_time(8)
				set_state("bozo", "frame3")
				break_time(8)
			end
		end
	},		
	objects = {
		fire = {
			name = "fire",
			state = "frame1",
			--state = 0,
			x = 8*8, -- (*8 to use map cell pos)
			y = 4*8,
			states = {
				-- states are spr values
				frame1 = 23, 
				frame2 = 24,
				frame3 = 25
			},
			w = 1,	-- relates to spr or map cel, depending on above
			h = 1,  --
			transcol = 0,
			--bounds = {} -- generated on draw
				
			--[dependent-on object-name being object-state]
			--[class is class-state [class-state]]
			verbs = {
				lookat = function()
					--origx=selected_actor.x
					--origy=selected_actor.y
					--walk_to(actor, room_curr.objects.fire.x-5, room_curr.objects.fire.y+15)
					say_line(selected_actor, "it's a nice, warm fire...")
					wait_for_message()
					break_time(10)
					say_line(selected_actor, "ouch! it's hot!")
					wait_for_message()
					--walk_to(actor, origx, origy)
					say_line(selected_actor, "*stupid fire*")
				end
			}
		},
		front_door = {
			name = "front door",
			--dependent_on = "closet-door",
			--dependent_on_state = state_closed,
			state = state_closed,
			x = 1*8, -- (*8 to use map cell pos)
			y = 2*8,
			states = {
				-- states are spr values
				closed = 4, -- state_closed
				open = 0 -- state_open
			},
			flip_x = false, -- used for flipping the sprite
			flip_y = false,
			w = 1,	-- relates to spr or map cel, depending on above
			h = 4,  --
			verbs = {
				walkto = function()
					printh("me = "..type(me))
					if state_of(me) == state_open then
						-- todo: go to new room!
					else
						say_line(selected_actor, "the door is closed")
					end
				end,
				open = function()
					if (isnull(me)) printh("me is NULL!")
					printh("me = "..me.name)
					if state_of(me) == state_open then
						say_line(selected_actor, "it's already open!")
					else
						set_state(me, state_open)
					end
				end,
				close = function()
					set_state(me, state_closed)
				end
			}
		},
		bat = {
			name = "bat",
			class = class_pickupable,
			state = state_closed,
			x = 11*8, -- (*8 to use map cell pos)
			y = 5*8,
			w = 1,	-- relates to spr or map cel, depending on above
			h = 1,  --
			states = {
				-- states are spr values
				closed = 7 -- state_closed
				--open = 0 -- state_open
			},
			--owner (set on pickup)
			--hidden (invisible + non-collidable)
			--[dependent-on object-name being object-state]
			--class is class-state [class-state]
			verbs = {
				lookat = function()
					if owner_of("bat") == selected_actor then
						say_line(selected_actor, "it is a bat in my pocket!")
					else
						say_line(selected_actor, "it is a bat!")
					end
				end,
				pickup = function()
					printh("b4 pickup")
					pickup_obj("bat")
				end,
				use = function()
					--printh("in bat use()...")
					--printh("noun2 type: "..type(noun2_curr))
					if (isnull(noun2_curr)) printh("noun2_curr: null")
					--printh("noun2_curr: "..noun2_curr.name)
					if (noun2_curr.name == "window") then
						--printh("111")
						set_state("window", state_open)
					end
				end
			}
		},
		bozo = {
			name = "bozo",
			state = "frame1",
			--state = 0,
			x = 2*8, -- (*8 to use map cell pos)
			y = 6*8,
			states = {
				-- states are spr values
				frame1 = 64, 
				frame2 = 65,
				frame3 = 66
			},
			w = 1,	-- relates to spr or map cel, depending on above
			h = 1,  --
			verbs = {
				push = function()
					printh("here1!")
					if script_running(room_curr.scripts.move_bozo) then
						stop_script(room_curr.scripts.move_bozo)
						set_state(me, "frame1")
					else
						start_script(room_curr.scripts.move_bozo)
					end
				end,
				pull = function()
					printh("here2!")
					stop_script(room_curr.scripts.move_bozo)
					set_state(me, "frame1")
				end
			}
		},
		window = {
			name = "window",
			state = state_closed,
			x = 4*8, -- (*8 to use map cell pos)
			y = 2*8,
			w = 2,	-- relates to spr or map cel, depending on above
			h = 2,  --
			states = {
				-- states are spr values
				closed = 80, -- state_closed
				open = 82 -- state_open
			}
		}
	}
}

second_room = {
	map = {
		x = 16,
		y = 0,
		w = 16,	-- default these?
		h = 8	-- 
	},
	enter = function()
		-- todo: anything here?
	end,
	exit = function()
		-- todo: anything here?
	end,
	scripts = {	  -- scripts that are at room-level
	},
	objects = {
		back_door = {
			name = "back door",
			--dependent_on = "closet-door",
			--dependent_on_state = state_closed,
			state = state_closed,
			x = 14*8, -- (*8 to use map cell pos)
			y = 2*8,
			states = {
				-- states are spr values
				closed = 4, -- state_closed
				open = 0 -- state_open
			},
			flip_x = true, -- used for flipping the sprite
			flip_y = false,
			w = 1,	-- relates to spr or map cel, depending on above
			h = 4,  --
			--default_verb = "open",
			verbs = {
				walkto = function()
					printh("me = "..type(me))
					if state_of(me) == state_open then
						-- todo: go to new room!
					else
						say_line(selected_actor, "the door is closed")
					end
				end,
				open = function()
					printh("me = "..me.name)
					if state_of(me) == state_open then
						say_line(selected_actor, "it's already open!")
					else
						set_state(me, state_open)
						default_verb = "close"
					end
				end,
				close = function()
					set_state(me, state_closed)
					default_verb = "open"
				end
			}
		},
	},
}


-- set which room to start the game in 
-- (could be a "pseudo" room for title screen!)
selected_room = first_room
--selected_room = second_room

-- logic used to determine a "default" verb to use
-- (e.g. when you right-click an object)
function find_default_verb(obj)
  local default_verb = nil
	-- look for verbs in the following order of priority
	local verb_ordered_list = {
		"open", "close", "talkto", "lookat", "push", "pull"
	}

	for v in all(verb_ordered_list) do
		-- if object supports current verb
	  if valid_verb(v, obj) then
			-- check for reasons NOT to use this verb
			if (v == "open" and obj.state != state_closed) 
			or (v == "close" and obj.state != state_open)
			--or (v == "talkto" and obj.class == class_ACTOR!!!)
			--or (v == "lookat")
			then
				-- not suitable ver, continue
			else
				-- found default verb
				default_verb = v
				break
			end
		end
	end

	-- now find the full verb definition
	for v in all(verbs) do
		if (v[1] == default_verb) default_verb=v break
	end

	return default_verb
end









-- #######################################################
-- internal scumm-8 workings
-- #######################################################


-- global vars
--scene=1
screenwidth = 127
screenheight = 127
stage_top = 16

-- offset to display speech above actors (dist in px from their feet)
text_offset = (selected_actor.sprh+2)*8

camera = {}
camera.x = 0
camera.max = 0 -- the maximum x position the camera can move to in the current room
camera.min = 0 -- the minimum x position the camera can move to in the current room

cursor = {}
cursor.x = screenwidth/2
cursor.y = screenheight/2
cursor.tmr = 0 -- used to animate cursor col
cursor.cols = {7,12,13,13,12,7}
cursor.colpos = 1 

-- keeps reference to currently hovered items
-- e.g. objects, ui elements, etc.
hover_curr = {
	-- verb, 
	-- default_verb,
	-- object, 
	-- ui_arrow, 
	-- inv_object (NOT USED - same as object)
}

last_mouse_x = 0
last_mouse_y = 0
-- wait for button release before repeating action
ismouseclicked = false

verb_curr = nil --verb_default
noun1_curr = nil -- main/first object in command
noun2_curr = nil -- holds whatever is used after the preposition (e.g. "with <noun2>")
cmd_curr = "" -- contains last displayed or actioned command
executing_cmd = false
dialog_curr = nil -- {x,y,col}
me = nil -- same as noun1_curr (to make scripting easier)

global_scripts = {}		-- table of scripts that are at game-level

active_scripts = {}		-- table of scripts that are actively running
room_curr = nil			-- contains the current room definition
room_stash = nil		-- contains the "paused" room before cutscene(s)






-- game loop

function _init()
-- this function runs as soon as the game loads
	
	-- use mouse input?
	if (enable_mouse) poke(0x5f2d, 1)

	-- load the initial room
	change_room(selected_room)
end

function _update60()	-- _update()
	-- if scene==0 then
	-- 	titleupdate()
	-- elseif scene==1 then
		gameupdate()
	--end
end

function _draw()
	-- if scene==0 then
	-- 	titledraw()
	-- elseif scene==1 then
		gamedraw()
	-- end
end
-- update functions
-- function titleupdate()
-- 	if btnp(4) then
-- 		scene=1
-- 	end
-- end

function gameupdate()
	-- process selected_actor threads/actions
	if selected_actor.thread and not coresume(selected_actor.thread) then
		selected_actor.thread = nil
	end

	-- update all the active scripts
	-- (will auto-remove those that have ended)
	for scr_obj in all(active_scripts) do
		if scr_obj[2] and not coresume(scr_obj[2]) then
			del(active_scripts, scr_obj)
			scr_obj = nil
		end
	end

	-- selected_actor/ui control
	selected_actorcontrol()

	-- check for collisions
	checkcollisions()
end

-- draw functions
-- function titledraw()
-- 	local titletxt = "title screen"
-- 	local starttxt = "press z to start"
-- 	rectfill(0,0,screenwidth, screenheight, 3)
-- 	print(titletxt, hcenter(titletxt), screenheight/4, 10)
-- 	print(starttxt, hcenter(starttxt), (screenheight/4)+(screenheight/2),7)			
-- end

function gamedraw()
	--local gametxt = "game screen"

	-- clear screen every frame?
	rectfill(0,0,screenwidth, screenheight, 0)

	-- draw room (bg + objects)
	roomdraw()

	-- draw selected_actor/actor
	selected_actordraw()

	-- draw active dialog
	dialogdraw()

	-- draw current command (verb/object)
	commanddraw()

	-- draw ui and inventory
	uidraw()

	cursordraw()

	if (show_perfinfo) print("cpu: "..stat(1), 0, stage_top - 8, 8)
	if (show_debuginfo) print("x: "..cursor.x.." y:"..cursor.y, 80, stage_top - 8, 8)
	
end


-- handle button inputs
function selected_actorcontrol()	
	-- 
	if (btn(0)) cursor.x-=1 
	if (btn(1)) cursor.x+=1 
	if (btn(2)) cursor.y-=1
	if (btn(3)) cursor.y+=1

	if (btnp(4)) input_button_pressed(1) 
	if (btnp(5)) input_button_pressed(2)

	-- only update position if mouse moved
	if (enable_mouse) then	
		if (stat(32)-1 != last_mouse_x) cursor.x = stat(32)-1	-- mouse xpos
		if (stat(33)-1 != last_mouse_y) cursor.y = stat(33)-1	-- mouse ypos
		-- don't repeat action if same press/click
		if (stat(34) > 0) then
			if (not ismouseclicked) then
				input_button_pressed(stat(34))
				ismouseclicked = true
			end
		else
			ismouseclicked = false
		end		-- mouse button state
		-- store for comparison next cycle
		last_mouse_x = stat(32)-1
		last_mouse_y = stat(33)-1
	end

	-- keep cursor within screen
	cursor.x = max(cursor.x, 0)
	cursor.x = min(cursor.x, 127)
	cursor.y = max(cursor.y, 0)
	cursor.y = min(cursor.y, 127)
end

function input_button_pressed(button_index)	-- 1 = z/lmb, 2 = x/rmb, (4=middle)

	local verb_in = verb_curr
	--local obj_in = object_curr

	for k,h in pairs(hover_curr) do
		if type(h) != nil then
			-- found something being hovered...
			if k == "verb" then
				verb_curr = h
				printh("verb = "..h[1])
				break
			elseif k == "object" then
				-- if valid obj, complete command
				-- else, abort command (clear verb, etc.)
				if button_index == 1 then
					if verb_curr[1] == "use" and notnull(noun1_curr) then
						noun2_curr = h
						printh("noun2_curr = "..noun2_curr.name)					
					else
						noun1_curr = h
						me = noun1_curr
						printh("noun1_curr = "..noun1_curr.name)
					end
				elseif (notnull(hover_curr.default_verb)) then
					-- TODO: perform default verb action (if present)
					verb_curr = hover_curr.default_verb
					noun1_curr = h
					me = noun1_curr
					-- force repaint of command (to reflect default verb)
					commanddraw()	
					break
					--[[for v in all(verbs) do
						if (v[1] == h.default_verb) verb_curr=v break
					end
					noun1_curr = h]]
				end
				--printh("object = "..h.name)
				break
			elseif k == "ui_arrow" then
				break
			elseif k == "inv_object" then
				break
			else
				-- what else could there be?
			end
		end
	end

	-- attempt to use verb on object
	if (noun1_curr != nil) then
		-- are we starting a 'use' command?
		if verb_curr[1] == "use" then
			if notnull(noun2_curr) then
				-- 'use' part 2
			else
				-- 'use' part 1 (e.g. "use hammer")
				-- wait for noun2 to be set
				return
			end
		end
		-- execute verb script
		executing_cmd = true
		selected_actor.thread = cocreate(function(actor, obj, verb)
			if isnull(obj.owner) then
				-- todo: walk to use pos and face dir
				walk_to(selected_actor, obj.x+((obj.w*8)/2), obj.y+(obj.h*8))
			end
			-- does current object support active verb?
			if valid_verb(verb,obj) then
			--if (notnull(obj.verbs)) 
			--and (notnull(obj.verbs[verb[1]])) then
				-- finally, execute verb script
				printh("verb_obj_script!")
				printh("verb = "..verb[1])
				printh("obj = "..obj.name)
				start_script(obj.verbs[verb[1]])
			elseif verb[1] != verb_default[1] then
				say_line(selected_actor, "i don't think that will work")
			end
		end)
		coresume(selected_actor.thread, selected_actor, noun1_curr, verb_curr)
		--end
	elseif (cursor.y > stage_top and cursor.y < stage_top+64) then
		-- in map area
		executing_cmd = true
		-- todo: determine if within walkable area
		selected_actor.thread = cocreate(walk_to)
		coresume(selected_actor.thread, selected_actor, cursor.x, cursor.y - stage_top)
	end

	--printh(verb_curr[1])

	-- show highlighted for a few secs 
	-- (or until completed - e.g. after walkto)
	-- clear command	
	if  (executing_cmd) then
		start_script(function()
			while (selected_actor.moving==1) do
				-- wait for selected_actor
				--printh("wait for selected_actor (b4 wiping command)...")
				break_time(1)
			end
			-- wait some more to allow scripts to run
			printh("wait b4 wiping command...")
			break_time(4)
			verb_curr = verb_default
			noun1_curr = nil
			noun2_curr = nil
			me = nil
			executing_cmd = false
			cmd_curr = ""
		end)
  end

	printh("--------------------------------")
end

-- collision detection
function checkcollisions()
--printh("in checkcollisions()...")
	--printh("verbs = "..#verbs)

	-- reset hover collisions
	hover_curr = {}

	-- ########################################################################
	-- todo: consolodate this into generic bounds-check routine! ######################
	-- ########################################################################

	-- todo: check room/object collisions
	for k,obj in pairs(room_curr.objects) do
		if (type(obj.bounds) != 'nil') then

			xcoll=true; ycoll=true
			if (cursor.x>obj.bounds.x1 or cursor.x<obj.bounds.x) xcoll=false
			if (cursor.y>obj.bounds.y1 or cursor.y<obj.bounds.y) ycoll=false
			
			if xcoll and ycoll then
				hover_curr.object = obj
			else
				--
			end
		end
	end

	-- todo: check ui/inventory collisions
	for v in all(verbs) do
		-- aabb
		if (type(v.bounds) != 'nil') then
			xcoll=true; ycoll=true
			if (cursor.x>v.bounds.x1 or cursor.x<v.bounds.x) xcoll=false
			if (cursor.y>v.bounds.y1 or cursor.y<v.bounds.y) ycoll=false
			
			if xcoll and ycoll then
				hover_curr.verb = v
			else
				--
			end
		end
	end

	-- default to walkto (if nothing set)
	if (verb_curr == nil) then
		verb_curr = verb_default
	end

	-- update "default" verb for hovered object (if any)
	if notnull(hover_curr.object) then
		hover_curr.default_verb = find_default_verb(hover_curr.object)
	end
end

function roomdraw()
	-- draw current room (base layer)
	room_map = room_curr.map
	map(room_map.x, room_map.y, 0, stage_top, room_map.w, room_map.h) --,layer
	
	-- debug walkable areas
	if show_collision then
		celx = flr(cursor.x/8)
		cely = flr((cursor.y - stage_top)/8)
		spr_num = mget(celx, cely)
		--printh("spr:"..spr_num)
		walkable = fget(spr_num,0)
		--printh("flg:"..flags)
		if walkable then
			rect(celx*8, stage_top+(cely*8), celx*8+8, stage_top+(cely*8)+8, 11)
		end
	end

	-- draw all "visible" room objects (e.g. check dependent-on's)
	for k,obj in pairs(room_curr.objects) do
		-- todo: check dependent-on's
		if (type(obj.states) != "nil") 
			and (obj.states[obj.state] > 0)
			and (isnull(obj.owner)) then
			-- something to draw
			draw_object(obj)
			-- capture bounds
			recalc_obj_bounds(obj)
		end
	end
end

-- draw selected_actor
function selected_actordraw()
 	-- offets
	local offset_x = selected_actor.x - (selected_actor.sprw *8) /2
	local offset_y = selected_actor.y -(selected_actor.sprh * 8)

	sprdraw(selected_actor.spr, offset_x, offset_y, selected_actor.sprw , selected_actor.sprh, 11)
end

function commanddraw()
	-- draw current command
	command = ""
	cmd_col = 12

	if not executing_cmd then
		if notnull(verb_curr) then
			command = verb_curr[2]
		end
		if notnull(noun1_curr) then
			command = command.." "..noun1_curr.name
		end
		if verb_curr[1] == "use" and notnull(noun1_curr) then
			command = command.." with"
		end
		if notnull(noun2_curr) then
			command = command.." "..noun2_curr.name
		elseif notnull(hover_curr.object) 
			-- don't show use object with itself!
			and ( isnull(noun1_curr) or (noun1_curr != hover_curr.object) ) then
			command = command.." "..hover_curr.object.name
		end
		cmd_curr = command
	else
		-- highlight active command
		command = cmd_curr
		cmd_col = 7
	end

	print(smallcaps(command), 
		hcenter(command), 
		stage_top + 66, cmd_col)
end

function dialogdraw()
	-- alignment 
	--   0 = no auto-alignment
	--   1 = center horiz block
	--   2 = left horiz block
	--   3 = right horiz block
	if type(dialog_curr) != 'nil' then
		line_offset_y = 0
		for l in all(dialog_curr.msg_lines) do
			line_offset_x=0
			-- center-align line
			if dialog_curr.align == 1 then
				line_offset_x = ((dialog_curr.char_width*4)-(#l*4))/2
			end
			shadow_text(
				l, 
				dialog_curr.x + line_offset_x, 
				dialog_curr.y + line_offset_y, 
				dialog_curr.col)
			line_offset_y += 6
		end

		-- update message lifespan
		dialog_curr.time_left -= 1
		if (dialog_curr.time_left <=0) dialog_curr = nil
	end
end

-- draw ui and inventory
function uidraw()
	-- draw verbs
	xpos = 0
	ypos = stage_top + 75
	col_len=0


	for v in all(verbs) do
		--print(v[2], xpos, ypos+1, 1) -- shadow
		verbcol = 12  -- lightblue

		-- highlight default (first?) verb

		--if notnull(hover_curr.object) 
		-- and notnull(hover_curr.object.verbs) then
		 --and (hover_curr.object.verbs[1] == v) then

		 --todo: narrow down one default (valid!) verb per object
		 if notnull(hover_curr.default_verb)
		 	and (v == hover_curr.default_verb) then
		--[[if notnull(hover_curr.object)
		 and notnull(hover_curr.object.default_verb) 
		 and hover_curr.object.default_verb == v[1] then]]
			verbcol = 10 -- yellow
		end

		 	--[[for k,v_func in pairs(hover_curr.object.verbs) do
		 		--printh("> k:"..k.."   v:"..v[1])
			 	if k == v[1] then
				 --	printh("!!!")
		  		verbcol=10
					break
				end
			end]]
		--end
		if (v == hover_curr.verb) verbcol=7
		print(v[2], xpos, ypos, verbcol)  -- main
		-- capture bounds
		v["bounds"] = {
			x=xpos,
			y=ypos,
			x1= xpos + #v[2]*4-1,
			y1 = ypos+5
		}
		if (show_collision) rect(v.bounds.x, v.bounds.y, v.bounds.x1, v.bounds.y1, 8)
		--if (show_collision) rect(xpos, ypos, xpos + #v[2]*4-1, ypos+5, 8)
		-- auto-size column
		if (#v[2] > col_len) col_len = #v[2]
		ypos += 8
		-- move to next column
		if ypos >= stage_top + 95 then
			ypos = stage_top + 75
			xpos += (col_len + 1.0) * 4
			col_len = 0
		end
	end

	-- draw arrows
	sprdraw(16, 75, stage_top + 60, 1, 1, 0)
	sprdraw(48, 75, stage_top + 73, 1, 1, 0)

	-- draw inventory
	xpos = 86
	ypos = 76
	for ipos=1, 8 do
		-- draw inventory bg
		rectfill(xpos-1, stage_top+ypos-1, xpos+8, stage_top+ypos+8, 1)
		obj = selected_actor.inventory[ipos]
		if type(obj) != 'nil' then
			-- something to draw
			obj.x = xpos
			obj.y = ypos
			-- draw object/sprite
			draw_object(obj)
			-- re-calculate bounds (as pos may have changed)
			recalc_obj_bounds(obj)
		end
		xpos += 11
		if xpos >= 125 then
			ypos += 12
			xpos=86
		end
		ipos += 1
	end
end

-- draw cursor
function cursordraw()
	col = cursor.cols[cursor.colpos]
	-- switch sprite color accordingly
	pal(7,col)
	spr(32, cursor.x-4, cursor.y-3, 1, 1, 0)
	pal() --reset palette

	cursor.tmr += 1
	if (cursor.tmr > 7) then
		--reset timer
		cursor.tmr = 1
		-- move to next color?
		cursor.colpos += 1
		if (cursor.colpos > #cursor.cols) cursor.colpos = 1
	end
end

function sprdraw(n, x, y, w, h, transcol, flip_x, flip_y)
	-- switch transparency
 	palt(0, false)
 	palt(transcol, true)
	 -- draw sprite
	spr(n, x, stage_top + y, w, h, flip_x, flip_y) --
	-- restore trans
	palt(transcol, false)
	palt(0, true)
end

-- scumm core functions -------------------------------------------

function change_room(new_room)
	-- switch to new room
	-- todo: play the exit() script of old room
	-- todo: transition to new room (e.g. iris/swipe)
	-- todo: play the enter() script of new room
	room_curr = new_room
	-- execute "enter" code
	if notnull(room_curr.enter) then
		start_script(room_curr.enter)
	end
end

function valid_verb(verb, object)
	-- check params
	if (isnull(object)) return false
	if (isnull(object.verbs)) return false
	-- look for verb
	if type(verb) == "table" then
		if (notnull(object.verbs[verb[1]])) return true
	else
		if (notnull(object.verbs[verb])) return true
	end
	--[[for k,v_func in pairs(object.verbs) do
		if k == verb[1] then
			-- valid verb
			return true
		end
	end]]
	-- must not be valid if reached here
	return false
end

function pickup_obj(objname)
	obj = find_object(objname)
if notnull(obj) 
	 and notnull(obj.class) 
	 and obj.class == class_pickupable
	 and isnull(obj.owner) then
	 	printh("adding to inv")
		-- assume selected_actor picked-up at this point
		add(selected_actor.inventory, obj)
		obj.owner = selected_actor
	end
end

function owner_of(objname)
	obj = find_object(objname)
	if notnull(obj) then
		return obj.owner
	end
end

function state_of(objname, state)
	obj = find_object(objname)
	if notnull(obj) then
		return obj.state
	end
end

function set_state(objname, state)
	obj = find_object(objname)
	if notnull(obj) then
		obj.state = state
	end
end

-- find object by ref or name
function find_object(name)
	-- if object passed, just return object!
	--printh("type(name): "..type(name))
	if (type(name) == "table") return name
	-- else look for object by unique name
	for k,obj in pairs(room_curr.objects) do
		if (k == name) return obj
	end
end

function start_script(func)
	-- create new thread for script and add to list of active_scripts
	local thread = cocreate(func)
	add(active_scripts, {func, thread} )
end

function script_running(func)
	printh("script_running()")
	-- find script and stop it running
	for k,scr_obj in pairs(active_scripts) do
		printh("...")
		if (scr_obj[1] == func) then 
			printh("found!")
			return true
		end
	end
	-- must not be running
	return false
end

function stop_script(func)
	printh("stop_script()")
	-- find script and stop it running
	for k,scr_obj in pairs(active_scripts) do
		printh("...")
		if (scr_obj[1] == func) then 
			printh("found!")
			del(active_scripts, scr_obj)
			printh("deleted!")
			scr_obj = nil
		end
	end
end

function break_time(jiffies)
	-- draw object (depending on state!)
	for x = 1, jiffies do
		yield()
	end
end

function wait_for_message()
	-- draw object (depending on state!)
	while dialog_curr != nil do
		yield()
	end
end

-- uses actor's position and color
function say_line(actor, msg)
	-- get pos above actor's head
	ypos = actor.y-text_offset --((actor.sprh+2)*8)
	-- call the base print_line to show actor line
	print_line(msg, actor.x, ypos, actor.col, 1)
end


function print_line(msg, x, y, col, align)
	-- todo: an actor's talk animation is not activated as it is with say-line.
	local col=col or 7 		-- default to white
	local align=align or 0	-- default to no align

	printh(msg)
	-- default max width (unless hit a screen edge)
	local lines={}
	local currline=""
	local curword=""
	local curchar=""
	
	longest_line=0
	-- auto-wrap
	-- calc max line width based on x-pos/available space
	screen_space = min(x, screenwidth - x)
	-- (or no less than min length)
	max_line_length = max(flr(screen_space/2), 16)

	local upt=function(max_length)
		if #curword + #currline > max_line_length then
			add(lines,currline)
			if (#currline > longest_line) longest_line = #currline
			currline=""
		end
		currline=currline..curword
		curword=""
	end
	for i=1,#msg do
		curchar=sub(msg,i,i)
		curword=curword..curchar
		if curchar==" " then
			upt(max_line_length)
		elseif #curword>max_line_length-1 then
			curword=curword.."-"
			upt(max_line_length)
		end
	end
	upt(max_line_length)
	if currline~="" then
		add(lines,currline)
		if (#currline > longest_line) longest_line = #currline
	end

	-- center-align text block
	if align == 1 then
		x = x - ((longest_line*4)/2)
	end

	-- screen bound check
	-- left
	xpos = max(2,x)	
	-- top
	ypos = max(18,y)
	-- right
	xpos = min(xpos, screenwidth - (longest_line*4)+4)

	
	dialog_curr = {
		msg_lines = lines,
		x = xpos,
		y = ypos,
		col = col,
		align = align,
		time_left = #msg*8,
		char_width = longest_line
	}
end

function draw_object(obj)
	-- draw object (depending on state!)
	sprdraw(obj.states[obj.state], obj.x, obj.y, obj.w, obj.h, obj.transcol, obj.flip_x)
end

-- walk actor to position
function walk_to(actor, x, y)
	local distance = sqrt((x - actor.x) ^ 2 + (y - actor.y) ^ 2)
	local step_x = actor.speed * (x - actor.x) / distance
	local step_y = actor.speed * (y - actor.y) / distance

	-- check target position is in walkable block
	celx = flr(x/8)
	cely = flr(y/8)
	spr_num = mget(celx, cely)
	printh("spr:"..spr_num)
	walkable = fget(spr_num, 0) -- flag 0 = walkable
	-- if it is...
	if walkable then
		actor.moving = 1 --walking
		for i = 0, distance/actor.speed do
			actor.x += step_x
			actor.y += step_y
			yield()
		end
		actor.moving = 2 --arrived
	end
end



-- internal functions -----------------------------------------------

function recalc_obj_bounds(obj)
	obj["bounds"] = {
			x = obj.x,
			y = stage_top + obj.y,
			x1 = obj.x + (obj.w*8),
			y1 = stage_top + obj.y + (obj.h*8)
		}
end


-- library functions -----------------------------------------------

function shadow_text(str,x,y,c0,c1) --al
 --if al==1 then x-=#str*2-1
 --elseif al==2 then x-=#str*4 end

 local c0=c0 or 7
 local c1=c1 or 0

 str = smallcaps(str)

 print(str,x,y+1,c1)
 print(str,x,y-1,c1)
 print(str,x+1,y,c1)
 print(str,x+1,y+1,c1)
 print(str,x+1,y-1,c1)
 print(str,x-1,y,c1)
 print(str,x-1,y+1,c1)
 print(str,x-1,y-1,c1)

 print(str,x,y,c0)
end

--- center align from: pico-8.wikia.com/wiki/centering_text
function hcenter(s)
	-- string length times the 
	-- pixels in a char's width
	-- cut in half and rounded down
	return (screenwidth / 2)-flr((#s*4)/2)
end

function vcenter(s)
	-- string char's height
	-- cut in half and rounded down
	return (screenheight /2)-flr(5/2)
end

--- collision check
function iscolliding(obj1, obj2)
	local x1 = obj1.x
	local y1 = obj1.y
	local w1 = obj1.w
	local h1 = obj1.h
	
	local x2 = obj2.x
	local y2 = obj2.y
	local w2 = obj2.w
	local h2 = obj2.h

	if(x1 < (x2 + w2)  and (x1 + w1)  > x2 and y1 < (y2 + h2) and (y1 + h1) > y2) then
		return true
	else
		return false
	end
end

function smallcaps(s)
	local d=""
	local l,c,t=false,false
	for i=1,#s do
		local a=sub(s,i,i)
		if a=="^" then
			if(c) d=d..a
				c=not c
			elseif a=="~" then
				if(t) d=d..a
				t,l=not t,not l
			else 
				if c==l and a>="a" and a<="z" then
				for j=1,26 do
					if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
						a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
					break
					end
				end
			end
			d=d..a
			c,t=false,false
		end
	end
	return d
end

function isnull(var)
	return (type(var) == 'nil')
end

function notnull(var)
	return (type(var) != 'nil')
end

__gfx__
000000000444449000000000bbbbbbbb4444444411111111f9e9f9f9000000940000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000004440444900000000bbbbbbbb4ffffff4111111119eee9f9f000009440000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000004040000400000000b444449b4f44449411111111feeef9f9000094400000000000000000ffffffff7777777766666666cccccccc3333333300000000
0000000004ffff0000000000444044494f444494111111119fef9fef000944000000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000000f9ff9f000000000404000044f44449411111111f9f9feee000440000000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000000f5ff5f00000000004ffff004f444494111111119f9f9eee004000000000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000004ffffff4000000000f9ff9f04f44449411111111f9f9feee940000000000000000000000ffffffff7777777766666666cccccccc3333333300000000
000000000ff44ff0000000000f5ff5f04f444494111111119f9f9fef440000000000000000000000ffffffff7777777766666666cccccccc3333333300000000
000cc00006ffff60000000004ffffff44f444494ccccccccddd5ddd5000000000000000000000000000000000000000000000000000000000000000000000000
00c11c000065560000000000bff44ffb4f444494ccccccccdd5ddd5d00000000000a000000000000000000000000000000000000000000000000000000000000
0c1001c00006600000000000b6ffff6b4f449994ccccccccd5ddd5dd000000000000000000000000000000000000000000000000000000000000000000000000
ccc00ccc0000000000000000bb6556bb4f994444cccccccc5ddd5ddd00a0a000000aa000000a0a00cccccccc55555555dddddddd111111110000000000000000
00c00c000000000000000000bbb66bbb44444444ccccccccddd5ddd500aaaa0000aaaa0000aaa000cccccccc55555555dddddddd111111110000000000000000
00c00c000000000000000000bdc55cdb44444444ccccccccdd5ddd5d00a9aa0000a99a0000aa9a00cccccccc55555555dddddddd111111110000000000000000
00cccc000000000000000000dcc55ccd49a44444ccccccccd5ddd5dd00a99a0000a99a0000a99a00cccccccc55555555dddddddd111111110000000000000000
001111000000000000000000c1c66c1c49944444cccccccc5ddd5ddd004444000044440000444400cccccccc55555555dddddddd111111110000000000000000
000700000dc55cd000000000c1c55c1c44444444dddddddd99999999777777777777777777777777ffffffcc77777755666666ddcccccc115555553300000000
00070000dcc55ccd00000000c1c55c1c4444fff4dddddddd55555555555555555555555555555555ffffcccc777755556666ddddcccc11115555333300000000
00070000c1c66c1c00000000c1c55c1c4fff4494dddddddd444444440dd6dd6dd6dd6dd6d6dd6d50ffcccccc7755555566ddddddcc1111115533333300000000
77707770c1c55c1c00000000d1cddc1d4f444494ddddddddffff4fff0dd6dd6dd6dd6dd6d6dd6d50cccccccc55555555dddddddd111111115333333300000000
00070000c1c55c1c00000000fe1111ef4f444494dddddddd44494944066666666666666666666650cccccccc55555555dddddddd111111115333333300000000
00070000c1c55c1c00000000bf1111fb4f444494dddddddd444949440d6dd6dd6dd6dd6ddd6dd650cccccccc55555555dddddddd111111115533333300000000
00070000d1cddc1d00000000bb1121bb4f444494dddddddd444949440d6dd6dd6dd6dd6ddd6dd650cccccccc55555555dddddddd111111115555333300000000
00000000f0d66d0f00000000bb1121bb4f444494dddddddd44494944066666666666666666666650cccccccc55555555dddddddd111111115555553300000000
00cccc000011110000000000bb1121bb4f44449455555555444949440dd6dd600000000056dd6d50ccffffff55777777dd66666611cccccc5555555500000000
00c11c000011210000000000bb1121bb4f44499455555555444949440dd6dd650000000056dd6d50ccccffff55557777dddd66661111cccc3333555500000000
00c00c000011210000000000bb1121bb4f4994445555555544494944066666650000000056666650ccccccff55555577dddddd66111111cc3333335500000000
ccc00ccc0011210000000000bb1121bb4f94444455555555444949440d6dd6d5000000005d6dd650cccccccc55555555dddddddd111111113333333500000000
1c1001c10011210000000000bb1121bb4444440055555555444949440d6dd6d5000000005d6dd650cccccccc55555555dddddddd111111113333333500000000
01c00c100011210000000000bbccccbb444400005555555544494944066666650000000056666650cccccccc55555555dddddddd111111113333335500000000
001cc10000cccc0000000000b776677b4400000055555555999949990dd6dd650000000056dd6d50cccccccc55555555dddddddd111111113333555500000000
000110000776677000000000bbbbbbbb0000000055555555444444440dd6dd650000000056dd6d50cccccccc55555555dddddddd111111115555555500000000
00077000000000700700000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000000877800000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000008800880000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000008800880000077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770
00088000000088000088000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000088000088000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000880000008800000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00088000000880000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7777777777777777775555555555557700070000000700000007000000070000000700000007000000070000000700000007bbbb000700000007000000070000
7000000770000007707000000000070700070000000700000007000000070000000700000007000000070000000700000007bbbb000700000007000000070000
7000000770000007700700000000700700070000000700000007000000070000000700000007000000070000000700000007bbbb000700000007000000070000
7000000770000007700060000006000777707770777077707770777077707770777077707770777077707770777077707770777b777077707770777077707770
700000077000000770006000000600070007000000070000000700000007000000070000000700000007000000070000bbb7bbbb000700000007000000070000
700000077000000770006000000600070007000000070000000700000007000000070000000700000007000000070000bbb7bbbb000700000007000000070000
700000077000000770006000000600070007000000070000000700000007000000070000000700000007000000070000bbb7bbbb000700000007000000070000
777777777777777777776000000677770000000000000000000000000000000000000000000000000000000000000000bbbbbbbb000000000000000000000000
7000006776000007700660000006600700070000000700000007cccc000700000007000000079999000700000007000000070000000700000007000000074444
7000060770600007706060000006060700070000000700000007cccc000700000007000000079999000700000007000000070000000700000007000000074444
7000050770500007705060000006050700070000000700000007cccc000700000007000000079999000700000007000000070000000700000007000000074444
7000000770000007700060000006000777707770777077707770777c777077707770777077707779777077707770777077707770777077707770777077707774
700000077000000770050000000050070007000000070000ccc7cccc000700000007000099979999000700000007000000070000000700000007000044474444
700000077000000770500000000005070007000000070000ccc7cccc000700000007000099979999000700000007000000070000000700000007000044474444
777777777777777775000000000000770007000000070000ccc7cccc000700000007000099979999000700000007000000070000000700000007000044474444
555555555555555555555555555555550000000000000000cccccccc000000000000000099999999000000000000000000000000000000000000000044444444
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
77707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
777077707770777077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777777770777077707770
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000000000000000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770000000000000000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
777077707770777077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777777770777077707770
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000000000000000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770000000000000000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
777077707770777077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777777770777077707770
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000000000000000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770000000000000000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
777077707770777077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777777770777077707770
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000700000007000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770007000000070000
000000000000000077777777777777777777777777777777cccccccccccccccccccccccccccccccc777777777777777777777777777777770000000000000000
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
777077707770777077707770777077707770777077707770777077707770777077707770eeeeeeeebbbbbbbb9999999977707770777077707770777077707770
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
000700000007000000070000000700000007000000070000000700000007000000070000eeeeeeeebbbbbbbb9999999900070000000700000007000000070000
000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeebbbbbbbb9999999900000000000000000000000000000000
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
77707770777077707770777077707770777077707770777077707770777077707770777077707770cccccccc8888888855555555777077707770777077707770
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000cccccccc8888888855555555000700000007000000070000
00000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccc8888888855555555000000000000000000000000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
77707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000088888888
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000080000008
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000080800808
77707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777077707770777080088008
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000080088008
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000080800808
00070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000000070000000700000007000080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888

__gff__
0000000000010000000000000000010000000000000100000000010101010000000000000001000000000101010101000000000000010000000001010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0b0b0b060606060606060606060b0b0b0a0a0a161616161616161616160a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0b0b0b060606060606060606060b0b0b0a0a0a161616161616161616160a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0b000b060000060606060606060b000b0a090a161616161616161616160a090a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a
0b000b260000262728292626260b000b0a090a262626262626262626260a090a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a
0b000b363636363700393636360b000b0a090a363636363636363636360a090a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a
0b1b2b353535353535353535353b1b0b0a1a2a151515151515151515153a1a0a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a
2b3535352e0e0e0e0e0e0e3e3535353b2a15151515151515151515151515153a0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e
3535353535353535353535353535353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a000a060606060606060606060a000a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a
0a000a262626272828292626260a000a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a
0a000a363636370000393636360a000a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a
0a1a2a151515151515151515153a1a0a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a
2a1515150d0d0d0d0d0d0d0d1515153a0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e
1515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a
0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a
0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a
0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a
0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e
1515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a0a0a0a060606060606060606060a0a0a
0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a0a040a060606060606060606060a240a
0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a0a140a262626272828292626260a340a
0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a0a140a363636370000393636360a340a
0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a0a070f151515151515151515151e080a
0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e0f15151517191919191919181515151e
1515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344


pico-8 cartridge // http://www.pico-8.com
version 9
__lua__
-- scumm-8 editor (pus)
-- by paul nicholas

-- debugging
show_debuginfo = true
show_collision = false
--show_pathfinding = true
show_perfinfo = true
enable_mouse = true
d = printh


-- global vars
rooms = {}
objects = {}
actors = {}
stage_top = 8 --16
cam_x = 100--0
draw_zplanes = {}		-- table of tables for each of the (8) zplanes for drawing depth
cursor_x, cursor_y, cursor_tmr, cursor_colpos = 63.5, 63.5, 0, 1
cursor_cols = {7,12,13,13,12,7}
curr_selection = nil		-- currently selected object/actor (or room, if nil)
curr_selection_class = nil
prop_page_num = 0
prop_panel_col = 7
gui = nil	-- widget ui

-- "dark blue" gui theme
gui_bg1 = 1
gui_bg2 = 5
gui_bg3 = 6
gui_fg1 = 12
gui_fg2 = 13
gui_fg3 = 7


-- list of properties (room/object/actor)
-- types:
--   1 = number
--   2 = string
--   3 = bool
--   4 = decimal (0..1)

--  10 = state ref
--  11 = states list (or numbers)
--  12 = classes list 
--  13 = color picker
--  14 = color replace list (using pairs of color pickers)
--  15 = room map cels

--  30 = use position (pos preset or specific pos)
--  31 = use/face dir

--  40 = single sprites (directional)
--  41 = sprite anim sequence

--  50 = object ref

prop_definitions = {
	-- shared props (room/object/actor)
	{"trans_col", "trans col", 13, {"class_room","class_object","class_actor"} ,"transparent color" },
	{"col_replace", "col swap", 14, {"class_room","class_object","class_actor"}, "color to replace" },
	{"lighting", "light", 4, {"class_room","class_object","class_actor"} ,"lighting level" },

	-- object/actor props
	{"name", "name", 2, {"class_object","class_actor"} },
	{"x", "x", 1, {"class_object","class_actor"}, "x position" },
	{"y", "y", 1, {"class_object","class_actor"}, "y position"  },
	{"z", "z", 1, {"class_object","class_actor"}, "z position"  },
	{"w", "w", 1, {"class_object","class_actor"} },
	{"h", "h", 1, {"class_object","class_actor"} },
	{"state", "state", 10, {"class_object","class_actor"} },
	{"states", "states", 11, {"class_object","class_actor"} },
	{"classes", "classes", 12, {"class_object","class_actor"} },
	{"use_pos", "use pos", 30, {"class_object","class_actor"}, "use positions" },
	{"use_dir", "use dir", 31, {"class_object","class_actor"}, "actor use direction" },
	{"use_with", "use with", 3, {"class_object","class_actor"}, "can be used with..." },
	{"repeat_x", "repeat_x", 1, {"class_object","class_actor"}, "repeat draw # times" },
	{"flip_x", "flip x", 3, {"class_object","class_actor"}, "flip sprite(s) horiz" },

	-- object props
	{"dependent_on", "depends on", 50, {"class_object"}, "depends on obj..." },
	{"dependent_on_state", "state req", 11, {"class_object"}, "state of other obj" },

	-- room-only props
	{"map", "map", 15, {"class_room"}, "map cels for room layout"},

	-- actor-only props
	{"idle", "idle frame", 40, {"class_actor"} },
	{"talk", "talk frame", 40, {"class_actor"} },
	{"walk_anim_side", "walk anim(side)", 41, {"class_actor"} },
	{"walk_anim_front", "walk anim(front)", 41, {"class_actor"} },
	{"walk_anim_back", "walk anim(back)", 41, {"class_actor"} },
	{"col", "talk col", 13, {"class_actor"} },
	{"walk_speed", "walk speed", 1, {"class_actor"} },
	{"frame_delay", "anim speed", 1, {"class_actor"} },
	{"face_dir", "start dir", 31, {"class_actor"} },

}


function _init()
  base_cart_name = "game_base"
  disk_cart_name = "game_disk"
  num_extra_disks = 0    
  is_dirty = false  -- has been modified since last "save"?

	room_index = 2--1


  -- packed game data (rooms/objects/actors)
  data = [[
			id=1/map={0,16}/objects={}/classes={class_room}
      id=2/map={0,24,31,31}/objects={30,31,32,33,34,35}/classes={class_room}
      id=3/map={32,24,55,31}/col_replace={5,2}/objects={}
      id=4/map={56,24,79,31}/trans_col=10/col_replace={7,4}/lighting=0.25/objects={}/classes={class_room}
      id=5/map={80,24,103,31}/objects={}/classes={class_room}
      id=6/map={104,24,127,31}/objects={}/classes={class_room}
      id=7/map={32,16,55,31}/objects={}/classes={class_room}
      id=8/map={64,16}/objects={}/classes={class_room}
			|
			id=30/x=144/y=40/classes={class_untouchable}
			id=31/state=1/states={47}/x=80/y=24/w=1/h=2/trans_col=8/repeat_x=8/classes={class_untouchable}
			id=32/state=1/states={47}/x=176/y=24/w=1/h=2/trans_col=8/repeat_x=8/classes={class_untouchable}
			id=33/name=front door/state=1/states={78}/x=152/y=8/w=1/h=3/flip_x=true/classes={class_openable,class_door}/use_dir=face_back
			id=34/name=bucket/state=2/states={143,159}/x=208/y=48/w=1/h=1/trans_col=15/use_with=true/classes={class_pickupable}
			|
			id=1000/name=humanoid/w=1/h=4/idle={193,197,199,197}/talk={218,219,220,219}/walk_anim_side={196,197,198,197}/walk_anim_front={194,193,195,193}/walk_anim_back={200,199,201,199}/col=12/trans_col=11/walk_speed=0.6/frame_delay=5/classes={class_actor}/face_dir=face_front
			id=1001/name=purpletentacle/x=140/y=52/w=1/h=3/idle={154,154,154,154}/talk={171,171,171,171}/col=11/trans_col=15/walk_speed=0.4/frame_delay=5/classes={class_actor,class_talkable}/face_dir=face_front/use_pos=pos_left
		]]

  -- unpack data to it's relevent target(s)
  printh("------------------------------------")
  explode_data(data)
  set_data_defaults()

	-- use mouse input?
	if enable_mouse then poke(0x5f2d, 1) end

  -- load gfx + map from current "disk" (e.g. base cart)
	reload(0,0,0x1800, base_cart_name..".p8") -- first 3 gfx pages
  reload(0x2000,0x2000,0x1000, base_cart_name..".p8") -- map + props

  --reload(0,0,0x3000, base_cart_name..".p8")

	-- init widget library + controls
	init_ui()
end

function _draw()
	draw_editor()
end

function _update60()

	update_room()

	input_control()

  room_index = mid(1, room_index, #rooms)

  room_curr = rooms[room_index]

	-- default first selection to current room
	if not curr_selection then
		curr_selection = room_curr
		curr_selection_class = "class_room"
		create_ui_props(0)
	end

  cam_x = mid(0, cam_x, (room_curr.map_w*8)-127 -1)

	gui:update()
end

-- =====================================
-- init related
--

function init_ui()
	-- init widget library
	gui = gui_root.new()

 -- status bar
 local p=panel.new(128, 7, gui_bg1, false, 3)
 p.name="panel status"
 gui:add_child(p, 0, 121)
 
 local l=label.new(status_label, gui_bg2)
 l.name="info"
 p:add_child(l, 2, 1)
 
 l=label.new(cpu_label, gui_bg2)
 l.name="perf"
 p:add_child(l, 65, 1)
 
end

-- ===========================================================================
-- update related
--

function update_room()
	-- check for current room
	if not room_curr then
		return
	end

	-- reset hover collisions
	hover_curr_selection = nil

 	-- reset zplane info
	reset_zplanes()

	-- check room/object collisions
	for obj in all(room_curr.objects) do

		--printh("obj:"..obj.id)

		-- capture bounds
		-- if not has_flag(obj.classes, "class_untouchable") then
		recalc_bounds(obj, obj.w*8, obj.h*8, cam_x, cam_y)
		-- end

		--d("obj-z:"..type(obj.z))
		
		-- mouse over?
		if iscursorcolliding(obj) then

			-- if highest (or first) object in hover "stack"
			if not hover_curr_selection
			 or	(not obj.z and hover_curr_selection.z and hover_curr_selection.z < 0) 
			 or	(obj.z and hover_curr_selection.z and obj.z > hover_curr_selection.z) 
			then
				hover_curr_selection = obj
				hover_curr_selection_class = "class_object"
			end
		end
		-- recalc z-plane
		recalc_zplane(obj)
	end

end

function reset_zplanes()
	draw_zplanes = {}
	for x = -64, 64 do
		draw_zplanes[x] = {}
	end
end

function recalc_zplane(obj)
	-- calculate the correct z-plane
	-- based on x,y pos + elevation
	ypos = -1
	if obj.offset_y then
		ypos = obj.y
	else
		ypos = obj.y + (obj.h*8)
	end
	zplane = flr(ypos) --  - stage_top)
	--d("object_zcal obj:"..obj.id.." = "..zplane.."(h="..obj.h..")")

	if obj.z then
		zplane = obj.z
	end

	add(draw_zplanes[zplane],obj)
end

function iscursorcolliding(obj)
	-- check params / not in cutscene
	if not obj.bounds then 
	 return false 
	end
	
	bounds = obj.bounds
	if (cursor_x + bounds.cam_off_x > bounds.x1 or cursor_x + bounds.cam_off_x < bounds.x) 
	 or (cursor_y > bounds.y1 or cursor_y < bounds.y) then
		return false
	else
		return true
	end
end

-- handle button inputs
function input_control()	

	-- check for cutscene "skip/override"
	-- (or that we have an actor to control!)
	if cutscene_curr then
		if btnp(4) and btnp(5) and cutscene_curr.override then 
			-- skip cutscene!
			cutscene_curr.thread = cocreate(cutscene_curr.override)
			cutscene_curr.override = nil
			--if (enable_mouse) then ismouseclicked = true end
			return
		end
		-- either way - don't allow other user actions!
		return
	end

	-- 

  -- handle player input
  if btnp(2) then
    room_index += 1
		curr_selection = nil
  end
  if btnp(3) then
    room_index -= 1
		curr_selection = nil
  end
  if btn(1) then
    cam_x += 1
  end
  if btn(0) then
    cam_x -= 1
  end
	-- if btn(0) then cursor_x -= 1 end
	-- if btn(1) then cursor_x += 1 end
	-- if btn(2) then cursor_y -= 1 end
	-- if btn(3) then cursor_y += 1 end

	-- if btnp(4) then input_button_pressed(1) end
	-- if btnp(5) then input_button_pressed(2) end

	-- only update position if mouse moved
	if enable_mouse then	
		mouse_x,mouse_y = stat(32)-1, stat(33)-1
		if mouse_x != last_mouse_x then cursor_x = mouse_x end	-- mouse xpos
		if mouse_y!= last_mouse_y then cursor_y = mouse_y end  -- mouse ypos
		-- don't repeat action if same press/click
		if stat(34) > 0 then
			if not ismouseclicked then
				input_button_pressed(stat(34))
				ismouseclicked = true
			end
		else
			ismouseclicked = false
		end
		-- store for comparison next cycle
		last_mouse_x = mouse_x
		last_mouse_y = mouse_y
	end

	-- keep cursor within screen
	cursor_x = mid(0, cursor_x, 127)
	cursor_y = mid(0, cursor_y, 127)
end

-- 1 = z/lmb, 2 = x/rmb, (4=middle)
function input_button_pressed(button_index)	

	-- todo: check for modal dialog input first



	--if hover_curr_cmd then




  -- gui clicked?
	if gui.clicked_widget or gui.widget_under_mouse then
		
		-- do nothing, leave it for widget library to handle

	-- check room-level interaction
	elseif cursor_y >= stage_top 
	 and cursor_y < stage_top+64 then
	 	-- stage clicked
		if hover_curr_selection then
			-- select object
			curr_selection = hover_curr_selection
			curr_selection_class = hover_curr_selection_class
			create_ui_props(prop_page_num)
		else
			-- nothing clicked (so default to room selected)
			curr_selection = room_curr
			curr_selection_class = "class_room"
			create_ui_props(0)
		end
	end
end


-- =================================================
-- ui/widget related
--

function create_ui_sprite_select(pagenum, func)
	local xoff=8
	local yoff=1

	-- create container for controls
	create_ui_bottom_panel()
	local pnl_prop = gui:find("properties")
	-- set prop panel bg to black
	prop_panel_col = 0

	-- todo: show current "page" of sprites
	local startoff = (pagenum-1)*64
	for i = 1+startoff, 64+startoff-1 do
		
		local sprite = icon.new(i, nil, func)
		sprite.index = i
		sprite.desc = "select sprite:"..i
		pnl_prop:add_child(sprite, xoff, yoff)
		--spr(i, xoff, yoff)	

		xoff += 8
		if xoff > 120 then 
			xoff = 0
			yoff += 8
		end
	end
end



function create_ui_states(mode)
	-- modes (1=select, 2=edit)
	local xoff=0
	local yoff=0

	-- create container for controls
	create_ui_bottom_panel()
	local pnl_prop = gui:find("properties")

	-- get current object states
	--local states = curr_selection.states

	d("states:")
	-- go through all available properties
	for i = 1,#curr_selection.states do
		state = curr_selection.states[i]

		-- state thumbnail
		local stateicon = icon.new(state, nil, function(self)			
			if mode == 1 then
				-- select mode
				curr_selection.state = self.index
				-- close prop view/edit and go back to all properties
				create_ui_props(prop_page_num)			
			elseif mode == 2 then
				-- edit mode
				-- todo: allow browse to pick/edit sprite number
				create_ui_sprite_select(1, function(self)		
					d("sprite "..self.index.." selected!")
					curr_selection.states[curr_selection.state] = self.index
					-- close sprite view and go back to states view
					create_ui_states(mode)
				end)
			end
		end)
		stateicon.index = i
		if mode == 1 then
			stateicon.desc = "select state:"..i
		else
			stateicon.desc = "edit state:"..i
		end
		pnl_prop:add_child(stateicon, 2+xoff, 2+yoff)

		if mode == 1 then
			-- label
			local lbl=label.new(i, gui_fg1)
			pnl_prop:add_child(lbl, 5+xoff, 11+yoff)
		else
			-- delete
			local btn_del = button.new("\x97", function(self)
				-- todo: delete state!
				d("delete state!")
				d(">"..self.state)
				d(#curr_selection.states)
				del(curr_selection.states, self.state)
				-- recreate states view
				create_ui_states(mode)
				d(#curr_selection.states)
			end, 8)
			btn_del.w=5
			btn_del.h=5
			btn_del.desc = "delete state "..i
			btn_del.children[1].x -= 3
			btn_del.children[1].y -= 2
			btn_del.children[1].c = 7
			btn_del.state = state
			pnl_prop:add_child(btn_del, 3+xoff, 11+yoff)
		end

		xoff += 10
		if xoff > 110 then 
			xoff = 0
			yoff += 24
		end
	end
	
	if mode == 2 then
		-- show "add" button
		local btn_add = button.new("+", function(self)
			-- todo: allow browse to pick/edit sprite number
			d("add state!")
			create_ui_sprite_select(1, function(self)		
				d("sprite "..self.index.." selected!")
				add(curr_selection.states, self.index)
				-- close sprite view and go back to states view
				create_ui_states(mode)
			end)
		end)
		btn_add.w=7
		btn_add.h=5
		btn_add.desc = "add state"
		btn_add.children[1].y -= 2
		btn_add.children[1].c = 1
		pnl_prop:add_child(btn_add, xoff+2, yoff+4)
	end

end

-- create/reuse panel for controls at bottom portion of screen
function create_ui_bottom_panel()
	-- look for existing panel
	local pnl_prop = gui:find("properties")
	if pnl_prop then
		-- remove existing controls
		for w in all(pnl_prop.children) do
			pnl_prop:remove_child(w)
		end
	else
		-- create (trans) panel to put controls on
		pnl_prop = panel.new(128, 39, gui_fg3, false, 4) --4=transparent!
		pnl_prop.name = "properties"
		pnl_prop.desc = ""
		--pnl_prop.func = function() end
		gui:add_child(pnl_prop, 0,82)
	end

	-- default prop panel bg to white
	prop_panel_col = 7
end

-- build the current "page" of properties
function create_ui_props(pagenum)
	local xoff=0
	local yoff=0
	local start_pos = pagenum * 12 +1
	local control_count = 0
	
	-- create container for controls
	create_ui_bottom_panel()
	local pnl_prop = gui:find("properties")

	-- go through all available properties
	for i = 1, min(start_pos+12-1, #prop_definitions) do
		-- if within the "page" to show
		if i >= start_pos 
		 and control_count < 12 --i <= start_pos+12-1 
		then
			local prop = prop_definitions[i]
			--local col_size = 0
			d("checking prop: "..prop[2])
			if curr_selection 
			and has_flag(prop[4], curr_selection_class)
			then
				local lbltext = prop[2]..":"
				local lbl=label.new(lbltext, gui_bg2)
				lbl.desc = prop[5]
				lbl.wants_mouse = true
				
				lbl.w=60
				lbl.func = function() end

				pnl_prop:add_child(lbl, 2+xoff, 2+yoff)
				create_control(prop[3], curr_selection[prop[1]], pnl_prop, 2+xoff+(#lbltext*4), 2+yoff, prop[5], curr_selection, prop[1])
				yoff += 6
				if yoff > 30 then 
					yoff = 0
					xoff += 63 
				end
				control_count += 1
			end
		end
	end
end


function create_control(datatype, value, parent, x, y, tooltip, bound_obj, bound_prop)
	--   1 = number
	--   2 = string
	--   3 = bool
	--   4 = decimal (0..1)

	--  10 = state ref
	--  11 = states list (or numbers)
	--  12 = classes list 
	--  13 = color picker
	--  14 = color replace list (using pairs of color pickers)
	--  15 = room map cels

	--  30 = use position (pos preset or specific pos)
	--  31 = use/face dir

	--  40 = single sprites (directional)
	--  41 = sprite anim sequence

	--  50 = object ref

	d("create_control()")

	-- number
	if datatype == 1 then
		value = value or 0	-- default nil to 0?
	d("datatype = "..datatype)
	d("value = "..value)
		local spin = spinner.new(-64, 1000, value, 1, set_bound_val)
		spin.bound_obj = bound_obj
		spin.bound_prop = bound_prop
		spin.desc = tooltip
		parent:add_child(spin, x-2, y-2)

	-- string
	elseif datatype == 2 then
		value = value or ""	-- default nil to ""?
	d("datatype = "..datatype)
	d("value = "..value)
		local safe_value = value
		if (#value > 9) safe_value = sub(value,1,7).."..."
		local lbl=label.new(safe_value, gui_fg1)
		lbl.desc = value
		lbl.wants_mouse = true
		parent:add_child(lbl, x, y)

	-- decimal (lighting)
	elseif datatype == 4 then
		value = value or 1	-- default nil to 1
	d("datatype = "..datatype)
	d("value = "..value)
		local spin = spinner.new(0, 1, value, 0.05, set_bound_val_decimal)
		spin.bound_obj = bound_obj
		spin.bound_prop = bound_prop
		spin.desc = tooltip
		parent:add_child(spin, x-2, y-2)

	-- state ref
	elseif datatype == 10 then
		local btn_more = button.new(249, function(self)
		  -- show "select state"
			create_ui_states(1)
		end)
		btn_more.w=9
		btn_more.h=5
		btn_more.bound_obj = bound_obj
		btn_more.bound_prop = bound_prop
		btn_more.desc = tooltip
		parent:add_child(btn_more, x, y)

	-- states list (or numbers)
	elseif datatype == 11 then
		local btn_more = button.new(249, function(self)
			-- show "edit states"
			create_ui_states(2)
		end)
		btn_more.w=9
		btn_more.h=5
		btn_more.bound_obj = bound_obj
		btn_more.bound_prop = bound_prop
		btn_more.desc = tooltip
		parent:add_child(btn_more, x, y)

  -- color picker
	elseif datatype == 13 then
		local bc=button.new("", 
			function(w)
				-- show color picker for this property
				pick = color_picker.new(w.c, function(self)
					w.bound_obj[w.bound_prop]=self.value
					w.c=self.value
					parent:remove_child(self)
				end)
				parent:add_child(pick,w.x,w.y)
			end,
			value)
		bc.w=6
		bc.h=6
		bc.desc = tooltip
		bc.bound_obj = bound_obj
		bc.bound_prop = bound_prop
		parent:add_child(bc, x, y-1)
	
	-- color replace (using pairs of color pickers)
	elseif datatype == 14 then
		local xoff = 0
		d("type = "..type(value))
	 	for i = 1,2 do
			local bc=button.new("", 
				function(w)
					-- show color picker for this property
					pick = color_picker.new(w.c, function(self)
						local array = w.bound_obj[w.bound_prop]
						array = array or {}
						array[w.bound_index]=self.value
						w.bound_obj[w.bound_prop]=array
						w.c=self.value
						parent:remove_child(self)
					end)
					parent:add_child(pick,w.x,w.y)
				end)
			bc.w=6
			bc.h=6
			if (value) bc.c = value[i]
			bc.desc = tooltip
			bc.bound_obj = bound_obj
			bc.bound_prop = bound_prop
			bc.bound_index = i
			parent:add_child(bc, x+xoff, y-1)
			xoff += 8
		end
	else
		--- ...
	end
end


-- event handlers
function set_bound_val(widget)
	d("set_bound_val()")
	d("  > "..widget.bound_prop.." = "..widget.value)
	--if (widget.bound) d("bound not null!")
 widget.bound_obj[widget.bound_prop] = widget.value
end

function set_bound_val_decimal(widget)
	d("set_bound_val_decimal()")
	local val = round(widget.value, 2)
	d("  > "..widget.bound_prop.." = "..val)
	--if (widget.bound) d("bound not null!")
 widget.bound_obj[widget.bound_prop] = val
 	widget.value = val
end


-- content functions (for labels, etc.)
function status_label()
--  if msg and msg_time>0 then
--   return msg
--  end
 
 if not gui:mouse_blocked() then
  -- mouse is not over a panel
	if cursor_y-stage_top >= 0 
	 and cursor_y-stage_top < 64 then
		return "x:"..pad_3(cursor_x+cam_x).." y:"..pad_3(cursor_y-stage_top)
	end
  -- local c=flr(stat(32)/8)
  -- local r=flr(stat(33)/8)
  -- local pos=c..", "..r..": "
  -- if r<0 or c<0 or r>=16 or c>=map_width then
  --  return pos.."nothing!"
  -- else
  --  return pos.."tile "..mget(c, r)
  -- end
 else
  -- mouse is over a panel
  local w=gui.clicked_widget or gui.widget_under_mouse
	--if w.desc then d("over: "..w.desc) end
  if w and w.desc then
   return w.desc
  end
 end

 -- otherise...
 return ""
end


function cpu_label()
	-- check no status text being displayed
	local w=gui.clicked_widget or gui.widget_under_mouse
	if w and w.desc then
		return ""
	else
		return "cpu:"..flr(100*stat(1)).."% mem:"..flr(stat(0)/1024*100).."%"
	end
end

-- ===========================================================================
-- draw related
--
function draw_editor()
	cls()

  -- reposition camera (account for shake, if active)
	camera(cam_x,0)

	-- clip room bounds (also used for "iris" transition)
	clip(0, stage_top, 128, 64)
    
	-- draw room (bg + objects + actors)
	draw_room()

	-- reset camera and clip bounds for "static" content (ui, etc.)
	camera(0,0)
	clip()

	draw_ui()

	draw_cursor()
end

function draw_room()
	-- todo: factor in diff drawing modes?

	 -- check for current room
	if not room_curr then
		print("-error-  no current room set",5+cam_x,5+stage_top,8,0)
		return
	end


	-- set room background col (or black by default)
	rectfill(0, stage_top, 127, stage_top+64, room_curr.bg_col or 0)


	-- draw each zplane, from back to front
	for z = -64,64 do

		-- draw bg layer?
		if z == 0 then			
			-- replace colors?
			replace_colors(room_curr)

			if room_curr.trans_col then
				set_trans_col(room_curr.trans_col, true)
				-- palt(0, false)
				-- palt(room_curr.trans_col, true)
			end

  		map(room_curr.map[1], room_curr.map[2], 0, stage_top, room_curr.map_w, 8)
			--map(room_curr.map[1], room_curr.map[2], 0, stage_top, room_curr.map_w, room_curr.map_h)
			
			--reset palette
			pal()		


					-- ===============================================================
					-- debug walkable areas
					
					-- if show_pathfinding then
					-- 	actor_cell_pos = getcellpos(selected_actor)

					-- 	celx = flr((cursor_x + cam_x + 0) /8) + room_curr.map[1]
					-- 	cely = flr((cursor_y - stage_top + 0) /8 ) + room_curr.map[2]
					-- 	target_cell_pos = { celx, cely }

					-- 	path = find_path(actor_cell_pos, target_cell_pos)

					-- 	-- finally, add our destination to list
					-- 	click_cell = getcellpos({x=(cursor_x + cam_x), y=(cursor_y - stage_top)})
					-- 	if is_cell_walkable(click_cell[1], click_cell[2]) then
					-- 	--if (#path>0) then
					-- 		add(path, click_cell)
					-- 	end

					-- 	for p in all(path) do
					-- 		--d("  > "..p[1]..","..p[2])
					-- 		rect(
					-- 			(p[1]-room_curr.map[1])*8, 
					-- 			stage_top+(p[2]-room_curr.map[2])*8, 
					-- 			(p[1]-room_curr.map[1])*8+7, 
					-- 			stage_top+(p[2]-room_curr.map[2])*8+7, 11)
					-- 	end
					-- end

		else
			-- draw other layers
			zplane = draw_zplanes[z]
		
			-- draw all objs/actors in current zplane
			for obj in all(zplane) do
				-- object or actor?
					--d("object_zplane:"..obj.id)

				if not has_flag(obj.classes, "class_actor") then
					-- object
					-- if obj.states	  -- object has a state?
				  --   or (obj.state
					--    and obj[obj.state]
					--    and obj[obj.state] > 0)
					--  and (not obj.dependent_on 			-- object has a valid dependent state?
					-- 	or obj.dependent_on.state == obj.dependent_on_state)
					--  and not obj.owner   						-- object is not "owned"
					--  or obj.draw
					-- then
						-- something to draw
						object_draw(obj)
					--end
				else
					-- actor
					if obj.in_room == room_curr then
						actor_draw(obj)
					end
				end

				if obj.bounds then
					if curr_selection == obj then
						rect(obj.bounds.x-1, obj.bounds.y-1, obj.bounds.x1+1, obj.bounds.y1+1, cursor_cols[cursor_colpos]) 
					elseif hover_curr_selection == obj
						or show_collision 
					then
						rect(obj.bounds.x-1, obj.bounds.y-1, obj.bounds.x1+1, obj.bounds.y1+1, 8)
						--rect(obj.bounds.x-2, obj.bounds.y-2, obj.bounds.x1+2, obj.bounds.y1+2, 2)
					end
				end	
			end
		end		
	end
end

function draw_ui()
	-- todo: factor in diff drawing modes (normal/modal)?

	-- header bar
	rectfill(0,0,127,7,gui_bg1)
	pal(5,12)
	spr(192,3,1)
	spr(193,12,1)
	spr(194,22,1)
	--
	pal(5,7)
	spr(212,101,1)
	pal(5,12)
	spr(229,110,1)
	spr(230,119,1)
	
	pal()
	
	-- properties (bar)
	rectfill(0,72,127,82,gui_bg2)
	if curr_selection then
		-- draw obj? (1 sprite)
		if curr_selection_class != "class_room" then
			palt(0,false)
			spr(curr_selection.states[curr_selection.state], 1, 73)
			pal()
		end
		print(
			sub(curr_selection_class,7)..":"..pad_3(curr_selection.id)
			,11,74,gui_fg3)
	end

	spr(204,96,74)
	spr(221,104,74)
	spr(222,112,74)
	spr(223,120,74)

	-- properties (section)	
	rectfill(0,82,127,120, prop_panel_col)
	--rectfill(0,82,127,120,gui_fg3)

	-- draw widget library
	gui:draw()

	-- find all properties for selected object (or room, if no obj/actor selected)
	-- local xoff=0
	-- local yoff=0
	-- local start_pos = prop_page_num * 12 +1
	-- for i = start_pos, min(start_pos+12-1, #prop_definitions) do
	-- 	d("i="..i)
	-- --for p in all(prop_definitions) do
	-- 	local prop = prop_definitions[i]
	-- 	--local col_size = 0
	-- 	if curr_selection 
	-- 	 and has_flag(prop[4], curr_selection_class)
	-- 	then
	-- 		local label = prop[2]..":"
	-- 		print(label, 3+xoff, 83+yoff, gui_bg2)
	-- 		-- draw the 
	-- 		draw_control(1, "val", 3+xoff+(#label*4), 83+yoff)
	-- 		yoff += 6
	-- 		if yoff > 30 then 
	-- 			yoff = 0
	-- 			xoff += 60 
	-- 		end
	-- 	end
	-- end

	-- status bar
	-- rectfill(0,119,127,127,gui_bg1)
	-- print("x:"..pad_3(cursor_x+cam_x).." y:"..pad_3(cursor_y-stage_top), 
	-- 	3,121, gui_bg2) 

	-- print("cpu:"..flr(100*stat(1)).."%", 
	-- 	66, 121, gui_bg2) 
	-- print("mem:"..flr(stat(0)/1024*100).."%", 
	-- 	98, 121, gui_bg2)

end


function draw_cursor()
	col = cursor_cols[cursor_colpos]
	-- switch sprite color accordingly

	-- game cursor
	-- line(cursor_x-4, cursor_y,cursor_x-1, cursor_y, col)
	-- line(cursor_x+1, cursor_y,cursor_x+4, cursor_y, col)
	-- line(cursor_x, cursor_y-4,cursor_x, cursor_y-1, col)
	-- line(cursor_x, cursor_y+1,cursor_x, cursor_y+4, col)

	--pset(cursor_x, cursor_y, 8)
	palt(0,true)
	spr(240, cursor_x, cursor_y, 1, 1)
	-- pal() --reset palette

	cursor_tmr += 1
	if cursor_tmr > 14 then
		--reset timer
		cursor_tmr = 1
		-- move to next color?
		cursor_colpos += 1
		if cursor_colpos > #cursor_cols then cursor_colpos = 1 end
	end
end

function replace_colors(obj)
	-- replace colors (where defined)
	if obj.col_replace then
		c = obj.col_replace
		--for c in all(obj.col_replace) do
			pal(c[1], c[2])
		--end
	end
	-- also apply brightness (default to room-level, if not set)
	if obj.lighting then
		_fadepal(obj.lighting)
	elseif obj.in_room 
	 and obj.in_room.lighting then
		_fadepal(obj.in_room.lighting)
	end
end


function object_draw(obj)
	-- replace colors?
	replace_colors(obj)

	--d("object_draw:"..obj.id)

	-- check for custom draw
	if not obj.state then
		--obj.draw(obj)
		palt(0,false)
		spr(217, obj.x, obj.y + stage_top)
		pal()
		return
	else
		-- allow for repeating
		rx=1
		if obj.repeat_x then rx = obj.repeat_x end
		for h = 0, rx-1 do
			-- draw object (in its state!)
			local obj_spr = 0
			if obj.states then
				obj_spr = obj.states[obj.state]
			else
				obj_spr = obj[obj.state]
			end
			sprdraw(obj_spr, obj.x+(h*(obj.w*8)), obj.y, obj.w, obj.h, obj.trans_col, obj.flip_x)
		end
	end

	--reset palette
	pal() 
end

-- draw actor(s)
function actor_draw(actor)

	dirnum = face_dir_vals[actor.face_dir]

	if actor.moving == 1
	 and actor.walk_anim 
	then
		actor.tmr += 1
		if actor.tmr > actor.frame_delay then
			actor.tmr = 1
			actor.anim_pos += 1
			if actor.anim_pos > #actor.walk_anim then actor.anim_pos=1 end
		end
		-- choose walk anim frame
		sprnum = actor.walk_anim[actor.anim_pos]	
	else

		-- idle
		sprnum = actor.idle[dirnum]
	end

	-- replace colors?
	replace_colors(actor)

	sprdraw(sprnum, actor.offset_x, actor.offset_y, 
		actor.w , actor.h, actor.trans_col, 
		actor.flip, false)
	
	-- talking overlay
	if talking_actor 
	 and talking_actor == actor 
	 and talking_actor.talk
	then
			if actor.talk_tmr < 7 then
				sprnum = actor.talk[dirnum]
				sprdraw(sprnum, actor.offset_x, actor.offset_y +8, 1, 1, 
					actor.trans_col, actor.flip, false)
			end
			actor.talk_tmr += 1	
			if actor.talk_tmr > 14 then actor.talk_tmr = 1 end
	end

	--reset palette
	pal()
end


function sprdraw(n, x, y, w, h, transcol, flip_x, flip_y)
	-- switch transparency
	set_trans_col(transcol, true)

	-- draw sprite
	spr(n, x, stage_top + y, w, h, flip_x, flip_y)

	--pal() -- don't do, affects lighting!
end

function set_trans_col(transcol, enabled)
	-- set transparency for specific col
	palt(0, false)
	palt(transcol, true)
	
	-- set status of default transparency
	if transcol and transcol > 0 then
		palt(0, false)
	end
end


function _fadepal(perc)
 if perc then perc = 1-perc end
 local p=flr(mid(0,perc,1)*100)
 local dpal={0,1,1, 2,1,13,6,
          4,4,9,3, 13,1,13,14}
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col)
 end
end



-- ===========================================================================
-- data related
--

function has_flag(obj, value)
	for f in all(obj) do
	 if f == value then
	 	return true 
	 end
	end
  --if band(obj, value) != 0 then return true end
  return false
end

function recalc_bounds(obj, w, h, cam_off_x, cam_off_y)
  x = obj.x
	y = obj.y
	-- offset for actors?
	if has_flag(obj.classes, "class_actor") then
		obj.offset_x = x - (obj.w *8) /2
		obj.offset_y = y - (obj.h *8) +1		
		x = obj.offset_x
		y = obj.offset_y
	end

	-- adjust bounds for repeat-drawn sprites
	if obj.repeat_x then 
		w *= obj.repeat_x 
	end

	obj.bounds = {
		x = x,
		y = y + stage_top,
		x1 = x + w -1,
		y1 = y + h + stage_top -1,
		cam_off_x = cam_off_x,
		cam_off_y = cam_off_y
	}
end


-- ===========================================================================
-- pack/unpack related
--

function set_data_defaults()
  
  -- init rooms
	for room in all(rooms) do		
		if (#room.map > 2) then
			room.map_w = room.map[3] - room.map[1] + 1
			room.map_h = room.map[4] - room.map[2] + 1
		else
			room.map_w = 16
			room.map_h = 8
		end

		-- init objects (in room)
		local obj_list = {}
		for obj_id in all(room.objects) do
			--printh("obj id2: "..obj_id)
			obj = objects[obj_id]
			if obj then
				obj.in_room = room
				obj.h = obj.h or 1
				obj.w = obj.w or 1
				-- if obj.repeat_x  then
				-- 	d("repeat:"..obj.repeat_x.." --- obj.w:"..obj.w)
				-- end
				add(obj_list, obj)
			end
		end
		-- now replace room.objectids with .objects
		room.objects = obj_list
	end

	-- init actors with defaults
	-- for ka,actor in pairs(actors) do
	-- 	explode_data(actor)
	-- 	actor.moving = 2 		-- 0=stopped, 1=walking, 2=arrived
	-- 	actor.tmr = 1 		  -- internal timer for managing animation
	-- 	actor.talk_tmr = 1
	-- 	actor.anim_pos = 1 	-- used to track anim pos
	-- 	actor.inventory = {
	-- 		-- obj_switch_player,
	-- 		-- obj_switch_tent
	-- 	}
	-- 	actor.inv_pos = 0 	-- pointer to the row to start displaying from
	-- end
end


function explode_data(data)
  local areas=split(data, "|")
  
  -- unpack rooms + data
  local room_data = areas[1]
	local lines=split(room_data, "\n")
	for l in all(lines) do
    room = {}
		--d("curr line = ["..l.."]")
    local properties=split(l, "/")
		local id = 0
    for prop in all(properties) do
      --printh("curr prop = ["..prop.."]")
      local pairs=split(prop, "=")
      if #pairs==2 then
				if pairs[1] == "id" then
					id = autotype(pairs[2])
				end
				room[pairs[1]] = autotype(pairs[2])
      else
        printh("invalid data line")
      end
    end
		-- only add if something to add
		if #properties > 0 
		 and id > 0 then
			rooms[id] = room
    	--add(rooms, room)
		end
		--if (room.objects) printh("obj count:"..#room.objects)
	end

	-- unpack objects + data
	local obj_data = areas[2]
	local lines=split(obj_data, "\n")
	for l in all(lines) do
    obj = {}
    local properties=split(l, "/")
		local id = 0
    for prop in all(properties) do
      local pairs=split(prop, "=")
      -- now set actual values
      if #pairs==2 then
				if pairs[1] == "id" then
					id = autotype(pairs[2])
				end
				obj[pairs[1]] = autotype(pairs[2])
      else
        printh("invalid data line")
      end
    end
		-- only add if something to add
		if #properties > 0 
		 and id > 0 then
			objects[id] = obj
    	--add(objects, room)
		end
	end
	--printh("objects:"..#objects)

	-- unpack actors + data
	local actor_data = areas[3]
	local lines=split(actor_data, "\n")
	for l in all(lines) do
    actor = {}
    local properties=split(l, "/")
		local id = 0
    for prop in all(properties) do
			--printh("curr prop = ["..prop.."]")
      local pairs=split(prop, "=")
      -- now set actual values
      if #pairs==2 then
				if pairs[1] == "id" then
					id = autotype(pairs[2])
				end
				actor[pairs[1]] = autotype(pairs[2])
      else
        printh("invalid data line")
      end
    end
		-- only add if something to add
		if #properties > 0 
		 and id > 0 then
			actors[id] = actor
    	--add(actors, actor)
		end
	end

	--printh("actors:"..#actors)
end

function split(s, delimiter)
	local retval = {}
	local start_pos = 0
	local last_char_pos = 0

	for i=1,#s do
		local curr_letter = sub(s,i,i)
		if curr_letter == delimiter then
			add(retval, sub(s,start_pos,last_char_pos))
			start_pos = 0
			last_char_pos = 0

		elseif curr_letter != " "
		 and curr_letter != "\t" then
			-- curr letter is useful
			last_char_pos = i
			if start_pos == 0 then start_pos = i end
		end
	end
	-- add remaining content?
	if start_pos + last_char_pos > 0 then 	
		add(retval, sub(s,start_pos,last_char_pos))
	end
	return retval
end

function autotype(str_value)
	local first_letter = sub(str_value,1,1)
	local retval = nil

	if str_value == "true" then
		retval = true
	elseif str_value == "false" then
		retval = false
	elseif is_num_char(first_letter) then
		-- must be number
		if first_letter == "-" then
			retval = sub(str_value,2,#str_value) * -1
		else
			retval = str_value + 0
		end
	elseif first_letter == "{" then
		-- array - so split it
		local temp = sub(str_value,2,#str_value-1)
		retval = split(temp, ",")
		retarray = {}
		for val in all(retval) do
			val = autotype(val)
			add(retarray, val)
		end
		retval = retarray
	else --if first_letter == "\"" then
		-- string - so do nothing
		retval = str_value
	end
	return retval
end

function is_num_char(c)
	for d=1,13 do
		if c==sub("0123456789.-+",d,d) then
			return true
		end
	end
end

function pad_3(number)
	local strnum=""..flr(number)
	local z="000"
	return sub(z,#strnum+1)..strnum
end

function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end





-- ====================================
-- widget library
--


-- gui lib follows


-- utils

function draw_convex_frame(x0, y0, x1, y1, c)
 rectfill(x0, y0, x1, y1, c)
 line(x0, y0, x0, y1-1, 7)
 line(x0, y0, x1-1, y0, 7)
 line(x0+1, y1, x1, y1, 5)
 line(x1, y0+1, x1, y1, 5)
end

function draw_concave_frame(x0, y0, x1, y1, c)
 rectfill(x0, y0, x1, y1, c)
 line(x0, y0, x0, y1-1, 5)
 line(x0, y0, x1-1, y0, 5)
 line(x0+1, y1, x1, y1, 7)
 line(x1, y0+1, x1, y1, 7)
end

function make_label(val)
 local t=type(val)
 if t=="number" then
  return icon.new(val)
 elseif t=="string" then
  return label.new(val)
 elseif t=="function" then
  local ret=val()
  if type(ret)=="number" then
   return icon.new(val)
  else
   return label.new(val)
  end
 else
  return val
 end
end

function subwidget(t)
 t.__index=t
 setmetatable(t, { __index=widget })
end

function dummy()
end

-- base widget

widget={
 x=0, y=0,
 w=0, h=0,
 visible=true,
 name="",
 draw=dummy,
 update=dummy,
 on_mouse_enter=dummy,
 on_mouse_exit=dummy,
 on_mouse_press=dummy,
 on_mouse_release=dummy,
 on_mouse_move=dummy
}
widget.__index=widget

function widget.new()
 local w={ children={} }
 setmetatable(w, widget)
 return w
end

function widget:draw_all(px, py)
 if self.visible then
  self:draw(px, py)
  for c in all(self.children) do
   c:draw_all(px+c.x, py+c.y)
  end
 end
end

function widget:update_all()
 self:update()
 for c in all(self.children) do
  c:update_all()
 end
end

function widget:add_child(c, x, y)
 if (c.parent) c.parent:remove_child(c)
 c.x=x
 c.y=y
 c.parent=self
 add(self.children, c)
end

function widget:remove_child(c)
 del(self.children, c)
 c.parent=nil
end

function widget:find(n)
 if (self.name==n) return self
 for c in all(self.children) do
  local w=c:find(n)
  if (w) return w
 end
end

function widget:get_under_mouse(x, y)
 if (not self.visible) return nil
 
 x-=self.x
 y-=self.y
 if x>=0 and x<self.w and y>=0 and y<self.h then
  local ret=nil
  if (self.wants_mouse) ret=self
  for c in all(self.children) do
   local mc=c:get_under_mouse(x, y)
   if (mc) ret=mc
  end
  return ret
 end
end


function widget:abs_x()
 return self.parent:abs_x()+self.x
end

function widget:abs_y()
 return self.parent:abs_y()+self.y
end

-- gui root

gui_root={}
subwidget(gui_root)

function gui_root.new()
 local g=widget.new()
 setmetatable(g, gui_root)
 g.w=128
 g.h=128
 g.lastx=0
 g.lasty=0
 g.lastbt=0
 return g
end

function gui_root:update()
 local x=stat(32)
 local y=stat(33)
 local dx=x-self.lastx
 local dy=y-self.lasty
 local bt=band(stat(34), 1)==1
 
 local wum=self:get_under_mouse(x, y)
 if wum!=self.widget_under_mouse then
  if self.widget_under_mouse then
   self.widget_under_mouse:on_mouse_exit()
  end
  self.widget_under_mouse=wum
  if wum then
   wum:on_mouse_enter()
  end
 end
 
 if dx!=0 or dy!=0 then
  local w=self.clicked_widget or self.widget_under_mouse
  if (w) w:on_mouse_move(dx, dy)
 end
 
 if self.lastbt then
  if not bt and self.clicked_widget then
   self.clicked_widget:on_mouse_release()
   self.clicked_widget=nil
  end
 elseif bt then
  self.clicked_widget=self.widget_under_mouse
  if self.clicked_widget then
   self.clicked_widget:on_mouse_press()
  end
 end
 
 self.lastx=x
 self.lasty=y
 self.lastbt=bt
 
 for c in all(self.children) do
  c:update_all()
 end
end

function gui_root:draw()
 if self.visible then
  for c in all(self.children) do
   c:draw_all(c.x, c.y)
  end
 end
end

function gui_root:mouse_blocked()
 if self.visible then
  local x=stat(32)
  local y=stat(33)
  for c in all(self.children) do
   if c.visible and x>=c.x and x<c.x+c.w and y>=c.y and y<c.y+c.h then
    return true
   end
  end
 end
 return false
end


function gui_root:abs_x()
 return self.x
end

function gui_root:abs_y()
 return self.y
end

-- panel

panel={ wants_mouse=true }
subwidget(panel)

function panel.new(w, h, c, d, s)
 local p=widget.new()
 setmetatable(p, panel)
 p.w=w or 5
 p.h=h or 5
 p.c=c or 6
 p.style=s or 1
 if (d) p.draggable=true
 return p
end

function panel:add_child(c, x, y)
 local ex=2
 if (self.style==3) ex=1
 self.w=max(self.w, x+c.w+ex)
 self.h=max(self.h, y+c.h+ex)
 widget.add_child(self, c, x, y)
end

function panel:draw(x, y)
 if self.style==1 then
  draw_convex_frame(x, y, x+self.w-1, y+self.h-1, self.c)
 elseif self.style==2 then
  draw_concave_frame(x, y, x+self.w-1, y+self.h-1, self.c)
 elseif self.style==3 then
  rectfill(x, y, x+self.w-1, y+self.h-1, self.c)
 else
  -- transparent
 end
end

function panel:on_mouse_press()
 if (self.draggable) self.drag=true
end

function panel:on_mouse_release()
 self.drag=false
end

function panel:on_mouse_move(dx, dy)
 if self.drag then
  self.x+=dx
  self.y+=dy
 end
end

-- label

label={}
subwidget(label)

function label.new(text, c, func)
 local l=widget.new()
 setmetatable(l, label)
 l.h=5
 l.c=c or 0
 if func then
  l.wants_mouse=true
  l.func=func
 end
 if type(text)=="function" then
  l.text=text
  l.w=max(#text(self)*4-1, 0)
 else
  l.text=""..text
  l.w=max(#l.text*4-1, 0)
 end
 return l
end

function label:draw(x, y)
 if(type(self.text)=="string") then
  print(self.text, x, y, self.c)
 else
  print(""..self.text(self), x, y, self.c)
 end
end

function label:on_mouse_press()
 self.func(self)
end

-- icon

icon={}
subwidget(icon)

function icon.new(n, t, f)
 local i=widget.new()
 setmetatable(i, icon)
 i.num=n
 i.trans=t
 i.w=8
 i.h=8
 if f then
  i.wants_mouse=true
  i.func=f
 end
 return i
end

function icon:draw(x, y)
 if self.trans then
  palt()
  palt(0, false)
  palt(self.trans, true)
 end
 if type(self.num)=="number" then
  spr(self.num, x, y)
 else
  spr(self.num(self), x, y)
 end
 if (self.trans) palt()
end

function icon:on_mouse_press()
 self.func(self)
end

-- button

button={ wants_mouse=true }
subwidget(button)

function button.new(lbl, func, c)
 local b=widget.new()
 setmetatable(b, button)
 local l=make_label(lbl)
 b:add_child(l, 2, 2)
 b.w=l.w+4
 b.h=l.h+4
 b.c=c or 6
 b.func=func
 return b
end

function button:draw(x, y)
 if self.clicked and self.under_mouse then
  draw_concave_frame(x, y, x+self.w-1, y+self.h-1, self.c)
 else
  draw_convex_frame(x, y, x+self.w-1, y+self.h-1, self.c)
 end
end

function button:on_mouse_enter()
 self.under_mouse=true
end

function button:on_mouse_exit()
 self.under_mouse=false
end

function button:on_mouse_press()
 self.clicked=true
end

function button:on_mouse_release()
 self.clicked=false
 if self.under_mouse then
  self.func(self)
 end
end

-- spinner

spinner={}
subwidget(spinner)

spinbtn={ wants_mouse=true }
subwidget(spinbtn)

function spinner.new(minv, maxv, v, step, f)
 local s=widget.new()
 setmetatable(s, spinner)
 s.w=53
 s.h=9
 s.minv=minv
 s.maxv=maxv
 s.step=step or 1
 s.value=v or minv
 s.func=f
 local b=spinbtn.new("+", s, 1)
 s:add_child(b, 15, 3)
 b=spinbtn.new("-", s, -1)
 s:add_child(b, 22, 3)
 return s
end

function spinner:draw(x, y)
 --rectfill(x, y, x+self.w-1, y+self.h-1, 7)
 print(self.value, x+2, y+2, gui_fg1) --0)
end

function spinner:adjust(amt)
 self.value=mid(
  self.value+amt*self.step,
  self.minv, self.maxv)
 if self.func then
  self.func(self)
 end
end

function spinbtn.new(t, p, s)
 local b=widget.new()
 setmetatable(b, spinbtn)
 b.w=7
 b.h=5 --9
 b.text=t
 b.parent=p
 b.sign=s
 b.timer=0
 return b
end

function spinbtn:draw(x, y)
 if self.clicked and self.under_mouse then
  draw_concave_frame(x, y-1, x+self.w-1, y+self.h-2, 6)
 else
  draw_convex_frame(x, y-1, x+self.w-1, y+self.h-2, 6)
 end
 print(self.text, x+2, y-1, 1)
 --print(self.text, x+2, y+2, 1)
end

function spinbtn:update()
 if (self.timer<200) self.timer+=1
 if self.clicked and self.under_mouse then
  if self.timer>=200 then
   self.parent:adjust(self.sign*500)
  elseif self.timer>=100 then
   self.parent:adjust(self.sign*50)
  elseif self.timer>=10 then
   self.parent:adjust(self.sign)
  end
 end
end

function spinbtn:on_mouse_enter()
 self.under_mouse=true
end

function spinbtn:on_mouse_exit()
 self.under_mouse=false
end

function spinbtn:on_mouse_press()
 self.clicked=true
 self.timer=0
 
 local p=self.parent
 self.parent:adjust(self.sign)
end

function spinbtn:on_mouse_release()
 self.clicked=false
end

-- checkbox

checkbox={ wants_mouse=true }
subwidget(checkbox)

function checkbox.new(lbl, v, f)
 local c=widget.new()
 setmetatable(c, checkbox)
 local l=make_label(lbl)
 c:add_child(l, 6, 0)
 c.w=l.w+6
 c.h=7
 c.value=v or false
 c.func=f
 return c
end

function checkbox:draw(x, y)
 rectfill(x, y, x+4, y+4, 7)
 if self.value then
  line(x+1, y+1, x+3, y+3, 0)
  line(x+1, y+3, x+3, y+1, 0)
 end
end

function checkbox:on_mouse_press()
 self.value=not self.value
 if self.func then
  self.func(self)
 end
end

-- radio button

radio={ wants_mouse=true }
subwidget(radio)

rbgroup={}
rbgroup.__index=rbgroup

function rbgroup.new(f)
 local g=widget.new()
 setmetatable(g, rbgroup)
 g.func=f
 g.btns={}
 return g
end

function rbgroup:select(val)
 if self.selected then
  self.selected.selected=false
 end
 
 self.selected=nil
 for r in all(self.btns) do
  if r.value==val then
   self.selected=r
   r.selected=true
   break
  end
 end
 
 if self.func then
  self.func(self.selected)
 end
end

function radio.new(grp, lbl, val)
 local r=widget.new()
 setmetatable(r, radio)
 local l=make_label(lbl)
 r:add_child(l, 6, 0)
 r.w=6+l.w
 r.h=5
 r.value=val
 r.group=grp
 r.selected=false
 add(grp.btns, r)
 return r
end

function radio:on_mouse_press()
 self.group:select(self.value)
end

function radio:draw(x, y)
 circfill(x+2, y+2, 2, 7)
 if self.selected then
  circfill(x+2, y+2, 1, 0)
 end
end



-- tab control

-- todo!


-- color picker

color_picker={ wants_mouse=true }
subwidget(color_picker)

function color_picker.new(sel, func)
 local c=widget.new()
 setmetatable(c, color_picker)
 c.w=18
 c.h=18
 c.func=func
 c.value=sel
 return c
end

function color_picker:draw(x, y)
 pal()
 palt(0, false)
 
 rect(x, y, x+17, y+17, 0)
 x+=1
 y+=1
 
 for c=0, 15 do
  local cx=x+(c%4)*4
  local cy=y+band(c, 12)
  rectfill(cx, cy, cx+3, cy+3, c)
 end
 
 if self.value then
  local cx=x+(self.value%4)*4
  local cy=y+band(self.value, 12)
  rect(cx, cy, cx+3, cy+3, 0)
  rect(cx-1, cy-1, cx+4, cy+4, 7)
 end
end

function color_picker:on_mouse_press()
 -- it would probably make more
 -- sense to take the position
 -- as arguments, but this will
 -- do...
 --printh("::"..self:abs_x())
 local mx=stat(32)-self:abs_x()-1
 local my=stat(33)-self:abs_y()-1
 local cx=flr(mx/4)
 local cy=flr(my/4)
 if cx>=0 and cx<4 and cy>=0 and cy<4 then
  self.value=cy*4+cx
  if (self.func) self.func(self)
 end
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055000055505000005000000000000000000000000000000055000005500000055500000800000000000000000000007777700077777000777770007777700
505000000555055000555000000000000055500055500000005555000055000050555050097f0000000000000000000077ccc77077cc777077ccc77077ccc770
550055500555555005555500000000000555550050555555005555000005000050050050a777e000000000000000000077c7c770777c77707777c770777cc770
5550055005000050000500000000000055555550555005500005500005555500055555000b7d0000000000000000000077c7c770777c777077c777707777c770
00005050050000505000005000000000050505000000055000555500005550000055500000c00000000000000000000077ccc77077ccc77077ccc77077ccc770
00550000050000505555555000000000050555000000000005555550005550000055500000000000000000000000000077777770777777707777777077777770
00000000000000000000000000000000000000000000000000000000005050000050500000000000000000000000000077777770777777707777777077777770
000000000000000000000000000000000000000000000000000000000050500005505500000000000000000000000000ccccccc0ccccccc0ccccccc0ccccccc0
00050000000500000000000000000000005550000000000000000000005500000000000082828282000000000000000000000000000000000000000000000000
00555000055555000000000000000000055555000055500000555000005500000000000020000008000000000000000001111100011111000111110001111100
05050000005550000000000000000000555555500555050000555000000500000000000080800802000000000000000011ccc11011cc111011ccc11011ccc110
05000500000500000000000000000000055505000555550005555500055555000000000020088008000000000000000011c1c110111c11101111c110111cc110
05000500500000500000000000000000050555000555550000555000005550000000000080088002000000000000000011c1c110111c111011c111101111c110
00555000555555500000000000000000050555000055500000505000005550000000000020800808000000000000000011ccc11011ccc11011ccc11011ccc110
00000000000000000000000000000000000000000000000000000000005050000000000080000002000000000000000011111110111111101111111011111110
00000000000000000000000000000000000000000000000000000000005050000000000028282828000000000000000011111110111111101111111011111110
01000000000000000000000000000000000000000005500000555000000000000000000000000000000000000000000000000000000000000000000000000000
17100000000000000000000000000000000000000055050000555000000000000000000000000000000000000000000000000000000000000000000000000000
17710000000000000000000000000000000000000555505000050000000000000000000000000000000000000000000000000000000000000000000000000000
17771000000000000000000000000000000000000555555005555500000000000000000000000000000000000000000000000000000000000000000000000000
17777100000000000000000000000000000000000055550000555000000000000000000000000000000000000000000000000000000000000000000000000000
17711000000000000000000000000000000000000005500000505000000000000000000000000000000000000000000000000000000000000000000000000000
01171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110000000171000000000000000100000080000000d0d000d0d0d0d0000d00000d00000016161000000000000000000000000000000000000000000000000000
17100000017110100010101000171000097f000000d0d0d00000000000ddd000ddd0000000000000000000000000000000000000000000000000000000000000
17610000017171710171717101000100a777e00000d0d0d0d00000d00d0d0d00ddd00d0000000000000000000000000000000000000000000000000000000000
177610001177777111777771170007100b7d000000ddddd000000000ddddddd00000ddd000000000000000000000000000000000000000000000000000000000
1776610071777771717777710100010000c00000d0ddddd0d00000d00d0d0d000d00ddd000000000000000000000000000000000000000000000000000000000
17611100177777711777777100171000000000000dddddd00000000000ddd0000000000000000000000000000000000000000000000000000000000000000000
1110000001177710011777100001000000000000000ddd00d0d0d0d0000d000000000d0000000000000000000000000000000000000000000000000000000000
00000000001777100017771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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


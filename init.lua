local farmnodes={
	"farming:wheat_8",
	"farming:cotton_8",
	"mcl_farming:wheat",
	"mcl_farming:carrot",
	"mcl_farming:potato",
	"mcl_farming:melon",
	"mcl_farming:pumpkin_face",
	"mcl_farming:beetroot",
	"default:papyrus"
}

local keepbottom={
	"mcl_core:cactus",
	"mcl_core:reeds",
	"default:papyrus"
}

local farmsoil = {
	"mcl_farming:soil",
	"mcl_farming:soil_wet",
	"farming:soil",
	"farming:soil_wet"
}

local seeds={
	["mcl_farming:wheat"]="mcl_farming:wheat_seed",
	["mcl_farming:carrot"]="mcl_farming:carrot_item",
	["mcl_farming:potato"]="mcl_farming:potato_item",
	["mcl_farming:pumpkin_face"]="mcl_farming:pumpkin_seeds",
	["mcl_farming:melon"]="mcl_farming:melon_seeds",
	["mcl_farming:beetroot"]="mcl_farming:beetroot_seeds",
	["farming:cotton"]="farming:seed_wheat",
	["farming:wheat"]="farming:seed_cotton"
}

local to_sew={}

ws.rg("Reap","Diggers","farmtool_reap",function()
	local nds=minetest.find_nodes_near(ws.dircoord(0,0,0),ws.range,farmnodes,true)
	for k,v in ipairs(nds) do
		local nd=minetest.get_node_or_nil(v)
		if nd then
			ws.dig(v)
			local s=seeds[nd.name]
			table.insert(to_sew,{pos=v,node=s})
		end
	end
	local knds=minetest.find_nodes_near(ws.dircoord(0,0,0),ws.range,keepbottom,true)
	for k,v in ipairs(knds) do
		local bt=minetest.get_node_or_nil(vector.new(0,-1,0),v)
		local nd=minetest.get_node_or_nil(v)
		if bt and bt.name==nd.name then
			ws.dig(v)
		end
	end
end)

local sseed="mcl_farming:wheat_seed"

ws.rg("Till","Placers",'farmtool_till',function()
	ws.switch_to_item("mcl_tools:hoe_diamond")
	for i=-1,1 do
		minetest.place_node(ws.dircoord(0,-1,i))
	end
end)


ws.rg("Sow","Placers","farmtool_sow",function()
	local nds=minetest.find_nodes_near(ws.dircoord(0,0,0),ws.range,farmsoil,true)
	for _,v in pairs(nds) do
		ws.place(vector.add(vector.new(0,1,0),v),sd)
	end
end,function()
	local s = minetest.localplayer:get_wielded_item():get_name()
	for _,v in pairs(seeds) do
		if v == s then
			ws.dcm("Sowing started with "..s)
			sseed = s
			return
		end
	end
	ws.dcm("No seed wielded.")
	return true
end)

local ADDON_NAME, ns = "Freebgrid", Freebgrid_NS

local L = ns.Locale

local macroedit = {
	hidden = true,
	path = nil,
	path1 = nil,
}
local defaultvalues = {
	["NONE"] = L.none,
	["target"] = L.target,
	["menu"] = L.menu,
	["follow"] = L.follow,
	["macro"] = L.macro,
}
local default_spells = {
	PRIEST = { 
			139,			--"恢復",
			527,			--"驅散魔法",
			2061,			--"快速治療",
			2006,			--"復活術",
			17,				--"真言術:盾",
			33076,			--"癒合禱言",
			528,			--"驅除疾病", 
			2060,			--"強效治療術",
			32546,			--"束縛治療",
			34861,			--"治療之環",
			2050,			--治疗术
			1706,			--漂浮术
			21562,			--耐
			596,			--治疗祷言
			47758,			-- 苦修
			73325,			-- 信仰飞跃	
			48153,			-- 守护之魂
			88625,			-- 圣言术
			33206,			--痛苦压制
			10060,			--能量灌注
			88684,			--圣言术：静
	},
	
	DRUID = { 
			774,			--"回春術",
			2782,			--"净化腐蚀",
			8936,			--"癒合",
			50769,			--"復活",
			48438,			--"野性成长",
			18562,			--"迅捷治愈",
			50464,			--"滋補術",
			1126,			-- 野性印记
			33763,			--"生命之花",
			5185,			--治疗之触
			20484,			--复生,
			29166,			--激活
			33763,			--生命之花
			467,			--荆棘术
	},
	SHAMAN = { 
			974,			--"大地之盾",
			2008,			--"先祖之魂",
			8004,			--"治疗之涌",
			1064,			--"治疗链",
			331,			--"治疗波",
			51886,			--"净化灵魂",
			546,			--水上行走
			131,			--水下呼吸
			61295,			--"激流",
			77472,			--"强效治疗波",	
			73680,			--"元素释放",
	},

	PALADIN = { 
			635,			--"聖光術",
			19750,			--"聖光閃現",
			53563,			--"圣光信标",
			7328,			--"救贖",
		    20473,			--"神聖震擊",
			82326,			--"神圣之光",
			4987,			--"淨化術",
			85673,			--"荣耀圣令",
			633,			--"聖療術",
		    31789,			--正義防護
			1044,			--自由之手
			31789,			-- 正义防御
			1022,			--"保护之手",
			6940,  			--牺牲之手
			1038,			--"拯救之手",
	},

	WARRIOR = { 
			50720,			--"戒備守護",
			3411,			--"阻擾",
	},

	MAGE = { 
			1459,			--"秘法智力",
			54646,			--"专注",
			475,			--"解除詛咒",
			130,			--"缓落",
	},

	WARLOCK = { 
			80398,			--"黑暗意图",
			5697,			--"魔息",
	},

	HUNTER = { 
			34477,			--"誤導",
			136,			--治疗宠物
			53271,      --"主人的召唤"
			53480,			--"牺牲咆哮"
	},
	
	ROGUE = { 
			57933,			--"偷天換日",
	},
	
	DEATHKNIGHT = {
			61999,			--复活盟友
			47541,			--死缠
			49016,			-- 邪恶狂乱（邪恶天赋)
	},
}

local SetClickKeyvalue = function(info,value)
	--local index = string.sub(info,string.find(info,"%d"))
	local index = string.sub(info,-1)
	if index then
		local val = string.gsub(info, "z", "-")
		local name = val
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end

		if value == "macro" then
			ns.db.ClickCast[index][val]["action"] = "macro"
			macroedit.hidden = false
			macroedit.path = index
			macroedit.path1 = val
		else
			ns.db.ClickCast[index][val]["action"] = value
			macroedit.hidden = true
			macroedit.path =nil
			macroedit.path1 =nil

		end
	end
end		

local GetClickKeyvalue = function(info)
	local index = string.sub(info,-1)
	--local index = string.sub(info,string.find(info,"%d"))
	local value = ""
	if index then
		local val = string.gsub(info, "z", "-")
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end
		value = ns.db.ClickCast[index][val]["action"]
	end
	return value
end		

local function setDefault(src, dest)
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			
			if type(v) == "table" then
				v = setDefault(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end

if type(ns.options) ~= "table" then
	ns.options = {
		type = "group", name = ADDON_NAME,
		get = function(info) return ns.db[info[#info]] end,
		set = function(info, value) ns.db[info[#info]] = value end,
		args={}
	}
end
ns.options.args.ClickCast = {
    type = "group",
	name = L.ClickCast, 
	childGroups = "select",
	get = function(info) return GetClickKeyvalue(info[#info]) end,
	set = function(info, value) SetClickKeyvalue(info[#info], value) end,
	args = {
		enable = {
			name = L.enable,
			type = "toggle",
			order = 1,
			width  = "full",
			desc = L.ClickCastdesc,
			get = function(info) return ns.db.ClickCast.enable end,
			set = function(info,val) ns.db.ClickCast.enable = val;end,
			},
		SetDefault = {
			name = L.SetDefault,
			type = "execute",
			func = function() setDefault(ns.defaults.ClickCast, ns.db.ClickCast);ns:ApplyClickSetting(); end,
			order = 2,
			desc = L.SetDefaultdesc,
			},
		apply = {
			name = L.ClickCastapply,
			type = "execute",
			func = function() ns:UpdateClickCastSet(); end,
			order = 3,
			desc = L.ClickCastapplydesc,
			},
		downclick = {
            name = L.downclick,
            type = "toggle",
            order = 4,
			disabled = function() return not ns.db.ClickCast.enable end,
            get = function(info) return ns.db.ClickCast.downclick end,
			set = function(info,val) ns.db.ClickCast.downclick = val; ns:UpdateClickCastSet();end,
        },
		CSGroup1 = {
			order = 5,
			type = "group",
			name = L.type1 ,		
			disabled = function() return not ns.db.ClickCast.enable end,
			args = {
				type1 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype1 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype1 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype1 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype1 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype1 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype1 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup2 = {
			order = 6,
			type = "group",
			name = L.type2 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type2 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype2 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues				
				},
				ctrlztype2 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype2 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype2 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype2 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype2 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup3 = {
			order = 7,
			type = "group",
			name = L.type3 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type3 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype3 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype3 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype3 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype3 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype3 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype3 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup4 = {
			order = 8,
			type = "group",
			name = L.type4 ,		
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type4 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype4 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype4 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype4 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype4 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype4 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype4 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup5 = {
			order = 9,
			type = "group",
			name = L.type5 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type5 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype5 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype5 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype5 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype5 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype5 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype5 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		macro = {
				order = 10,
				type = "input",
				width  = "full",
				multiline  = true,
				name = function(info)
				if macroedit.path then
					return macroedit.path1.."-"..macroedit.path.." "..L.ClickCastmacro
				else
					return ""			
				end	end,
				hidden =  function() return macroedit.hidden end,				
				desc = L.ClickCastmacrodesc,
				get = function(info) 
				if macroedit.path then 
					return ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] 
				else 
					return "" 
				end end,
				set = function(info,val)
					ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] = val
					macroedit.hidden = true
					ns:ApplyClickSetting() 
				end,
		},
    },	
}

local class = select(2, UnitClass("player"))
for _, v in pairs(default_spells[class]) do	--创建职业默认技能表
	local spellname = GetSpellInfo(v)	
	if spellname then
		defaultvalues[tostring(spellname)] = spellname
	end
end

for i = 1, 5 do	--设置下拉菜单
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in ipairs (path) do
		path[k]["values"] = defaultvalues
	end
end

local getclickargsname = function(var)
	local v = string.gsub(var, "z", " + ")
	local ktype = L[string.match(v, "type%d")]		
	local name = string.gsub(v, "type%d", "")..ktype

	return name
end	

for i = 1, 5 do	--设置名称
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in pairs (path) do
		path[k]["name"] = getclickargsname(k)
	end
end

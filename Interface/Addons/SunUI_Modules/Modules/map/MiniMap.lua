﻿-- Engines
local S, C, L, DB = unpack(SunUI)

 
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("MiniMap", "AceTimer-3.0")
function Module:OnInitialize()
	Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Minimap:SetFrameStrata("MEDIUM")
	Minimap:ClearAllPoints()
	Minimap:SetSize(120, 120)
	local h = CreateFrame("Frame", nil, Minimap)
	h:Point("TOPLEFT",1,-1)
	h:Point("BOTTOMRIGHT",-1,1)
	h:CreateShadow()
	local PMinimap = CreateFrame("Frame", nil, Minimap)
	PMinimap:SetFrameStrata("BACKGROUND")
	PMinimap:SetFrameLevel(0)
	PMinimap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -100, 100)
	PMinimap:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 100, -100)
	PMinimap.texture = PMinimap:CreateTexture(nil)
	PMinimap.texture:SetAllPoints(PMinimap)
	PMinimap.texture:SetTexture("World\\GENERIC\\ACTIVEDOODADS\\INSTANCEPORTAL\\GENERICGLOW2.BLP")
	PMinimap.texture:SetVertexColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b)
	PMinimap.texture:SetBlendMode("ADD")


	MoveHandle.Minimap = S.MakeMoveHandle(Minimap, L["小地图"], "Minimap")


	LFGSearchStatus:SetClampedToScreen(true)
	LFGDungeonReadyStatus:SetClampedToScreen(true)

	local frames = {
		"GameTimeFrame",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MiniMapBattlefieldBorder",
	--    "FeedbackUIButton",
	}

	for i in pairs(frames) do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = function() end
	end
	MinimapCluster:EnableMouse(false)

	-- Tracking
	MiniMapTrackingBackground:SetAlpha(0)
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -5)
	MiniMapTracking:SetScale(1)

	-- BG icon
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", 2, 8)

	-- Random Group icon
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrameBorder:SetAlpha(0)
	MiniMapLFGFrame:SetPoint("TOP", Minimap, "TOP", 1, 8)
	MiniMapLFGFrame:SetFrameStrata("MEDIUM")

	-- Instance Difficulty flag
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	MiniMapInstanceDifficulty:SetScale(0.1)
	MiniMapInstanceDifficulty:SetAlpha(0)
	MiniMapInstanceDifficulty:SetFrameStrata("LOW")

	-- Guild Instance Difficulty flag
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
	GuildInstanceDifficulty:SetScale(0.1)
	GuildInstanceDifficulty:SetAlpha(0)
	GuildInstanceDifficulty:SetFrameStrata("LOW")

	-- Mail icon
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\!SunUI\\media\\mail")

	-- Invites Icon
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent("Minimap")
	GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

	if FeedbackUIButton then
	FeedbackUIButton:ClearAllPoints()
	FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
	FeedbackUIButton:SetScale(0.8)
	end

	if StreamingIcon then
	StreamingIcon:ClearAllPoints()
	StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
	StreamingIcon:SetScale(0.8)
	end

	-- Enable mouse scrolling
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, z)
		local c = Minimap:GetZoom()
		if z > 0 and c < 5 then
			Minimap:SetZoom(c+1)
		elseif z < 0 and c > 0 then
			Minimap:SetZoom(c-1)
		end
	end)

	local menuFrame = CreateFrame("Frame", "m_MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = L["角色信息"], func = function() ToggleCharacter("PaperDollFrame") end},
		{text = L["法术书"], func = function() ToggleSpellBook("spell") end},
		{text = L["天赋"], func = function() ToggleTalentFrame() end},
		{text = L["成就"], func = function() ToggleAchievementFrame() end},
		{text = L["任务日志"], func = function() ToggleFrame(QuestLogFrame) end},
		{text = L["社交"], func = function() ToggleFriendsFrame(1) end},
		{text = L["公会"], func = function() ToggleGuildFrame(1) end},
		{text = "PvP", func = function() ToggleFrame(PVPFrame) end},
		{text = L["地城查找器"], func = function() ToggleFrame(LFDParentFrame) end},
		{text = L["团队查找器"], func = function() ToggleFrame(RaidParentFrame) end},
		{text = L["帮助"], func = function() ToggleHelpFrame() end},
		{text = L["行事历"], func = function() if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() end},
		{text = L["地城手册"],func = function() ToggleEncounterJournal() end},
		{text = "Bags",func = function() ToggleAllBags() end},
		{text = "系统菜单",func = function() ToggleFrame(GameMenuFrame) end},
	}

	Minimap:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			Minimap_OnClick(self)
		end
	end)
	local SubLoc = CreateFrame("Frame", "Sub Location", Minimap)
	local SubText = SubLoc:CreateFontString(nil)
	local SubText2 = SubLoc:CreateFontString(nil)
	SubText:SetFont(DB.Font, 17*S.mult, "OUTLINE")
	SubText:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
	SubLoc:SetAllPoints(SubText)
	SubText2:SetPoint("TOP", SubLoc, "BOTTOM", 0,-3)
	SubText2:SetFont(DB.Font, 13*S.mult, "OUTLINE")
	SubLoc:Hide()
	SubText2:SetText("")
	SubText:SetText("")
	Minimap:SetScript('OnEnter', function() 
		SubText:Show() 
		SubText2:Show() 
		SubText2:SetText(GetZoneText())
		SubText:SetText(GetSubZoneText()) 
		UIFrameFadeIn(SubLoc, 1.5, SubLoc:GetAlpha(), 1)
		local pvp = GetZonePVPInfo()
		if pvp == "friendly" then r,g,b = 0.1,1,0.1 
			elseif pvp == "sanctuary" then r,g,b = 0.41,0.8,0.94 
			elseif pvp =="arena" then r,g,b = 1,0.1,0.1 
			elseif pvp == "hostile" then r,g,b = 1,0.1,0.1 
			elseif pvp == "contested" then r,g,b = 1,0.7,0 
			elseif pvp == "combat" then r,g,b = 1,0.1,0.1 
			else r,g,b = 1,1,1 
		end
		SubText:SetTextColor(r,g,b) 
	end)
	Minimap:SetScript('OnLeave', function() 
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = 1.5
		fadeInfo.finishedFunc = function() SubLoc:Hide() end	--隐藏
		fadeInfo.startAlpha = SubLoc:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(SubLoc, fadeInfo)
	end)
end
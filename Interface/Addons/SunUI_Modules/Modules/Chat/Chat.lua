﻿local S, C, L, DB = unpack(SunUI)
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("Chat", "AceEvent-3.0")
 
function Module:OnInitialize()
-- 聊天设置
local AutoApply = false									--聊天设置锁定		
local def_position = {"BOTTOMLEFT", 5, 25} -- Chat Frame position
local chat_height = 122
local chat_width = 327
local fontsize = 10                          --other variables
local tscol = "64C2F5"						-- Timestamp coloring
local TimeStampsCopy = true					-- 时间戳

	for i = 1, 25 do
		CHAT_FONT_HEIGHTS[i] = i+4
	end
	local LinkHover = {}; LinkHover.show = {	-- enable (true) or disable (false) LinkHover functionality for different things in chat
		["achievement"] = true,
		["enchant"]     = true,
		["glyph"]       = true,
		["item"]        = true,
		["quest"]       = true,
		["spell"]       = true,
		["talent"]      = true,
		["unit"]        = true,}

	for i = 1, NUM_CHAT_WINDOWS do
	  local cf = _G['ChatFrame'..i]
	  cf:SetFading(true)  --渐隐
	  if cf then 
		cf:SetFont(NAMEPLATE_FONT, 10*S.Scale(1), "THINOUTLINE") 
		cf:SetFrameStrata("LOW")
		cf:SetFrameLevel(2)
		cf:CreateShadow("Background")
	  end
	  local tab = _G['ChatFrame'..i..'Tab']
	  if tab then
		tab:GetFontString():SetFont(NAMEPLATE_FONT, 11*S.Scale(1), "OUTLINE")
		--fix for color and alpha of undocked frames
		tab:GetFontString():SetTextColor(0,0,1)
		tab:SetAlpha(1)
	  end
	end

	-- 打开输入框回到上次对话
	ChatTypeInfo.SAY.sticky = 0
	ChatTypeInfo.EMOTE.sticky = 0
	ChatTypeInfo.YELL.sticky = 0
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 0
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 0

	-------------- > Custom timestamps color
	do
		ChatFrame2ButtonFrameBottomButton:RegisterEvent("PLAYER_LOGIN")
		ChatFrame2ButtonFrameBottomButton:SetScript("OnEvent", function(f)
			TIMESTAMP_FORMAT_HHMM = "|cff"..tscol.."[%I:%M]|r "
			TIMESTAMP_FORMAT_HHMMSS = "|cff"..tscol.."[%I:%M:%S]|r "
			TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff"..tscol.."[%H:%M:%S]|r "
			TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff"..tscol.."[%I:%M:%S %p]|r "
			TIMESTAMP_FORMAT_HHMM_24HR = "|cff"..tscol.."[%H:%M]|r "
			TIMESTAMP_FORMAT_HHMM_AMPM = "|cff"..tscol.."[%I:%M %p]|r "
			f:UnregisterEvent("PLAYER_LOGIN")
			f:SetScript("OnEvent", nil)
		end)
	end

	---------------- > 渐隐透明度
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

	---------------- > Function to move and scale chatframes 
	SetChat = function()
		FCF_SetLocked(ChatFrame1, nil)
		FCF_SetChatWindowFontSize(self, ChatFrame1, fontsize*S.Scale(1)) 
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint(unpack(def_position))
		ChatFrame1:SetWidth(chat_width)
		ChatFrame1:SetHeight(chat_height)
		ChatFrame1:SetFrameLevel(8)
		ChatFrame1:SetUserPlaced(true)
		for i=1,10 do 
		local cf = _G["ChatFrame"..i] 
		cf:CreateShadow("Background")
		--FCF_SetWindowAlpha(cf, 0.8) 
		end 
		FCF_SavePositionAndDimensions(ChatFrame1)
		FCF_SetLocked(ChatFrame1, 1)
	end
	SlashCmdList["SETCHAT"] = SetChat
	SLASH_SETCHAT1 = "/setchat"
	if AutoApply then
		local f = CreateFrame"Frame"
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function() SetChat() end)
	end
	local function kill(f)
		if f.UnregisterAllEvents then
			f:UnregisterAllEvents()
		end
		--f.Show = function() end
		f:Hide()
	end
	
	do
		-- Buttons Hiding/moving 
		--local kill = function(f) f:Hide() end
		ChatFrameMenuButton:Hide()
		ChatFrameMenuButton:SetScript("OnShow", kill)
		FriendsMicroButton:Hide()
		FriendsMicroButton:SetScript("OnShow", kill)

		for i=1, 10 do
			local cf = _G[format("%s%d", "ChatFrame", i)]
		--fix fading
			cf:SetFading(false)
			--cf:SetClampRectInsets(0,0,0,0)
			local tab = _G["ChatFrame"..i.."Tab"]
			if style_chat_tabs then
				tab:SetAlpha(1)
				--if tab:GetAlpha() ~= 0 then tab.SetAlpha = UIFrameFadeRemoveFrame end
				_G["ChatFrame"..i.."TabText"]:SetTextColor(.9,.8,.5) -- 1,.7,.2
				_G["ChatFrame"..i.."TabText"].SetTextColor = function() end
				_G["ChatFrame"..i.."TabText"]:SetFont(DB.Font,12,"THINOUTLINE")
				_G["ChatFrame"..i.."TabText"]:SetShadowOffset(1.75, -1.75)
				
				kill(_G[format("ChatFrame%sTabLeft", i)])
				kill(_G[format("ChatFrame%sTabMiddle", i)])
				kill(_G[format("ChatFrame%sTabRight", i)])
				kill(_G[format("ChatFrame%sTabSelectedLeft", i)])
				kill(_G[format("ChatFrame%sTabSelectedMiddle", i)])
				kill(_G[format("ChatFrame%sTabSelectedRight", i)])
				kill(_G[format("ChatFrame%sTabHighlightLeft", i)])
				kill(_G[format("ChatFrame%sTabHighlightMiddle", i)])
				kill(_G[format("ChatFrame%sTabHighlightRight", i)])
				kill(_G[format("ChatFrame%sTabSelectedLeft", i)])
				kill(_G[format("ChatFrame%sTabSelectedMiddle", i)])
				kill(_G[format("ChatFrame%sTabSelectedRight", i)])
				kill(_G[format("ChatFrame%sTabGlow", i)])
				
				tab.leftSelectedTexture:Hide()
				tab.middleSelectedTexture:Hide()
				tab.rightSelectedTexture:Hide()
				tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
				tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
				tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide
			else
				tab:SetAlpha(0)
				tab.noMouseAlpha = 0
			end
		
		-- Hide chat textures
			for j = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
			end
		--Unlimited chatframes resizing
			cf:SetMinResize(0,0)
			cf:SetMaxResize(0,0)
		
		--Allow the chat frame to move to the end of the screen
			cf:SetClampedToScreen(false)
			cf:SetClampRectInsets(0,0,0,0)
		for i = 1, NUM_CHAT_WINDOWS do
					local chat = format("ChatFrame%s",i)
					_G[chat.."EditBoxLanguage"]:ClearAllPoints()
					_G[chat.."EditBoxLanguage"]:SetPoint("LEFT", _G[chat.."EditBox"], "RIGHT", S.Scale(5), 0)
					_G[chat.."EditBoxLanguage"]:SetSize(_G[chat.."EditBox"]:GetHeight(),_G[chat.."EditBox"]:GetHeight()+1)
					S.StripTextures(_G[chat.."EditBoxLanguage"])
					_G[chat.."EditBoxLanguage"]:CreateShadow("Background")
					_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
					_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
					local a = CreateFrame("Frame",nil,WorldFrame)
					a:RegisterEvent("PLAYER_ENTERING_WORLD") 
					a:SetScript("OnEvent",function(self,event,...) 
					if(event == "PLAYER_ENTERING_WORLD") then
					_G['ChatFrame'..i..'EditBox']:SetAlpha(0) end 
					end)
			end
				
		--EditBox Module
			local ebParts = {'Left', 'Mid', 'Right'}
			local eb = _G['ChatFrame'..i..'EditBox']
			for _, ebPart in ipairs(ebParts) do
				_G['ChatFrame'..i..'EditBox'..ebPart]:SetTexture(nil)
				local ebed = _G['ChatFrame'..i..'EditBoxFocus'..ebPart]
				--ebed:SetTexture(0,0,0,0.8)
				ebed:SetTexture(nil)
				ebed:SetHeight(18)
			end
			eb:SetAltArrowKeyMode(false)
			eb:ClearAllPoints()
			eb:Point("BOTTOMLEFT", cf, "TOPLEFT",  -1, 3)
			eb:Point("BOTTOMRIGHT", cf, "TOPRIGHT", 1, 3)
			eb:SetHeight(18)
			eb:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = DB.GlowTex, edgeSize = S.mult+0.2, 
				insets = {top = S.mult+0.2, left =S.mult+0.2, bottom = S.mult+0.2, right = S.mult+0.2}})
			eb:SetBackdropColor(0,0,0,0.3)
			eb:SetBackdropBorderColor(0,0,0,1)
			eb:EnableMouse(false)
		
		--Remove scroll buttons
			local bf = _G['ChatFrame'..i..'ButtonFrame']
			bf:Hide()
			bf:SetScript("OnShow",  kill)
		
		--Scroll to the bottom button
			local function BottomButtonClick(self)
				self:GetParent():ScrollToBottom();
			end
			local bb = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
			bb:SetParent(_G["ChatFrame"..i])
			bb:SetHeight(18)
			bb:SetWidth(18)
			bb:ClearAllPoints()
			bb:SetPoint("TOPRIGHT", cf, "TOPRIGHT", 0, -6)
			bb:SetAlpha(0.4)
			--bb.SetPoint = function() end
			bb:SetScript("OnClick", BottomButtonClick)
		end
	end

	---------------- > Channel names
	local gsub = _G.string.gsub
	local time = _G.time
	local newAddMsg = {}

	local chn, rplc
	do
		rplc = {
			L["综合"], --General
			L["交易"], --Trade
			L["世界防务"], --WorldDefense
			L["本地防御"], --LocalDefense
			L["寻求组队"], --LookingForGroup
			L["工会招募"], --GuildRecruitment
			L["战场"], --Battleground
			L["战场领袖"], --Battleground Leader
			L["工会"], --Guild
			L["小队"], --Party
			L["小队队长"], --Party Leader
			L["地城领袖"], --Party Leader (Guide)
			L["官员"], --Officer
			L["团队"], --Raid
			L["团队领袖"], --Raid Leader
			L["团队警告"], --Raid Warning
		}
		chn = {
			"%[%d+%. General.-%]",
			"%[%d+%. Trade.-%]",
			"%[%d+%. WorldDefense%]",
			"%[%d+%. LocalDefense.-%]",
			"%[%d+%. LookingForGroup%]",
			"%[%d+%. GuildRecruitment.-%]",
			gsub(CHAT_BATTLEGROUND_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_BATTLEGROUND_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
			gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		}
		local Lo = GetLocale()
		if Lo == "ruRU" then --Russian
			chn[1] = "%[%d+%. Общий.-%]"
			chn[2] = "%[%d+%. Торговля.-%]"
			chn[3] = "%[%d+%. Оборона: глобальный%]" --Defense: Global
			chn[4] = "%[%d+%. Оборона.-%]" --Defense: Zone
			chn[5] = "%[%d+%. Поиск спутников%]"
			chn[6] = "%[%d+%. Гильдии.-%]"
		elseif L == "deDE" then --German
			chn[1] = "%[%d+%. Allgemein.-%]"
			chn[2] = "%[%d+%. Handel.-%]"
			chn[3] = "%[%d+%. Weltverteidigung%]"
			chn[4] = "%[%d+%. LokaleVerteidigung.-%]"
			chn[5] = "%[%d+%. SucheNachGruppe%]"
			chn[6] = "%[%d+%. Gildenrekrutierung.-%]"
		end
	end
	local function AddMessage(frame, text, ...)
		for i = 1, 16 do
			text = gsub(text, chn[i], rplc[i])
		end
		--If Blizz timestamps is enabled, stamp anything it misses
		if CHAT_TIMESTAMP_FORMAT and not text:find("|r") then
			text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
		end
		text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
		return newAddMsg[frame:GetName()](frame, text, ...)
	end
	do
		for i = 1, 5 do
			if i ~= 2 then -- skip combatlog
				local f = _G[format("%s%d", "ChatFrame", i)]
				newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
				f.AddMessage = AddMessage
			end
		end
	end
	---------------- > Enable/Disable mouse for editbox
	eb_mouseon = function()
		for i =1, 10 do
			local eb = _G['ChatFrame'..i..'EditBox']
			eb:EnableMouse(true)
		end
	end
	eb_mouseoff = function()
		for i =1, 10 do
			local eb = _G['ChatFrame'..i..'EditBox']
			eb:EnableMouse(false)
		end
	end
	hooksecurefunc("ChatFrame_OpenChat",eb_mouseon)
	hooksecurefunc("ChatEdit_SendText",eb_mouseoff)

	---------------- > Show tooltips when hovering a link in chat (credits to Adys for his LinkHover)
	function LinkHover.OnHyperlinkEnter(_this, linkData, link)
		local t = linkData:match("^(.-):")
		if LinkHover.show[t] and IsAltKeyDown() then
			ShowUIPanel(GameTooltip)
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end
	function LinkHover.OnHyperlinkLeave(_this, linkData, link)
		local t = linkData:match("^(.-):")
		if LinkHover.show[t] then
			HideUIPanel(GameTooltip)
		end
	end
	local function LinkHoverOnLoad()
		for i = 1, NUM_CHAT_WINDOWS do
			local f = _G["ChatFrame"..i]
			f:SetScript("OnHyperlinkEnter", LinkHover.OnHyperlinkEnter)
			f:SetScript("OnHyperlinkLeave", LinkHover.OnHyperlinkLeave)
		end
	end
	LinkHoverOnLoad()

	---------------- > Chat Scroll Module
	hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
		if dir > 0 then
			if IsShiftKeyDown() then
				self:ScrollToTop()
			elseif IsControlKeyDown() then
				--only need to scroll twice because of blizzards scroll
				self:ScrollUp()
				self:ScrollUp()
			end
		elseif dir < 0 then
			if IsShiftKeyDown() then
				self:ScrollToBottom()
			elseif IsControlKeyDown() then
				--only need to scroll twice because of blizzards scroll
				self:ScrollDown()
				self:ScrollDown()
			end
		end
	end)

	---------------- > afk/dnd msg filter
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

	---------------- > Batch ChatCopy Module
	local lines = {}
	do
		--Create Frames/Objects
		local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
		frame:SetWidth(600)
		frame:SetHeight(500)
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:Hide()
		frame:SetFrameStrata("DIALOG")
		S.SetBD(frame)
		local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
		scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
		scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

		local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
		editBox:SetMultiLine(true)
		editBox:SetMaxLetters(99999)
		editBox:EnableMouse(true)
		editBox:SetAutoFocus(false)
		editBox:SetFontObject(ChatFontNormal)
		editBox:SetWidth(400)
		editBox:SetHeight(270)
		editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
		scrollArea:SetScrollChild(editBox)
		
		
		local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
		close:SetSize(20, 20)
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
		close.text = S.MakeFontString(close, 10)
		close.text:SetAllPoints(close)
		close.text:SetText("X")
		S.Reskin(close)
		local copyFunc = function(frame, btn)
			local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
			local _, size = cf:GetFont()
			FCF_SetChatWindowFontSize(cf, cf, 0.01)
			local ct = 1
			for i = select("#", cf:GetRegions()), 1, -1 do
				local region = select(i, cf:GetRegions())
				if region:GetObjectType() == "FontString" then
					lines[ct] = tostring(region:GetText())
					ct = ct + 1
				end
			end
			local lineCt = ct - 1
			local text = table.concat(lines, "\n", 1, lineCt)
			FCF_SetChatWindowFontSize(cf, cf, size)
			BCMCopyFrame:Show()
			BCMCopyBox:SetText(text)
			BCMCopyBox:HighlightText(0)
			wipe(lines)
		end
		local hintFunc = function(frame)
			GameTooltip:SetOwner(frame, "ANCHOR_TOP")
			if SHOW_NEWBIE_TIPS == "1" then
				GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
				GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
			end
			GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."|TInterface\\Buttons\\UI-GuildButton-OfficerNote-Disabled:27|t雙擊標籤複製.", 1, 1, 1)
			GameTooltip:Show()
		end
		for i = 1, 10 do
			local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
			tab:SetScript("OnDoubleClick", copyFunc)
			tab:SetScript("OnEnter", hintFunc)
		end
	end


	---------------- > Per-line chat copy via time stamps
	if TimeStampsCopy then
		local AddMsg = {}
		local AddMessage = function(frame, text, ...)
			text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
			text = ('|cffffffff|Hm_Chat|h|r%s|h %s'):format('|cff'..tscol..''..date('%H:%M')..'|r', text)
			return AddMsg[frame:GetName()](frame, text, ...)
		end
		for i = 1, 10 do
			if i ~= 2 then
				AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
				_G["ChatFrame"..i].AddMessage = AddMessage
			end
		end
	end

	--[[---------------- > URL copy Module
	local tlds = {
		"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
		"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
		"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
		"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]", "[Ss][Ee]", "[Nn][Oo]", "[Ff][Ii]"
	}

	local uPatterns = {
		'(http://%S+)',
		'(www%.%S+)',
		'(%d+%.%d+%.%d+%.%d+:?%d*)',
	}

	local cTypes = {
		"CHAT_MSG_CHANNEL",
		"CHAT_MSG_YELL",
		"CHAT_MSG_GUILD",
		"CHAT_MSG_OFFICER",
		"CHAT_MSG_PARTY",
		"CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_RAID",
		"CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_SAY",
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_BN_WHISPER",
		"CHAT_MSG_BN_CONVERSATION",
	}

	for _, event in pairs(cTypes) do
		ChatFrame_AddMessageEventFilter(event, function(self, event, text, ...)
			for i=1, 24 do
				local result, matches = string.gsub(text, "(%S-%."..tlds[i].."/?%S*)", "|cff8A9DDE|Hurl:%1|h[%1]|h|r")
				if matches > 0 then
					return false, result, ...
				end
			end
			for _, pattern in pairs(uPatterns) do
				local result, matches = string.gsub(text, pattern, '|cff8A9DDE|Hurl:%1|h[%1]|h|r')
				if matches > 0 then
					return false, result, ...
				end
			end 
		end)
	end

	local GetText = function(...)
		for l = 1, select("#", ...) do
			local obj = select(l, ...)
			if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
				return obj:GetText()
			end
		end
	end

	local SetIRef = SetItemRef
	SetItemRef = function(link, text, ...)
		local txt, frame
		if link:sub(1, 6) == 'm_Chat' then
			frame = GetMouseFocus():GetParent()
			txt = GetText(frame:GetRegions())
			txt = txt:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
			txt = txt:gsub("|H.-|h(.-)|h", "%1")
		elseif link:sub(1, 3) == 'url' then
			frame = GetMouseFocus():GetParent()
			txt = link:sub(5)
		end
		if txt then
			local editbox
			if GetCVar('chatStyle') == 'classic' then
				editbox = LAST_ACTIVE_CHAT_EDIT_BOX
			else
				editbox = _G['ChatFrame'..frame:GetID()..'EditBox']
			end
			editbox:Show()
			editbox:Insert(txt)
			editbox:HighlightText()
			editbox:SetFocus()
			return
		end
		return SetIRef(link, text, ...)
	end
	--]]
end
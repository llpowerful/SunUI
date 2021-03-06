


local alpha = .5 -- controls the backdrop opacity (0 = invisible, 1 = solid)

-- [[ Core ]]


local F, C = {}, {}
local S, _, _, DB = unpack(select(2, ...))
C.classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}

C.media = {
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\!Sunui\\Media\\CheckButtonHilight",
	["glow"] = DB.GlowTex,
	["texture"] = DB.Statusbar,
}

F.dummy = function() end

-- [[ Addon core ]]

local _, class = UnitClass("player")
local r, g, b
if CUSTOM_CLASS_COLORS then 
	r, g, b = CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
else
	r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b
end

F.CreateTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 8, -3)
	bg:Point("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg)

	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 10, -4)
	hl:Point("BOTTOMRIGHT", -10, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.downtex:SetVertexColor(0, .76, 1)
	end
end

local function clearArrow(f)
	f.downtex:SetVertexColor(1, 1, 1)
end

F.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:ClearAllPoints()
	down:Point("TOPRIGHT", -18, -4)
	down:Point("BOTTOMRIGHT", -18, 8)
	down:SetWidth(19)

	S.Reskin(down, true)
	
	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-down-active")
	downtex:Size(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.downtex = downtex
	
	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)
	
	local bg = CreateFrame("Frame", nil, f)
	bg:Point("TOPLEFT", 16, -4)
	bg:Point("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bg, 0)

	S.CreateGradient(bg)
end

F.ReskinArrow = function(f, direction)
	f:Size(18, 18)
	S.Reskin(f)
	
	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:Size(8, 8)
	tex:SetPoint("CENTER")
	
	if direction == 1 then
		tex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-left-active")
	elseif direction == 2 then
		tex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-right-active")
	end
end

F.ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 5, -5)
	hl:Point("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)
	
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", 5, -5)
	tex:Point("BOTTOMRIGHT", -5, 5)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", tex, -1, 1)
	bd:Point("BOTTOMRIGHT", tex, 1, -1)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	
end

F.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 14, -2)
	bd:Point("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	S.CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

F.ReskinExpandOrCollapse = function(f)
	S.Reskin(f, true)
	f.SetNormalTexture = F.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:Size(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(C.media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:Size(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(C.media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture(C.media.backdrop)
	f:SetCheckedTexture(C.media.backdrop)
	
	local hl = f:GetHighlightTexture()
	hl:Point("TOPLEFT", 5, -5)
	hl:Point("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)
	
	local ch = f:GetCheckedTexture()
	ch:Point("TOPLEFT", 5, -5)
	ch:Point("BOTTOMRIGHT", -5, 5)
	ch:SetVertexColor(r, g, b, .5)

	local bd = CreateFrame("Frame", nil, f)
	bd:Point("TOPLEFT", 4, -4)
	bd:Point("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	S.CreateBD(bd, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", 5, -5)
	tex:Point("BOTTOMRIGHT", -5, 5)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

local Skin = CreateFrame("Frame", nil, UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if addon == "!SunUI" then
		
		-- [[ Headers ]]

		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, #header do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:Point("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local bds = {"AutoCompleteBox", "BNToastFrame", "LFGSearchStatus", "TicketStatusFrameButton", "GearManagerDialogPopup", "TokenFramePopup", "ReputationDetailFrame", "RaidInfoFrame", "MissingLootFrame", "ScrollOfResurrectionSelectionFrame", "ScrollOfResurrectionFrame", "VoiceChatTalkers", "ReportPlayerNameDialog", "ReportCheatingDialog"}

		for i = 1, #bds do
			local bd = _G[bds[i]]
			if bd then
				S.CreateBD(bd)
			else
				print("Aurora: "..bds[i].." was not found.")
			end
		end

		local lightbds = {"SpellBookCompanionModelFrame", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigCategoryFrame", "ChatConfigBackgroundFrame", "ChatConfigChatSettingsLeft", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsLeft", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "QuestLogCount", "HelpFrameTicketScrollFrame", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2", "GuildRegistrarFrameEditBox", "FriendsFriendsNoteFrame", "AddFriendNoteFrame", "ScrollOfResurrectionSelectionFrameList", "HelpFrameReportBugScrollFrame", "HelpFrameSubmitSuggestionScrollFrame", "ReportPlayerNameDialogCommentFrame", "ReportCheatingDialogCommentFrame"}
		for i = 1, #lightbds do
			local bd = _G[lightbds[i]]
			if bd then
				S.CreateBD(bd, .25)
			else
				print("Aurora: "..lightbds[i].." was not found.")
			end
		end

		-- [[ Scroll bars ]]

		local scrollbars = {"FriendsFrameFriendsScrollFrameScrollBar", "QuestLogScrollFrameScrollBar", "QuestLogDetailScrollFrameScrollBar", "CharacterStatsPaneScrollBar", "PVPHonorFrameTypeScrollFrameScrollBar", "PVPHonorFrameInfoScrollFrameScrollBar", "LFDQueueFrameSpecificListScrollFrameScrollBar", "GossipGreetingScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameReportBugScrollFrameScrollBar", "HelpFrameSubmitSuggestionScrollFrameScrollBar", "HelpFrameTicketScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "SendMailScrollFrameScrollBar", "OpenMailScrollFrameScrollBar", "RaidInfoScrollFrameScrollBar", "ReputationListScrollFrameScrollBar", "FriendsFriendsScrollFrameScrollBar", "HelpFrameGM_ResponseScrollFrame1ScrollBar", "HelpFrameGM_ResponseScrollFrame2ScrollBar", "HelpFrameKnowledgebaseScrollFrame2ScrollBar", "WhoListScrollFrameScrollBar", "QuestProgressScrollFrameScrollBar", "QuestRewardScrollFrameScrollBar", "QuestDetailScrollFrameScrollBar", "QuestGreetingScrollFrameScrollBar", "QuestNPCModelTextScrollFrameScrollBar", "GearManagerDialogPopupScrollFrameScrollBar", "LFDQueueFrameRandomScrollFrameScrollBar", "WarGamesFrameScrollFrameScrollBar", "WarGamesFrameInfoScrollFrameScrollBar", "WorldStateScoreScrollFrameScrollBar", "ItemTextScrollFrameScrollBar", "ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar", "ChannelRosterScrollFrameScrollBar"}
		for i = 1, #scrollbars do
			local scrollbar = _G[scrollbars[i]]
			if scrollbar then
				S.ReskinScroll(scrollbar)
			else
				print(scrollbars[i].." was not found.")
			end
		end

		-- [[ Dropdowns ]]

		local dropdowns = {"FriendsFrameStatusDropDown", "LFDQueueFrameTypeDropDown", "LFRBrowseFrameRaidDropDown", "WhoFrameDropDown", "FriendsFriendsFrameDropDown", "RaidFinderQueueFrameSelectionDropDown", "WorldMapShowDropDown", "Advanced_GraphicsAPIDropDown"}
		for i = 1, #dropdowns do
			local dropdown = _G[dropdowns[i]]
			if dropdown then
				F.ReskinDropDown(dropdown)
			else
				print("Aurora: "..dropdowns[i].." was not found.")
			end
		end

		-- [[ Input frames ]]

		local inputs = {"AddFriendNameEditBox", "PVPTeamManagementFrameWeeklyDisplay", "SendMailNameEditBox", "SendMailSubjectEditBox", "SendMailMoneyGold", "SendMailMoneySilver", "SendMailMoneyCopper", "StaticPopup1MoneyInputFrameGold", "StaticPopup1MoneyInputFrameSilver", "StaticPopup1MoneyInputFrameCopper", "StaticPopup2MoneyInputFrameGold", "StaticPopup2MoneyInputFrameSilver", "StaticPopup2MoneyInputFrameCopper", "GearManagerDialogPopupEditBox", "FriendsFrameBroadcastInput", "HelpFrameKnowledgebaseSearchBox", "ChannelFrameDaughterFrameChannelName", "ChannelFrameDaughterFrameChannelPassword", "BagItemSearchBox", "BankItemSearchBox", "TradePlayerInputMoneyFrameGold", "TradePlayerInputMoneyFrameSilver", "TradePlayerInputMoneyFrameCopper", "ScrollOfResurrectionSelectionFrameTargetEditBox", "ScrollOfResurrectionFrameNoteFrame"}
		for i = 1, #inputs do
			local input = _G[inputs[i]]
			if input then
				S.ReskinInput(input)
			else
				print("Aurora: "..inputs[i].." was not found.")
			end
		end
		
		S.ReskinInput(FriendsFrameBroadcastInput, nil, nil, 0)
		S.ReskinInput(StaticPopup1EditBox, 20)
		S.ReskinInput(StaticPopup2EditBox, 20)
		S.ReskinInput(PVPBannerFrameEditBox, 20)

		-- [[ Arrows ]]

		F.ReskinArrow(SpellBookPrevPageButton, 1)
		F.ReskinArrow(SpellBookNextPageButton, 2)
		F.ReskinArrow(InboxPrevPageButton, 1)
		F.ReskinArrow(InboxNextPageButton, 2)
		F.ReskinArrow(MerchantPrevPageButton, 1)
		F.ReskinArrow(MerchantNextPageButton, 2)
		F.ReskinArrow(CharacterFrameExpandButton, 1)
		F.ReskinArrow(PVPTeamManagementFrameWeeklyToggleLeft, 1)
		F.ReskinArrow(PVPTeamManagementFrameWeeklyToggleRight, 2)
		F.ReskinArrow(PVPBannerFrameCustomization1LeftButton, 1)
		F.ReskinArrow(PVPBannerFrameCustomization1RightButton, 2)
		F.ReskinArrow(PVPBannerFrameCustomization2LeftButton, 1)
		F.ReskinArrow(PVPBannerFrameCustomization2RightButton, 2)
		F.ReskinArrow(ItemTextPrevPageButton, 1)
		F.ReskinArrow(ItemTextNextPageButton, 2)
		F.ReskinArrow(TabardCharacterModelRotateLeftButton, 1)
		F.ReskinArrow(TabardCharacterModelRotateRightButton, 2)
		for i = 1, 5 do
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], 1)
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], 2)
		end

		hooksecurefunc("CharacterFrame_Expand", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-left-active")
		end)

		hooksecurefunc("CharacterFrame_Collapse", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-right-active")
		end)

		-- [[ Check boxes ]]

		local checkboxes = {"TokenFramePopupInactiveCheckBox", "TokenFramePopupBackpackCheckBox", "ReputationDetailAtWarCheckBox", "ReputationDetailInactiveCheckBox", "ReputationDetailMainScreenCheckBox"}
		for i = 1, #checkboxes do
			local checkbox = _G[checkboxes[i]]
			if checkbox then
				F.ReskinCheck(checkbox)
			else
				print("Aurora: "..checkboxes[i].." was not found.")
			end
		end

		F.ReskinCheck(LFDQueueFrameRoleButtonTank:GetChildren())
		F.ReskinCheck(LFDQueueFrameRoleButtonHealer:GetChildren())
		F.ReskinCheck(LFDQueueFrameRoleButtonDPS:GetChildren())
		F.ReskinCheck(LFDQueueFrameRoleButtonLeader:GetChildren())
		F.ReskinCheck(LFRQueueFrameRoleButtonTank:GetChildren())
		F.ReskinCheck(LFRQueueFrameRoleButtonHealer:GetChildren())
		F.ReskinCheck(LFRQueueFrameRoleButtonDPS:GetChildren())
		F.ReskinCheck(LFDRoleCheckPopupRoleButtonTank:GetChildren())
		F.ReskinCheck(LFDRoleCheckPopupRoleButtonHealer:GetChildren())
		F.ReskinCheck(LFDRoleCheckPopupRoleButtonDPS:GetChildren())
		F.ReskinCheck(RaidFinderQueueFrameRoleButtonTank:GetChildren())
		F.ReskinCheck(RaidFinderQueueFrameRoleButtonHealer:GetChildren())
		F.ReskinCheck(RaidFinderQueueFrameRoleButtonDPS:GetChildren())
		F.ReskinCheck(RaidFinderQueueFrameRoleButtonLeader:GetChildren())
		F.ReskinCheck(LFGInvitePopupRoleButtonTank:GetChildren())
		F.ReskinCheck(LFGInvitePopupRoleButtonHealer:GetChildren())
		F.ReskinCheck(LFGInvitePopupRoleButtonDPS:GetChildren())
		
		-- [[ Radio buttons ]]

		local radiobuttons = {"ReportPlayerNameDialogPlayerNameCheckButton", "ReportPlayerNameDialogGuildNameCheckButton", "ReportPlayerNameDialogArenaTeamNameCheckButton"}
		for i = 1, #radiobuttons do
			local radiobutton = _G[radiobuttons[i]]
			if radiobutton then
				F.ReskinRadio(radiobutton)
			else
				print("Aurora: "..radiobuttons[i].." was not found.")
			end
		end
		
		-- [[ Backdrop frames ]]
			
		S.SetBD(FriendsFrame)
		S.SetBD(QuestLogFrame, 6, -9, -2, 6)
		S.SetBD(QuestFrame, 6, -15, -26, 64)
		S.SetBD(QuestLogDetailFrame, 6, -9, 0, 0)
		S.SetBD(GossipFrame, 6, -15, -26, 64)
		S.SetBD(MerchantFrame, 10, -10, -34, 61)
		S.SetBD(MailFrame, 10, -12, -34, 74)
		S.SetBD(OpenMailFrame, 10, -12, -34, 74)
		S.SetBD(DressUpFrame, 10, -12, -34, 74)
		S.SetBD(TaxiFrame, 3, -23, -5, 3)
		S.SetBD(TradeFrame, 10, -12, -30, 52)
		S.SetBD(ItemTextFrame, 16, -8, -28, 62)
		S.SetBD(TabardFrame, 10, -12, -34, 74)
		S.SetBD(HelpFrame)
		S.SetBD(GuildRegistrarFrame, 6, -15, -26, 64)
		S.SetBD(PetitionFrame, 6, -15, -26, 64)
		S.SetBD(SpellBookFrame)
		S.SetBD(LFDParentFrame)
		S.SetBD(CharacterFrame)
		S.SetBD(PVPFrame)
		S.SetBD(PVPBannerFrame)
		S.SetBD(PetStableFrame)
		S.SetBD(WorldStateScoreFrame)
		S.SetBD(RaidParentFrame)

		local FrameBDs = {"StaticPopup1", "StaticPopup2", "GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "LFGDungeonReadyStatus", "ChatConfigFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "LFDRoleCheckPopup", "LFGDungeonReadyDialog", "RolePollPopup", "GuildInviteFrame", "ChannelFrameDaughterFrame", "LFGInvitePopup"}
		for i = 1, #FrameBDs do
			FrameBD = _G[FrameBDs[i]]
			S.CreateBD(FrameBD)
			S.CreateSD(FrameBD)
			--S.StripTextures(FrameBD)
			--S.SetBD(FrameBD)
		end

		NPCBD = CreateFrame("Frame", nil, QuestNPCModel)
		NPCBD:Point("TOPLEFT", 0, 1)
		NPCBD:Point("RIGHT", 1, 0)
		NPCBD:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
		NPCBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		S.CreateBD(NPCBD)

		local line = CreateFrame("Frame", nil, QuestNPCModel)
		line:Point("BOTTOMLEFT", 0, -1)
		line:Point("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		S.CreateBD(line, 0)

		LFGDungeonReadyDialog.SetBackdrop = F.dummy

		-- [[ Custom skins ]]

		-- Dropdown lists

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				local backdrop = _G["DropDownList"..i.."Backdrop"]
				if not backdrop.reskinned then
					S.CreateBD(menu)
					S.CreateBD(backdrop)
					backdrop.reskinned = true
				end
			end
		end)

		hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
			if not level then level = 1 end	
			
			local listFrame = _G["DropDownList"..level]
			
			if level == 1 then
				if not anchorName then
					listFrame:SetPoint("TOPLEFT", dropDownFrame, "BOTTOMLEFT", 16, 9)
				elseif anchorName ~= "cursor" then
					-- this part might be a bit unreliable
					local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
					if relPoint == "BOTTOMLEFT" and xOff == 0 and yOff == 5 then
						listFrame:Point("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
					end
				end
			else
				local point, anchor, relPoint = listFrame:GetPoint()
				if point:find("RIGHT") then
					listFrame:Point(point, anchor, relPoint, -14, 0)
				else
					listFrame:Point(point, anchor, relPoint, 9, 0)
				end
			end
		end)

		-- Pet stuff

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				PetStableFrame:DisableDrawLayer("BACKGROUND")
				PetStableFrame:DisableDrawLayer("BORDER")
				PetStableFrameInset:DisableDrawLayer("BACKGROUND")
				PetStableFrameInset:DisableDrawLayer("BORDER")
				PetStableBottomInset:DisableDrawLayer("BACKGROUND")
				PetStableBottomInset:DisableDrawLayer("BORDER")
				PetStableLeftInset:DisableDrawLayer("BACKGROUND")
				PetStableLeftInset:DisableDrawLayer("BORDER")
				PetStableFramePortrait:Hide()
				PetStableModelShadow:Hide()
				PetStableFramePortraitFrame:Hide()
				PetStableFrameTopBorder:Hide()
				PetStableFrameTopRightCorner:Hide()
				PetStableModelRotateLeftButton:Hide()
				PetStableModelRotateRightButton:Hide()

				S.ReskinClose(PetStableFrameCloseButton)
				F.ReskinArrow(PetStablePrevPageButton, 1)
				F.ReskinArrow(PetStableNextPageButton, 2)

				for i = 1, 10 do
					local bu = _G["PetStableStabledPet"..i]
					local bd = CreateFrame("Frame", nil, bu)
					bd:Point("TOPLEFT", -1, 1)
					bd:Point("BOTTOMRIGHT", 1, -1)
					S.CreateBD(bd, .25)
					bu:SetNormalTexture("")
					bu:DisableDrawLayer("BACKGROUND")
					_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				end
			end

			local function FixTab()
				if CharacterFrameTab2:IsShown() then
					CharacterFrameTab3:Point("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
				else
					CharacterFrameTab3:Point("LEFT", CharacterFrameTab1, "RIGHT", -15, 0)
				end
			end
			CharacterFrame:HookScript("OnEvent", FixTab)
			CharacterFrame:HookScript("OnShow", FixTab)

			PetModelFrameRotateLeftButton:Hide()
			PetModelFrameRotateRightButton:Hide()
			PetModelFrameShadowOverlay:Hide()
			PetPaperDollXPBar1:Hide()
			select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()
			PetPaperDollPetModelBg:SetAlpha(0)
			PetPaperDollFrameExpBar:SetStatusBarTexture(C.media.texture)

			local bbg = CreateFrame("Frame", nil, PetPaperDollFrameExpBar)
			bbg:Point("TOPLEFT", -1, 1)
			bbg:Point("BOTTOMRIGHT", 1, -1)
			bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
			S.CreateBD(bbg, .25)
		end

		-- Ghost frame

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:Point("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:Point("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		S.CreateBD(GhostBD, 0)

		-- Mail frame

		OpenMailLetterButton:SetNormalTexture("")
		OpenMailLetterButton:SetPushedTexture("")
		OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmail = CreateFrame("Frame", nil, OpenMailLetterButton)
		bgmail:Point("TOPLEFT", -1, 1)
		bgmail:Point("BOTTOMRIGHT", 1, -1)
		bgmail:SetFrameLevel(OpenMailLetterButton:GetFrameLevel()-1)
		S.CreateBD(bgmail)

		OpenMailMoneyButton:SetNormalTexture("")
		OpenMailMoneyButton:SetPushedTexture("")
		OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmoney = CreateFrame("Frame", nil, OpenMailMoneyButton)
		bgmoney:Point("TOPLEFT", -1, 1)
		bgmoney:Point("BOTTOMRIGHT", 1, -1)
		bgmoney:SetFrameLevel(OpenMailMoneyButton:GetFrameLevel()-1)
		S.CreateBD(bgmoney)

		for i = 1, INBOXITEMS_TO_DISPLAY do
			local it = _G["MailItem"..i]
			local bu = _G["MailItem"..i.."Button"]
			local st = _G["MailItem"..i.."ButtonSlot"]
			local ic = _G["MailItem"..i.."Button".."Icon"]
			local line = select(3, _G["MailItem"..i]:GetRegions())

			local a, b = it:GetRegions()
			a:Hide()
			b:Hide()

			bu:SetCheckedTexture(C.media.checked)

			st:Hide()
			line:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, 0)
		end

		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			button:GetRegions():Hide()

			local bg = CreateFrame("Frame", nil, button)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local bu = _G["OpenMailAttachmentButton"..i]
			local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		hooksecurefunc("SendMailFrame_Update", function()
			for i = 1, ATTACHMENTS_MAX_SEND do
				local button = _G["SendMailAttachment"..i]
				if button:GetNormalTexture() then
					button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				end
			end
		end)

		-- Currency frame

		TokenFrame:HookScript("OnShow", function()
			for i=1, GetCurrencyListSize() do
				local button = _G["TokenFrameContainerButton"..i]

				if button and not button.reskinned then
					button.highlight:Point("TOPLEFT", 1, 0)
					button.highlight:Point("BOTTOMRIGHT", -1, 0)
					button.highlight.SetPoint = F.dummy
					button.highlight:SetTexture(r, g, b, .2)
					button.highlight.SetTexture = F.dummy
					button.categoryMiddle:SetAlpha(0)	
					button.categoryLeft:SetAlpha(0)	
					button.categoryRight:SetAlpha(0)

					if button.icon and button.icon:GetTexture() then
						button.icon:SetTexCoord(.08, .92, .08, .92)
						S.CreateBG(button.icon)
					end
					button.reskinned = true
				end
			end
		end)

		-- Reputation frame

		local function UpdateFactionSkins()
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(C.media.backdrop)

					if not statusbar.reskinned then
						S.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end		
			end		
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

		for i = 1, NUM_FACTIONS_DISPLAYED do
			local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			F.ReskinExpandOrCollapse(bu)
		end

		hooksecurefunc("ReputationFrame_Update", function()
			local numFactions = GetNumFactions()
			local factionIndex, factionButton, isCollapsed
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

			for i = 1, NUM_FACTIONS_DISPLAYED do
				factionIndex = factionOffset + i
				factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

				if factionIndex <= numFactions then
					_, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
					if isCollapsed then
						factionButton.plus:Show()
					else
						factionButton.plus:Hide()
					end
				end
			end
		end)

		-- LFD frame

		LFDQueueFrameCapBarProgress:SetTexture(C.media.backdrop)
		LFDQueueFrameCapBarCap1:SetTexture(C.media.backdrop)
		LFDQueueFrameCapBarCap2:SetTexture(C.media.backdrop)

		LFDQueueFrameCapBarLeft:Hide()
		LFDQueueFrameCapBarMiddle:Hide()
		LFDQueueFrameCapBarRight:Hide()
		LFDQueueFrameCapBarBG:SetTexture(nil)

		LFDQueueFrameCapBar.backdrop = CreateFrame("Frame", nil, LFDQueueFrameCapBar)
		LFDQueueFrameCapBar.backdrop:Point("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -2)
		LFDQueueFrameCapBar.backdrop:Point("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", 1, 2)
		LFDQueueFrameCapBar.backdrop:SetFrameLevel(0)
		S.CreateBD(LFDQueueFrameCapBar.backdrop)

		for i = 1, 2 do
			local bu = _G["LFDQueueFrameCapBarCap"..i.."Marker"]
			_G["LFDQueueFrameCapBarCap"..i.."MarkerTexture"]:Hide()

			local cap = bu:CreateTexture(nil, "OVERLAY")
			cap:Size(1, 14)
			cap:SetPoint("CENTER")
			cap:SetTexture(C.media.backdrop)
			cap:SetVertexColor(0, 0, 0)
		end

		LFDQueueFrameRandomScrollFrame:SetWidth(304)

		local function ReskinRewards()
			for i = 1, LFD_MAX_REWARDS do
				local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
				local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]

				if button then
					icon:SetTexCoord(.08, .92, .08, .92)
					if not button.reskinned then
						local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
						local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
						local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

						S.CreateBG(icon)
						icon:SetDrawLayer("OVERLAY")
						count:SetDrawLayer("OVERLAY")
						na:SetTexture(0, 0, 0, .25)
						na:Size(118, 39)
						cta:SetAlpha(0)

						button.bg2 = CreateFrame("Frame", nil, button)
						button.bg2:Point("TOPLEFT", na, "TOPLEFT", 10, 0)
						button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
						S.CreateBD(button.bg2, 0)

						button.reskinned = true
					end
				end
			end
		end

		hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", ReskinRewards)

		for i = 1, NUM_LFD_CHOICE_BUTTONS do
			F.ReskinCheck(_G["LFDQueueFrameSpecificListButton"..i.."EnableButton"])
			F.ReskinExpandOrCollapse(_G["LFDQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"])
		end

		for i = 1, NUM_LFR_CHOICE_BUTTONS do
			local bu = _G["LFRQueueFrameSpecificListButton"..i.."EnableButton"]
			F.ReskinCheck(bu)
			bu.SetNormalTexture = F.dummy
			bu.SetPushedTexture = F.dummy

			F.ReskinExpandOrCollapse(_G["LFRQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"])
		end

		hooksecurefunc("LFDQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
			local isCollapsed = LFGCollapseList[dungeonID]

			if isCollapsed then
				button.expandOrCollapseButton.plus:Show()
			else
				button.expandOrCollapseButton.plus:Hide()
			end
		end)

		hooksecurefunc("LFRQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
			local isCollapsed = LFGCollapseList[dungeonID]
			if isCollapsed then
				button.expandOrCollapseButton.plus:Show()
			else
				button.expandOrCollapseButton.plus:Hide()
			end
		end)

		-- Raid Finder

		for i = 1, 2 do
			local tab = _G["LFRParentFrameSideTab"..i]
			tab:GetRegions():Hide()
			tab:SetCheckedTexture(C.media.checked)
			if i == 1 then
				local a1, p, a2, x, y = tab:GetPoint()
				tab:SetPoint(a1, p, a2, x + 11, y)
			end
			S.CreateBG(tab)
			S.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]
			local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]

			if button then
				if not button.reskinned then
					local cta = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."NameFrame"]

					S.CreateBG(icon)
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture(0, 0, 0, .25)
					na:Size(118, 39)
					cta:SetAlpha(0)

					button.bg2 = CreateFrame("Frame", nil, button)
					button.bg2:Point("TOPLEFT", na, "TOPLEFT", 10, 0)
					button.bg2:Point("BOTTOMRIGHT", na, "BOTTOMRIGHT")
					S.CreateBD(button.bg2, 0)

					button.reskinned = true
				end
			end
		end

		RaidParentFrameTab2:Point("LEFT", RaidParentFrameTab1, "RIGHT", -15, 0)
		RaidParentFrameTab3:Point("LEFT", RaidParentFrameTab2, "RIGHT", -15, 0)

		-- Spellbook

		for i = 1, SPELLS_PER_PAGE do
			local bu = _G["SpellButton"..i]
			local ic = _G["SpellButton"..i.."IconTexture"]
			_G["SpellButton"..i.."Background"]:SetAlpha(0)
			_G["SpellButton"..i.."TextBackground"]:Hide()
			_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
			_G["SpellButton"..i.."UnlearnedSlotFrame"]:SetAlpha(0)
			_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

			bu:SetCheckedTexture("")
			bu:SetPushedTexture("")

			ic:SetTexCoord(.08, .92, .08, .92)

			ic.bg = S.CreateBG(bu)
		end

		hooksecurefunc("SpellButton_UpdateButton", function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			local subSpellString = _G[name.."SubSpellName"]

			subSpellString:SetTextColor(1, 1, 1)
			if slotType == "FUTURESPELL" then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel("player")) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end

			local ic = _G[name.."IconTexture"]
			if not ic.bg then return end
			if ic:IsShown() then
				ic.bg:Show()
			else
				ic.bg:Hide()
			end
		end)

		for i = 1, 5 do
			local tab = _G["SpellBookSkillLineTab"..i]
			tab:GetRegions():Hide()
			tab:SetCheckedTexture(C.media.checked)
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 11, y)
			S.CreateBG(tab)
			S.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			_G["SpellBookSkillLineTab"..i.."TabardIconFrame"]:SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		-- Professions

		local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

		for _, button in pairs(professions) do
			local bu = _G[button]
			bu.professionName:SetTextColor(1, 1, 1)
			bu.missingHeader:SetTextColor(1, 1, 1)
			bu.missingText:SetTextColor(1, 1, 1)

			bu.statusBar:SetHeight(13)
			bu.statusBar:SetStatusBarTexture(C.media.backdrop)
			bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
			bu.statusBar.rankText:SetPoint("CENTER")

			local _, p = bu.statusBar:GetPoint()
			bu.statusBar:Point("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

			_G[button.."StatusBarLeft"]:Hide()
			bu.statusBar.capRight:SetAlpha(0)
			_G[button.."StatusBarBGLeft"]:Hide()
			_G[button.."StatusBarBGMiddle"]:Hide()
			_G[button.."StatusBarBGRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bu.statusBar)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end

		local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

		for _, button in pairs(professionbuttons) do
			local icon = _G[button.."IconTexture"]
			local bu = _G[button]
			_G[button.."NameFrame"]:SetAlpha(0)

			bu:SetPushedTexture("")
			bu:SetCheckedTexture(C.media.checked)
			bu:GetHighlightTexture():Hide()

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				S.CreateBG(icon)
			end					
		end

		for i = 1, 2 do
			local bu = _G["PrimaryProfession"..i]
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT")
			bg:Point("BOTTOMRIGHT", 0, -4)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)
		end

		-- Mounts and pets

		for i = 1, NUM_COMPANIONS_PER_PAGE do
			_G["SpellBookCompanionButton"..i.."Background"]:Hide()
			_G["SpellBookCompanionButton"..i.."TextBackground"]:Hide()
			_G["SpellBookCompanionButton"..i.."ActiveTexture"]:SetTexture(C.media.checked)

			local bu = _G["SpellBookCompanionButton"..i]
			local ic = _G["SpellBookCompanionButton"..i.."IconTexture"]

			if ic then
				ic:SetTexCoord(.08, .92, .08, .92)

				bu.bd = CreateFrame("Frame", nil, bu)
				bu.bd:Point("TOPLEFT", ic, -1, 1)
				bu.bd:Point("BOTTOMRIGHT", ic, 1, -1)
				S.CreateBD(bu.bd, 0)

				bu:SetPushedTexture(nil)
				bu:SetCheckedTexture(nil)
			end
		end

		-- Merchant Frame

		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local button = _G["MerchantItem"..i]
			local bu = _G["MerchantItem"..i.."ItemButton"]
			local ic = _G["MerchantItem"..i.."ItemButtonIconTexture"]
			local mo = _G["MerchantItem"..i.."MoneyFrame"]

			_G["MerchantItem"..i.."SlotTexture"]:Hide()
			_G["MerchantItem"..i.."NameFrame"]:Hide()
			_G["MerchantItem"..i.."Name"]:SetHeight(20)
			local a1, p, a2= bu:GetPoint()
			bu:SetPoint(a1, p, a2, -2, -2)
			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:Size(40, 40)

			local a3, p2, a4, x, y = mo:GetPoint()
			mo:SetPoint(a3, p2, a4, x, y+2)

			S.CreateBD(bu, 0)

			button.bd = CreateFrame("Frame", nil, button)
			button.bd:Point("TOPLEFT", 39, 0)
			button.bd:SetPoint("BOTTOMRIGHT")
			button.bd:SetFrameLevel(0)
			S.CreateBD(button.bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:ClearAllPoints()
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			
			for j = 1, 3 do
				S.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
				_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end
		
		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
			local numMerchantItems = GetMerchantNumItems()
			for i = 1, MERCHANT_ITEMS_PER_PAGE do
				local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
				if index <= numMerchantItems then
					local name, texture, price, stackCount, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if extendedCost and (price <= 0) then
						_G["MerchantItem"..i.."AltCurrencyFrame"]:Point("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
					end
				end
			end					
		end)
		
		MerchantBuyBackItemSlotTexture:Hide()
		MerchantBuyBackItemNameFrame:Hide()
		MerchantBuyBackItemItemButton:SetNormalTexture("")
		MerchantBuyBackItemItemButton:SetPushedTexture("")

		S.CreateBD(MerchantBuyBackItemItemButton, 0)
		S.CreateBD(MerchantBuyBackItem, .25)

		MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
		MerchantBuyBackItemItemButtonIconTexture:Point("TOPLEFT", 1, -1)
		MerchantBuyBackItemItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)

		MerchantGuildBankRepairButton:SetPushedTexture("")
		S.CreateBG(MerchantGuildBankRepairButton)
		MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)

		MerchantRepairAllButton:SetPushedTexture("")
		S.CreateBG(MerchantRepairAllButton)
		MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)

		MerchantRepairItemButton:SetPushedTexture("")
		S.CreateBG(MerchantRepairItemButton)
		local ic = MerchantRepairItemButton:GetRegions():SetTexCoord(0.04, 0.24, 0.06, 0.5)

		hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
			for i = 1, MAX_MERCHANT_CURRENCIES do
				local bu = _G["MerchantToken"..i]
				if bu and not bu.reskinned then
					local ic = _G["MerchantToken"..i.."Icon"]
					local co = _G["MerchantToken"..i.."Count"]

					ic:SetTexCoord(.08, .92, .08, .92)
					ic:SetDrawLayer("OVERLAY")
					ic:Point("LEFT", co, "RIGHT", 2, 0)
					co:Point("TOPLEFT", bu, "TOPLEFT", -2, 0)

					S.CreateBG(ic)
					bu.reskinned = true
				end
			end
		end)

		-- Friends Frame

		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local ic = bu.gameIcon
			local inv = _G["FriendsFrameFriendsScrollFrameButton"..i.."TravelPassButton"]

			bu:SetHighlightTexture(C.media.backdrop)
			bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

			ic:Size(22, 22)
			ic:SetTexCoord(.15, .85, .15, .85)

			ic:ClearAllPoints()
			ic:Point("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
			ic.SetPoint = F.dummy

			inv:SetAlpha(0)
			inv:EnableMouse(false)
		end

		local function UpdateScroll()
			for i = 1, FRIENDS_TO_DISPLAY do
				local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
				if not bu.bg then
					bu.bg = CreateFrame("Frame", nil, bu)
					bu.bg:SetPoint("TOPLEFT", bu.gameIcon)
					bu.bg:SetPoint("BOTTOMRIGHT", bu.gameIcon)
					S.CreateBD(bu.bg, 0)
				end
				if bu.gameIcon:IsShown() then
					bu.bg:Show()
				else
					bu.bg:Hide()
				end
			end
		end

		hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
		FriendsFrameFriendsScrollFrame:HookScript("OnVerticalScroll", UpdateScroll)


		local whobg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
		whobg:SetPoint("TOPLEFT")
		whobg:Point("BOTTOMRIGHT", -1, 1)
		whobg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
		S.CreateBD(whobg, .25)

		FriendsTabHeaderSoRButtonIcon:SetTexCoord(.08, .92, .08, .92)
		local sorbg = CreateFrame("Frame", nil, FriendsTabHeaderSoRButton)
		sorbg:Point("TOPLEFT", -1, 1)
		sorbg:Point("BOTTOMRIGHT", 1, -1)
		S.CreateBD(sorbg, 0)

		-- Nav Bar

		local function navButtonFrameLevel(self)
			for i=1, #self.navList do
				local navButton = self.navList[i]
				local lastNav = self.navList[i-1]
				if navButton and lastNav then
					navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
					navButton:ClearAllPoints()
					navButton:Point("LEFT", lastNav, "RIGHT", 1, 0)
				end
			end			
		end

		hooksecurefunc("NavBar_AddButton", function(self, buttonData)
			local navButton = self.navList[#self.navList]


			if not navButton.skinned then
				S.Reskin(navButton)
				navButton:GetRegions():SetAlpha(0)
				select(2, navButton:GetRegions()):SetAlpha(0)
				select(3, navButton:GetRegions()):SetAlpha(0)

				navButton.skinned = true

				navButton:HookScript("OnClick", function()
					navButtonFrameLevel(self)
				end)
			end

			navButtonFrameLevel(self)
		end)

		-- Character frame

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Character"..slots[i].."Slot"]
			local ic = _G["Character"..slots[i].."SlotIconTexture"]
			_G["Character"..slots[i].."SlotFrame"]:Hide()

			slot:SetNormalTexture("")
			slot:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			slot.bg = S.CreateBG(slot)
		end

		select(10, CharacterMainHandSlot:GetRegions()):Hide()
		select(10, CharacterRangedSlot:GetRegions()):Hide()

		hooksecurefunc("PaperDollItemSlotButton_Update", function()
			for i = 1, #slots do
				local slot = _G["Character"..slots[i].."Slot"]
				local ic = _G["Character"..slots[i].."SlotIconTexture"]

				if GetInventoryItemLink("player", i) then
					ic:SetAlpha(1)
					slot.bg:SetAlpha(1)
				else
					ic:SetAlpha(0)
					slot.bg:SetAlpha(0)
				end
			end
		end)

		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]

			if i == 1 then
				for i = 1, 4 do
					local region = select(i, tab:GetRegions())
					region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					region.SetTexCoord = F.dummy
				end
			end

			tab.Highlight:SetTexture(r, g, b, .2)
			tab.Highlight:Point("TOPLEFT", 3, -4)
			tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
			tab.Hider:SetTexture(.3, .3, .3, .4)
			tab.TabBg:SetAlpha(0)

			select(2, tab:GetRegions()):ClearAllPoints()
			if i == 1 then
				select(2, tab:GetRegions()):Point("TOPLEFT", 3, -4)
				select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, 0)
			else
				select(2, tab:GetRegions()):Point("TOPLEFT", 2, -4)
				select(2, tab:GetRegions()):Point("BOTTOMRIGHT", -1, -1)
			end

			tab.bg = CreateFrame("Frame", nil, tab)
			tab.bg:Point("TOPLEFT", 2, -3)
			tab.bg:Point("BOTTOMRIGHT", 0, -1)
			tab.bg:SetFrameLevel(0)
			S.CreateBD(tab.bg)

			tab.Hider:Point("TOPLEFT", tab.bg, 1, -1)
			tab.Hider:Point("BOTTOMRIGHT", tab.bg, -1, 1)
		end

		for i = 1, NUM_GEARSET_ICONS_SHOWN do
			local bu = _G["GearManagerDialogPopupButton"..i]
			local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()
			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bu, .25)
		end

		local sets = false
		PaperDollSidebarTab3:HookScript("OnClick", function()
			if sets == false then
				for i = 1, 9 do
					local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
					local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
					local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

					bd:Hide()
					bd.Show = F.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					S.CreateBG(ic)
				end
				sets = true
			end
		end)

		EquipmentFlyoutFrameButtons:HookScript("OnShow", function(self)
			for i = 1, 10 do
				local bu = _G["EquipmentFlyoutFrameButton"..i]
				if bu and not bu.reskinned then
					bu:SetNormalTexture("")
					bu:SetPushedTexture("")
					S.CreateBG(bu)

					_G["EquipmentFlyoutFrameButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

					bu.reskinned = true
				end

			end
		end)

		-- Quest Frame

		QuestInfoSkillPointFrameIconTexture:Size(40, 40)
		QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
		bg:Point("TOPLEFT", -3, 0)
		bg:Point("BOTTOMRIGHT", -3, 0)
		bg:Lower()
		S.CreateBD(bg, .25)

		QuestInfoSkillPointFrameNameFrame:Hide()
		QuestInfoSkillPointFrameName:SetParent(bg)
		QuestInfoSkillPointFrameIconTexture:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBg:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBgGlow:SetParent(bg)
		QuestInfoSkillPointFramePoints:SetParent(bg)

		local line = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
		line:Size(1, 40)
		line:Point("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
		line:SetTexture(C.media.backdrop)
		line:SetVertexColor(0, 0, 0)

		local function clearHighlight()
			for i = 1, MAX_NUM_ITEMS do
				_G["QuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, point = self:GetPoint()
			point:SetBackdropColor(r, g, b, .2)
		end

		hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
		QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
		QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

		for i = 1, MAX_REQUIRED_ITEMS do
			local bu = _G["QuestProgressItem"..i]
			local ic = _G["QuestProgressItem"..i.."IconTexture"]
			local na = _G["QuestProgressItem"..i.."NameFrame"]
			local co = _G["QuestProgressItem"..i.."Count"]

			ic:Size(40, 40)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:Size(1, 40)
			line:Point("RIGHT", ic, 1, 0)
			S.CreateBD(line)
		end

		for i = 1, MAX_NUM_ITEMS do
			local bu = _G["QuestInfoItem"..i]
			local ic = _G["QuestInfoItem"..i.."IconTexture"]
			local na = _G["QuestInfoItem"..i.."NameFrame"]
			local co = _G["QuestInfoItem"..i.."Count"]

			ic:Point("TOPLEFT", 1, -1)
			ic:Size(39, 39)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			S.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:Size(1, 40)
			line:Point("RIGHT", ic, 1, 0)
			S.CreateBD(line)
		end

		local function updateQuest()
			local numEntries = GetNumQuestLogEntries()

			local buttons = QuestLogScrollFrame.buttons
			local numButtons = #buttons
			local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
			local questLogTitle, questIndex
			local isHeader, isCollapsed

			for i = 1, numButtons do
				questLogTitle = buttons[i]
				questIndex = i + scrollOffset

				if not questLogTitle.reskinned then
					questLogTitle.reskinned = true

					questLogTitle:SetNormalTexture("")
					questLogTitle.SetNormalTexture = F.dummy
					questLogTitle:SetPushedTexture("")
					questLogTitle:SetHighlightTexture("")
					questLogTitle.SetHighlightTexture = F.dummy

					questLogTitle.bg = CreateFrame("Frame", nil, questLogTitle)
					questLogTitle.bg:Size(13, 13)
					questLogTitle.bg:Point("LEFT", 4, 0)
					questLogTitle.bg:SetFrameLevel(questLogTitle:GetFrameLevel()-1)
					S.CreateBD(questLogTitle.bg, 0)	

					questLogTitle.tex = questLogTitle:CreateTexture(nil, "BACKGROUND")
					questLogTitle.tex:SetAllPoints(questLogTitle.bg)
					questLogTitle.tex:SetTexture(C.media.backdrop)
					questLogTitle.tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

					questLogTitle.minus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.minus:Size(7, 1)
					questLogTitle.minus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.minus:SetTexture(C.media.backdrop)
					questLogTitle.minus:SetVertexColor(1, 1, 1)

					questLogTitle.plus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.plus:Size(1, 7)
					questLogTitle.plus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.plus:SetTexture(C.media.backdrop)
					questLogTitle.plus:SetVertexColor(1, 1, 1)
				end

				if questIndex <= numEntries then
					_, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(questIndex)
					if isHeader then
						questLogTitle.bg:Show()
						questLogTitle.tex:Show()
						questLogTitle.minus:Show()
						if isCollapsed then
							questLogTitle.plus:Show()
						else
							questLogTitle.plus:Hide()
						end
					else
						questLogTitle.bg:Hide()
						questLogTitle.tex:Hide()
						questLogTitle.minus:Hide()
						questLogTitle.plus:Hide()
					end
				end
			end
		end

		hooksecurefunc("QuestLog_Update", updateQuest)
		QuestLogScrollFrame:HookScript("OnVerticalScroll", updateQuest)
		QuestLogScrollFrame:HookScript("OnMouseWheel", updateQuest)

		-- PVP Frame

		PVPTeamManagementFrameFlag2Header:SetAlpha(0)
		PVPTeamManagementFrameFlag3Header:SetAlpha(0)
		PVPTeamManagementFrameFlag5Header:SetAlpha(0)
		PVPTeamManagementFrameFlag2HeaderSelected:SetAlpha(0)
		PVPTeamManagementFrameFlag3HeaderSelected:SetAlpha(0)
		PVPTeamManagementFrameFlag5HeaderSelected:SetAlpha(0)
		PVPTeamManagementFrameFlag2Title:SetTextColor(1, 1, 1)
		PVPTeamManagementFrameFlag3Title:SetTextColor(1, 1, 1)
		PVPTeamManagementFrameFlag5Title:SetTextColor(1, 1, 1)
		PVPTeamManagementFrameFlag2Title.SetTextColor = F.dummy
		PVPTeamManagementFrameFlag3Title.SetTextColor = F.dummy
		PVPTeamManagementFrameFlag5Title.SetTextColor = F.dummy

		local pvpbg = CreateFrame("Frame", nil, PVPTeamManagementFrame)
		pvpbg:SetPoint("TOPLEFT", PVPTeamManagementFrameFlag2)
		pvpbg:SetPoint("BOTTOMRIGHT", PVPTeamManagementFrameFlag5)
		S.CreateBD(pvpbg, .25)

		PVPFrameConquestBarLeft:Hide()
		PVPFrameConquestBarMiddle:Hide()
		PVPFrameConquestBarRight:Hide()
		PVPFrameConquestBarBG:Hide()
		PVPFrameConquestBarShadow:Hide()
		PVPFrameConquestBarCap1:SetAlpha(0)

		for i = 1, 4 do
			_G["PVPFrameConquestBarDivider"..i]:Hide()
		end

		PVPFrameConquestBarProgress:SetTexture(C.media.backdrop)
		PVPFrameConquestBarProgress:SetGradient("VERTICAL", .7, 0, 0, .8, 0, 0)

		local qbg = CreateFrame("Frame", nil, PVPFrameConquestBar)
		qbg:Point("TOPLEFT", -1, -2)
		qbg:Point("BOTTOMRIGHT", 1, 2)
		qbg:SetFrameLevel(PVPFrameConquestBar:GetFrameLevel()-1)
		S.CreateBD(qbg, .25)

		-- StaticPopup

		for i = 1, 2 do
			local bu = _G["StaticPopup"..i.."ItemFrame"]
			_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

			bu:SetNormalTexture("")
			S.CreateBG(bu)
		end

		-- PvP cap bar

		local function CaptureBar()
			if not NUM_EXTENDED_UI_FRAMES then return end
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				local barname = "WorldStateCaptureBar"..i
				local bar = _G[barname]

				if bar and bar:IsVisible() then
					bar:ClearAllPoints()
					bar:Point("TOP", UIParent, "TOP", 0, -120)
					if not bar.skinned then
						local left = _G[barname.."LeftBar"]
						local right = _G[barname.."RightBar"]
						local middle = _G[barname.."MiddleBar"]

						left:SetTexture(C.media.backdrop)
						right:SetTexture(C.media.backdrop)
						middle:SetTexture(C.media.backdrop)
						left:SetDrawLayer("BORDER")
						middle:SetDrawLayer("ARTWORK")
						right:SetDrawLayer("BORDER")

						left:SetGradient("VERTICAL", .1, .4, .9, .2, .6, 1)
						right:SetGradient("VERTICAL", .7, .1, .1, .9, .2, .2)
						middle:SetGradient("VERTICAL", .8, .8, .8, 1, 1, 1)

						_G[barname.."RightLine"]:SetAlpha(0)
						_G[barname.."LeftLine"]:SetAlpha(0)
						select(4, bar:GetRegions()):Hide()
						_G[barname.."LeftIconHighlight"]:SetAlpha(0)
						_G[barname.."RightIconHighlight"]:SetAlpha(0)

						bar.bg = bar:CreateTexture(nil, "BACKGROUND")
						bar.bg:Point("TOPLEFT", left, -1, 1)
						bar.bg:Point("BOTTOMRIGHT", right, 1, -1)
						bar.bg:SetTexture(C.media.backdrop)
						bar.bg:SetVertexColor(0, 0, 0)

						bar.bgmiddle = CreateFrame("Frame", nil, bar)
						bar.bgmiddle:Point("TOPLEFT", middle, -1, 1)
						bar.bgmiddle:Point("BOTTOMRIGHT", middle, 1, -1)
						S.CreateBD(bar.bgmiddle, 0)

						bar.skinned = true
					end
				end
			end
		end

		hooksecurefunc("UIParent_ManageFramePositions", CaptureBar)
		-- Achievement popup

		hooksecurefunc("AchievementAlertFrame_FixAnchors", function()
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["AchievementAlertFrame"..i]

				if frame then			
					frame:SetAlpha(1)
					frame.SetAlpha = F.dummy

					if not frame.bg then
						frame.bg = CreateFrame("Frame", nil, frame)
						frame.bg:Point("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
						frame.bg:Point("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 8)
						frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
						S.CreateBD(frame.bg)
						
						frame:HookScript("OnEnter", function()
							S.CreateBD(frame.bg)
						end)
						frame:HookScript("OnShow", function()
							S.CreateBD(frame.bg)
						end)
					end

					_G["AchievementAlertFrame"..i.."Glow"]:Hide()
					_G["AchievementAlertFrame"..i.."Shine"]:Hide()
					_G["AchievementAlertFrame"..i.."Glow"].Show = F.dummy
					_G["AchievementAlertFrame"..i.."Shine"].Show = F.dummy

					_G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)

					_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
					_G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)

					_G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					_G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()	

					if not frame.iconreskinned then
						S.CreateBG(_G["AchievementAlertFrame"..i.."IconTexture"])
						frame.iconreskinned = true
					end
				end
			end
		end)
		-- Guild challenges

		local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
		challenge:Point("TOPLEFT", 8, -12)
		challenge:Point("BOTTOMRIGHT", -8, 13)
		challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
		S.CreateBD(challenge)
		S.CreateBG(GuildChallengeAlertFrameEmblemBackground)

		-- Dungeon completion rewards

		local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame1)
		bg:Point("TOPLEFT", 6, -14)
		bg:Point("BOTTOMRIGHT", -6, 6)
		bg:SetFrameLevel(DungeonCompletionAlertFrame1:GetFrameLevel()-1)
		S.CreateBD(bg)

		DungeonCompletionAlertFrame1DungeonTexture:SetDrawLayer("ARTWORK")
		DungeonCompletionAlertFrame1DungeonTexture:SetTexCoord(.02, .98, .02, .98)
		S.CreateBG(DungeonCompletionAlertFrame1DungeonTexture)

		DungeonCompletionAlertFrame1.dungeonArt1:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt2:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt3:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt4:SetAlpha(0)
		DungeonCompletionAlertFrame1.raidArt:SetAlpha(0)

		DungeonCompletionAlertFrame1.dungeonTexture:Point("BOTTOMLEFT", DungeonCompletionAlertFrame1, "BOTTOMLEFT", 13, 13)
		DungeonCompletionAlertFrame1.dungeonTexture.SetPoint = F.dummy

		hooksecurefunc("DungeonCompletionAlertFrame_ShowAlert", function()
			for i = 1, 3 do
				local bu = _G["DungeonCompletionAlertFrame1Reward"..i]
				if bu and not bu.reskinned then
					local ic = _G["DungeonCompletionAlertFrame1Reward"..i.."Texture"]
					_G["DungeonCompletionAlertFrame1Reward"..i.."Border"]:Hide()

					ic:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(ic)

					bu.rekinned = true
				end
			end
		end)

		-- Help frame

		for i = 1, 15 do
			local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
			bu:DisableDrawLayer("ARTWORK")
			S.CreateBD(bu, 0)

			S.CreateGradient(bu)
		end

		HelpFrameCharacterStuckHearthstone:Size(56, 56)
		S.CreateBG(HelpFrameCharacterStuckHearthstone)
		HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

		-- Option panels

		local options = false
		GameMenuButtonOptions:HookScript("OnClick", function()
			if options == true then return end
			options = true

			local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:Size(1, 512)
			line:Point("LEFT", 205, 30)
			line:SetTexture(1, 1, 1, .2)

			S.CreateBD(AudioOptionsSoundPanelPlayback, .25)
			S.CreateBD(AudioOptionsSoundPanelHardware, .25)
			S.CreateBD(AudioOptionsSoundPanelVolume, .25)
			S.CreateBD(AudioOptionsVoicePanelTalking, .25)
			S.CreateBD(AudioOptionsVoicePanelBinding, .25)
			S.CreateBD(AudioOptionsVoicePanelListening, .25)

			AudioOptionsSoundPanelPlaybackTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelHardwareTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelVolumeTitle:Point("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelTalkingTitle:Point("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelListeningTitle:Point("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

			local dropdowns = {"Graphics_DisplayModeDropDown", "Graphics_ResolutionDropDown", "Graphics_RefreshDropDown", "Graphics_PrimaryMonitorDropDown", "Graphics_MultiSampleDropDown", "Graphics_VerticalSyncDropDown", "Graphics_TextureResolutionDropDown", "Graphics_FilteringDropDown", "Graphics_ProjectedTexturesDropDown", "Graphics_ShadowsDropDown", "Graphics_LiquidDetailDropDown", "Graphics_SunshaftsDropDown", "Graphics_ParticleDensityDropDown", "Graphics_ViewDistanceDropDown", "Graphics_EnvironmentalDetailDropDown", "Graphics_GroundClutterDropDown", "Advanced_BufferingDropDown", "Advanced_LagDropDown", "Advanced_HardwareCursorDropDown", "InterfaceOptionsLanguagesPanelLocaleDropDown", "AudioOptionsSoundPanelHardwareDropDown", "AudioOptionsSoundPanelSoundChannelsDropDown", "AudioOptionsVoicePanelInputDeviceDropDown", "AudioOptionsVoicePanelChatModeDropDown", "AudioOptionsVoicePanelOutputDeviceDropDown"}
 
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end
			S.StripTextures(Graphics_MultiSampleDropDown)
			Graphics_RightQuality:GetRegions():Hide()
			Graphics_RightQuality:DisableDrawLayer("BORDER")

			local sliders = {"Graphics_Quality", "Advanced_UIScaleSlider", "Advanced_MaxFPSSlider", "Advanced_MaxFPSBKSlider", "Advanced_GammaSlider", "AudioOptionsSoundPanelSoundQuality", "AudioOptionsSoundPanelMasterVolume", "AudioOptionsSoundPanelSoundVolume", "AudioOptionsSoundPanelMusicVolume", "AudioOptionsSoundPanelAmbienceVolume", "AudioOptionsVoicePanelMicrophoneVolume", "AudioOptionsVoicePanelSpeakerVolume", "AudioOptionsVoicePanelSoundFade", "AudioOptionsVoicePanelMusicFade", "AudioOptionsVoicePanelAmbienceFade"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			Graphics_Quality.SetBackdrop = F.dummy

			local checkboxes = {"Advanced_UseUIScale", "Advanced_MaxFPSCheckBox", "Advanced_MaxFPSBKCheckBox", "Advanced_DesktopGamma", "NetworkOptionsPanelOptimizeSpeed", "NetworkOptionsPanelUseIPv6", "AudioOptionsSoundPanelEnableSound", "AudioOptionsSoundPanelSoundEffects", "AudioOptionsSoundPanelErrorSpeech", "AudioOptionsSoundPanelEmoteSounds", "AudioOptionsSoundPanelPetSounds", "AudioOptionsSoundPanelMusic", "AudioOptionsSoundPanelLoopMusic", "AudioOptionsSoundPanelAmbientSounds", "AudioOptionsSoundPanelSoundInBG", "AudioOptionsSoundPanelReverb", "AudioOptionsSoundPanelHRTF", "AudioOptionsSoundPanelEnableDSPs", "AudioOptionsSoundPanelUseHardware", "AudioOptionsVoicePanelEnableVoice", "AudioOptionsVoicePanelEnableMicrophone", "AudioOptionsVoicePanelPushToTalkSound"}
			for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			S.Reskin(RecordLoopbackSoundButton)
			S.Reskin(PlayLoopbackSoundButton)
			S.Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)
		end)

		local interface = false
		GameMenuButtonUIOptions:HookScript("OnClick", function()
			if interface == true then return end
			interface = true

			local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:Size(1, 536)
			line:Point("LEFT", 205, 18)
			line:SetTexture(1, 1, 1, .2)

			local checkboxes = {"InterfaceOptionsControlsPanelStickyTargeting", "InterfaceOptionsControlsPanelAutoDismount", "InterfaceOptionsControlsPanelAutoClearAFK", "InterfaceOptionsControlsPanelBlockTrades", "InterfaceOptionsControlsPanelBlockGuildInvites", "InterfaceOptionsControlsPanelLootAtMouse", "InterfaceOptionsControlsPanelAutoLootCorpse", "InterfaceOptionsControlsPanelInteractOnLeftClick", "InterfaceOptionsCombatPanelAttackOnAssist", "InterfaceOptionsCombatPanelStopAutoAttack", "InterfaceOptionsCombatPanelNameplateClassColors", "InterfaceOptionsCombatPanelTargetOfTarget", "InterfaceOptionsCombatPanelShowSpellAlerts", "InterfaceOptionsCombatPanelReducedLagTolerance", "InterfaceOptionsCombatPanelActionButtonUseKeyDown", "InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait", "InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates", "InterfaceOptionsCombatPanelAutoSelfCast", "InterfaceOptionsDisplayPanelShowCloak", "InterfaceOptionsDisplayPanelShowHelm", "InterfaceOptionsDisplayPanelShowAggroPercentage", "InterfaceOptionsDisplayPanelPlayAggroSounds", "InterfaceOptionsDisplayPanelDetailedLootInfo", "InterfaceOptionsDisplayPanelShowSpellPointsAvg", "InterfaceOptionsDisplayPanelemphasizeMySpellEffects", "InterfaceOptionsDisplayPanelShowFreeBagSpace", "InterfaceOptionsDisplayPanelCinematicSubtitles", "InterfaceOptionsDisplayPanelRotateMinimap", "InterfaceOptionsDisplayPanelScreenEdgeFlash", "InterfaceOptionsObjectivesPanelAutoQuestTracking", "InterfaceOptionsObjectivesPanelAutoQuestProgress", "InterfaceOptionsObjectivesPanelMapQuestDifficulty", "InterfaceOptionsObjectivesPanelWatchFrameWidth", "InterfaceOptionsSocialPanelProfanityFilter", "InterfaceOptionsSocialPanelSpamFilter", "InterfaceOptionsSocialPanelChatBubbles", "InterfaceOptionsSocialPanelPartyChat", "InterfaceOptionsSocialPanelChatHoverDelay", "InterfaceOptionsSocialPanelGuildMemberAlert", "InterfaceOptionsSocialPanelChatMouseScroll", "InterfaceOptionsActionBarsPanelBottomLeft", "InterfaceOptionsActionBarsPanelBottomRight", "InterfaceOptionsActionBarsPanelRight", "InterfaceOptionsActionBarsPanelRightTwo", "InterfaceOptionsActionBarsPanelLockActionBars", "InterfaceOptionsActionBarsPanelAlwaysShowActionBars", "InterfaceOptionsActionBarsPanelSecureAbilityToggle", "InterfaceOptionsNamesPanelMyName", "InterfaceOptionsNamesPanelFriendlyPlayerNames", "InterfaceOptionsNamesPanelFriendlyPets", "InterfaceOptionsNamesPanelFriendlyGuardians", "InterfaceOptionsNamesPanelFriendlyTotems", "InterfaceOptionsNamesPanelUnitNameplatesFriends", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems", "InterfaceOptionsNamesPanelGuilds", "InterfaceOptionsNamesPanelGuildTitles", "InterfaceOptionsNamesPanelTitles", "InterfaceOptionsNamesPanelNonCombatCreature", "InterfaceOptionsNamesPanelEnemyPlayerNames", "InterfaceOptionsNamesPanelEnemyPets", "InterfaceOptionsNamesPanelEnemyGuardians", "InterfaceOptionsNamesPanelEnemyTotems", "InterfaceOptionsNamesPanelUnitNameplatesEnemies", "InterfaceOptionsNamesPanelUnitNameplatesEnemyPets", "InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems", "InterfaceOptionsCombatTextPanelTargetDamage", "InterfaceOptionsCombatTextPanelPeriodicDamage", "InterfaceOptionsCombatTextPanelPetDamage", "InterfaceOptionsCombatTextPanelHealing", "InterfaceOptionsCombatTextPanelTargetEffects", "InterfaceOptionsCombatTextPanelOtherTargetEffects", "InterfaceOptionsCombatTextPanelEnableFCT", "InterfaceOptionsCombatTextPanelDodgeParryMiss", "InterfaceOptionsCombatTextPanelDamageReduction", "InterfaceOptionsCombatTextPanelRepChanges", "InterfaceOptionsCombatTextPanelReactiveAbilities", "InterfaceOptionsCombatTextPanelFriendlyHealerNames", "InterfaceOptionsCombatTextPanelCombatState", "InterfaceOptionsCombatTextPanelComboPoints", "InterfaceOptionsCombatTextPanelLowManaHealth", "InterfaceOptionsCombatTextPanelEnergyGains", "InterfaceOptionsCombatTextPanelPeriodicEnergyGains", "InterfaceOptionsCombatTextPanelHonorGains", "InterfaceOptionsCombatTextPanelAuras", "InterfaceOptionsStatusTextPanelPlayer", "InterfaceOptionsStatusTextPanelPet", "InterfaceOptionsStatusTextPanelParty", "InterfaceOptionsStatusTextPanelTarget", "InterfaceOptionsStatusTextPanelAlternateResource", "InterfaceOptionsStatusTextPanelPercentages", "InterfaceOptionsStatusTextPanelXP", "InterfaceOptionsUnitFramePanelPartyBackground", "InterfaceOptionsUnitFramePanelPartyPets", "InterfaceOptionsUnitFramePanelArenaEnemyFrames", "InterfaceOptionsUnitFramePanelArenaEnemyCastBar", "InterfaceOptionsUnitFramePanelArenaEnemyPets", "InterfaceOptionsUnitFramePanelFullSizeFocusFrame", "CompactUnitFrameProfilesRaidStylePartyFrames", "CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight", "CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder", "CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs", "CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP", "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE", "InterfaceOptionsBuffsPanelBuffDurations", "InterfaceOptionsBuffsPanelDispellableDebuffs", "InterfaceOptionsBuffsPanelCastableBuffs", "InterfaceOptionsBuffsPanelConsolidateBuffs", "InterfaceOptionsBuffsPanelShowAllEnemyDebuffs", "InterfaceOptionsBattlenetPanelOnlineFriends", "InterfaceOptionsBattlenetPanelOfflineFriends", "InterfaceOptionsBattlenetPanelBroadcasts", "InterfaceOptionsBattlenetPanelFriendRequests", "InterfaceOptionsBattlenetPanelConversations", "InterfaceOptionsBattlenetPanelShowToastWindow", "InterfaceOptionsCameraPanelFollowTerrain", "InterfaceOptionsCameraPanelHeadBob", "InterfaceOptionsCameraPanelWaterCollision", "InterfaceOptionsCameraPanelSmartPivot", "InterfaceOptionsMousePanelInvertMouse", "InterfaceOptionsMousePanelClickToMove", "InterfaceOptionsMousePanelWoWMouse", "InterfaceOptionsHelpPanelShowTutorials", "InterfaceOptionsHelpPanelLoadingScreenTips", "InterfaceOptionsHelpPanelEnhancedTooltips", "InterfaceOptionsHelpPanelBeginnerTooltips", "InterfaceOptionsHelpPanelShowLuaErrors", "InterfaceOptionsHelpPanelColorblindMode", "InterfaceOptionsHelpPanelMovePad"}
			for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			local dropdowns = {"InterfaceOptionsControlsPanelAutoLootKeyDropDown", "InterfaceOptionsCombatPanelTOTDropDown", "InterfaceOptionsCombatPanelFocusCastKeyDropDown", "InterfaceOptionsCombatPanelSelfCastKeyDropDown", "InterfaceOptionsDisplayPanelAggroWarningDisplay", "InterfaceOptionsDisplayPanelWorldPVPObjectiveDisplay", "InterfaceOptionsSocialPanelChatStyle", "InterfaceOptionsSocialPanelTimestamps", "InterfaceOptionsSocialPanelWhisperMode", "InterfaceOptionsSocialPanelBnWhisperMode", "InterfaceOptionsSocialPanelConversationMode", "InterfaceOptionsActionBarsPanelPickupActionKeyDropDown", "InterfaceOptionsNamesPanelNPCNamesDropDown", "InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown", "InterfaceOptionsCombatTextPanelFCTDropDown", "CompactUnitFrameProfilesProfileSelector", "CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown", "CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown", "InterfaceOptionsCameraPanelStyleDropDown", "InterfaceOptionsMousePanelClickMoveStyleDropDown"}
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end

			local sliders = {"InterfaceOptionsCombatPanelSpellAlertOpacitySlider", "InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset", "CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider", "CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider", "InterfaceOptionsBattlenetPanelToastDurationSlider", "InterfaceOptionsCameraPanelMaxDistanceSlider", "InterfaceOptionsCameraPanelFollowSpeedSlider", "InterfaceOptionsMousePanelMouseSensitivitySlider", "InterfaceOptionsMousePanelMouseLookSpeedSlider"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			S.Reskin(CompactUnitFrameProfilesSaveButton)
			S.Reskin(CompactUnitFrameProfilesDeleteButton)
			S.Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
			S.Reskin(InterfaceOptionsHelpPanelResetTutorials)

			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
		end)

		-- SideDressUp

		SideDressUpModel:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:Point("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
		end)

		SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
		SideDressUpModel.bg:Point("TOPLEFT", 0, 1)
		SideDressUpModel.bg:Point("BOTTOMRIGHT", 1, -1)
		SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
		S.CreateBD(SideDressUpModel.bg)

		-- Trade Frame

		for i = 1, MAX_TRADE_ITEMS do
			local bu1 = _G["TradePlayerItem"..i.."ItemButton"]
			local bu2 = _G["TradeRecipientItem"..i.."ItemButton"]

			_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
			_G["TradePlayerItem"..i.."NameFrame"]:Hide()
			_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
			_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

			bu1:SetNormalTexture("")
			bu1:SetPushedTexture("")
			bu1.icon:SetTexCoord(.08, .92, .08, .92)
			bu2:SetNormalTexture("")
			bu2:SetPushedTexture("")
			bu2.icon:SetTexCoord(.08, .92, .08, .92)

			local bg1 = CreateFrame("Frame", nil, bu1)
			bg1:Point("TOPLEFT", -1, 1)
			bg1:Point("BOTTOMRIGHT", 1, -1)
			bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
			S.CreateBD(bg1, .25)

			local bg2 = CreateFrame("Frame", nil, bu2)
			bg2:Point("TOPLEFT", -1, 1)
			bg2:Point("BOTTOMRIGHT", 1, -1)
			bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
			S.CreateBD(bg2, .25)
		end

		select(4, TradePlayerItem7:GetRegions()):Hide()
		select(4, TradeRecipientItem7:GetRegions()):Hide()

		TradePlayerInputMoneyFrameSilver:Point("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
		TradePlayerInputMoneyFrameCopper:Point("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

		-- [[ Hide regions ]]

		local bglayers = {"FriendsFrame", "SpellBookFrame", "LFDParentFrame", "LFDParentFrameInset", "WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4", "RaidInfoInstanceLabel", "RaidInfoIDLabel", "CharacterFrame", "CharacterFrameInset", "CharacterFrameInsetRight", "GossipFrameGreetingPanel", "PVPFrame", "PVPFrameInset", "PVPFrameTopInset", "PVPTeamManagementFrame", "PVPTeamManagementFrameHeader1", "PVPTeamManagementFrameHeader2", "PVPTeamManagementFrameHeader3", "PVPTeamManagementFrameHeader4", "PVPBannerFrame", "PVPBannerFrameInset", "LFRQueueFrame", "LFRBrowseFrame", "HelpFrameMainInset", "CharacterModelFrame", "HelpFrame", "HelpFrameLeftInset", "QuestFrameDetailPanel", "QuestFrameProgressPanel", "QuestFrameRewardPanel", "WorldStateScoreFrame", "WorldStateScoreFrameInset", "QuestFrameGreetingPanel", "EquipmentFlyoutFrameButtons", "EmptyQuestLogFrame", "VideoOptionsFrameCategoryFrame", "InterfaceOptionsFrameCategories", "InterfaceOptionsFrameAddOns", "RaidParentFrame"}
		for i = 1, #bglayers do
			_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
		end
		local borderlayers = {"FriendsFrame", "FriendsFrameInset", "WhoFrameListInset", "WhoFrameEditBoxInset", "ChannelFrameLeftInset", "ChannelFrameRightInset", "SpellBookFrame", "SpellBookFrameInset", "LFDParentFrame", "LFDParentFrameInset", "CharacterFrame", "CharacterFrameInset", "CharacterFrameInsetRight", "MerchantFrame", "PVPFrame", "PVPFrameInset", "PVPConquestFrameInfoButton", "PVPFrameTopInset", "PVPTeamManagementFrame", "PVPBannerFrame", "PVPBannerFrameInset", "TabardFrame", "QuestLogDetailFrame", "HelpFrame", "HelpFrameLeftInset", "HelpFrameMainInset", "TaxiFrame", "ItemTextFrame", "CharacterModelFrame", "OpenMailFrame", "WorldStateScoreFrame", "WorldStateScoreFrameInset", "VideoOptionsFramePanelContainer", "InterfaceOptionsFramePanelContainer", "QuestFrameDetailPanel", "QuestFrameRewardPanel", "RaidParentFrame", "RaidParentFrameInset", "RaidFinderFrameRoleInset", "LFRQueueFrameRoleInset", "LFRQueueFrameListInset", "LFRQueueFrameCommentInset"}
		for i = 1, #borderlayers do
			_G[borderlayers[i]]:DisableDrawLayer("BORDER")
		end
		local overlayers = {"SpellBookFrame", "LFDParentFrame", "CharacterModelFrame", "MerchantFrame", "TaxiFrame"}
		for i = 1, #overlayers do
			_G[overlayers[i]]:DisableDrawLayer("OVERLAY")
		end
		local artlayers = {"GossipFrameGreetingPanel", "PVPConquestFrame", "TabardFrame", "GuildRegistrarFrame", "QuestLogDetailFrame", "EquipmentFlyoutFrameButtons"}
		for i = 1, #artlayers do
			_G[artlayers[i]]:DisableDrawLayer("ARTWORK")
		end
		CharacterFramePortrait:Hide()
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
			for j = 1, 2 do
				select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
			end
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFramePortrait:Hide()
		GossipFramePortrait:Hide()
		for i = 1, 6 do
			_G["HelpFrameButton"..i.."Selected"]:SetAlpha(0)
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = F.dummy
			end
		end
		HelpFrameButton16Selected:SetAlpha(0)
		SpellBookCompanionModelFrameShadowOverlay:Hide()
		PVPFramePortrait:Hide()
		PVPHonorFrameBGTex:Hide()
		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
			_G["TabardFrameCustomization"..i.."Left"]:Hide()
			_G["TabardFrameCustomization"..i.."Middle"]:Hide()
			_G["TabardFrameCustomization"..i.."Right"]:Hide()
		end
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		MerchantFramePortrait:Hide()
		DressUpFramePortrait:Hide()
		DressUpBackgroundTopLeft:Hide()
		DressUpBackgroundTopRight:Hide()
		DressUpBackgroundBotLeft:Hide()
		DressUpBackgroundBotRight:Hide()
		TradeFrameRecipientPortrait:Hide()
		TradeFramePlayerPortrait:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
			_G["LFDQueueFrameCapBarDivider"..i]:Hide()
			select(i, SideDressUpFrame:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		ItemTextScrollFrameMiddle:SetAlpha(0)
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		QuestNPCModelShadowOverlay:Hide()
		QuestNPCModelBg:Hide()
		QuestNPCModel:DisableDrawLayer("OVERLAY")
		QuestNPCModelNameText:SetDrawLayer("ARTWORK")
		QuestNPCModelTextFrameBg:Hide()
		QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
		TabardFramePortrait:Hide()
		LFDParentFrameEyeFrame:Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		RaidInfoFrameHeader:Hide()
		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
			select(i, FriendsFriendsNoteFrame:GetRegions()):Hide()
			select(i, AddFriendNoteFrame:GetRegions()):Hide()
			select(i, ReportPlayerNameDialogCommentFrame:GetRegions()):Hide()
			select(i, ReportCheatingDialogCommentFrame:GetRegions()):Hide()
		end
		PVPBannerFramePortrait:Hide()
		HelpFrameHeader:Hide()
		ReadyCheckPortrait:SetAlpha(0)
		select(2, ReadyCheckListenerFrame:GetRegions()):Hide()
		HelpFrameLeftInsetBg:Hide()
		LFDQueueFrameCapBarShadow:Hide()
		LFDQueueFrameBackground:Hide()
		select(3, HelpFrameReportBug:GetChildren()):Hide()
		select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
			select(i, TradeFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()
		select(5, HelpFrameGM_Response:GetChildren()):Hide()
		select(6, HelpFrameGM_Response:GetChildren()):Hide()

		select(2, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(3, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(4, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		PVPHonorFrameTypeScrollFrame:GetRegions():Hide()
		select(2, PVPHonorFrameTypeScrollFrame:GetRegions()):Hide()
		HelpFrameKnowledgebaseNavBarHomeButtonLeft:Hide()
		TokenFramePopupCorner:Hide()
		QuestNPCModelTextScrollFrameScrollBarThumbTexture.bg:Hide()
		GearManagerDialogPopupScrollFrame:GetRegions():Hide()
		select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
		for i = 1, 10 do
			select(i, GuildInviteFrame:GetRegions()):Hide()
		end
		CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
		CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
		InboxPrevPageButton:GetRegions():Hide()
		InboxNextPageButton:GetRegions():Hide()
		MerchantPrevPageButton:GetRegions():Hide()
		MerchantNextPageButton:GetRegions():Hide()
		select(2, MerchantPrevPageButton:GetRegions()):Hide()
		select(2, MerchantNextPageButton:GetRegions()):Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		SpellBookCompanionModelFrameRotateLeftButton:Hide()
		SpellBookCompanionModelFrameRotateRightButton:Hide()
		ItemTextPrevPageButton:GetRegions():Hide()
		ItemTextNextPageButton:GetRegions():Hide()
		GuildRegistrarFramePortrait:Hide()
		LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
		QuestLogFrameShowMapButton:Hide()
		QuestLogFrameShowMapButton.Show = F.dummy
		select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
		select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()
		ChannelFrameDaughterFrameCorner:Hide()
		PetitionFramePortrait:Hide()
		LFDQueueFrameCancelButton_LeftSeparator:Hide()
		LFDQueueFrameFindGroupButton_RightSeparator:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
			_G["ChannelButton"..i]:SetNormalTexture("")
		end
		CharacterStatsPaneTop:Hide()
		CharacterStatsPaneBottom:Hide()
		hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)
		hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
			categoryFrame.BgTop:Hide()
			categoryFrame.BgMiddle:Hide()
			categoryFrame.BgBottom:Hide()
		end)
		CharacterFramePortraitFrame:Hide()
		CharacterFrameTopRightCorner:Hide()
		CharacterFrameTopBorder:Hide()
		local titles = false
		hooksecurefunc("PaperDollTitlesPane_Update", function()
			if titles == false then
				for i = 1, 17 do
					_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
				end
				titles = true
			end
		end)
		ReputationListScrollFrame:GetRegions():Hide()
		select(2, ReputationListScrollFrame:GetRegions()):Hide()
		select(3, ReputationDetailFrame:GetRegions()):Hide()
		MerchantNameText:SetDrawLayer("ARTWORK")
		BuybackFrameTopLeft:SetAlpha(0)
		BuybackFrameTopRight:SetAlpha(0)
		BuybackFrameBotLeft:SetAlpha(0)
		BuybackFrameBotRight:SetAlpha(0)
		SendScrollBarBackgroundTop:Hide()
		select(4, SendMailScrollFrame:GetRegions()):Hide()
		PVPFramePortraitFrame:Hide()
		PVPFrameTopBorder:Hide()
		PVPFrameTopRightCorner:Hide()
		PVPFrameLeftButton_RightSeparator:Hide()
		PVPFrameRightButton_LeftSeparator:Hide()
		PVPBannerFrameCustomizationBorder:Hide()
		PVPBannerFramePortraitFrame:Hide()
		PVPBannerFrameTopBorder:Hide()
		PVPBannerFrameTopRightCorner:Hide()
		PVPBannerFrameAcceptButton_RightSeparator:Hide()
		PVPBannerFrameCancelButton_LeftSeparator:Hide()
		for i = 7, 16 do
			select(i, TabardFrame:GetRegions()):Hide()
		end
		TabardFrameCustomizationBorder:Hide()
		select(2, GuildRegistrarGreetingFrame:GetRegions()):Hide()
		QuestLogDetailTitleText:SetDrawLayer("OVERLAY")
		SpellBookCompanionsModelFrame:Hide()
		for i = 1, 7 do
			_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
			_G["WarGamesFrameScrollFrameButton"..i.."WarGameBg"]:Hide()
		end
		HelpFrameKnowledgebaseTopTileStreaks:Hide()
		TaxiFrameBg:Hide()
		TaxiFrameTitleBg:Hide()
		for i = 2, 5 do
			select(i, DressUpFrame:GetRegions()):Hide()
			select(i, PetitionFrame:GetRegions()):Hide()
		end
		ItemTextScrollFrameTop:SetAlpha(0)
		ItemTextScrollFrameBottom:SetAlpha(0)
		ChannelFrameDaughterFrameTitlebar:Hide()
		OpenScrollBarBackgroundTop:Hide()
		select(2, OpenMailScrollFrame:GetRegions()):Hide()
		QuestLogDetailScrollFrameScrollBackgroundTopLeft:SetAlpha(0)
		QuestLogDetailScrollFrameScrollBackgroundBottomRight:SetAlpha(0)
		select(2, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(3, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(4, WarGamesFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		HelpFrameKnowledgebaseNavBar:GetRegions():Hide()
		MerchantFrameExtraCurrencyTex:Hide()
		WarGamesFrameBGTex:Hide()
		WarGamesFrameBarLeft:Hide()
		select(3, WarGamesFrame:GetRegions()):Hide()
		WarGameStartButton_RightSeparator:Hide()
		QuestLogFrameCompleteButton_LeftSeparator:Hide()
		QuestLogFrameCompleteButton_RightSeparator:Hide()
		WhoListScrollFrame:GetRegions():Hide()
		select(2, WhoListScrollFrame:GetRegions()):Hide()
		WorldStateScoreFrameTopLeftCorner:Hide()
		WorldStateScoreFrameTopBorder:Hide()
		WorldStateScoreFrameTopRightCorner:Hide()
		select(9, QuestFrameGreetingPanel:GetRegions()):Hide()
		QuestInfoItemHighlight:GetRegions():Hide()
		QuestInfoSpellObjectiveFrameNameFrame:Hide()
		select(2, GuildChallengeAlertFrame:GetRegions()):Hide()
		select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
		select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()
		LFGDungeonReadyDialogBackground:Hide()
		LFGDungeonReadyDialogBottomArt:Hide()
		LFGDungeonReadyDialogFiligree:Hide()
		InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
		for i = 1, 2 do
			_G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
		end
		ChannelRosterScrollFrameTop:SetAlpha(0)
		ChannelRosterScrollFrameBottom:SetAlpha(0)
		FriendsFrameTopRightCorner:Hide()
		FriendsFrameTopLeftCorner:Hide()
		FriendsFrameTopBorder:Hide()
		FriendsFramePortraitFrame:Hide()
		FriendsFrameIcon:Hide()
		FriendsFrameInsetBg:Hide()
		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		WhoFrameListInsetBg:Hide()
		WhoFrameEditBoxInsetBg:Hide()
		ChannelFrameLeftInsetBg:Hide()
		ChannelFrameRightInsetBg:Hide()
		RaidFinderQueueFrameBackground:Hide()
		RaidParentFrameInsetBg:Hide()
		RaidFinderFrameRoleInsetBg:Hide()
		RaidFinderFrameRoleBackground:Hide()
		RaidParentFramePortraitFrame:Hide()
		RaidParentFramePortrait:Hide()
		RaidParentFrameTopBorder:Hide()
		RaidParentFrameTopRightCorner:Hide()
		LFRQueueFrameRoleInsetBg:Hide()
		LFRQueueFrameListInsetBg:Hide()
		LFRQueueFrameCommentInsetBg:Hide()
		RaidFinderFrameFindRaidButton_RightSeparator:Hide()
		RaidFinderFrameCancelButton_LeftSeparator:Hide()
		select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
		IgnoreListFrameTop:Hide()
		IgnoreListFrameMiddle:Hide()
		IgnoreListFrameBottom:Hide()
		PendingListFrameTop:Hide()
		PendingListFrameMiddle:Hide()
		PendingListFrameBottom:Hide()
		MissingLootFrameCorner:Hide()
		ItemTextMaterialTopLeft:SetAlpha(0)
		ItemTextMaterialTopRight:SetAlpha(0)
		ItemTextMaterialBotLeft:SetAlpha(0)
		ItemTextMaterialBotRight:SetAlpha(0)

		ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)
		SpellBookPageText:SetTextColor(.8, .8, .8)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetShadowColor(0, 0, 0)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
		AvailableServicesText:SetTextColor(1, 1, 1)
		AvailableServicesText:SetShadowColor(0, 0, 0)
		PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
		PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
		PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
		PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetTextColor(1, 1, 1)
		QuestInfoTitleHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
		QuestInfoDescriptionHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
		QuestInfoObjectivesHeader.SetTextColor = F.dummy
		QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetTextColor(1, 1, 1)
		QuestInfoRewardsHeader.SetTextColor = F.dummy
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText.SetTextColor = F.dummy
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText.SetTextColor = F.dummy
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoGroupSize.SetTextColor = F.dummy
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardText.SetTextColor = F.dummy
		QuestInfoItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoItemChooseText.SetTextColor = F.dummy
		QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoItemReceiveText.SetTextColor = F.dummy
		QuestInfoSpellLearnText:SetTextColor(1, 1, 1)
		QuestInfoSpellLearnText.SetTextColor = F.dummy
		QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)
		QuestInfoXPFrameReceiveText.SetTextColor = F.dummy
		GossipGreetingText:SetTextColor(1, 1, 1)
		QuestProgressTitleText:SetTextColor(1, 1, 1)
		QuestProgressTitleText.SetTextColor = F.dummy
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressText.SetTextColor = F.dummy
		ItemTextPageText:SetTextColor(1, 1, 1)
		ItemTextPageText.SetTextColor = F.dummy
		GreetingText:SetTextColor(1, 1, 1)
		GreetingText.SetTextColor = F.dummy
		AvailableQuestsText:SetTextColor(1, 1, 1)
		AvailableQuestsText.SetTextColor = F.dummy
		AvailableQuestsText:SetShadowColor(0, 0, 0)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy
		CurrentQuestsText:SetTextColor(1, 1, 1)
		CurrentQuestsText.SetTextColor = F.dummy
		CurrentQuestsText:SetShadowColor(0, 0, 0)

		for i = 1, MAX_OBJECTIVES do
			local objective = _G["QuestInfoObjective"..i]
			objective:SetTextColor(1, 1, 1)
			objective.SetTextColor = F.dummy
		end

		hooksecurefunc("UpdateProfessionButton", function(self)
			self.spellString:SetTextColor(1, 1, 1);	
			self.subSpellString:SetTextColor(1, 1, 1)
		end)

		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetPrimaryTalentTree()
			local classDisplayName, class = UnitClass("player")
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or C.classcolours[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetTalentTabInfo(primaryTalentTree);
			end

			if (specName and specName ~= "") then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
			end
		end

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:Point("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
		ChatConfigFrameOkayButton:Point("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)
		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
		QuestLogFramePushQuestButton:SetWidth(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:Point("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)
		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:Point("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)
		RaidFrameConvertToRaidButton:ClearAllPoints()
		RaidFrameConvertToRaidButton:Point("TOPLEFT", RaidFrame, "TOPLEFT", 38, -35)
		ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
		PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
		GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 1, 0)
		DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
		SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
		OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
		OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
		HelpFrameReportBugScrollFrameScrollBar:Point("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameSubmitSuggestionScrollFrameScrollBar:Point("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameTicketScrollFrameScrollBar:Point("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame1ScrollBar:Point("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame2ScrollBar:Point("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
		RaidInfoFrame:Point("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
		CharacterFrameExpandButton:Point("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
		PVPTeamManagementFrameWeeklyDisplay:Point("RIGHT", PVPTeamManagementFrameWeeklyToggleRight, "LEFT", -2, 0)
		TabardCharacterModelRotateRightButton:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
		LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:Point("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
		LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:Point("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
		MerchantFrameTab2:Point("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
		GuildRegistrarFrameEditBox:SetHeight(20)
		SendMailMoneySilver:Point("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
		SendMailMoneyCopper:Point("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)
		StaticPopup1MoneyInputFrameSilver:Point("LEFT", StaticPopup1MoneyInputFrameGold, "RIGHT", 1, 0)
		StaticPopup1MoneyInputFrameCopper:Point("LEFT", StaticPopup1MoneyInputFrameSilver, "RIGHT", 1, 0)
		StaticPopup2MoneyInputFrameSilver:Point("LEFT", StaticPopup2MoneyInputFrameGold, "RIGHT", 1, 0)
		StaticPopup2MoneyInputFrameCopper:Point("LEFT", StaticPopup2MoneyInputFrameSilver, "RIGHT", 1, 0)
		WorldStateScoreFrameTab2:Point("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
		WorldStateScoreFrameTab3:Point("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)
		WhoFrameWhoButton:Point("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
		WhoFrameAddFriendButton:Point("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
		WarGameStartButton:ClearAllPoints()
		WarGameStartButton:Point("BOTTOMRIGHT", PVPFrame, "BOTTOMRIGHT", -4, 4)
		FriendsFrameTitleText:Point("TOP", FriendsFrame, "TOP", 0, -8)
		VideoOptionsFrameOkay:Point("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		InterfaceOptionsFrameOkay:Point("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		RaidFrameRaidInfoButton:Point("LEFT", RaidFrameConvertToRaidButton, "RIGHT", 67, 12)

		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
			local parent = parentFrame:GetName()
			if parent == "QuestLogFrame" or parent == "QuestLogDetailFrame" then
				QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x+4, y)
			else
				QuestNPCModel:Point("TOPLEFT", parentFrame, "TOPRIGHT", x+8, y)
			end
		end)

		local questlogcontrolpanel = function()
			local parent
			if QuestLogFrame:IsShown() then
				parent = QuestLogFrame
				QuestLogControlPanel:Point("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 6)
			elseif QuestLogDetailFrame:IsShown() then
				parent = QuestLogDetailFrame
				QuestLogControlPanel:Point("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 0)
			end
		end
		hooksecurefunc("QuestLogControlPanel_UpdatePosition", questlogcontrolpanel)

		-- [[ Tabs ]]

		for i = 1, 5 do
			F.CreateTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			F.CreateTab(_G["FriendsFrameTab"..i])
			F.CreateTab(_G["PVPFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				F.CreateTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 3 do
			F.CreateTab(_G["WorldStateScoreFrameTab"..i])
			F.CreateTab(_G["RaidParentFrameTab"..i])
		end

		for i = 1, 2 do
			F.CreateTab(_G["MerchantFrameTab"..i])
			F.CreateTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 3 do
				S.Reskin(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "GossipFrameGreetingGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "TradeFrameTradeButton", "TradeFrameCancelButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "TabardFrameAcceptButton", "TabardFrameCancelButton", "GameMenuButtonHelp", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "FriendsFrameAddFriendButton", "FriendsFrameSendMessageButton", "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "PVPFrameLeftButton", "PVPFrameRightButton", "WorldStateScoreFrameLeaveButton", "SpellBookCompanionSummonButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "FriendsFrameIgnorePlayerButton", "FriendsFrameUnsquelchButton", "LFGDungeonReadyDialogEnterDungeonButton", "LFGDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "PVPBannerFrameAcceptButton", "PVPColorPickerButton1", "PVPColorPickerButton2", "PVPColorPickerButton3", "HelpFrameButton1", "HelpFrameButton2", "HelpFrameButton3", "HelpFrameButton4", "HelpFrameButton5", "HelpFrameButton16", "HelpFrameButton6", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "RolePollPopupAcceptButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "GMChatOpenLog", "HelpFrameKnowledgebaseNavBarHomeButton", "AddFriendInfoFrameContinueButton", "GuildRegistrarFrameGoodbyeButton", "GuildRegistrarFramePurchaseButton", "GuildRegistrarFrameCancelButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameDaughterFrameCancelButton", "PetitionFrameSignButton", "PetitionFrameRequestButton", "PetitionFrameRenameButton", "PetitionFrameCancelButton", "QuestLogFrameCompleteButton", "WarGameStartButton", "PendingListInfoFrameContinueButton", "LFDQueueFrameNoLFDWhileLFRLeaveQueueButton", "InterfaceOptionsHelpPanelResetTutorials", "RaidFinderFrameFindRaidButton", "RaidFinderFrameCancelButton", "RaidFinderQueueFrameIneligibleFrameLeaveQueueButton", "SideDressUpModelResetButton", "LFGInvitePopupAcceptButton", "LFGInvitePopupDeclineButton", "RaidFinderQueueFramePartyBackfillBackfillButton", "RaidFinderQueueFramePartyBackfillNoBackfillButton", "ScrollOfResurrectionSelectionFrameAcceptButton", "ScrollOfResurrectionSelectionFrameCancelButton", "ScrollOfResurrectionFrameAcceptButton", "ScrollOfResurrectionFrameCancelButton", "HelpFrameReportBugSubmit", "HelpFrameSubmitSuggestionSubmit", "ReportPlayerNameDialogReportButton", "ReportPlayerNameDialogCancelButton", "ReportCheatingDialogReportButton", "ReportCheatingDialogCancelButton", "HelpFrameOpenTicketHelpItemRestoration"}
		for i = 1, #buttons do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				S.Reskin(reskinbutton)
			else
				print("Aurora: "..buttons[i].." was not found.")
			end
		end

		S.Reskin(select(6, PVPBannerFrame:GetChildren()))

		if IsAddOnLoaded("ACP") then S.Reskin(GameMenuButtonAddOns) end

		local closebuttons = {"LFDParentFrameCloseButton", "CharacterFrameCloseButton", "PVPFrameCloseButton", "SpellBookFrameCloseButton", "HelpFrameCloseButton", "PVPBannerFrameCloseButton", "RaidInfoCloseButton", "RolePollPopupCloseButton", "ItemRefCloseButton", "TokenFramePopupCloseButton", "ReputationDetailCloseButton", "ChannelFrameDaughterFrameDetailCloseButton", "WorldStateScoreFrameCloseButton", "LFGDungeonReadyStatusCloseButton", "RaidParentFrameCloseButton", "SideDressUpModelCloseButton", "FriendsFrameCloseButton", "MissingLootFramePassButton", "LFGDungeonReadyDialogCloseButton", "StaticPopup1CloseButton"}
		for i = 1, #closebuttons do
			local closebutton = _G[closebuttons[i]]
			S.ReskinClose(closebutton)
		end

		S.ReskinClose(QuestLogFrameCloseButton, "TOPRIGHT", QuestLogFrame, "TOPRIGHT", -7, -14)
		S.ReskinClose(QuestLogDetailFrameCloseButton, "TOPRIGHT", QuestLogDetailFrame, "TOPRIGHT", -5, -14)
		S.ReskinClose(TaxiFrameCloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -1, -1)
		S.ReskinClose(InboxCloseButton, "TOPRIGHT", MailFrame, "TOPRIGHT", -38, -16)
		S.ReskinClose(OpenMailCloseButton, "TOPRIGHT", OpenMailFrame, "TOPRIGHT", -38, -16)
		S.ReskinClose(GossipFrameCloseButton, "TOPRIGHT", GossipFrame, "TOPRIGHT", -30, -20)
		S.ReskinClose(MerchantFrameCloseButton, "TOPRIGHT", MerchantFrame, "TOPRIGHT", -38, -14)
		S.ReskinClose(QuestFrameCloseButton, "TOPRIGHT", QuestFrame, "TOPRIGHT", -30, -20)
		S.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
		S.ReskinClose(ItemTextCloseButton, "TOPRIGHT", ItemTextFrame, "TOPRIGHT", -32, -12)
		S.ReskinClose(GuildRegistrarFrameCloseButton, "TOPRIGHT", GuildRegistrarFrame, "TOPRIGHT", -30, -20)
		S.ReskinClose(TabardFrameCloseButton, "TOPRIGHT", TabardFrame, "TOPRIGHT", -38, -16)
		S.ReskinClose(PetitionFrameCloseButton, "TOPRIGHT", PetitionFrame, "TOPRIGHT", -30, -20)
		S.ReskinClose(TradeFrameCloseButton, "TOPRIGHT", TradeFrame, "TOPRIGHT", -34, -16)

	-- [[ Load on Demand Addons ]]

	elseif addon == "Blizzard_ArchaeologyUI" then
		S.SetBD(ArchaeologyFrame)
		S.Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
		S.Reskin(ArchaeologyFrameArtifactPageBackButton)
		ArchaeologyFramePortrait:Hide()
		ArchaeologyFrame:DisableDrawLayer("BACKGROUND")
		ArchaeologyFrame:DisableDrawLayer("BORDER")
		ArchaeologyFrame:DisableDrawLayer("OVERLAY")
		ArchaeologyFrameInset:DisableDrawLayer("BACKGROUND")
		ArchaeologyFrameInset:DisableDrawLayer("BORDER")
		ArchaeologyFrameSummaryPageTitle:SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPageTitle:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPageTitleTop:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPageTitleMid:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPagePageText:SetTextColor(1, 1, 1)

		for i = 1, 10 do
			_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
		end
		for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
			local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
			bu:GetRegions():Hide()
			select(2, bu:GetRegions()):Hide()
			select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
			select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
			local vline = CreateFrame("Frame", nil, bu)
			vline:Point("LEFT", 44, 0)
			vline:Size(1, 44)
			S.CreateBD(vline)
		end

		ArchaeologyFrameInfoButton:Point("TOPLEFT", 3, -3)

		F.ReskinDropDown(ArchaeologyFrameRaceFilter)
		S.ReskinClose(ArchaeologyFrameCloseButton)
		S.ReskinScroll(ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
		F.ReskinArrow(ArchaeologyFrameCompletedPagePrevPageButton, 1)
		F.ReskinArrow(ArchaeologyFrameCompletedPageNextPageButton, 2)
		ArchaeologyFrameCompletedPagePrevPageButtonIcon:Hide()
		ArchaeologyFrameCompletedPageNextPageButtonIcon:Hide()

		ArchaeologyFrameRankBarBorder:Hide()
		ArchaeologyFrameRankBarBackground:Hide()
		ArchaeologyFrameRankBarBar:SetTexture(C.media.backdrop)
		ArchaeologyFrameRankBarBar:SetGradient("VERTICAL", 0, .65, 0, 0, .75, 0)
		ArchaeologyFrameRankBar:SetHeight(14)
		S.CreateBD(ArchaeologyFrameRankBar, .25)

		ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
		local bar = select(3, ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetRegions())
		bar:SetTexture(C.media.backdrop)
		bar:SetGradient("VERTICAL", .65, .25, 0, .75, .35, .1)

		local bg = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPageSolveFrameStatusBar)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		S.CreateBD(bg, .25)

		ArchaeologyFrameArtifactPageIcon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(ArchaeologyFrameArtifactPageIcon)
	elseif addon == "Blizzard_AuctionUI" then
		S.SetBD(AuctionFrame, 2, -10, 0, 10)
		S.CreateBD(AuctionProgressFrame)

		AuctionProgressBar:SetStatusBarTexture(C.media.backdrop)
		local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
		ABBD:Point("TOPLEFT", -1, 1)
		ABBD:Point("BOTTOMRIGHT", 1, -1)
		ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
		S.CreateBD(ABBD, .25)

		AuctionProgressBarIcon:SetTexCoord(.08, .92, .08, .92)
		S.CreateBG(AuctionProgressBarIcon)

		AuctionProgressBarText:ClearAllPoints()
		AuctionProgressBarText:Point("CENTER", 0, 1)

		S.ReskinClose(AuctionProgressFrameCancelButton, "LEFT", AuctionProgressBar, "RIGHT", 4, 0)
		select(15, AuctionProgressFrameCancelButton:GetRegions()):Point("CENTER", 0, 2)

		AuctionFrame:DisableDrawLayer("ARTWORK")
		AuctionPortraitTexture:Hide()
		for i = 1, 4 do
			select(i, AuctionProgressFrame:GetRegions()):Hide()
		end
		AuctionProgressBarBorder:Hide()
		BrowseFilterScrollFrame:GetRegions():Hide()
		select(2, BrowseFilterScrollFrame:GetRegions()):Hide()
		BrowseScrollFrame:GetRegions():Hide()
		select(2, BrowseScrollFrame:GetRegions()):Hide()
		BidScrollFrame:GetRegions():Hide()
		select(2, BidScrollFrame:GetRegions()):Hide()
		AuctionsScrollFrame:GetRegions():Hide()
		select(2, AuctionsScrollFrame:GetRegions()):Hide()
		BrowseQualitySort:DisableDrawLayer("BACKGROUND")
		BrowseLevelSort:DisableDrawLayer("BACKGROUND")
		BrowseDurationSort:DisableDrawLayer("BACKGROUND")
		BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
		BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
		BidQualitySort:DisableDrawLayer("BACKGROUND")
		BidLevelSort:DisableDrawLayer("BACKGROUND")
		BidDurationSort:DisableDrawLayer("BACKGROUND")
		BidBuyoutSort:DisableDrawLayer("BACKGROUND")
		BidStatusSort:DisableDrawLayer("BACKGROUND")
		BidBidSort:DisableDrawLayer("BACKGROUND")
		AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
		AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
		AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
		AuctionsBidSort:DisableDrawLayer("BACKGROUND")

		for i = 1, NUM_FILTERS_TO_DISPLAY do
			_G["AuctionFilterButton"..i]:SetNormalTexture("")
		end

		for i = 1, 3 do
			F.CreateTab(_G["AuctionFrameTab"..i])
		end

		local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
		for i = 1, #abuttons do
			local reskinbutton = _G[abuttons[i]]
			if reskinbutton then
				S.Reskin(reskinbutton)
			end
		end

		BrowseCloseButton:ClearAllPoints()
		BrowseCloseButton:Point("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
		BrowseBuyoutButton:ClearAllPoints()
		BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
		BrowseBidButton:ClearAllPoints()
		BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
		BidBuyoutButton:ClearAllPoints()
		BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -1, 0)
		BidBidButton:ClearAllPoints()
		BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
		AuctionsCancelAuctionButton:ClearAllPoints()
		AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)

		-- Blizz needs to be more consistent

		BrowseBidPriceSilver:Point("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
		BrowseBidPriceCopper:Point("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
		BidBidPriceSilver:Point("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
		BidBidPriceCopper:Point("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
		StartPriceSilver:Point("LEFT", StartPriceGold, "RIGHT", 1, 0)
		StartPriceCopper:Point("LEFT", StartPriceSilver, "RIGHT", 1, 0)
		BuyoutPriceSilver:Point("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
		BuyoutPriceCopper:Point("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

		for i = 1, NUM_BROWSE_TO_DISPLAY do
			local bu = _G["BrowseButton"..i]
			local it = _G["BrowseButton"..i.."Item"]
			local ic = _G["BrowseButton"..i.."ItemIconTexture"]

			if bu and it then
				it:SetNormalTexture("")
				ic:SetTexCoord(.08, .92, .08, .92)

				S.CreateBG(it)

				_G["BrowseButton"..i.."Left"]:Hide()
				select(6, _G["BrowseButton"..i]:GetRegions()):Hide()
				_G["BrowseButton"..i.."Right"]:Hide()

				local bd = CreateFrame("Frame", nil, bu)
				bd:SetPoint("TOPLEFT")
				bd:Point("BOTTOMRIGHT", 0, 5)
				bd:SetFrameLevel(bu:GetFrameLevel()-1)
				S.CreateBD(bd, .25)

				bu:SetHighlightTexture(C.media.backdrop)
				local hl = bu:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .2)
				hl:ClearAllPoints()
				hl:Point("TOPLEFT", 0, -1)
				hl:Point("BOTTOMRIGHT", -1, 6)
			end
		end

		for i = 1, NUM_BIDS_TO_DISPLAY do
			local bu = _G["BidButton"..i]
			local it = _G["BidButton"..i.."Item"]
			local ic = _G["BidButton"..i.."ItemIconTexture"]

			it:SetNormalTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBG(it)

			_G["BidButton"..i.."Left"]:Hide()
			select(6, _G["BidButton"..i]:GetRegions()):Hide()
			_G["BidButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:Point("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bd, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:Point("TOPLEFT", 0, -1)
			hl:Point("BOTTOMRIGHT", -1, 6)
		end

		for i = 1, NUM_AUCTIONS_TO_DISPLAY do
			local bu = _G["AuctionsButton"..i]
			local it = _G["AuctionsButton"..i.."Item"]
			local ic = _G["AuctionsButton"..i.."ItemIconTexture"]

			it:SetNormalTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBG(it)

			_G["AuctionsButton"..i.."Left"]:Hide()
			select(5, _G["AuctionsButton"..i]:GetRegions()):Hide()
			_G["AuctionsButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:Point("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bd, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:Point("TOPLEFT", 0, -1)
			hl:Point("BOTTOMRIGHT", -1, 6)
		end

		local auctionhandler = CreateFrame("Frame")
		auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
		auctionhandler:SetScript("OnEvent", function()
			local _, _, _, _, _, _, _, _, _, _, _, _, _, AuctionsItemButtonIconTexture = AuctionsItemButton:GetRegions() -- blizzard, please name your textures
			if AuctionsItemButtonIconTexture then
				AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
				AuctionsItemButtonIconTexture:Point("TOPLEFT", 1, -1)
				AuctionsItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)
			end
		end)

		S.CreateBD(AuctionsItemButton, .25)
		local _, AuctionsItemButtonNameFrame = AuctionsItemButton:GetRegions()
		AuctionsItemButtonNameFrame:Hide()

		S.ReskinClose(AuctionFrameCloseButton, "TOPRIGHT", AuctionFrame, "TOPRIGHT", -4, -14)
		S.ReskinScroll(BrowseScrollFrameScrollBar)
		S.ReskinScroll(AuctionsScrollFrameScrollBar)
		S.ReskinScroll(BrowseFilterScrollFrameScrollBar)
		F.ReskinDropDown(PriceDropDown)
		F.ReskinDropDown(DurationDropDown)
		S.ReskinInput(BrowseName)
		F.ReskinArrow(BrowsePrevPageButton, 1)
		F.ReskinArrow(BrowseNextPageButton, 2)
		F.ReskinCheck(IsUsableCheckButton)
		F.ReskinCheck(ShowOnPlayerCheckButton)
		
		BrowsePrevPageButton:GetRegions():Point("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

		-- seriously, consistency
		BrowseDropDownLeft:SetAlpha(0)
		BrowseDropDownMiddle:SetAlpha(0)
		BrowseDropDownRight:SetAlpha(0)

		local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
		BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
		BrowseDropDownButton:Size(16, 16)
		S.Reskin(BrowseDropDownButton)

		local downtex = BrowseDropDownButton:CreateTexture(nil, "OVERLAY")
		downtex:SetTexture("Interface\\AddOns\\!SunUI\\media\\arrow-down-active")
		downtex:Size(8, 8)
		downtex:SetPoint("CENTER")
		downtex:SetVertexColor(1, 1, 1)

		local bg = CreateFrame("Frame", nil, BrowseDropDown)
		bg:Point("TOPLEFT", 16, -5)
		bg:Point("BOTTOMRIGHT", 109, 11)
		bg:SetFrameLevel(BrowseDropDown:GetFrameLevel(-1))
		S.CreateBD(bg, 0)

		S.CreateGradient(bg)

		local inputs = {"BrowseMinLevel", "BrowseMaxLevel", "BrowseBidPriceGold", "BrowseBidPriceSilver", "BrowseBidPriceCopper", "BidBidPriceGold", "BidBidPriceSilver", "BidBidPriceCopper", "StartPriceGold", "StartPriceSilver", "StartPriceCopper", "BuyoutPriceGold", "BuyoutPriceSilver", "BuyoutPriceCopper", "AuctionsStackSizeEntry", "AuctionsNumStacksEntry"}
		for i = 1, #inputs do
			S.ReskinInput(_G[inputs[i]])
		end
	elseif addon == "Blizzard_AchievementUI" then
		S.CreateBD(AchievementFrame)
		S.CreateSD(AchievementFrame)
		AchievementFrameCategories:SetBackdrop(nil)
		AchievementFrameSummary:SetBackdrop(nil)
		for i = 1, 17 do
			select(i, AchievementFrame:GetRegions()):Hide()
		end
		AchievementFrameSummaryBackground:Hide()
		AchievementFrameSummary:GetChildren():Hide()
		AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)
		for i = 1, 4 do
			select(i, AchievementFrameHeader:GetRegions()):Hide()
		end
		AchievementFrameHeaderRightDDLInset:SetAlpha(0)
		select(2, AchievementFrameAchievements:GetChildren()):Hide()
		AchievementFrameAchievementsBackground:Hide()
		select(3, AchievementFrameAchievements:GetRegions()):Hide()
		AchievementFrameStatsBG:Hide()
		AchievementFrameSummaryAchievementsHeaderHeader:Hide()
		AchievementFrameSummaryCategoriesHeaderTexture:Hide()
		select(3, AchievementFrameStats:GetChildren()):Hide()
		select(5, AchievementFrameComparison:GetChildren()):Hide()
		AchievementFrameComparisonHeaderBG:Hide()
		AchievementFrameComparisonHeaderPortrait:Hide()
		AchievementFrameComparisonHeaderPortraitBg:Hide()
		AchievementFrameComparisonBackground:Hide()
		AchievementFrameComparisonDark:SetAlpha(0)
		AchievementFrameComparisonSummaryPlayerBackground:Hide()
		AchievementFrameComparisonSummaryFriendBackground:Hide()
		
		local first = 1
		hooksecurefunc("AchievementFrameCategories_Update", function()
			if first == 1 then
				for i = 1, 19 do
					_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:Hide()
				end
				first = 0
			end
		end)

		AchievementFrameHeaderPoints:Point("TOP", AchievementFrame, "TOP", 0, -6)
		AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -98, 1)
		AchievementFrameFilterDropDownText:ClearAllPoints()
		AchievementFrameFilterDropDownText:Point("CENTER", -10, 1)

		AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(C.media.backdrop)
		AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
		AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
		AchievementFrameSummaryCategoriesStatusBarRight:Hide()
		AchievementFrameSummaryCategoriesStatusBarFillBar:Hide()
		AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
		AchievementFrameSummaryCategoriesStatusBarTitle:Point("LEFT", AchievementFrameSummaryCategoriesStatusBar, "LEFT", 6, 0)
		AchievementFrameSummaryCategoriesStatusBarText:Point("RIGHT", AchievementFrameSummaryCategoriesStatusBar, "RIGHT", -5, 0)

		local bg = CreateFrame("Frame", nil, AchievementFrameSummaryCategoriesStatusBar)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(AchievementFrameSummaryCategoriesStatusBar:GetFrameLevel()-1)
		S.CreateBD(bg, .25)
		
		for i = 1, 3 do
			local tab = _G["AchievementFrameTab"..i]
			if tab then
				F.CreateTab(tab)
			end
		end
		
		for i = 1, 7 do
			local bu = _G["AchievementFrameAchievementsContainerButton"..i]
			bu:DisableDrawLayer("BORDER")

			local bd = _G["AchievementFrameAchievementsContainerButton"..i.."Background"]

			bd:SetTexture(C.media.backdrop)
			bd:SetVertexColor(0, 0, 0, .25)

			local text = _G["AchievementFrameAchievementsContainerButton"..i.."Description"]
			text:SetTextColor(.9, .9, .9)
			text.SetTextColor = F.dummy
			text:SetShadowOffset(1, -1)
			text.SetShadowOffset = F.dummy

			_G["AchievementFrameAchievementsContainerButton"..i.."TitleBackground"]:Hide()
			_G["AchievementFrameAchievementsContainerButton"..i.."Glow"]:Hide()
			_G["AchievementFrameAchievementsContainerButton"..i.."RewardBackground"]:SetAlpha(0)
			_G["AchievementFrameAchievementsContainerButton"..i.."PlusMinus"]:SetAlpha(0)
			_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
			_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()
			_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
			_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 2, -2)
			bg:Point("BOTTOMRIGHT", -2, 2)
			S.CreateBD(bg, 0)

			local ic = _G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]
			ic:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(ic)
		end

		hooksecurefunc("AchievementObjectives_DisplayCriteria", function()
			for i = 1, 63 do
				local name = _G["AchievementFrameCriteria"..i.."Name"]
				if name and select(2, name:GetTextColor()) == 0 then
					name:SetTextColor(1, 1, 1)
				end
			end

			for i = 1, 28 do
				local bu = _G["AchievementFrameMeta"..i]
				if bu and select(2, bu.label:GetTextColor()) == 0 then
					bu.label:SetTextColor(1, 1, 1)
				end
			end
		end)

		hooksecurefunc("AchievementButton_GetProgressBar", function(index)
			local bar = _G["AchievementFrameProgressBar"..index]
			if not bar.reskinned then
				bar:SetStatusBarTexture(C.media.texture)

				_G["AchievementFrameProgressBar"..index.."BG"]:SetTexture(0, 0, 0, .25)
				_G["AchievementFrameProgressBar"..index.."BorderLeft"]:Hide()
				_G["AchievementFrameProgressBar"..index.."BorderCenter"]:Hide()
				_G["AchievementFrameProgressBar"..index.."BorderRight"]:Hide()

				local bg = CreateFrame("Frame", nil, bar)
				bg:Point("TOPLEFT", -1, 1)
				bg:Point("BOTTOMRIGHT", 1, -1)
				S.CreateBD(bg, 0)

				bar.reskinned = true
			end
		end)

		hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
			for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
				local bu = _G["AchievementFrameSummaryAchievement"..i]
				if not bu.reskinned then
					bu:DisableDrawLayer("BORDER")

					local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]

					bd:SetTexture(C.media.backdrop)
					bd:SetVertexColor(0, 0, 0, .25)

					_G["AchievementFrameSummaryAchievement"..i.."TitleBackground"]:Hide()
					_G["AchievementFrameSummaryAchievement"..i.."Glow"]:Hide()
					_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
					_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

					local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
					text:SetTextColor(.9, .9, .9)
					text.SetTextColor = F.dummy
					text:SetShadowOffset(1, -1)
					text.SetShadowOffset = F.dummy

					local bg = CreateFrame("Frame", nil, bu)
					bg:Point("TOPLEFT", 2, -2)
					bg:Point("BOTTOMRIGHT", -2, 2)
					S.CreateBD(bg, 0)

					local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
					ic:SetTexCoord(.08, .92, .08, .92)
					S.CreateBG(ic)

					bu.reskinned = true
				end
			end
		end)

		for i = 1, 8 do
			local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
			local bar = bu:GetStatusBarTexture()
			local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

			bu:SetStatusBarTexture(C.media.backdrop)
			bar:SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
			label:SetTextColor(1, 1, 1)
			label:Point("LEFT", bu, "LEFT", 6, 0)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
			
			_G["AchievementFrameSummaryCategoriesCategory"..i.."Left"]:Hide()
			_G["AchievementFrameSummaryCategoriesCategory"..i.."Middle"]:Hide()
			_G["AchievementFrameSummaryCategoriesCategory"..i.."Right"]:Hide()
			_G["AchievementFrameSummaryCategoriesCategory"..i.."FillBar"]:Hide()
			_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)
			_G["AchievementFrameSummaryCategoriesCategory"..i.."Text"]:Point("RIGHT", bu, "RIGHT", -5, 0)
		end

		for i = 1, 20 do
			_G["AchievementFrameStatsContainerButton"..i.."BG"]:Hide()
			_G["AchievementFrameStatsContainerButton"..i.."BG"].Show = F.dummy
			_G["AchievementFrameStatsContainerButton"..i.."HeaderLeft"]:SetAlpha(0)
			_G["AchievementFrameStatsContainerButton"..i.."HeaderMiddle"]:SetAlpha(0)
			_G["AchievementFrameStatsContainerButton"..i.."HeaderRight"]:SetAlpha(0)
		end
		
		AchievementFrameComparisonHeader:Point("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 39, 25)
		
		local headerbg = CreateFrame("Frame", nil, AchievementFrameComparisonHeader)
		headerbg:Point("TOPLEFT", 20, -20)
		headerbg:Point("BOTTOMRIGHT", -28, -5)
		headerbg:SetFrameLevel(AchievementFrameComparisonHeader:GetFrameLevel()-1)
		S.CreateBD(headerbg, .25)
		
		local summaries = {AchievementFrameComparisonSummaryPlayer, AchievementFrameComparisonSummaryFriend}
		
		for _, frame in pairs(summaries) do
			frame:SetBackdrop(nil)
			local bg = CreateFrame("Frame", nil, frame)
			bg:Point("TOPLEFT", 2, -2)
			bg:Point("BOTTOMRIGHT", -2, 0)
			bg:SetFrameLevel(frame:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end

		local bars = {AchievementFrameComparisonSummaryPlayerStatusBar, AchievementFrameComparisonSummaryFriendStatusBar}
		
		for _, bar in pairs(bars) do
			local name = bar:GetName()
			bar:SetStatusBarTexture(C.media.backdrop)
			bar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
			_G[name.."Left"]:Hide()
			_G[name.."Middle"]:Hide()
			_G[name.."Right"]:Hide()
			_G[name.."FillBar"]:Hide()
			_G[name.."Title"]:SetTextColor(1, 1, 1)
			_G[name.."Title"]:Point("LEFT", bar, "LEFT", 6, 0)
			_G[name.."Text"]:Point("RIGHT", bar, "RIGHT", -5, 0)
			
			local bg = CreateFrame("Frame", nil, bar)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bar:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end
		
		for i = 1, 9 do
			local buttons = {_G["AchievementFrameComparisonContainerButton"..i.."Player"], _G["AchievementFrameComparisonContainerButton"..i.."Friend"]}
			
			for _, button in pairs(buttons) do
				button:DisableDrawLayer("BORDER")
				local bg = CreateFrame("Frame", nil, button)
				bg:Point("TOPLEFT", 2, -3)
				bg:Point("BOTTOMRIGHT", -2, 2)
				S.CreateBD(bg, 0)
			end

			local bd = _G["AchievementFrameComparisonContainerButton"..i.."PlayerBackground"]
			bd:SetTexture(C.media.backdrop)
			bd:SetVertexColor(0, 0, 0, .25)
			
			local bd = _G["AchievementFrameComparisonContainerButton"..i.."FriendBackground"]
			bd:SetTexture(C.media.backdrop)
			bd:SetVertexColor(0, 0, 0, .25)

			local text = _G["AchievementFrameComparisonContainerButton"..i.."PlayerDescription"]
			text:SetTextColor(.9, .9, .9)
			text.SetTextColor = F.dummy
			text:SetShadowOffset(1, -1)
			text.SetShadowOffset = F.dummy

			_G["AchievementFrameComparisonContainerButton"..i.."PlayerTitleBackground"]:Hide()
			_G["AchievementFrameComparisonContainerButton"..i.."PlayerGlow"]:Hide()
			_G["AchievementFrameComparisonContainerButton"..i.."PlayerIconOverlay"]:Hide()
			_G["AchievementFrameComparisonContainerButton"..i.."FriendTitleBackground"]:Hide()
			_G["AchievementFrameComparisonContainerButton"..i.."FriendGlow"]:Hide()
			_G["AchievementFrameComparisonContainerButton"..i.."FriendIconOverlay"]:Hide()
			
			local ic = _G["AchievementFrameComparisonContainerButton"..i.."PlayerIconTexture"]
			ic:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(ic)
			
			local ic = _G["AchievementFrameComparisonContainerButton"..i.."FriendIconTexture"]
			ic:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(ic)
		end
		
		S.ReskinClose(AchievementFrameCloseButton)
		S.ReskinScroll(AchievementFrameAchievementsContainerScrollBar)
		S.ReskinScroll(AchievementFrameStatsContainerScrollBar)
		S.ReskinScroll(AchievementFrameCategoriesContainerScrollBar)
		S.ReskinScroll(AchievementFrameComparisonContainerScrollBar)
		F.ReskinDropDown(AchievementFrameFilterDropDown)
	elseif addon == "Blizzard_BarbershopUI" then
		S.SetBD(BarberShopFrame, 44, -75, -40, 44)
		BarberShopFrameBackground:Hide()
		BarberShopFrameMoneyFrame:GetRegions():Hide()
		S.Reskin(BarberShopFrameOkayButton)
		S.Reskin(BarberShopFrameCancelButton)
		S.Reskin(BarberShopFrameResetButton)
		F.ReskinArrow(BarberShopFrameSelector1Prev, 1)
		F.ReskinArrow(BarberShopFrameSelector1Next, 2)
		F.ReskinArrow(BarberShopFrameSelector2Prev, 1)
		F.ReskinArrow(BarberShopFrameSelector2Next, 2)
		F.ReskinArrow(BarberShopFrameSelector3Prev, 1)
		F.ReskinArrow(BarberShopFrameSelector3Next, 2)
	elseif addon == "Blizzard_BattlefieldMinimap" then
		S.SetBD(BattlefieldMinimap, -1, 1, -5, 3)
		BattlefieldMinimapCorner:Hide()
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCloseButton:Hide()
	elseif addon == "Blizzard_BindingUI" then
		S.SetBD(KeyBindingFrame, 2, 0, -38, 10)
		KeyBindingFrame:DisableDrawLayer("BACKGROUND")
		KeyBindingFrameOutputText:SetDrawLayer("OVERLAY")
		KeyBindingFrameHeader:SetTexture("")
		S.Reskin(KeyBindingFrameDefaultButton)
		S.Reskin(KeyBindingFrameUnbindButton)
		S.Reskin(KeyBindingFrameOkayButton)
		S.Reskin(KeyBindingFrameCancelButton)
		KeyBindingFrameOkayButton:ClearAllPoints()
		KeyBindingFrameOkayButton:Point("RIGHT", KeyBindingFrameCancelButton, "LEFT", -1, 0)
		KeyBindingFrameUnbindButton:ClearAllPoints()
		KeyBindingFrameUnbindButton:Point("RIGHT", KeyBindingFrameOkayButton, "LEFT", -1, 0)

		for i = 1, KEY_BINDINGS_DISPLAYED do
			local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
			local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]

			button2:Point("LEFT", button1, "RIGHT", 1, 0)
			S.Reskin(button1)
			S.Reskin(button2)
		end

		S.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)
		F.ReskinCheck(KeyBindingFrameCharacterButton)
	elseif addon == "Blizzard_Calendar" then
		CalendarFrame:DisableDrawLayer("BORDER")
		for i = 1, 9 do
			select(i, CalendarViewEventFrame:GetRegions()):Hide()
		end
		select(15, CalendarViewEventFrame:GetRegions()):Hide()
		
		for i = 1, 9 do
			select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, CalendarCreateEventTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
			select(i, CalendarMassInviteTitleFrame:GetRegions()):Hide()
		end
		for i = 1, 42 do
			_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
			local bu = _G["CalendarDayButton"..i]
			bu:DisableDrawLayer("BACKGROUND")
			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl.SetAlpha = F.dummy
			hl:Point("TOPLEFT", -1, 1)
			hl:SetPoint("BOTTOMRIGHT")
		end
		for i = 1, 7 do
			_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
		end
		CalendarViewEventDivider:Hide()
		CalendarCreateEventDivider:Hide()
		CalendarViewEventInviteList:GetRegions():Hide()
		CalendarViewEventDescriptionContainer:GetRegions():Hide()
		select(5, CalendarCreateEventCloseButton:GetRegions()):Hide()
		select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
		select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
		select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
		CalendarCreateEventBackground:Hide()
		CalendarCreateEventFrameButtonBackground:Hide()
		CalendarCreateEventMassInviteButtonBorder:Hide()
		CalendarCreateEventCreateButtonBorder:Hide()
		CalendarEventPickerTitleFrameBackgroundLeft:Hide()
		CalendarEventPickerTitleFrameBackgroundMiddle:Hide()
		CalendarEventPickerTitleFrameBackgroundRight:Hide()
		CalendarEventPickerFrameButtonBackground:Hide()
		CalendarEventPickerCloseButtonBorder:Hide()
		CalendarCreateEventRaidInviteButtonBorder:Hide()
		CalendarMonthBackground:SetAlpha(0)
		CalendarYearBackground:SetAlpha(0)
		CalendarFrameModalOverlay:SetAlpha(.25)
		CalendarViewHolidayInfoTexture:SetAlpha(0)
		CalendarTexturePickerTitleFrameBackgroundLeft:Hide()
		CalendarTexturePickerTitleFrameBackgroundMiddle:Hide()
		CalendarTexturePickerTitleFrameBackgroundRight:Hide()
		CalendarTexturePickerFrameButtonBackground:Hide()
		CalendarTexturePickerAcceptButtonBorder:Hide()
		CalendarTexturePickerCancelButtonBorder:Hide()
		CalendarClassTotalsButtonBackgroundTop:Hide()
		CalendarClassTotalsButtonBackgroundMiddle:Hide()
		CalendarClassTotalsButtonBackgroundBottom:Hide()
		CalendarFilterFrameLeft:Hide()
		CalendarFilterFrameMiddle:Hide()
		CalendarFilterFrameRight:Hide()
		CalendarMassInviteFrameDivider:Hide()

		S.SetBD(CalendarFrame, 12, 0, -9, 4)
		S.CreateBD(CalendarViewEventFrame)
		S.CreateBD(CalendarViewHolidayFrame)
		S.CreateBD(CalendarViewRaidFrame)
		S.CreateBD(CalendarCreateEventFrame)
		S.CreateBD(CalendarClassTotalsButton)
		S.CreateBD(CalendarTexturePickerFrame, .7)
		S.CreateBD(CalendarViewEventInviteList, .25)
		S.CreateBD(CalendarViewEventDescriptionContainer, .25)
		S.CreateBD(CalendarCreateEventInviteList, .25)
		S.CreateBD(CalendarCreateEventDescriptionContainer, .25)
		S.CreateBD(CalendarEventPickerFrame, .25)
		S.CreateBD(CalendarMassInviteFrame)
		
		CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)
		
		hooksecurefunc("CalendarFrame_SetToday", function()
			CalendarTodayFrame:SetAllPoints()
		end)
		
		CalendarTodayFrame:SetScript("OnUpdate", nil)
		CalendarTodayTextureGlow:Hide()
		CalendarTodayTexture:Hide()
		
		CalendarTodayFrame:SetBackdrop({
			edgeFile = C.media.backdrop,
			edgeSize = S.mult,
		})
		CalendarTodayFrame:SetBackdropBorderColor(r, g, b)

		for i, class in ipairs(CLASS_SORT_ORDER) do
			local bu = _G["CalendarClassButton"..i]
			bu:GetRegions():Hide()
			S.CreateBG(bu)

			local tcoords = CLASS_ICON_TCOORDS[class]
			local ic = bu:GetNormalTexture()
			ic:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
		end

		local bd = CreateFrame("Frame", nil, CalendarFilterFrame)
		bd:Point("TOPLEFT", 40, 0)
		bd:Point("BOTTOMRIGHT", -19, 0)
		bd:SetFrameLevel(CalendarFilterFrame:GetFrameLevel()-1)
		S.CreateBD(bd, 0)
		S.CreateGradient(bd)
		
		local downtex = CalendarFilterButton:CreateTexture(nil, "ARTWORK")
		downtex:SetTexture("Interface\\AddOns\\!SunUI\\Media\\arrow-down-active")
		downtex:Size(8, 8)
		downtex:SetPoint("CENTER")
		downtex:SetVertexColor(1, 1, 1)

		for i = 1, 6 do
			local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			vline:SetHeight(546)
			vline:SetWidth(1)
			vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
			S.CreateBD(vline)
		end
		for i = 1, 36, 7 do
			local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			hline:SetWidth(637)
			hline:SetHeight(1)
			hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
			S.CreateBD(hline)
		end
		
		if not(IsAddOnLoaded("CowTip") or IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("lolTip") or IsAddOnLoaded("StarTip") or IsAddOnLoaded("TipTop") or IsAddOnLoaded("SunUI_Tooltips")) then
			local tooltips = {CalendarContextMenu, CalendarInviteStatusContextMenu}

			for _, tooltip in pairs(tooltips) do
				tooltip:SetBackdrop(nil)
				local bg = CreateFrame("Frame", nil, tooltip)
				bg:Point("TOPLEFT", 2, -2)
				bg:Point("BOTTOMRIGHT", -1, 2)
				bg:SetFrameLevel(tooltip:GetFrameLevel()-1)
				S.CreateBD(bg)
			end
		end

		CalendarViewEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
		CalendarViewHolidayFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
		CalendarViewRaidFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
		CalendarCreateEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", -8, -24)
		CalendarCreateEventInviteButton:Point("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
		CalendarClassButton1:Point("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

		CalendarCreateEventHourDropDown:SetWidth(80)
		CalendarCreateEventMinuteDropDown:SetWidth(80)
		CalendarCreateEventAMPMDropDown:SetWidth(90)
		
		local line = CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
		line:Size(240, 1)
		line:Point("TOP", CalendarMassInviteFrame, "TOP", 0, -150)
		line:SetTexture(C.media.backdrop)
		line:SetVertexColor(0, 0, 0)
		
		CalendarMassInviteFrame:ClearAllPoints()
		CalendarMassInviteFrame:Point("BOTTOMLEFT", CalendarCreateEventCreateButton, "TOPRIGHT", 10, 0)
		
		CalendarTexturePickerFrame:ClearAllPoints()
		CalendarTexturePickerFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 311, -24)

		local cbuttons = {"CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton", "CalendarCreateEventMassInviteButton", "CalendarCreateEventCreateButton", "CalendarCreateEventInviteButton", "CalendarEventPickerCloseButton", "CalendarCreateEventRaidInviteButton", "CalendarTexturePickerAcceptButton", "CalendarTexturePickerCancelButton", "CalendarFilterButton"}
		for i = 1, #cbuttons do
			local cbutton = _G[cbuttons[i]]
			S.Reskin(cbutton)
		end

		S.ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -4)
		S.ReskinClose(CalendarCreateEventCloseButton)
		S.ReskinClose(CalendarViewEventCloseButton)
		S.ReskinClose(CalendarViewHolidayCloseButton)
		S.ReskinClose(CalendarViewRaidCloseButton)
		S.ReskinClose(CalendarMassInviteCloseButton)
		S.ReskinScroll(CalendarTexturePickerScrollBar)
		S.ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
		S.ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
		S.ReskinScroll(CalendarCreateEventInviteListScrollFrameScrollBar)
		F.ReskinDropDown(CalendarCreateEventTypeDropDown)
		F.ReskinDropDown(CalendarCreateEventHourDropDown)
		F.ReskinDropDown(CalendarCreateEventMinuteDropDown)
		F.ReskinDropDown(CalendarCreateEventAMPMDropDown)
		F.ReskinDropDown(CalendarMassInviteGuildRankMenu)
		S.ReskinInput(CalendarCreateEventTitleEdit)
		S.ReskinInput(CalendarCreateEventInviteEdit)
		S.ReskinInput(CalendarMassInviteGuildMinLevelEdit)
		S.ReskinInput(CalendarMassInviteGuildMaxLevelEdit)
		F.ReskinArrow(CalendarPrevMonthButton, 1)
		F.ReskinArrow(CalendarNextMonthButton, 2)
		CalendarPrevMonthButton:Size(19, 19)
		CalendarNextMonthButton:Size(19, 19)
		F.ReskinCheck(CalendarCreateEventLockEventCheck)
	elseif addon == "Blizzard_DebugTools" then
		ScriptErrorsFrame:SetScale(UIParent:GetScale())
		ScriptErrorsFrame:Size(386, 274)
		ScriptErrorsFrame:DisableDrawLayer("OVERLAY")
		ScriptErrorsFrameTitleBG:Hide()
		ScriptErrorsFrameDialogBG:Hide()
		S.CreateBD(ScriptErrorsFrame)
		S.CreateSD(ScriptErrorsFrame)

		FrameStackTooltip:SetScale(UIParent:GetScale())
		FrameStackTooltip:SetBackdrop(nil)

		local bg = CreateFrame("Frame", nil, FrameStackTooltip)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
		bg:SetFrameLevel(FrameStackTooltip:GetFrameLevel()-1)
		S.CreateBD(bg, .6)

		S.ReskinClose(ScriptErrorsFrameClose)
		S.ReskinScroll(ScriptErrorsFrameScrollFrameScrollBar)
		S.Reskin(select(4, ScriptErrorsFrame:GetChildren()))
		S.Reskin(select(5, ScriptErrorsFrame:GetChildren()))
		S.Reskin(select(6, ScriptErrorsFrame:GetChildren()))
	elseif addon == "Blizzard_EncounterJournal" then
		EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
		EncounterJournal:DisableDrawLayer("BORDER")
		EncounterJournalInset:DisableDrawLayer("BORDER")
		EncounterJournalNavBar:DisableDrawLayer("BORDER")
		EncounterJournalSearchResults:DisableDrawLayer("BORDER")
		EncounterJournal:DisableDrawLayer("OVERLAY")
		EncounterJournalInstanceSelectDungeonTab:DisableDrawLayer("OVERLAY")
		EncounterJournalInstanceSelectRaidTab:DisableDrawLayer("OVERLAY")

		EncounterJournalPortrait:Hide()
		EncounterJournalInstanceSelectBG:Hide()
		EncounterJournalNavBar:GetRegions():Hide()
		EncounterJournalNavBarOverlay:Hide()
		EncounterJournalBg:Hide() 
		EncounterJournalTitleBg:Hide()
		EncounterJournalInsetBg:Hide()
		EncounterJournalInstanceSelectDungeonTabMid:Hide()
		EncounterJournalInstanceSelectRaidTabMid:Hide()
		EncounterJournalNavBarHomeButtonLeft:Hide()
		for i = 8, 10 do
			select(i, EncounterJournalInstanceSelectDungeonTab:GetRegions()):SetAlpha(0)
			select(i, EncounterJournalInstanceSelectRaidTab:GetRegions()):SetAlpha(0)
		end
		EncounterJournalEncounterFrameModelFrameShadow:Hide()
		EncounterJournalEncounterFrameInfoDifficultyUpLeft:SetAlpha(0)
		EncounterJournalEncounterFrameInfoDifficultyUpRIGHT:SetAlpha(0)
		EncounterJournalEncounterFrameInfoDifficultyDownLeft:SetAlpha(0)
		EncounterJournalEncounterFrameInfoDifficultyDownRIGHT:SetAlpha(0)
		select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
		select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
		EncounterJournalEncounterFrameInfoLootScrollFrameFilterUpLeft:SetAlpha(0)
		EncounterJournalEncounterFrameInfoLootScrollFrameFilterUpRIGHT:SetAlpha(0)
		EncounterJournalEncounterFrameInfoLootScrollFrameFilterDownLeft:SetAlpha(0)
		EncounterJournalEncounterFrameInfoLootScrollFrameFilterDownRIGHT:SetAlpha(0)
		select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilter:GetRegions()):Hide()
		select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilter:GetRegions()):Hide()
		EncounterJournalSearchResultsBg:Hide()

		S.SetBD(EncounterJournal)
		S.CreateBD(EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame)
		S.CreateBD(EncounterJournalSearchResults, .75)

		EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoBossTab:Point("TOPRIGHT", EncounterJournalEncounterFrame, "TOPRIGHT", 75, 20)
		EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoLootTab:Point("TOP", EncounterJournalEncounterFrameInfoBossTab, "BOTTOM", 0, -4)

		EncounterJournalEncounterFrameInfoBossTab:SetScale(0.75)
		EncounterJournalEncounterFrameInfoLootTab:SetScale(0.75)

		EncounterJournalEncounterFrameInfoBossTab:SetBackdrop({
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = 1 / .75,
		})
		EncounterJournalEncounterFrameInfoBossTab:SetBackdropColor(0, 0, 0, alpha)
		EncounterJournalEncounterFrameInfoBossTab:SetBackdropBorderColor(0, 0, 0)

		EncounterJournalEncounterFrameInfoLootTab:SetBackdrop({
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = 1 / .75,
		})
		EncounterJournalEncounterFrameInfoLootTab:SetBackdropColor(0, 0, 0, alpha)
		EncounterJournalEncounterFrameInfoLootTab:SetBackdropBorderColor(0, 0, 0)

		EncounterJournalEncounterFrameInfoBossTab:SetNormalTexture(nil)
		EncounterJournalEncounterFrameInfoBossTab:SetPushedTexture(nil)
		EncounterJournalEncounterFrameInfoBossTab:SetDisabledTexture(nil)
		EncounterJournalEncounterFrameInfoBossTab:SetHighlightTexture(nil)

		EncounterJournalEncounterFrameInfoLootTab:SetNormalTexture(nil)
		EncounterJournalEncounterFrameInfoLootTab:SetPushedTexture(nil)
		EncounterJournalEncounterFrameInfoLootTab:SetDisabledTexture(nil)
		EncounterJournalEncounterFrameInfoLootTab:SetHighlightTexture(nil)

		for i = 1, 14 do
			local bu = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i] or _G["EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton"..i]

			if bu then
				bu:SetNormalTexture("")
				bu:SetHighlightTexture("")

				local bg = CreateFrame("Frame", nil, bu)
				bg:Point("TOPLEFT", 4, -4)
				bg:Point("BOTTOMRIGHT", -5, 3)
				S.CreateBD(bg, 0)
			end
		end

		local modelbg = CreateFrame("Frame", nil, EncounterJournalEncounterFrameModelFrame)
		modelbg:Point("TOPLEFT", -1, 1)
		modelbg:Point("BOTTOMRIGHT", 1, -1)
		modelbg:SetFrameLevel(EncounterJournalEncounterFrameModelFrame:GetFrameLevel()-1)
		S.CreateBD(modelbg, .25)

		EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(.9, .9, .9)
		EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetShadowOffset(1, -1)
		EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
		EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetShadowOffset(1, -1)
		EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			local bossIndex = 1;
			local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
			while bossID do
				local bossButton = _G["EncounterJournalBossButton"..bossIndex]

				if not bossButton.reskinned then
					bossButton.reskinned = true

					S.Reskin(bossButton, true)
					bossButton.text:SetTextColor(1, 1, 1)
					bossButton.text.SetTextColor = F.dummy
				end


				bossIndex = bossIndex + 1
				name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
			end
		end)

		hooksecurefunc("EncounterJournal_ToggleHeaders", function()
			for i = 1, 50 do 
				local name = "EncounterJournalInfoHeader"..i
				local header = _G[name]

				if header then

					if not header.button.bg then
						header.button.bg = header.button:CreateTexture(nil, "BACKGROUND")
						header.button.bg:Point("TOPLEFT", header.button.abilityIcon, -1, 1)
						header.button.bg:Point("BOTTOMRIGHT", header.button.abilityIcon, 1, -1)
						header.button.bg:SetTexture(C.media.backdrop)
						header.button.bg:SetVertexColor(0, 0, 0)
					end

					if header.button.abilityIcon:IsShown() then
						header.button.bg:Show()
					else
						header.button.bg:Hide()
					end

					if not header.reskinned then
						header.reskinned = true

						header.flashAnim.Play = F.dummy

						header.description:SetTextColor(1, 1, 1)
						header.description:SetShadowOffset(1, -1)
						header.button.title:SetTextColor(1, 1, 1)
						header.button.title.SetTextColor = F.dummy
						header.button.expandedIcon:SetTextColor(1, 1, 1)
						header.button.expandedIcon.SetTextColor = F.dummy
						header.descriptionBG:SetAlpha(0)
						header.descriptionBGBottom:SetAlpha(0)

						S.Reskin(header.button, true)

						header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)

						_G[name.."HeaderButtonELeftUp"]:SetAlpha(0)
						_G[name.."HeaderButtonERightUp"]:SetAlpha(0)
						_G[name.."HeaderButtonEMidUp"]:SetAlpha(0)
						_G[name.."HeaderButtonCLeftUp"]:SetAlpha(0)
						_G[name.."HeaderButtonCRightUp"]:SetAlpha(0)
						_G[name.."HeaderButtonCMidUp"]:SetAlpha(0)
						_G[name.."HeaderButtonELeftDown"]:SetAlpha(0)
						_G[name.."HeaderButtonERightDown"]:SetAlpha(0)
						_G[name.."HeaderButtonEMidDown"]:SetAlpha(0)
						_G[name.."HeaderButtonCLeftDown"]:SetAlpha(0)
						_G[name.."HeaderButtonCRightDown"]:SetAlpha(0)
						_G[name.."HeaderButtonCMidDown"]:SetAlpha(0)
						_G[name.."HeaderButtonHighlightLeft"]:Hide()
						_G[name.."HeaderButtonHighlightMid"]:Hide()
						_G[name.."HeaderButtonHighlightRight"]:Hide()
					end
				end
			end
		end)

		local items = EncounterJournal.encounter.info.lootScroll.buttons
		local item

		for i = 1, #items do
			item = items[i]

			item.boss:SetTextColor(1, 1, 1)
			item.slot:SetTextColor(1, 1, 1)
			item.armorType:SetTextColor(1, 1, 1)

			item.bossTexture:SetAlpha(0)
			item.bosslessTexture:SetAlpha(0)

			item.icon:Point("TOPLEFT", 3, -3)
			item.icon:SetTexCoord(.08, .92, .08, .92)
			item.icon:SetDrawLayer("OVERLAY")
			S.CreateBG(item.icon)

			local bg = CreateFrame("Frame", nil, item)
			bg:SetPoint("TOPLEFT")
			bg:Point("BOTTOMRIGHT", 0, 1)
			bg:SetFrameStrata("BACKGROUND")
			S.CreateBD(bg, 0)

			local tex = item:CreateTexture(nil, "BACKGROUND")
			tex:SetPoint("TOPLEFT")
			tex:Point("BOTTOMRIGHT", -1, 2)
			tex:SetTexture(C.media.backdrop)
			tex:SetVertexColor(0, 0, 0, .25)
		end

		hooksecurefunc("EncounterJournal_SearchUpdate", function()
			local results = EncounterJournal.searchResults.scrollFrame.buttons
			local result

			for i = 1, #results do
				results[i]:SetNormalTexture("")
			end
		end)

		S.Reskin(EncounterJournalNavBarHomeButton)
		S.Reskin(EncounterJournalInstanceSelectDungeonTab)
		S.Reskin(EncounterJournalInstanceSelectRaidTab)
		S.Reskin(EncounterJournalEncounterFrameInfoDifficulty)
		S.Reskin(EncounterJournalEncounterFrameInfoResetButton)
		S.Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilter)
		S.ReskinClose(EncounterJournalCloseButton)
		S.ReskinClose(EncounterJournalSearchResultsCloseButton)
		S.ReskinInput(EncounterJournalSearchBox)
		S.ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
		S.ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
		S.ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
		S.ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)
		S.ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)
	elseif addon == "Blizzard_GlyphUI" then
		GlyphFrameBackground:Hide()
		GlyphFrameSideInset:DisableDrawLayer("BACKGROUND")
		GlyphFrameSideInset:DisableDrawLayer("BORDER")
		GlyphFrameClearInfoFrameIcon:Point("TOPLEFT", 1, -1)
		GlyphFrameClearInfoFrameIcon:Point("BOTTOMRIGHT", -1, 1)
		S.CreateBD(GlyphFrameClearInfoFrame)
		GlyphFrameClearInfoFrameIcon:SetTexCoord(.08, .92, .08, .92)

		for i = 1, 3 do
			_G["GlyphFrameHeader"..i.."Left"]:Hide()
			_G["GlyphFrameHeader"..i.."Middle"]:Hide()
			_G["GlyphFrameHeader"..i.."Right"]:Hide()

		end

		for i = 1, 12 do
			local bu = _G["GlyphFrameScrollFrameButton"..i]
			local ic = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 38, -2)
			bg:Point("BOTTOMRIGHT", 0, 2)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)

			_G["GlyphFrameScrollFrameButton"..i.."Name"]:SetParent(bg)
			_G["GlyphFrameScrollFrameButton"..i.."TypeName"]:SetParent(bg)
			bu:SetHighlightTexture("")
			select(3, bu:GetRegions()):SetAlpha(0)
			select(4, bu:GetRegions()):SetAlpha(0)

			local check = select(2, bu:GetRegions())
			check:Point("TOPLEFT", 39, -3)
			check:Point("BOTTOMRIGHT", -1, 3)
			check:SetTexture(C.media.backdrop)
			check:SetVertexColor(r, g, b, .2)

			S.CreateBG(ic)

			ic:SetTexCoord(.08, .92, .08, .92)
		end

		S.ReskinInput(GlyphFrameSearchBox)
		S.ReskinScroll(GlyphFrameScrollFrameScrollBar)
		F.ReskinDropDown(GlyphFrameFilterDropDown)
	elseif addon == "Blizzard_GMSurveyUI" then
		S.SetBD(GMSurveyFrame, 0, 0, -32, 4)
		S.CreateBD(GMSurveyCommentFrame, .25)
		for i = 1, 11 do
			S.CreateBD(_G["GMSurveyQuestion"..i], .25)
		end

		for i = 1, 11 do
			select(i, GMSurveyFrame:GetRegions()):Hide()
		end
		GMSurveyHeaderLeft:Hide()
		GMSurveyHeaderRight:Hide()
		GMSurveyHeaderCenter:Hide()
		GMSurveyScrollFrameTop:SetAlpha(0)
		GMSurveyScrollFrameMiddle:SetAlpha(0)
		GMSurveyScrollFrameBottom:SetAlpha(0)
		S.Reskin(GMSurveySubmitButton)
		S.Reskin(GMSurveyCancelButton)
		S.ReskinClose(GMSurveyCloseButton, "TOPRIGHT", GMSurveyFrame, "TOPRIGHT", -36, -4)
		S.ReskinScroll(GMSurveyScrollFrameScrollBar)
	elseif addon == "Blizzard_GuildBankUI" then
		local bg = CreateFrame("Frame", nil, GuildBankFrame)
		bg:Point("TOPLEFT", 10, -8)
		bg:Point("BOTTOMRIGHT", 0, 6)
		bg:SetFrameLevel(GuildBankFrame:GetFrameLevel()-1)
		S.CreateBD(bg)
		S.CreateSD(bg)

		GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 2, -30)

		local bd = CreateFrame("Frame", nil, GuildBankPopupFrame)
		bd:SetPoint("TOPLEFT")
		bd:Point("BOTTOMRIGHT", -28, 26)
		bd:SetFrameLevel(GuildBankPopupFrame:GetFrameLevel()-1)
		S.CreateBD(bd)
		S.CreateBD(GuildBankPopupEditBox, .25)

		GuildBankEmblemFrame:Hide()
		GuildBankPopupFrameTopLeft:Hide()
		GuildBankPopupFrameBottomLeft:Hide()
		select(2, GuildBankPopupFrame:GetRegions()):Hide()
		select(4, GuildBankPopupFrame:GetRegions()):Hide()
		GuildBankPopupNameLeft:Hide()
		GuildBankPopupNameMiddle:Hide()
		GuildBankPopupNameRight:Hide()
		GuildBankPopupScrollFrame:GetRegions():Hide()
		select(2, GuildBankPopupScrollFrame:GetRegions()):Hide()
		GuildBankTabTitleBackground:SetAlpha(0)
		GuildBankTabTitleBackgroundLeft:SetAlpha(0)
		GuildBankTabTitleBackgroundRight:SetAlpha(0)
		GuildBankTabLimitBackground:SetAlpha(0)
		GuildBankTabLimitBackgroundLeft:SetAlpha(0)
		GuildBankTabLimitBackgroundRight:SetAlpha(0)
		GuildBankFrameLeft:Hide()
		GuildBankFrameRight:Hide()
		local a, b = GuildBankTransactionsScrollFrame:GetRegions()
		a:Hide()
		b:Hide()

		for i = 1, 4 do
			local tab = _G["GuildBankFrameTab"..i]
			F.CreateTab(tab)

			if i ~= 1 then
				tab:Point("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
			end
		end

		GuildBankFrameWithdrawButton:ClearAllPoints()
		GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

		for i = 1, NUM_GUILDBANK_COLUMNS do
			_G["GuildBankColumn"..i]:GetRegions():Hide()
			for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
				local bu = _G["GuildBankColumn"..i.."Button"..j]
				bu:SetPushedTexture("")

				_G["GuildBankColumn"..i.."Button"..j.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				_G["GuildBankColumn"..i.."Button"..j.."NormalTexture"]:SetAlpha(0)

				local bg = CreateFrame("Frame", nil, bu)
				bg:Point("TOPLEFT", -1, 1)
				bg:Point("BOTTOMRIGHT", 1, -1)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				S.CreateBD(bg, 0)
			end
		end

		for i = 1, 8 do
			local tb = _G["GuildBankTab"..i]
			local bu = _G["GuildBankTab"..i.."Button"]
			local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
			local nt = _G["GuildBankTab"..i.."ButtonNormalTexture"]

			bu:SetCheckedTexture(C.media.checked)
			S.CreateBG(bu)
			S.CreateSD(bu, 5, 0, 0, 0, 1, 1)

			local a1, p, a2, x, y = bu:GetPoint()
			bu:SetPoint(a1, p, a2, x + 11, y)

			ic:SetTexCoord(.08, .92, .08, .92)
			tb:GetRegions():Hide()
			nt:SetAlpha(0)
		end

		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local bu = _G["GuildBankPopupButton"..i]
			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()
			
			_G["GuildBankPopupButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			
			S.CreateBG(_G["GuildBankPopupButton"..i.."Icon"])
		end
		
		S.Reskin(GuildBankFrameWithdrawButton)
		S.Reskin(GuildBankFrameDepositButton)
		S.Reskin(GuildBankFramePurchaseButton)
		S.Reskin(GuildBankPopupOkayButton)
		S.Reskin(GuildBankPopupCancelButton)
		S.Reskin(GuildBankInfoSaveButton)
		local GuildBankClose = select(14, GuildBankFrame:GetChildren())
		S.ReskinClose(GuildBankClose, "TOPRIGHT", GuildBankFrame, "TOPRIGHT", -4, -12)
		S.ReskinScroll(GuildBankTransactionsScrollFrameScrollBar)
		S.ReskinScroll(GuildBankInfoScrollFrameScrollBar)
		S.ReskinScroll(GuildBankPopupScrollFrameScrollBar)
		S.ReskinInput(GuildItemSearchBox)
	elseif addon == "Blizzard_GuildControlUI" then
		S.SetBD(GuildControlUI, 0, 0, 0, -28)
		S.CreateBD(GuildControlUIRankBankFrameInset, .25)

		for i = 1, 9 do
			select(i, GuildControlUI:GetRegions()):Hide()
		end

		for i = 1, 8 do
			select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
		end

		GuildControlUIRankSettingsFrameChatBg:SetAlpha(0)
		GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
		GuildControlUIRankSettingsFrameInfoBg:SetAlpha(0)
		GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
		GuildControlUITopBg:Hide()
		GuildControlUIHbar:Hide()
		GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
		GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

		hooksecurefunc("GuildControlUI_RankOrder_Update", function()
			for i = 1, GuildControlGetNumRanks() do
				local name = "GuildControlUIRankOrderFrameRank"..i
				local rank = _G[name.."NameEditBox"]
				if not rank.reskinned then
					S.ReskinInput(rank, 20)
					F.ReskinArrow(_G[name.."ShiftUpButton"], "up")
					_G[name.."ShiftUpButtonIcon"]:Hide()
					F.ReskinArrow(_G[name.."ShiftDownButton"], "down")
					_G[name.."ShiftDownButtonIcon"]:Hide()
					S.ReskinClose(_G[name.."DeleteButton"])
					_G[name.."DeleteButtonIcon"]:Hide()
					rank.reskinned = true
				end
			end
		end)

		hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
			for i = 1, GetNumGuildBankTabs()+1 do
				local tab = "GuildControlBankTab"..i
				local bu = _G[tab]
				if bu and not bu.reskinned then
					_G[tab.."Bg"]:Hide()
					S.CreateBD(bu, .12)
					S.Reskin(_G[tab.."BuyPurchaseButton"])
					F.ReskinCheck(_G[tab.."OwnedViewCheck"])
					F.ReskinCheck(_G[tab.."OwnedDepositCheck"])
					F.ReskinCheck(_G[tab.."OwnedUpdateInfoCheck"])
					S.ReskinInput(_G[tab.."OwnedStackBox"])

					bu.reskinned = true
				end
			end
		end)

		for i = 1, 19 do
			local checkbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
			if checkbox then F.ReskinCheck(checkbox) end
		end
		
		S.Reskin(GuildControlUIRankOrderFrameNewButton)

		S.ReskinClose(GuildControlUICloseButton)
		S.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
		F.ReskinDropDown(GuildControlUINavigationDropDown)
		F.ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
		F.ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
		S.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
	elseif addon == "Blizzard_GuildUI" then
		S.SetBD(GuildFrame)
		S.CreateBD(GuildMemberDetailFrame)
		S.CreateBD(GuildMemberNoteBackground, .25)
		S.CreateBD(GuildMemberOfficerNoteBackground, .25)
		S.CreateBD(GuildLogFrame)
		S.CreateBD(GuildLogContainer, .25)
		S.CreateBD(GuildNewsFiltersFrame)
		S.CreateBD(GuildTextEditFrame)
		S.CreateBD(GuildTextEditContainer, .25)
		S.CreateBD(GuildRecruitmentInterestFrame, .25)
		S.CreateBD(GuildRecruitmentAvailabilityFrame, .25)
		S.CreateBD(GuildRecruitmentRolesFrame, .25)
		S.CreateBD(GuildRecruitmentLevelFrame, .25)
		for i = 1, 5 do
			F.CreateTab(_G["GuildFrameTab"..i])
		end
		GuildFrameTabardBackground:Hide()
		GuildFrameTabardEmblem:Hide()
		GuildFrameTabardBorder:Hide()
		GuildFrameInset:Hide()
		select(5, GuildInfoFrameInfo:GetRegions()):Hide()
		select(11, GuildMemberDetailFrame:GetRegions()):Hide()
		GuildMemberDetailCorner:Hide()
		for i = 1, 9 do
			select(i, GuildLogFrame:GetRegions()):Hide()
			select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
			select(i, GuildTextEditFrame:GetRegions()):Hide()
		end
		select(2, GuildNewPerksFrame:GetRegions()):Hide()
		select(3, GuildNewPerksFrame:GetRegions()):Hide()
		GuildAllPerksFrame:GetRegions():Hide()
		GuildNewsFrame:GetRegions():Hide()
		GuildRewardsFrame:GetRegions():Hide()
		GuildNewsBossModelShadowOverlay:Hide()
		GuildPerksToggleButtonLeft:Hide()
		GuildPerksToggleButtonMiddle:Hide()
		GuildPerksToggleButtonRight:Hide()
		GuildPerksToggleButtonHighlightLeft:Hide()
		GuildPerksToggleButtonHighlightMiddle:Hide()
		GuildPerksToggleButtonHighlightRight:Hide()
		GuildPerksContainerScrollBarTrack:Hide()
		GuildNewPerksFrameHeader1:SetAlpha(0)
		GuildNewsContainerScrollBarTrack:Hide()
		GuildInfoDetailsFrameScrollBarTrack:Hide()
		GuildInfoFrameInfoHeader1:SetAlpha(0)
		GuildInfoFrameInfoHeader2:SetAlpha(0)
		GuildInfoFrameInfoHeader3:SetAlpha(0)
		GuildInfoChallengesDungeonTexture:SetAlpha(0)
		GuildInfoChallengesRaidTexture:SetAlpha(0)
		GuildInfoChallengesRatedBGTexture:SetAlpha(0)
		GuildRecruitmentCommentInputFrameTop:Hide()
		GuildRecruitmentCommentInputFrameTopLeft:Hide()
		GuildRecruitmentCommentInputFrameTopRight:Hide()
		GuildRecruitmentCommentInputFrameBottom:Hide()
		GuildRecruitmentCommentInputFrameBottomLeft:Hide()
		GuildRecruitmentCommentInputFrameBottomRight:Hide()
		GuildRecruitmentInterestFrameBg:Hide()
		GuildRecruitmentAvailabilityFrameBg:Hide()
		GuildRecruitmentRolesFrameBg:Hide()
		GuildRecruitmentLevelFrameBg:Hide()
		GuildRecruitmentCommentFrameBg:Hide()
		GuildRecruitmentDeclineButton_LeftSeparator:Hide()
		GuildRecruitmentInviteButton_RightSeparator:Hide()
		GuildRecruitmentListGuildButton_LeftSeparator:Hide()
		GuildNewsFrameHeader:SetAlpha(0)
		
		GuildFrame:DisableDrawLayer("BACKGROUND")
		GuildFrame:DisableDrawLayer("BORDER")
		GuildFrameInset:DisableDrawLayer("BACKGROUND")
		GuildFrameInset:DisableDrawLayer("BORDER")
		GuildFrameBottomInset:DisableDrawLayer("BACKGROUND")
		GuildFrameBottomInset:DisableDrawLayer("BORDER")
		GuildInfoFrameInfoBar1Left:SetAlpha(0)
		GuildInfoFrameInfoBar2Left:SetAlpha(0)
		select(2, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
		select(4, GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
		GuildFramePortraitFrame:Hide()
		GuildFrameTopRightCorner:Hide()
		GuildFrameTopBorder:Hide()
		GuildRosterColumnButton1:DisableDrawLayer("BACKGROUND")
		GuildRosterColumnButton2:DisableDrawLayer("BACKGROUND")
		GuildRosterColumnButton3:DisableDrawLayer("BACKGROUND")
		GuildRosterColumnButton4:DisableDrawLayer("BACKGROUND")
		GuildAddMemberButton_RightSeparator:Hide()
		GuildControlButton_LeftSeparator:Hide()
		GuildNewsBossModel:DisableDrawLayer("BACKGROUND")
		GuildNewsBossModel:DisableDrawLayer("OVERLAY")
		GuildNewsBossNameText:SetDrawLayer("ARTWORK")
		GuildNewsBossModelTextFrame:DisableDrawLayer("BACKGROUND")
		for i = 2, 6 do
			select(i, GuildNewsBossModelTextFrame:GetRegions()):Hide()
		end
		GuildMemberRankDropdown:HookScript("OnShow", function()
			GuildMemberDetailRankText:Hide()
		end)
		GuildMemberRankDropdown:HookScript("OnHide", function()
			GuildMemberDetailRankText:Show()
		end)
		hooksecurefunc("GuildNews_Update", function()
			local buttons = GuildNewsContainer.buttons
			for i = 1, #buttons do
				buttons[i].header:SetAlpha(0)
			end
		end)
		
		--GuildNewsFrameHeader:SetTexture(nil)
		-- for i = 1, 17 do
			-- S.StripTextures(_G["GuildNewsContainerButton"..i])
			-- local hover = _G["GuildNewsContainerButton"..i]:CreateTexture(nil, "OVERLAY")
			-- hover:SetTexture(1, 1, 1, 0.3)
			-- hover:SetAllPoints()
			-- _G["GuildNewsContainerButton"..i]:SetHighlightTexture(hover)
		-- end
		S.ReskinClose(GuildFrameCloseButton)
		S.ReskinClose(GuildNewsFiltersFrameCloseButton)
		S.ReskinClose(GuildLogFrameCloseButton)
		S.ReskinClose(GuildMemberDetailCloseButton)
		S.ReskinClose(GuildTextEditFrameCloseButton)
		S.ReskinScroll(GuildPerksContainerScrollBar)
		S.ReskinScroll(GuildRosterContainerScrollBar)
		S.ReskinScroll(GuildNewsContainerScrollBar)
		S.ReskinScroll(GuildRewardsContainerScrollBar)
		S.ReskinScroll(GuildInfoDetailsFrameScrollBar)
		S.ReskinScroll(GuildLogScrollFrameScrollBar)
		S.ReskinScroll(GuildTextEditScrollFrameScrollBar)
		F.ReskinDropDown(GuildRosterViewDropdown)
		F.ReskinDropDown(GuildMemberRankDropdown)
		S.ReskinInput(GuildRecruitmentCommentInputFrame)
		GuildRecruitmentCommentInputFrame:SetWidth(312)
		GuildRecruitmentCommentEditBox:SetWidth(284)
		GuildRecruitmentCommentFrame:ClearAllPoints()
		GuildRecruitmentCommentFrame:Point("TOPLEFT", GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)
		F.ReskinCheck(GuildRosterShowOfflineButton)
		for i = 1, 7 do
			F.ReskinCheck(_G["GuildNewsFilterButton"..i])
		end

		local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
		GuildNewsBossModel:ClearAllPoints()
		GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

		local f = CreateFrame("Frame", nil, GuildNewsBossModel)
		f:Point("TOPLEFT", 0, 1)
		f:Point("BOTTOMRIGHT", 1, -52)
		f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		S.CreateBD(f)

		local line = CreateFrame("Frame", nil, GuildNewsBossModel)
		line:Point("BOTTOMLEFT", 0, -1)
		line:Point("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		S.CreateBD(line, 0)

		GuildNewsFiltersFrame:SetWidth(224)
		GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -20)
		GuildMemberDetailFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, -28)
		GuildLogFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
		GuildTextEditFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 1, 0)
		
		for i = 1, 5 do
			local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]
			S.CreateBD(bu, .25)
			bu:SetHighlightTexture("")
			bu:GetRegions():SetTexture(C.media.backdrop)
			bu:GetRegions():SetVertexColor(r, g, b, .2)
		end

		GuildFactionBarProgress:SetTexture(C.media.backdrop)
		GuildFactionBarLeft:Hide()
		GuildFactionBarMiddle:Hide()
		GuildFactionBarRight:Hide()
		GuildFactionBarShadow:SetAlpha(0)
		GuildFactionBarBG:Hide()
		GuildFactionBarCap:SetAlpha(0)
		GuildFactionBar.bg = CreateFrame("Frame", nil, GuildFactionFrame)
		GuildFactionBar.bg:Point("TOPLEFT", GuildFactionFrame, -1, -1)
		GuildFactionBar.bg:Point("BOTTOMRIGHT", GuildFactionFrame, -3, 0)
		GuildFactionBar.bg:SetFrameLevel(0)
		S.CreateBD(GuildFactionBar.bg, .25)

		GuildXPFrame:ClearAllPoints()
		GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)
		GuildXPBarProgress:SetTexture(C.media.backdrop)
		GuildXPBarLeft:SetAlpha(0)
		GuildXPBarRight:SetAlpha(0)
		GuildXPBarMiddle:SetAlpha(0)
		GuildXPBarBG:SetAlpha(0)
		GuildXPBarShadow:SetAlpha(0)
		GuildXPBarCap:SetAlpha(0)
		GuildXPBarDivider1:Hide()
		GuildXPBarDivider2:Hide()
		GuildXPBarDivider3:Hide()
		GuildXPBarDivider4:Hide()
		GuildXPBar.bg = CreateFrame("Frame", nil, GuildXPBar)
		GuildXPBar.bg:Point("TOPLEFT", GuildXPBar, 0, -3)
		GuildXPBar.bg:Point("BOTTOMRIGHT", GuildXPBar, 0, 1)
		GuildXPBar.bg:SetFrameLevel(0)
		S.CreateBD(GuildXPBar.bg, .25)

		local perkbuttons = {"GuildLatestPerkButton", "GuildNextPerkButton"}
		for _, button in pairs(perkbuttons) do
			local bu = _G[button]
			local ic = _G[button.."IconTexture"]
			local na = _G[button.."NameFrame"]

			na:SetAlpha(0)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")
			S.CreateBG(ic)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:Point("TOPLEFT", 0, -1)
			bu.bg:Point("BOTTOMRIGHT", 0, 2)
			bu.bg:SetFrameLevel(0)
			S.CreateBD(bu.bg, .25)
		end

		select(5, GuildLatestPerkButton:GetRegions()):Hide()
		select(6, GuildLatestPerkButton:GetRegions()):Hide()

		local reskinnedperks = false
		GuildPerksToggleButton:HookScript("OnClick", function()
			if not reskinnedperks == true then
				for i = 1, 8 do
					local button = "GuildPerksContainerButton"..i
					local bu = _G[button]
					local ic = _G[button.."IconTexture"]

					bu:DisableDrawLayer("BACKGROUND")
					bu:DisableDrawLayer("BORDER")
					bu.EnableDrawLayer = F.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					ic.bg = CreateFrame("Frame", nil, bu)
					ic.bg:Point("TOPLEFT", ic, -1, 1)
					ic.bg:Point("BOTTOMRIGHT", ic, 1, -1)
					S.CreateBD(ic.bg, 0)
				end
				reskinnedperks = true
			end
		end)

		local reskinnedrewards = false
		hooksecurefunc("GuildRewards_Update", function()
				if reskinnedRewards == true then return end
				
				for i = 1, 8 do
					local button = "GuildRewardsContainerButton"..i
					local bu = _G[button]
					local ic = _G[button.."Icon"]
					local locked = select(6, bu:GetRegions())
					local bd = select(7, bu:GetRegions())

					local bg = CreateFrame("Frame", nil, bu)
					bg:Point("TOPLEFT", 0, -1)
					bg:SetPoint("BOTTOMRIGHT")
					S.CreateBD(bg, 0)

					bu:SetHighlightTexture(C.media.backdrop)
					local hl = bu:GetHighlightTexture()
					hl:SetVertexColor(r, g, b, .2)
					hl:Point("TOPLEFT", 0, -1)
					hl:SetPoint("BOTTOMRIGHT")

					ic:SetTexCoord(.08, .92, .08, .92)

					locked:Hide()
					locked.Show = F.dummy
					bd:SetTexture(C.media.backdrop)
					bd:SetVertexColor(0, 0, 0, .25)
					bd:Point("TOPLEFT", 0, -1)
					bd:Point("BOTTOMRIGHT", 0, 1)

					S.CreateBG(ic)
				end
				reskinnedrewards = true
		end)

		local function createButtonBg(bu)
			bu:SetHighlightTexture(C.media.backdrop)
			bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

			bu.bg = S.CreateBG(bu.icon)
		end			

		local tcoords = {
			["WARRIOR"]     = {0.02, 0.23, 0.02, 0.23},
			["MAGE"]        = {0.27, 0.47609375, 0.02, 0.23},
			["ROGUE"]       = {0.51609375, 0.7221875, 0.02, 0.23},
			["DRUID"]       = {0.7621875, 0.96828125, 0.02, 0.23},
			["HUNTER"]      = {0.02, 0.23, 0.27, 0.48},
			["SHAMAN"]      = {0.27, 0.47609375, 0.27, 0.48},
			["PRIEST"]      = {0.51609375, 0.7221875, 0.27, 0.48},
			["WARLOCK"]     = {0.7621875, 0.96828125, 0.27, 0.48},
			["PALADIN"]     = {0.02, 0.23, 0.52, 0.73},
			["DEATHKNIGHT"] = {0.27, .48, 0.52, .73},
		}

		local UpdateIcons = function()
			local index
			local offset = HybridScrollFrame_GetOffset(GuildRosterContainer)
			local totalMembers, onlineMembers = GetNumGuildMembers()
			local visibleMembers = onlineMembers
			local numbuttons = #GuildRosterContainer.buttons
			if GetGuildRosterShowOffline() then
				visibleMembers = totalMembers
			end

			for i = 1, numbuttons do
				local button = GuildRosterContainer.buttons[i]

				if not button.bg then
					createButtonBg(button)
				end

				index = offset + i
				local name, _, _, _, _, _, _, _, _, _, classFileName  = GetGuildRosterInfo(index)
				if name and index <= visibleMembers then
					if button.icon:IsShown() then
						button.icon:SetTexCoord(unpack(tcoords[classFileName]))
						button.bg:Show()
					else
						button.bg:Hide()
					end
				end
			end
		end

		hooksecurefunc("GuildRoster_Update", UpdateIcons)
		GuildRosterContainer:HookScript("OnMouseWheel", UpdateIcons)
		GuildRosterContainer:HookScript("OnVerticalScroll", UpdateIcons)
		
		GuildLevelFrame:SetAlpha(0)
		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		S.Reskin(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		S.Reskin(logbutton)
		local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildPerksToggleButton", "GuildRecruitmentListGuildButton"}
		for i = 1, #gbuttons do
			S.Reskin(_G[gbuttons[i]])
		end
		
		local checkboxes = {"GuildRecruitmentQuestButton", "GuildRecruitmentDungeonButton", "GuildRecruitmentRaidButton", "GuildRecruitmentPvPButton", "GuildRecruitmentRPButton", "GuildRecruitmentWeekdaysButton", "GuildRecruitmentWeekendsButton"}
		for i = 1, #checkboxes do
			F.ReskinCheck(_G[checkboxes[i]])
		end
		
		F.ReskinCheck(GuildRecruitmentTankButton:GetChildren())
		F.ReskinCheck(GuildRecruitmentHealerButton:GetChildren())
		F.ReskinCheck(GuildRecruitmentDamagerButton:GetChildren())
		
		F.ReskinRadio(GuildRecruitmentLevelAnyButton)
		F.ReskinRadio(GuildRecruitmentLevelMaxButton)

		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = F.dummy
			end
		end
	elseif addon == "Blizzard_InspectUI" then
		S.SetBD(InspectFrame)
		InspectFrame:DisableDrawLayer("BACKGROUND")
		InspectFrame:DisableDrawLayer("BORDER")
		InspectFrameInset:DisableDrawLayer("BACKGROUND")
		InspectFrameInset:DisableDrawLayer("BORDER")
		InspectModelFrame:DisableDrawLayer("OVERLAY")

		InspectPVPTeam1:DisableDrawLayer("BACKGROUND")
		InspectPVPTeam2:DisableDrawLayer("BACKGROUND")
		InspectPVPTeam3:DisableDrawLayer("BACKGROUND")
		InspectFramePortrait:Hide()
		InspectGuildFrameBG:Hide()
		for i = 1, 5 do
			select(i, InspectModelFrame:GetRegions()):Hide()
		end
		for i = 1, 4 do
			select(i, InspectTalentFrame:GetRegions()):Hide()
			local tab = _G["InspectFrameTab"..i]
			F.CreateTab(tab)
			if i ~= 1 then
				tab:Point("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
			end
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()).Show = F.dummy
			end
		end
		InspectFramePortraitFrame:Hide()
		InspectFrameTopBorder:Hide()
		InspectFrameTopRightCorner:Hide()
		InspectPVPFrameBG:SetAlpha(0)
		InspectPVPFrameBottom:SetAlpha(0)
		InspectTalentFramePointsBarBorderLeft:Hide()
		InspectTalentFramePointsBarBorderMiddle:Hide()
		InspectTalentFramePointsBarBorderRight:Hide()

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Inspect"..slots[i].."Slot"]
			slot:DisableDrawLayer("BACKGROUND")
			slot:SetNormalTexture("")
			slot:SetPushedTexture("")
			slot.bd = CreateFrame("Frame", nil, slot)
			slot.bd:Point("TOPLEFT", -1, 1)
			slot.bd:Point("BOTTOMRIGHT", 1, -1)
			slot.bd:SetFrameLevel(0)
			S.CreateBD(slot.bd, .25)
			_G["Inspect"..slots[i].."SlotIconTexture"]:SetTexCoord(.08, .92, .08, .92)
		end

		S.ReskinClose(InspectFrameCloseButton)
	elseif addon == "Blizzard_ItemAlterationUI" then
		S.SetBD(TransmogrifyFrame)
		TransmogrifyArtFrame:DisableDrawLayer("BACKGROUND")
		TransmogrifyArtFrame:DisableDrawLayer("BORDER")
		TransmogrifyArtFramePortraitFrame:Hide()
		TransmogrifyArtFramePortrait:Hide()
		TransmogrifyArtFrameTopBorder:Hide()
		TransmogrifyArtFrameTopRightCorner:Hide()
		TransmogrifyModelFrameMarbleBg:Hide()
		select(2, TransmogrifyModelFrame:GetRegions()):Hide()
		TransmogrifyModelFrameLines:Hide()
		TransmogrifyFrameButtonFrame:GetRegions():Hide()
		TransmogrifyFrameButtonFrameButtonBorder:Hide()
		TransmogrifyFrameButtonFrameButtonBottomBorder:Hide()
		TransmogrifyFrameButtonFrameMoneyLeft:Hide()
		TransmogrifyFrameButtonFrameMoneyRight:Hide()
		TransmogrifyFrameButtonFrameMoneyMiddle:Hide()
		TransmogrifyApplyButton_LeftSeparator:Hide()

		local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "MainHand", "SecondaryHand", "Ranged"}

		for i = 1, #slots do
			local slot = _G["TransmogrifyFrame"..slots[i].."Slot"]
			if slot then
				local ic = _G["TransmogrifyFrame"..slots[i].."SlotIconTexture"]
				_G["TransmogrifyFrame"..slots[i].."SlotBorder"]:Hide()
				_G["TransmogrifyFrame"..slots[i].."SlotGrabber"]:Hide()

				ic:SetTexCoord(.08, .92, .08, .92)
				S.CreateBD(slot, 0)
			end
		end

		S.Reskin(TransmogrifyApplyButton)
		S.ReskinClose(TransmogrifyArtFrameCloseButton)
	elseif addon == "Blizzard_ItemSocketingUI" then
		S.SetBD(ItemSocketingFrame, 12, -8, -2, 24)
		S.CreateBD(ItemSocketingScrollFrame, .25)
		select(2, ItemSocketingFrame:GetRegions()):Hide()
		ItemSocketingFramePortrait:Hide()
		ItemSocketingScrollFrameTop:SetAlpha(0)
		ItemSocketingScrollFrameBottom:SetAlpha(0)
		ItemSocketingSocket1Left:SetAlpha(0)
		ItemSocketingSocket1Right:SetAlpha(0)
		ItemSocketingSocket2Left:SetAlpha(0)
		ItemSocketingSocket2Right:SetAlpha(0)
		ItemSocketingSocket3Left:SetAlpha(0)
		ItemSocketingSocket3Right:SetAlpha(0)
		S.Reskin(ItemSocketingSocketButton)
		ItemSocketingSocketButton:ClearAllPoints()
		ItemSocketingSocketButton:Point("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -10, 28)

		for i = 1, MAX_NUM_SOCKETS do
			local bu = _G["ItemSocketingSocket"..i]
			local ic = _G["ItemSocketingSocket"..i.."IconTexture"]

			_G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
			_G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)
			select(2, bu:GetRegions()):Hide()

			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetAllPoints(bu)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)

			bu.glow = CreateFrame("Frame", nil, bu)
			bu.glow:SetBackdrop({
				edgeFile = C.media.glow,
				edgeSize = 4,
			})
			bu.glow:Point("TOPLEFT", -4, 4)
			bu.glow:Point("BOTTOMRIGHT", 4, -4)
		end
		hooksecurefunc("ItemSocketingFrame_Update", function()
			for i = 1, MAX_NUM_SOCKETS do
				local color = GEM_TYPE_INFO[GetSocketTypes(i)]
				_G["ItemSocketingSocket"..i].glow:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end)

		S.ReskinClose(ItemSocketingCloseButton, "TOPRIGHT", ItemSocketingFrame, "TOPRIGHT", -6, -12)
		S.ReskinScroll(ItemSocketingScrollFrameScrollBar)
	elseif addon == "Blizzard_LookingForGuildUI" then
		S.SetBD(LookingForGuildFrame)
		S.CreateBD(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrameBg:Hide()
		S.CreateBD(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrameBg:Hide()
		S.CreateBD(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrameBg:Hide()
		S.CreateBD(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrameBg:Hide()
		S.CreateBD(LookingForGuildCommentInputFrame, .12)
		LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
		LookingForGuildFrame:DisableDrawLayer("BORDER")
		LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
		LookingForGuildFrameInset:DisableDrawLayer("BORDER")
		S.CreateBD(GuildFinderRequestMembershipFrame)
		S.CreateSD(GuildFinderRequestMembershipFrame)
		for i = 1, 5 do
			local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
			S.CreateBD(bu, .25)
			bu:SetHighlightTexture("")
			bu:GetRegions():SetTexture(C.media.backdrop)
			bu:GetRegions():SetVertexColor(r, g, b, .2)
		end
		for i = 1, 9 do
			select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = F.dummy
			end
		end
		for i = 1, 6 do
			select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
		end
		LookingForGuildFrameTabardBackground:Hide()
		LookingForGuildFrameTabardEmblem:Hide()
		LookingForGuildFrameTabardBorder:Hide()
		LookingForGuildFramePortraitFrame:Hide()
		LookingForGuildFrameTopBorder:Hide()
		LookingForGuildFrameTopRightCorner:Hide()
		LookingForGuildBrowseButton_LeftSeparator:Hide()
		LookingForGuildRequestButton_RightSeparator:Hide()

		S.Reskin(LookingForGuildBrowseButton)
		S.Reskin(LookingForGuildRequestButton)
		S.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
		S.Reskin(GuildFinderRequestMembershipFrameCancelButton)

		S.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)
		S.ReskinClose(LookingForGuildFrameCloseButton)
		F.ReskinCheck(LookingForGuildQuestButton)
		F.ReskinCheck(LookingForGuildDungeonButton)
		F.ReskinCheck(LookingForGuildRaidButton)
		F.ReskinCheck(LookingForGuildPvPButton)
		F.ReskinCheck(LookingForGuildRPButton)
		F.ReskinCheck(LookingForGuildWeekdaysButton)
		F.ReskinCheck(LookingForGuildWeekendsButton)
		F.ReskinCheck(LookingForGuildTankButton:GetChildren())
		F.ReskinCheck(LookingForGuildHealerButton:GetChildren())
		F.ReskinCheck(LookingForGuildDamagerButton:GetChildren())
		S.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
	elseif addon == "Blizzard_MacroUI" then
		S.SetBD(MacroFrame, 12, -10, -33, 68)
		S.CreateBD(MacroFrameScrollFrame, .25)
		S.CreateBD(MacroPopupFrame)
		S.CreateBD(MacroPopupEditBox, .25)
		for i = 1, 6 do
			select(i, MacroFrameTab1:GetRegions()):Hide()
			select(i, MacroFrameTab2:GetRegions()):Hide()
			select(i, MacroFrameTab1:GetRegions()).Show = F.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = F.dummy
		end
		for i = 1, 8 do
			if i ~= 6 then select(i, MacroFrame:GetRegions()):Hide() end
		end
		for i = 1, 5 do
			select(i, MacroPopupFrame:GetRegions()):Hide()
		end
		MacroPopupScrollFrame:GetRegions():Hide()
		select(2, MacroPopupScrollFrame:GetRegions()):Hide()
		MacroPopupNameLeft:Hide()
		MacroPopupNameMiddle:Hide()
		MacroPopupNameRight:Hide()
		MacroFrameTextBackground:SetBackdrop(nil)
		select(2, MacroFrameSelectedMacroButton:GetRegions()):Hide()
		MacroFrameSelectedMacroBackground:SetAlpha(0)
		MacroButtonScrollFrameTop:Hide()
		MacroButtonScrollFrameBottom:Hide()

		for i = 1, MAX_ACCOUNT_MACROS do
			local bu = _G["MacroButton"..i]
			local ic = _G["MacroButton"..i.."Icon"]

			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()

			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bu, .25)
		end

		for i = 1, NUM_MACRO_ICONS_SHOWN do
			local bu = _G["MacroPopupButton"..i]
			local ic = _G["MacroPopupButton"..i.."Icon"]

			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()

			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bu, .25)
		end

		MacroFrameSelectedMacroButton:Point("TOPLEFT", MacroFrameSelectedMacroBackground, "TOPLEFT", 12, -16)
		MacroFrameSelectedMacroButtonIcon:Point("TOPLEFT", 1, -1)
		MacroFrameSelectedMacroButtonIcon:Point("BOTTOMRIGHT", -1, 1)
		MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)

		S.CreateBD(MacroFrameSelectedMacroButton, .25)

		S.Reskin(MacroDeleteButton)
		S.Reskin(MacroNewButton)
		S.Reskin(MacroExitButton)
		S.Reskin(MacroEditButton)
		S.Reskin(MacroPopupOkayButton)
		S.Reskin(MacroPopupCancelButton)
		S.Reskin(MacroSaveButton)
		S.Reskin(MacroCancelButton)
		MacroPopupFrame:ClearAllPoints()
		MacroPopupFrame:Point("TOPLEFT", MacroFrame, "TOPRIGHT", -32, -40)

		S.ReskinClose(MacroFrameCloseButton, "TOPRIGHT", MacroFrame, "TOPRIGHT", -38, -14)
		S.ReskinScroll(MacroButtonScrollFrameScrollBar)
		S.ReskinScroll(MacroFrameScrollFrameScrollBar)
		S.ReskinScroll(MacroPopupScrollFrameScrollBar)
	elseif addon == "Blizzard_RaidUI" then
		S.Reskin(RaidFrameReadyCheckButton)
		F.ReskinCheck(RaidFrameAllAssistCheckButton)
	elseif addon == "Blizzard_ReforgingUI" then
		S.CreateBD(ReforgingFrame)
		S.CreateSD(ReforgingFrame)
		ReforgingFrame:DisableDrawLayer("BORDER")
		for i = 15, 25 do
			select(i, ReforgingFrame:GetRegions()):Hide()
		end
		ReforgingFrameLines:SetAlpha(0)
		ReforgingFrameReceiptBG:SetAlpha(0)
		ReforgingFramePortrait:Hide()
		ReforgingFrameBg:Hide()
		ReforgingFrameTitleBg:Hide()
		ReforgingFramePortraitFrame:Hide()
		ReforgingFrameTopBorder:Hide()
		ReforgingFrameTopRightCorner:Hide()
		ReforgingFrameRestoreButton_LeftSeparator:Hide()
		ReforgingFrameRestoreButton_RightSeparator:Hide()
		ReforgingFrameButtonFrame:GetRegions():Hide()
		ReforgingFrameButtonFrameButtonBorder:Hide()
		ReforgingFrameButtonFrameButtonBottomBorder:Hide()
		ReforgingFrameButtonFrameMoneyLeft:Hide()
		ReforgingFrameButtonFrameMoneyRight:Hide()
		ReforgingFrameButtonFrameMoneyMiddle:Hide()
		ReforgingFrameMissingFadeOut:SetAlpha(0)
		ReforgingFrameRestoreMessage:SetTextColor(1, 1, 1)
		S.Reskin(ReforgingFrameRestoreButton)
		S.Reskin(ReforgingFrameReforgeButton)
		S.ReskinClose(ReforgingFrameCloseButton)
	elseif addon == "Blizzard_TalentUI" then
		S.SetBD(PlayerTalentFrame)
		S.Reskin(PlayerTalentFrameToggleSummariesButton)
		S.Reskin(PlayerTalentFrameLearnButton)
		S.Reskin(PlayerTalentFrameResetButton)
		S.Reskin(PlayerTalentFrameActivateButton)
		PlayerTalentFrame:DisableDrawLayer("BACKGROUND")
		PlayerTalentFrame:DisableDrawLayer("BORDER")
		PlayerTalentFrameInset:DisableDrawLayer("BACKGROUND")
		PlayerTalentFrameInset:DisableDrawLayer("BORDER")
		PlayerTalentFramePortrait:Hide()
		PlayerTalentFramePortraitFrame:Hide()
		PlayerTalentFrameTopBorder:Hide()
		PlayerTalentFrameTopRightCorner:Hide()
		PlayerTalentFrameToggleSummariesButton_LeftSeparator:Hide()
		PlayerTalentFrameToggleSummariesButton_RightSeparator:Hide()
		PlayerTalentFrameLearnButton_LeftSeparator:Hide()
		PlayerTalentFrameResetButton_LeftSeparator:Hide()
		--PlayerTalentFrameTitleGlowLeft:SetAlpha(0)
		--PlayerTalentFrameTitleGlowRight:SetAlpha(0)
		--PlayerTalentFrameTitleGlowCenter:SetAlpha(0)

		if class == "HUNTER" then
			PlayerTalentFramePetPanel:DisableDrawLayer("BORDER")
			PlayerTalentFramePetModelBg:Hide()
			PlayerTalentFramePetShadowOverlay:Hide()
			PlayerTalentFramePetModelRotateLeftButton:Hide()
			PlayerTalentFramePetModelRotateRightButton:Hide()
			PlayerTalentFramePetIconBorder:Hide()
			PlayerTalentFramePetPanelHeaderIconBorder:Hide()
			PlayerTalentFramePetPanelHeaderBackground:Hide()
			PlayerTalentFramePetPanelHeaderBorder:Hide()

			PlayerTalentFramePetIcon:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(PlayerTalentFramePetIcon)

			PlayerTalentFramePetPanelHeaderIconIcon:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(PlayerTalentFramePetPanelHeaderIcon)

			PlayerTalentFramePetPanelHeaderIcon:Point("TOPLEFT", PlayerTalentFramePetPanelHeaderBackground, "TOPLEFT", -2, 3)
			PlayerTalentFramePetPanelName:Point("LEFT", PlayerTalentFramePetPanelHeaderBackground, "LEFT", 62, 8)

			local bg = CreateFrame("Frame", nil, PlayerTalentFramePetPanel)
			bg:Point("TOPLEFT", 4, -6)
			bg:Point("BOTTOMRIGHT", -4, 4)
			bg:SetFrameLevel(0)
			S.CreateBD(bg, .25)

			local line = PlayerTalentFramePetPanel:CreateTexture(nil, "BACKGROUND")
			line:SetHeight(1)
			line:Point("TOPLEFT", 4, -52)
			line:Point("TOPRIGHT", -4, -52)
			line:SetTexture(C.media.backdrop)
			line:SetVertexColor(0, 0, 0)
		end

		for i = 1, 3 do
			local tab = _G["PlayerTalentFrameTab"..i]
			if tab then
				F.CreateTab(tab)
			end

			local panel = _G["PlayerTalentFramePanel"..i]
			local icon = _G["PlayerTalentFramePanel"..i.."HeaderIcon"]
			local num = _G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpent"]
			local icontexture = _G["PlayerTalentFramePanel"..i.."HeaderIconIcon"]

			for j = 1, 8 do
				select(j, panel:GetRegions()):Hide()
			end
			for j = 14, 21 do
				select(j, panel:GetRegions()):SetAlpha(0)
			end

			_G["PlayerTalentFramePanel"..i.."HeaderBackground"]:SetAlpha(0)
			_G["PlayerTalentFramePanel"..i.."HeaderBorder"]:Hide()
			_G["PlayerTalentFramePanel"..i.."BgHighlight"]:Hide()
			_G["PlayerTalentFramePanel"..i.."HeaderIconPrimaryBorder"]:SetAlpha(0)
			_G["PlayerTalentFramePanel"..i.."HeaderIconSecondaryBorder"]:SetAlpha(0)
			_G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpentBgGold"]:SetAlpha(0)
			_G["PlayerTalentFramePanel"..i.."HeaderIconPointsSpentBgSilver"]:SetAlpha(0)

			icontexture:SetTexCoord(.08, .92, .08, .92)
			icontexture:Point("TOPLEFT", 1, -1)
			icontexture:Point("BOTTOMRIGHT", -1, 1)

			S.CreateBD(icon)

			icon:Point("TOPLEFT", panel, "TOPLEFT", 4, -1)

			num:ClearAllPoints()
			num:Point("RIGHT", _G["PlayerTalentFramePanel"..i.."HeaderBackground"], "RIGHT", -40, 0)
			num:SetFont(DB.Font, 12)
			num:SetJustifyH("RIGHT")

			panel.bg = CreateFrame("Frame", nil, panel)
			panel.bg:Point("TOPLEFT", 4, -39)
			panel.bg:Point("BOTTOMRIGHT", -4, 4)
			panel.bg:SetFrameLevel(0)
			S.CreateBD(panel.bg)

			panel.bg2 = CreateFrame("Frame", nil, panel)
			panel.bg2:Size(200, 36)
			panel.bg2:Point("TOPLEFT", 4, -1)
			panel.bg2:SetFrameLevel(0)
			S.CreateBD(panel.bg2, .25)

			S.Reskin(_G["PlayerTalentFramePanel"..i.."SelectTreeButton"])

			for j = 1, 28 do
				local bu = _G["PlayerTalentFramePanel"..i.."Talent"..j]
				local ic = _G["PlayerTalentFramePanel"..i.."Talent"..j.."IconTexture"]

				_G["PlayerTalentFramePanel"..i.."Talent"..j.."Slot"]:SetAlpha(0)
				_G["PlayerTalentFramePanel"..i.."Talent"..j.."SlotShadow"]:SetAlpha(0)
				_G["PlayerTalentFramePanel"..i.."Talent"..j.."GoldBorder"]:SetAlpha(0)
				_G["PlayerTalentFramePanel"..i.."Talent"..j.."GlowBorder"]:SetAlpha(0)

				bu:SetPushedTexture("")
				bu.SetPushedTexture = F.dummy
				ic:SetTexCoord(.08, .92, .08, .92)
				ic:Point("TOPLEFT", 1, -1)
				ic:Point("BOTTOMRIGHT", -1, 1)

				S.CreateBD(bu)
			end
		end
		for i = 1, 2 do
			_G["PlayerSpecTab"..i.."Background"]:Hide()
			local tab = _G["PlayerSpecTab"..i]
			tab:SetCheckedTexture(C.media.checked)
			local a1, p, a2, x, y = PlayerSpecTab1:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
				PlayerSpecTab1:SetPoint(a1, p, a2, x + 11, y + 10)
				PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
			end)
			S.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			S.CreateBD(bg, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		S.ReskinClose(PlayerTalentFrameCloseButton)
	elseif addon == "Blizzard_TradeSkillUI" then
		S.SetBD(TradeSkillFrame)
		S.SetBD(TradeSkillGuildFrame)
		S.CreateBD(TradeSkillGuildFrameContainer, .25)

		TradeSkillFrame:DisableDrawLayer("BORDER")
		TradeSkillFrameInset:DisableDrawLayer("BORDER")
		TradeSkillFramePortrait:Hide()
		TradeSkillFramePortrait.Show = F.dummy
		for i = 18, 20 do
			select(i, TradeSkillFrame:GetRegions()):Hide()
			select(i, TradeSkillFrame:GetRegions()).Show = F.dummy
		end
		TradeSkillHorizontalBarLeft:Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()
		for i = 1, 3 do
			select(i, TradeSkillExpandButtonFrame:GetRegions()):Hide()
			select(i, TradeSkillFilterButton:GetRegions()):Hide()
		end
		for i = 1, 9 do
			select(i, TradeSkillGuildFrame:GetRegions()):Hide()
		end
		TradeSkillListScrollFrame:GetRegions():Hide()
		select(2, TradeSkillListScrollFrame:GetRegions()):Hide()
		TradeSkillDetailHeaderLeft:Hide()
		select(6, TradeSkillDetailScrollChildFrame:GetRegions()):Hide()
		TradeSkillDetailScrollFrameTop:SetAlpha(0)
		TradeSkillDetailScrollFrameBottom:SetAlpha(0)
		TradeSkillFrameBg:Hide()
		TradeSkillFrameInsetBg:Hide()
		TradeSkillFrameTitleBg:Hide()
		TradeSkillFramePortraitFrame:Hide()
		TradeSkillFrameTopBorder:Hide()
		TradeSkillFrameTopRightCorner:Hide()
		TradeSkillCreateAllButton_RightSeparator:Hide()
		TradeSkillCreateButton_LeftSeparator:Hide()
		TradeSkillCancelButton_LeftSeparator:Hide()
		TradeSkillViewGuildCraftersButton_RightSeparator:Hide()
		TradeSkillGuildCraftersFrameTrack:Hide()
		TradeSkillRankFrameBorder:Hide()
		TradeSkillRankFrameBackground:Hide()

		TradeSkillDetailScrollFrame:SetHeight(176)

		local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
		TradeSkillGuildFrame:ClearAllPoints()
		TradeSkillGuildFrame:SetPoint(a1, p, a2, x + 16, y)

		TradeSkillLinkButton:Point("LEFT", 0, -1)

		S.Reskin(TradeSkillCreateButton)
		S.Reskin(TradeSkillCreateAllButton)
		S.Reskin(TradeSkillCancelButton)
		S.Reskin(TradeSkillViewGuildCraftersButton)
		S.Reskin(TradeSkillFilterButton)

		TradeSkillRankFrame:SetStatusBarTexture(C.media.backdrop)
		TradeSkillRankFrame.SetStatusBarColor = F.dummy
		TradeSkillRankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

		local bg = CreateFrame("Frame", nil, TradeSkillRankFrame)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(TradeSkillRankFrame:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		for i = 1, MAX_TRADE_SKILL_REAGENTS do
			local bu = _G["TradeSkillReagent"..i]
			local na = _G["TradeSkillReagent"..i.."NameFrame"]
			local ic = _G["TradeSkillReagent"..i.."IconTexture"]

			na:Hide()

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("ARTWORK")
			S.CreateBG(ic)

			local bd = CreateFrame("Frame", nil, bu)
			bd:Point("TOPLEFT", 39, -1)
			bd:Point("BOTTOMRIGHT", 0, 1)
			bd:SetFrameLevel(0)
			S.CreateBD(bd, .25)

			_G["TradeSkillReagent"..i.."Name"]:SetParent(bd)
		end

		hooksecurefunc("TradeSkillFrame_SetSelection", function()
			local ic = TradeSkillSkillIcon:GetNormalTexture()
			if ic then
				ic:SetTexCoord(.08, .92, .08, .92)
				ic:Point("TOPLEFT", 1, -1)
				ic:Point("BOTTOMRIGHT", -1, 1)
				S.CreateBD(TradeSkillSkillIcon)
			else
				TradeSkillSkillIcon:SetBackdrop(nil)
			end
		end)

		local all = TradeSkillCollapseAllButton
		all:SetNormalTexture("")
		all.SetNormalTexture = F.dummy
		all:SetHighlightTexture("")
		all:SetPushedTexture("")

		all.bg = CreateFrame("Frame", nil, all)
		all.bg:Size(13, 13)
		all.bg:Point("LEFT", 4, 0)
		all.bg:SetFrameLevel(all:GetFrameLevel()-1)
		S.CreateBD(all.bg, 0)	

		all.tex = all:CreateTexture(nil, "BACKGROUND")
		all.tex:SetAllPoints(all.bg)
		all.tex:SetTexture(C.media.backdrop)
		all.tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

		all.minus = all:CreateTexture(nil, "OVERLAY")
		all.minus:Size(7, 1)
		all.minus:SetPoint("CENTER", all.bg)
		all.minus:SetTexture(C.media.backdrop)
		all.minus:SetVertexColor(1, 1, 1)

		all.plus = all:CreateTexture(nil, "OVERLAY")
		all.plus:Size(1, 7)
		all.plus:SetPoint("CENTER", all.bg)
		all.plus:SetTexture(C.media.backdrop)
		all.plus:SetVertexColor(1, 1, 1)

		hooksecurefunc("TradeSkillFrame_Update", function()
			local numTradeSkills = GetNumTradeSkills()
			local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
			local skillIndex, skillButton
			local buttonHighlight
			local diplayedSkills = TRADE_SKILLS_DISPLAYED
			local hasFilterBar = TradeSkillFilterBar:IsShown()
			if  hasFilterBar then
				diplayedSkills = TRADE_SKILLS_DISPLAYED - 1
			end
			local buttonIndex = 0

			for i = 1, diplayedSkills do
				skillIndex = i + skillOffset
				_, skillType, _, isExpanded = GetTradeSkillInfo(skillIndex)
				if hasFilterBar then
					buttonIndex = i + 1
				else
					buttonIndex = i
				end

				skillButton = _G["TradeSkillSkill"..buttonIndex]

				if not skillButton.reskinned then
					skillButton.reskinned = true

					skillButton:SetNormalTexture("")
					skillButton.SetNormalTexture = F.dummy
					skillButton:SetPushedTexture("")
					buttonHighlight = _G["TradeSkillSkill"..buttonIndex.."Highlight"]
					buttonHighlight:SetTexture("")
					buttonHighlight.SetTexture = F.dummy

					skillButton.bg = CreateFrame("Frame", nil, skillButton)
					skillButton.bg:Size(13, 13)
					skillButton.bg:Point("LEFT", 4, 0)
					skillButton.bg:SetFrameLevel(skillButton:GetFrameLevel()-1)
					S.CreateBD(skillButton.bg, 0)	

					skillButton.tex = skillButton:CreateTexture(nil, "BACKGROUND")
					skillButton.tex:SetAllPoints(skillButton.bg)
					skillButton.tex:SetTexture(C.media.backdrop)
					skillButton.tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

					skillButton.minus = skillButton:CreateTexture(nil, "OVERLAY")
					skillButton.minus:Size(7, 1)
					skillButton.minus:SetPoint("CENTER", skillButton.bg)
					skillButton.minus:SetTexture(C.media.backdrop)
					skillButton.minus:SetVertexColor(1, 1, 1)

					skillButton.plus = skillButton:CreateTexture(nil, "OVERLAY")
					skillButton.plus:Size(1, 7)
					skillButton.plus:SetPoint("CENTER", skillButton.bg)
					skillButton.plus:SetTexture(C.media.backdrop)
					skillButton.plus:SetVertexColor(1, 1, 1)
				end

				if skillIndex <= numTradeSkills then
					if skillType == "header" then
						skillButton.bg:Show()
						skillButton.tex:Show()
						skillButton.minus:Show()
						if isExpanded then
							skillButton.plus:Hide()
						else
							skillButton.plus:Show()
						end
					else
						skillButton.bg:Hide()
						skillButton.tex:Hide()
						skillButton.minus:Hide()
						skillButton.plus:Hide()	
					end
				end

				if TradeSkillCollapseAllButton.collapsed == 1 then
					TradeSkillCollapseAllButton.plus:Show()
				else
					TradeSkillCollapseAllButton.plus:Hide()
				end
			end
		end)

		TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -9, 0)

		S.ReskinClose(TradeSkillFrameCloseButton)
		S.ReskinClose(TradeSkillGuildFrameCloseButton)
		S.ReskinScroll(TradeSkillDetailScrollFrameScrollBar)
		S.ReskinScroll(TradeSkillListScrollFrameScrollBar)
		S.ReskinInput(TradeSkillInputBox, nil, nil, -2, 2)
		S.ReskinInput(TradeSkillInputBox)
		S.ReskinInput(TradeSkillFrameSearchBox)
		F.ReskinArrow(TradeSkillDecrementButton, 1)
		F.ReskinArrow(TradeSkillIncrementButton, 2)
		F.ReskinArrow(TradeSkillLinkButton, 2)
	elseif addon == "Blizzard_TrainerUI" then
		S.SetBD(ClassTrainerFrame)
		ClassTrainerFrame:DisableDrawLayer("BACKGROUND")
		ClassTrainerFrame:DisableDrawLayer("BORDER")
		ClassTrainerFrameInset:DisableDrawLayer("BORDER")
		ClassTrainerFrameBottomInset:DisableDrawLayer("BORDER")
		ClassTrainerFrameInsetBg:Hide()
		ClassTrainerFramePortrait:Hide()
		ClassTrainerFramePortraitFrame:Hide()
		ClassTrainerFrameTopBorder:Hide()
		ClassTrainerFrameTopRightCorner:Hide()
		ClassTrainerFrameBottomInsetBg:Hide()
		ClassTrainerTrainButton_LeftSeparator:Hide()
		ClassTrainerFrameMoneyBg:SetAlpha(0)
		
		ClassTrainerStatusBarSkillRank:ClearAllPoints()
		ClassTrainerStatusBarSkillRank:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)

		local bg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
		bg:Point("TOPLEFT", 42, -2)
		bg:Point("BOTTOMRIGHT", 0, 2)
		bg:SetFrameLevel(ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
		S.CreateBD(bg, .25)

		ClassTrainerFrameSkillStepButton:SetHighlightTexture(nil)
		select(7, ClassTrainerFrameSkillStepButton:GetRegions()):SetAlpha(0)

		local check = select(4, ClassTrainerFrameSkillStepButton:GetRegions())
		check:Point("TOPLEFT", 43, -3)
		check:Point("BOTTOMRIGHT", -1, 3)
		check:SetTexture(C.media.backdrop)
		check:SetVertexColor(r, g, b, .2)

		local icbg = CreateFrame("Frame", nil, ClassTrainerFrameSkillStepButton)
		icbg:Point("TOPLEFT", ClassTrainerFrameSkillStepButtonIcon, -1, 1)
		icbg:Point("BOTTOMRIGHT", ClassTrainerFrameSkillStepButtonIcon, 1, -1)
		S.CreateBD(icbg, 0)

		ClassTrainerFrameSkillStepButtonIcon:SetTexCoord(.08, .92, .08, .92)

		for i = 1, 8 do
			local bu = _G["ClassTrainerScrollFrameButton"..i]
			local ic = _G["ClassTrainerScrollFrameButton"..i.."Icon"]

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", 42, -6)
			bg:Point("BOTTOMRIGHT", 0, 6)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)

			bu.name:SetParent(bg)
			bu.name:Point("TOPLEFT", ic, "TOPRIGHT", 6, -2)
			bu.subText:SetParent(bg)
			bu.money:SetParent(bg)
			bu.money:Point("TOPRIGHT", bu, "TOPRIGHT", 5, -8)
			bu:SetHighlightTexture(nil)
			bu.disabledBG:Hide()
			bu.disabledBG.Show = F.dummy
			select(5, bu:GetRegions()):SetAlpha(0)

			local check = select(2, bu:GetRegions())
			check:Point("TOPLEFT", 43, -6)
			check:Point("BOTTOMRIGHT", -1, 7)
			check:SetTexture(C.media.backdrop)
			check:SetVertexColor(r, g, b, .2)

			ic:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(ic)
		end

		ClassTrainerStatusBarLeft:Hide()
		ClassTrainerStatusBarMiddle:Hide()
		ClassTrainerStatusBarRight:Hide()
		ClassTrainerStatusBarBackground:Hide()
		ClassTrainerStatusBar:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 64, -35)
		ClassTrainerStatusBar:SetStatusBarTexture(C.media.backdrop)

		ClassTrainerStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

		local bd = CreateFrame("Frame", nil, ClassTrainerStatusBar)
		bd:Point("TOPLEFT", -1, 1)
		bd:Point("BOTTOMRIGHT", 1, -1)
		bd:SetFrameLevel(ClassTrainerStatusBar:GetFrameLevel()-1)
		S.CreateBD(bd, .25)
		
		local moneyBg = CreateFrame("Frame", nil, ClassTrainerFrame)
		moneyBg:SetPoint("TOPLEFT", ClassTrainerFrameMoneyBg)
		moneyBg:Point("BOTTOMRIGHT", ClassTrainerFrameMoneyBg, 0, 12)
		moneyBg:SetFrameLevel(ClassTrainerFrame:GetFrameLevel()-1)
		S.CreateBD(moneyBg, .25)
		
		S.Reskin(ClassTrainerTrainButton)

		S.ReskinClose(ClassTrainerFrameCloseButton)
		S.ReskinScroll(ClassTrainerScrollFrameScrollBar)
		F.ReskinDropDown(ClassTrainerFrameFilterDropDown)
	elseif addon == "Blizzard_VoidStorageUI" then
		S.SetBD(VoidStorageFrame, 20, 0, 0, 20)
		S.CreateBD(VoidStoragePurchaseFrame)
		VoidStorageBorderFrame:DisableDrawLayer("BORDER")
		VoidStorageDepositFrame:DisableDrawLayer("BACKGROUND")
		VoidStorageDepositFrame:DisableDrawLayer("BORDER")
		VoidStorageWithdrawFrame:DisableDrawLayer("BACKGROUND")
		VoidStorageWithdrawFrame:DisableDrawLayer("BORDER")
		VoidStorageCostFrame:DisableDrawLayer("BACKGROUND")
		VoidStorageCostFrame:DisableDrawLayer("BORDER")
		VoidStorageStorageFrame:DisableDrawLayer("BACKGROUND")
		VoidStorageStorageFrame:DisableDrawLayer("BORDER")
		VoidStorageFrameMarbleBg:Hide()
		select(2, VoidStorageFrame:GetRegions()):Hide()
		VoidStorageFrameLines:Hide()
		VoidStorageBorderFrameTitleBg:Hide()
		VoidStorageBorderFrameTopLeftCorner:Hide()
		VoidStorageBorderFrameTopBorder:Hide()
		VoidStorageBorderFrameTopRightCorner:Hide()
		VoidStorageBorderFrameTopEdge:Hide()
		VoidStorageBorderFrameHeader:Hide()
		VoidStorageStorageFrameLine1:Hide()
		VoidStorageStorageFrameLine2:Hide()
		VoidStorageStorageFrameLine3:Hide()
		VoidStorageStorageFrameLine4:Hide()
		select(12, VoidStorageDepositFrame:GetRegions()):Hide()
		select(12, VoidStorageWithdrawFrame:GetRegions()):Hide()
		VoidStorageBorderFrameBg:SetAlpha(0)
		for i = 1, 10 do
			select(i, VoidStoragePurchaseFrame:GetRegions()):Hide()
		end

		for i = 1, 9 do
			local bu1 = _G["VoidStorageDepositButton"..i]
			local bu2 = _G["VoidStorageWithdrawButton"..i]

			bu1:SetPushedTexture("")
			bu2:SetPushedTexture("")

			_G["VoidStorageDepositButton"..i.."Bg"]:Hide()
			_G["VoidStorageWithdrawButton"..i.."Bg"]:Hide()

			_G["VoidStorageDepositButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G["VoidStorageWithdrawButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

			local bg1 = CreateFrame("Frame", nil, bu1)
			bg1:Point("TOPLEFT", -1, 1)
			bg1:Point("BOTTOMRIGHT", 1, -1)
			bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
			S.CreateBD(bg1, .25)

			local bg2 = CreateFrame("Frame", nil, bu2)
			bg2:Point("TOPLEFT", -1, 1)
			bg2:Point("BOTTOMRIGHT", 1, -1)
			bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
			S.CreateBD(bg2, .25)
		end

		for i = 1, 80 do
			local bu = _G["VoidStorageStorageButton"..i]

			bu:SetPushedTexture("")

			_G["VoidStorageStorageButton"..i.."Bg"]:Hide()
			_G["VoidStorageStorageButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:Point("TOPLEFT", -1, 1)
			bg:Point("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bg, .25)
		end

		S.Reskin(VoidStoragePurchaseButton)
		S.Reskin(VoidStorageHelpBoxButton)
		S.Reskin(VoidStorageTransferButton)
		S.ReskinClose(VoidStorageBorderFrameCloseButton)
		S.ReskinInput(VoidItemSearchBox)
	elseif addon == "DBM-Core" then
		local first = true
		hooksecurefunc(DBM.RangeCheck, "Show", function()
			if first == true then
				DBMRangeCheck:SetBackdrop(nil)
				local bd = CreateFrame("Frame", nil, DBMRangeCheck)
				bd:SetPoint("TOPLEFT")
				bd:SetPoint("BOTTOMRIGHT")
				bd:SetFrameLevel(DBMRangeCheck:GetFrameLevel()-1)
				S.CreateBD(bd)
				first = false
			end
		end)
	end
	--RaidFrame Skin
	for i = 1, 8 do
		if _G["RaidGroup"..i] then 
			S.StripTextures(_G["RaidGroup"..i])
		end
		for f = 1, 5 do
			if _G["RaidGroup"..i.."Slot"..f] then 
				_G["RaidGroup"..i.."Slot"..f]:Hide()
			end
		end
	end
	for i = 1, 40 do
		if _G["RaidGroupButton"..i] then 
			S.StripTextures(_G["RaidGroupButton"..i])
			S.Reskin(_G["RaidGroupButton"..i])
		end
	end
end)

-- [[ Mac Options ]]

if IsMacClient() then
	S.CreateBD(MacOptionsFrame)
	MacOptionsFrameHeader:SetTexture("")
	MacOptionsFrameHeader:ClearAllPoints()
	MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
	S.CreateBD(MacOptionsFrameMovieRecording, .25)
	S.CreateBD(MacOptionsITunesRemote, .25)
	S.CreateBD(MacOptionsFrameMisc, .25)

	S.Reskin(MacOptionsButtonKeybindings)
	S.Reskin(MacOptionsButtonCompress)
	S.Reskin(MacOptionsFrameCancel)
	S.Reskin(MacOptionsFrameOkay)
	S.Reskin(MacOptionsFrameDefaults)

	F.ReskinDropDown(MacOptionsFrameResolutionDropDown)
	F.ReskinDropDown(MacOptionsFrameFramerateDropDown)
	F.ReskinDropDown(MacOptionsFrameCodecDropDown)

	for i = 1, 10 do
		F.ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
	end
	F.ReskinSlider(MacOptionsFrameQualitySlider)
 
	MacOptionsButtonCompress:SetWidth(136)
 
	MacOptionsFrameCancel:SetWidth(96)
	MacOptionsFrameCancel:SetHeight(22)
	MacOptionsFrameCancel:ClearAllPoints()
	MacOptionsFrameCancel:Point("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)
 
	MacOptionsFrameOkay:SetWidth(96)
	MacOptionsFrameOkay:SetHeight(22)
	MacOptionsFrameOkay:ClearAllPoints()
	MacOptionsFrameOkay:Point("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)
 
	MacOptionsButtonKeybindings:SetWidth(96)
	MacOptionsButtonKeybindings:SetHeight(22)
	MacOptionsButtonKeybindings:ClearAllPoints()
	MacOptionsButtonKeybindings:Point("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)
 
	MacOptionsFrameDefaults:SetWidth(96)
	MacOptionsFrameDefaults:SetHeight(22)
end

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not(IsAddOnLoaded("CowTip") or IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("lolTip") or IsAddOnLoaded("StarTip") or IsAddOnLoaded("TipTop")) then
		local tooltips = {
			"GameTooltip",
			"ItemRefTooltip",
			"ShoppingTooltip1",
			"ShoppingTooltip2",
			"ShoppingTooltip3",
			"WorldMapTooltip",
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}

		for i = 1, #tooltips do
			local t = _G[tooltips[i]]
			t:SetBackdrop(nil)
			local bg = CreateFrame("Frame", nil, t)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT")
			bg:SetFrameLevel(t:GetFrameLevel()-1)
			S.CreateBD(bg, .6)
		end

		local sb = _G["GameTooltipStatusBar"]
		sb:SetHeight(3)
		sb:ClearAllPoints()
		sb:Point("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 1, 1)
		sb:Point("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 1)
		sb:SetStatusBarTexture(C.media.backdrop)

		local sep = GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
		sep:SetHeight(1)
		sep:Point("BOTTOMLEFT", 0, 3)
		sep:Point("BOTTOMRIGHT", 0, 3)
		sep:SetTexture(C.media.backdrop)
		sep:SetVertexColor(0, 0, 0)

		S.CreateBD(FriendsTooltip)
	end
	if not(IsAddOnLoaded("MetaMap") or IsAddOnLoaded("m_Map") or IsAddOnLoaded("Mapster") or IsAddOnLoaded("!SunUI")) then
		WorldMapFrameMiniBorderLeft:SetAlpha(0)
		WorldMapFrameMiniBorderRight:SetAlpha(0)

		local scale = WORLDMAP_WINDOWED_SIZE
		local mapbg = CreateFrame("Frame", nil, WorldMapDetailFrame)
		mapbg:SetPoint("TOPLEFT", -1 / scale, 1 / scale)
		mapbg:SetPoint("BOTTOMRIGHT", 1 / scale, -1 / scale)
		mapbg:SetFrameLevel(0)
		mapbg:SetBackdrop({ 
			bgFile = C.media.backdrop, 
		})
		mapbg:SetBackdropColor(0, 0, 0)

		local frame = CreateFrame("Frame",nil,WorldMapButton)
		frame:SetFrameStrata("HIGH")

		local function skinmap()
			WorldMapFrameMiniBorderLeft:SetAlpha(0)
			WorldMapFrameMiniBorderRight:SetAlpha(0)
			WorldMapFrameCloseButton:ClearAllPoints()
			WorldMapFrameCloseButton:Point("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
			WorldMapFrameCloseButton:SetFrameStrata("HIGH")
			WorldMapFrameSizeUpButton:ClearAllPoints()
			WorldMapFrameSizeUpButton:Point("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
			WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
			WorldMapFrameTitle:ClearAllPoints()
			WorldMapFrameTitle:Point("BOTTOMLEFT", WorldMapDetailFrame, 9, 5)
			WorldMapFrameTitle:SetParent(frame)
			WorldMapFrameTitle:SetFont(DB.Font, 18, "OUTLINE")
			WorldMapFrameTitle:SetShadowOffset(0, 0)
			WorldMapFrameTitle:SetTextColor(1, 1, 1)
			WorldMapQuestShowObjectives:SetParent(frame)
			WorldMapQuestShowObjectives:ClearAllPoints()
			WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT")
			WorldMapQuestShowObjectivesText:ClearAllPoints()
			WorldMapQuestShowObjectivesText:Point("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
			WorldMapQuestShowObjectivesText:SetFont(DB.Font, 18, "OUTLINE")
			WorldMapQuestShowObjectivesText:SetShadowOffset(0, 0)
			WorldMapQuestShowObjectivesText:SetTextColor(1, 1, 1)
			WorldMapTrackQuest:SetParent(frame)
			WorldMapTrackQuest:ClearAllPoints()
			WorldMapTrackQuest:Point("TOPLEFT", WorldMapDetailFrame, 9, -5)
			WorldMapTrackQuestText:SetFont(DB.Font, 18, "OUTLINE")
			WorldMapTrackQuestText:SetShadowOffset(0, 0)
			WorldMapTrackQuestText:SetTextColor(1, 1, 1)
			WorldMapShowDigSites:SetParent(frame)
			WorldMapShowDigSites:ClearAllPoints()
			WorldMapShowDigSites:Point("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 19)
			WorldMapShowDigSitesText:SetFont(DB.Font, 18, "OUTLINE")
			WorldMapShowDigSitesText:SetShadowOffset(0, 0)
			WorldMapShowDigSitesText:ClearAllPoints()
			WorldMapShowDigSitesText:Point("RIGHT",WorldMapShowDigSites,"LEFT",-4,1)
			WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
		end

		skinmap()
		hooksecurefunc("WorldMap_ToggleSizeDown", skinmap)

		F.ReskinDropDown(WorldMapLevelDropDown)
		F.ReskinCheck(WorldMapShowDigSites)
		F.ReskinCheck(WorldMapQuestShowObjectives)
		F.ReskinCheck(WorldMapTrackQuest)
	end

	if not(IsAddOnLoaded("Baggins") or IsAddOnLoaded("Stuffing") or IsAddOnLoaded("Combuctor") or IsAddOnLoaded("cargBags") or IsAddOnLoaded("famBags") or IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("Bagnon") or IsAddOnLoaded("!SunUI")) then
		for i = 1, 12 do
			local con = _G["ContainerFrame"..i]

			for j = 1, 7 do
				select(j, con:GetRegions()):SetAlpha(0)
			end

			for k = 1, MAX_CONTAINER_ITEMS do
				local item = "ContainerFrame"..i.."Item"..k
				local button = _G[item]
				local icon = _G[item.."IconTexture"]
				local quest = _G[item.."IconQuestTexture"]

				button:SetNormalTexture("")
				button:SetPushedTexture("")

				icon:Point("TOPLEFT", 1, -1)
				icon:Point("BOTTOMRIGHT", -1, 1)
				icon:SetTexCoord(.08, .92, .08, .92)

				quest:SetTexture("Interface\\AddOns\\!SunUI\\Media\\quest")
				quest:SetVertexColor(1, 0, 0)
				quest:SetTexCoord(0.05, .955, 0.05, .965)
				quest.SetTexture = F.dummy

				S.CreateBD(button, 0)
			end

			local f = CreateFrame("Frame", nil, con)
			f:Point("TOPLEFT", 8, -4)
			f:Point("BOTTOMRIGHT", -4, 3)
			f:SetFrameLevel(con:GetFrameLevel()-1)
			S.CreateBD(f, .6)

			S.ReskinClose(_G["ContainerFrame"..i.."CloseButton"], "TOPRIGHT", con, "TOPRIGHT", -6, -6)
		end

		BackpackTokenFrame:GetRegions():Hide()

		for i = 1, 3 do
			local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
			ic:SetDrawLayer("OVERLAY")
			ic:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(ic)
		end

		S.SetBD(BankFrame, 28, -8, -30, 96)
		BankPortraitTexture:Hide()
		select(2, BankFrame:GetRegions()):Hide()
		S.Reskin(BankFramePurchaseButton)
		S.ReskinClose(BankCloseButton, "TOPRIGHT", BankFrame, "TOPRIGHT", -34, -12)

		for i = 1, 28 do
			local item = "BankFrameItem"..i
			local button = _G[item]
			local icon = _G[item.."IconTexture"]
			local quest = _G[item.."IconQuestTexture"]

			button:SetNormalTexture("")
			button:SetPushedTexture("")

			icon:Point("TOPLEFT", 1, -1)
			icon:Point("BOTTOMRIGHT", -1, 1)
			icon:SetTexCoord(.08, .92, .08, .92)

			quest:SetTexture("Interface\\AddOns\\!SunUI\\Media\\quest")
			quest:SetVertexColor(1, 0, 0)
			quest:SetTexCoord(0.05, .955, 0.05, .965)
			quest.SetTexture = F.dummy

			S.CreateBD(button, 0)
		end

		for i = 1, 7 do
			local bag = _G["BankFrameBag"..i]
			local ic = _G["BankFrameBag"..i.."IconTexture"]
			_G["BankFrameBag"..i.."HighlightFrameTexture"]:SetTexture(C.media.checked)

			bag:SetNormalTexture("")
			bag:SetPushedTexture("")

			ic:Point("TOPLEFT", 1, -1)
			ic:Point("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			S.CreateBD(bag, 0)
		end
	end

	if not(IsAddOnLoaded("Butsu") or IsAddOnLoaded("LovelyLoot") or IsAddOnLoaded("XLoot")) then
		LootFramePortraitOverlay:Hide()
		select(2, LootFrame:GetRegions()):Hide()
		S.ReskinClose(LootCloseButton, "CENTER", LootFrame, "TOPRIGHT", -81, -26)

		LootFrame.bg = CreateFrame("Frame", nil, LootFrame)
		LootFrame.bg:SetFrameLevel(LootFrame:GetFrameLevel()-1)
		LootFrame.bg:Point("TOPLEFT", LootFrame, "TOPLEFT", 20, -12)
		LootFrame.bg:Point("BOTTOMRIGHT", LootFrame, "BOTTOMRIGHT", -66, 12)

		S.CreateBD(LootFrame.bg)

		select(3, LootFrame:GetRegions()):Point("TOP", LootFrame.bg, "TOP", 0, -8)

		for i = 1, LOOTFRAME_NUMBUTTONS do
			local bu = _G["LootButton"..i]
			local ic = _G["LootButton"..i.."IconTexture"]
			_G["LootButton"..i.."IconQuestTexture"]:SetAlpha(0)
			_G["LootButton"..i.."NameFrame"]:Hide()

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:Point("BOTTOMRIGHT", 126, 0)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			S.CreateBD(bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = S.CreateBG(ic)


		end

		hooksecurefunc("LootFrame_UpdateButton", function(index)
			local ic = _G["LootButton"..index.."IconTexture"]
			if select(6, GetLootSlotInfo(index)) then
				ic.bg:SetVertexColor(1, 0, 0)
			else
				ic.bg:SetVertexColor(0, 0, 0)
			end
		end)
	end
end)
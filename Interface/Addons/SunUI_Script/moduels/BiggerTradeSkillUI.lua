local S, C, L, DB = unpack(SunUI)
local addonName, BTSUi = ...
local Launch = CreateFrame("Frame")
Launch:RegisterEvent("ADDON_LOADED")
Launch:SetScript("OnEvent", function(self, event)
 if   IsAddOnLoaded("Blizzard_TradeSkillUI") then
TRADE_SKILLS_DISPLAYED = 25


-- Add skill buttons if needed
for i=1, TRADE_SKILLS_DISPLAYED do
	if (not _G["TradeSkillSkill"..i]) then
		-- Create a new button
		local newSkillButton = CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillSkill1:GetParent(), "TradeSkillSkillButtonTemplate")
		newSkillButton:SetPoint("TOPLEFT", _G["TradeSkillSkill"..(i-1)], "BOTTOMLEFT")
	end
end   


-- Resize the main window
TradeSkillFrame:SetWidth(570)
TradeSkillFrame:SetHeight(525)

-- Hide Horizontal bar in the default UI
TradeSkillHorizontalBarLeft:Hide()

-- Move skillbar
TradeSkillRankFrame:ClearAllPoints()
TradeSkillRankFrame:SetPoint("TOPRIGHT", TradeSkillRankFrame:GetParent(), "TOPRIGHT", -37, -33)

-- Setup search box
TradeSkillFrameSearchBox:ClearAllPoints()
TradeSkillFrameSearchBox:SetPoint("TOPLEFT", TradeSkillFrameSearchBox:GetParent(), "TOPLEFT", 75, -56)
TradeSkillFrameSearchBox:SetPoint("RIGHT", TradeSkillRankFrame, "LEFT", -8, 0)

-- Blizzard FilterButton
TradeSkillFilterButton:Hide()

-- Mats filter
if (not BTSUiHaveMatsCheck) then
	CreateFrame("CheckButton", "BTSUiHaveMatsCheck", TradeSkillFrame, "UICheckButtonTemplate ")
end 

BTSUiHaveMatsCheck:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 66, -29)
BTSUiHaveMatsCheck:SetWidth(24)
BTSUiHaveMatsCheck:SetHeight(24)
BTSUiHaveMatsCheckText:SetText(CRAFT_IS_MAKEABLE)
BTSUiHaveMatsCheckText:SetWidth(80)
BTSUiHaveMatsCheckText:SetJustifyH("LEFT")
BTSUiHaveMatsCheck:SetHitRectInsets(0, -1 * BTSUiHaveMatsCheckText:GetWidth() , 0, 0) -- Increase click area so text is also clickable

BTSUiHaveMatsCheck:SetScript("OnClick", function(self)
	TradeSkillFrame.filterTbl.hasMaterials = not TradeSkillFrame.filterTbl.hasMaterials
	TradeSkillOnlyShowMakeable(TradeSkillFrame.filterTbl.hasMaterials)
	TradeSkillUpdateFilterBar()
end)   

function BTSUi.TradeSkillOnlyShowMakeable(show)
	BTSUiHaveMatsCheck:SetChecked(show)
end

-- Skillup filter
if (not BTSUiOnlySkillupCheck) then
	CreateFrame("CheckButton", "BTSUiOnlySkillupCheck", TradeSkillFrame, "UICheckButtonTemplate")
end 

BTSUiOnlySkillupCheck:SetPoint("LEFT", BTSUiHaveMatsCheck, "RIGHT", 80, 0)
BTSUiOnlySkillupCheck:SetWidth(24)
BTSUiOnlySkillupCheck:SetHeight(24)
BTSUiOnlySkillupCheckText:SetText(TRADESKILL_FILTER_HAS_SKILL_UP)
BTSUiOnlySkillupCheckText:SetWidth(80)
BTSUiOnlySkillupCheckText:SetJustifyH("LEFT")
BTSUiOnlySkillupCheck:SetHitRectInsets(0, -1 * BTSUiOnlySkillupCheckText:GetWidth() , 0, 0) -- Increase click area so text is also clickable

BTSUiOnlySkillupCheck:SetScript("OnClick", function(self)
      TradeSkillFrame.filterTbl.hasSkillUp = not TradeSkillFrame.filterTbl.hasSkillUp
      TradeSkillOnlyShowSkillUps(TradeSkillFrame.filterTbl.hasSkillUp)
      TradeSkillUpdateFilterBar()
end)

function BTSUi.TradeSkillOnlyShowSkillUps(show)
    BTSUiOnlySkillupCheck:SetChecked(show)
end

-- Subclass filter
if not BTSUiSubClassFilterDropDown then
   CreateFrame("Button", "BTSUiSubClassFilterDropDown", TradeSkillFrame, "UIDropDownMenuTemplate")
end

BTSUiSubClassFilterDropDown:ClearAllPoints()
BTSUiSubClassFilterDropDown:SetPoint("TOPLEFT", TradeSkillRankFrame, "BOTTOMLEFT", -20, -4)
BTSUiSubClassFilterDropDown:Show()
BTSUiSubClassFilterDropDownButton:SetHitRectInsets(-110, 0, 0, 0) -- To make Text part of combobox clickable

UIDropDownMenu_SetWidth(BTSUiSubClassFilterDropDown, 115); -- Need to set the width explicitly so text will be truncated correctly

-- Slot filter
if not BTSUiSlotFilterDropDown then
   CreateFrame("Button", "BTSUiSlotFilterDropDown", TradeSkillFrame, "UIDropDownMenuTemplate")
end

BTSUiSlotFilterDropDown:ClearAllPoints()
BTSUiSlotFilterDropDown:SetPoint("TOP", BTSUiSubClassFilterDropDown, "TOP")
BTSUiSlotFilterDropDown:SetPoint("RIGHT", TradeSkillFrame, "RIGHT", 9, 0)
BTSUiSlotFilterDropDown:Show()
BTSUiSlotFilterDropDownButton:SetHitRectInsets(-110, 0, 0, 0) -- To make Text part of combobox clickable

UIDropDownMenu_SetWidth(BTSUiSlotFilterDropDown, 115); -- Need to set the width explicitly so text will be truncated correctly

-- Add a vertical bar between the recipelist and the details pane
-- Usually the scrollbar will be over it, but when there is no scrollbar this one shows and looks better
if (not BTSUiVerticalBarTop) then
   BTSUiVerticalBarTop = TradeSkillFrame:CreateTexture("BTSUiVerticalBarTop", "BACKGROUND")
end
BTSUiVerticalBarTop:SetTexture(nil)
BTSUiVerticalBarTop:SetTexCoord(0, 0.1875, 0, 1.0) 
BTSUiVerticalBarTop:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame, "TOPLEFT", -7, 0)
BTSUiVerticalBarTop:SetWidth(8)
BTSUiVerticalBarTop:SetHeight(128)

if (not BTSUiVerticalBarMiddle) then
   BTSUiVerticalBarMiddle = TradeSkillFrame:CreateTexture("BTSUiVerticalBarMiddle", "BACKGROUND")
end
BTSUiVerticalBarMiddle:SetTexture(nil)
BTSUiVerticalBarMiddle:SetTexCoord(0.421875, 0.5625, 0, 1.0) 
BTSUiVerticalBarMiddle:SetPoint("TOPLEFT", BTSUiVerticalBarTop, "BOTTOMLEFT", 0, 0)
BTSUiVerticalBarMiddle:SetWidth(7)
BTSUiVerticalBarMiddle:SetHeight(159)

if (not BTSUiVerticalBarBottom) then
   BTSUiVerticalBarBottom = TradeSkillFrame:CreateTexture("BTSUiVerticalBarBottom", "BACKGROUND")
end
BTSUiVerticalBarBottom:SetTexture(nil)
BTSUiVerticalBarBottom:SetTexCoord(0.8125, 1, 0, 1.0) 
BTSUiVerticalBarBottom:SetPoint("TOPLEFT", BTSUiVerticalBarMiddle, "BOTTOMLEFT", 0, 0)
BTSUiVerticalBarBottom:SetWidth(8)
BTSUiVerticalBarBottom:SetHeight(128)

-- Detail frame with the ingredients
TradeSkillDetailScrollFrame:ClearAllPoints()
TradeSkillDetailScrollFrame:SetPoint("RIGHT", TradeSkillFrame, "RIGHT", -31, 0)
TradeSkillDetailScrollFrame:SetPoint("LEFT", TradeSkillFrame, "RIGHT", -260, 0)
TradeSkillDetailScrollFrame:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -86)
TradeSkillDetailScrollFrame:SetPoint("BOTTOM", TradeSkillFrame, "BOTTOM", 0, 30)

-- Re-anchor icons, text and stuff
TradeSkillDetailHeaderLeft:SetPoint("TOPLEFT", TradeSkillDetailScrollChildFrame, "TOPLEFT", 3, -5)
TradeSkillDetailHeaderLeft:SetWidth(140)
TradeSkillDetailHeaderLeft:Hide()

TradeSkillSkillIcon:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "TOPLEFT", 8, -6)


TradeSkillSkillName:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "TOPLEFT", 50, -4)
TradeSkillSkillName:SetPoint("RIGHT", TradeSkillDetailScrollFrame, "RIGHT", -5, 0)
TradeSkillSkillName:SetHeight(40)
TradeSkillSkillName:SetWidth(200)
-- Description and requirements swapped places cause it looks better.
-- Note that the anchors get reset when the recipe detail display is updated
-- So need to reapply this when that happens (hook TradeSkillFrame_SetSelection)
-- The values in the hook function are leading when they are different from here
TradeSkillDescription:SetPoint("TOPLEFT", TradeSkillDetailHeaderLeft, "BOTTOMLEFT", 5, 5)
TradeSkillDescription:SetWidth(220)  -- Set a width that matches the real width for the autosizing 
                                     -- to work. Smaller widths seem to add height, bigger widths 
                                     -- will cut off the text instead of expanding the textheight

-- Recolor label so it looks better
TradeSkillRequirementLabel:SetTextColor(TradeSkillReagentLabel:GetTextColor())
TradeSkillRequirementLabel:SetShadowColor(TradeSkillReagentLabel:GetShadowColor())
TradeSkillRequirementLabel:SetPoint("TOPLEFT", TradeSkillDescription, "BOTTOMLEFT", 0, -15)
TradeSkillRequirementText:SetPoint("TOPLEFT", TradeSkillRequirementLabel, "BOTTOMLEFT", 0, 0)
TradeSkillRequirementText:SetText(nil)
TradeSkillReagentLabel:SetPoint("TOPLEFT", TradeSkillRequirementText, "BOTTOMLEFT", 0, -15)
_G["TradeSkillReagent1"]:SetWidth(180)
-- Reposition reagent buttons
for i=2, MAX_TRADE_SKILL_REAGENTS do
   local reagentButton = _G["TradeSkillReagent"..i]
   reagentButton:SetWidth(180)
   reagentButton:ClearAllPoints()
   reagentButton:SetPoint("TOPLEFT", _G["TradeSkillReagent"..(i-1)], "BOTTOMLEFT", 0, -3)
   --reagentButton:SetPoint("RIGHT", TradeSkillDetailScrollFrame, "RIGHT")
end

-- Background for reagents/detailarea
-- Note that the background is also needed to hide a part of the original
-- horizontal bar that I can't figure out how to hide.
local detailBackground = TradeSkillDetailScrollFrame:CreateTexture(nil,"BACKGROUND")
detailBackground:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame)
detailBackground:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -10, 29)
detailBackground:SetTexCoord(0, 0.2, 0, 1)  -- Mess with TexCoords so the texture does not look too compressed/stretched
detailBackground:SetTexture(nil)
--detailBackground:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment")
--detailBackground:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble")

-- Scrollbar of the recipe list
TradeSkillListScrollFrame:ClearAllPoints()
TradeSkillListScrollFrame:SetPoint("TOPRIGHT", TradeSkillDetailScrollFrame, "TOPLEFT", -15, 0)
TradeSkillListScrollFrame:SetPoint("BOTTOMRIGHT", TradeSkillDetailScrollFrame, "BOTTOMLEFT", -15, 0)

if (not BTSUiTradeSkillListScrollBarMiddle) then
   -- Use horrible random name for texture. When using a proper name like BTSUiTradeSkillListScrollBarMiddle
   -- the top and bottom parts of the scrollbar disappear
   BTSUiTradeSkillListScrollBarMiddle = TradeSkillListScrollFrame:CreateTexture("kjfeowjpfa", "BACKGROUND")
end
BTSUiTradeSkillListScrollBarMiddle:SetTexture(nil)
BTSUiTradeSkillListScrollBarMiddle:SetTexCoord(0, 0.45, 0.1640625, 1)
BTSUiTradeSkillListScrollBarMiddle:SetPoint("TOPRIGHT", TradeSkillListScrollFrame, "TOPRIGHT", 27, -110)
BTSUiTradeSkillListScrollBarMiddle:SetPoint("BOTTOMRIGHT", TradeSkillListScrollFrame, "BOTTOMRIGHT", 27, 120)
BTSUiTradeSkillListScrollBarMiddle:SetWidth(29)

-- Scrollbar of the recipe details list
if (not BTSUiDetailScrollBarMiddle) then
   -- Use horrible random name for texture. When using a proper name like BTSUiTradeSkillListScrollBarMiddle
   -- the top and bottom parts of the scrollbar disappear
   BTSUiDetailScrollBarMiddle = TradeSkillDetailScrollFrame:CreateTexture("afiepipnp", "BACKGROUND")
   -- Additional blackish background for in the scrollbar, just because it looks better
   BTSUiDetailScrollBarMiddleBackground = TradeSkillDetailScrollFrame:CreateTexture("BTSUiMiddle2Background", "BACKGROUND")
end
BTSUiDetailScrollBarMiddle:SetTexture(nil)
BTSUiDetailScrollBarMiddle:SetTexCoord(0, 0.44, 0.1640625, 1)
BTSUiDetailScrollBarMiddle:SetPoint("TOPRIGHT", TradeSkillDetailScrollFrame, "TOPRIGHT", 28, -110)
BTSUiDetailScrollBarMiddle:SetPoint("BOTTOMRIGHT", TradeSkillDetailScrollFrame, "BOTTOMRIGHT", 28, 120)
BTSUiDetailScrollBarMiddle:SetWidth(29)
BTSUiDetailScrollBarMiddle:SetParent(TradeSkillDetailScrollFrameScrollBar)  -- Reparent to make it hide properly

BTSUiDetailScrollBarMiddleBackground:SetTexture(nil)
BTSUiDetailScrollBarMiddleBackground:SetAllPoints(TradeSkillDetailScrollFrameScrollBar)
BTSUiDetailScrollBarMiddleBackground:SetParent(TradeSkillDetailScrollFrameScrollBar)  -- Reparent to make it hide properly
BTSUiDetailScrollBarMiddleBackground:SetTexCoord(0, 0.2, 0, 1)

-- Reposition Create all button, decrement, and editbox.
-- The others are already at the right place
TradeSkillCreateAllButton:ClearAllPoints()
TradeSkillCreateAllButton:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMLEFT", 216, 4)



-- Functions for dropdowns, these are based on the old (3.3.5 patch) Blizzard code
-- Changes are mostly updates to use TradeSkillSetFilter to get the new Filterbar working

function BTSUi.TradeSkillInvSlotDropDown_Initialize()
	BTSUi.TradeSkillFilterFrame_LoadInvSlots(GetTradeSkillInvSlots());
end


function BTSUi.TradeSkillFilterFrame_LoadInvSlots(...)
	local allChecked = GetTradeSkillInvSlotFilter(0);
	local filterCount = select("#", ...);

	local info = UIDropDownMenu_CreateInfo();

	info.text = ALL_INVENTORY_SLOTS;
	info.func = BTSUi.TradeSkillInvSlotDropDownButton_OnClick;
	info.checked = allChecked;

	UIDropDownMenu_AddButton(info);

	local checked;
	for i=1, filterCount, 1 do
		if ( allChecked and filterCount > 1 ) then
			UIDropDownMenu_SetText(BTSUiSlotFilterDropDown, ALL_INVENTORY_SLOTS);
		else
			checked = GetTradeSkillInvSlotFilter(i);
			if ( checked ) then
				UIDropDownMenu_SetText(BTSUiSlotFilterDropDown, select(i, ...));
			end
		end

		info.text = select(i, ...);
		info.func = BTSUi.TradeSkillInvSlotDropDownButton_OnClick;
		info.checked = checked;

		UIDropDownMenu_AddButton(info);
	end
end


function BTSUi.TradeSkillFilterFrame_InvSlotName(...)
	for i=1, select("#", ...), 1 do
		if ( GetTradeSkillInvSlotFilter(i) ) then
			return select(i, ...);
		end
	end
end


function BTSUi.TradeSkillInvSlotDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(BTSUiSlotFilterDropDown, self:GetID());
	SetTradeSkillInvSlotFilter(self:GetID() - 1, 1, 1);
	BTSUiSlotFilterDropDown.selected = BTSUi.TradeSkillFilterFrame_InvSlotName(GetTradeSkillInvSlots());

	local selectedId = self:GetID()
	local selectedName = BTSUi.TradeSkillFilterFrame_InvSlotName(GetTradeSkillInvSlots()) or ""

	BTSUiSlotFilterDropDown.selected = nil
	if (selectedId > 1) then
		BTSUiSlotFilterDropDown.selected = selectedName
	end

	local selectedSubClassId = UIDropDownMenu_GetSelectedID(BTSUiSubClassFilterDropDown)
	local selectedSubClassName = BTSUiSubClassFilterDropDownText:GetText()
	if (selectedSubClassId == 1) then
		selectedSubClassName = ""
	end

	BTSUi.TradeSkillSetFilter(selectedSubClassId-1, selectedId-1, selectedSubClassName, selectedName)
end


function BTSUi.TradeSkillSetFilter(selectedSubclassId, selectedSlotId, selectedSubclassName, selectedSlotName)
--print(selectedSubclassId, "-", selectedSlotId, "-", selectedSubclassName, "-", selectedSlotName)
	TradeSkillSetFilter(selectedSubclassId, selectedSlotId, selectedSubclassName, selectedSlotName)
end


function BTSUi.TradeSkillSubClassDropDown_Initialize()
	BTSUi.TradeSkillFilterFrame_LoadSubClasses(GetTradeSkillSubClasses());
end


function BTSUi.TradeSkillFilterFrame_LoadSubClasses(...)
	local selectedID = UIDropDownMenu_GetSelectedID(BTSUiSubClassFilterDropDown);
	local numSubClasses = select("#", ...);
	local allChecked = GetTradeSkillSubClassFilter(0);

	-- the first button in the list is going to be an "all subclasses" button
	local info = UIDropDownMenu_CreateInfo();
	info.text = ALL_SUBCLASSES;
	info.func = BTSUi.TradeSkillSubClassDropDownButton_OnClick;
	info.checked = allChecked and (selectedID == nil or selectedID == 1);
	UIDropDownMenu_AddButton(info);
	if ( info.checked ) then
		UIDropDownMenu_SetText(BTSUiSubClassFilterDropDown, ALL_SUBCLASSES);
	end

	-- Add buttons for each subclass
	local checked;

	for i=1, select("#", ...), 1 do
		-- if there are no filters then don't check any individual subclasses
		if ( allChecked ) then
			checked = nil;
		else
			checked = GetTradeSkillSubClassFilter(i);
			if ( checked ) then
				UIDropDownMenu_SetText(BTSUiSubClassFilterDropDown, select(i, ...));
			end
		end
		info.text = select(i, ...);
		info.func = BTSUi.TradeSkillSubClassDropDownButton_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end


function BTSUi.TradeSkillSubClassDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(BTSUiSubClassFilterDropDown, self:GetID());
	SetTradeSkillSubClassFilter(self:GetID() - 1, 1, 1);

	if ( self:GetID() ~= 1 ) then
		if ( BTSUi.TradeSkillFilterFrame_InvSlotName(GetTradeSkillInvSlots()) ~= BTSUiSlotFilterDropDown.selected ) then
			SetTradeSkillInvSlotFilter(0, 1, 1);
			UIDropDownMenu_SetSelectedID(BTSUiSlotFilterDropDown, 1);
			UIDropDownMenu_SetText(BTSUiSlotFilterDropDown, ALL_INVENTORY_SLOTS);
		end
	end

	BTSUi.TradeSkillSetFilter(self:GetID() - 1, UIDropDownMenu_GetSelectedID(BTSUiSlotFilterDropDown)-1, self:GetText(), BTSUi.TradeSkillFilterFrame_InvSlotName(GetTradeSkillInvSlots()) or "")
end


-- This is needed to detect switching between professions and resetting the slot/subclass filters
-- so that no invalid values are selected (for example Plate on the Firstaid profession when switching from BS)
-- Also taken from the old code btw
function BTSUi.TradeSkillFrame_Update()
	local name, rank, maxRank = GetTradeSkillLine();
			
	if ( BTSUi.CURRENT_TRADESKILL ~= name ) then
--		StopTradeSkillRepeat();

		if ( BTSUi.CURRENT_TRADESKILL ~= "" ) then
			-- To fix problem with switching between two tradeskills
			UIDropDownMenu_Initialize(BTSUiSlotFilterDropDown, BTSUi.TradeSkillInvSlotDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(BTSUiSlotFilterDropDown, 1);

			UIDropDownMenu_Initialize(BTSUiSubClassFilterDropDown, BTSUi.TradeSkillSubClassDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(BTSUiSubClassFilterDropDown, 1);
		end
		BTSUi.CURRENT_TRADESKILL = name;
	end
end


-- Controls get reanchored in the TradeSkillFrame_SetSelection function
-- Basically reanchor everything in the detail frame to my liking
function BTSUi.TradeSkillFrame_SetSelection()

	local anchorTo = TradeSkillDetailHeaderLeft
	local anchorOffsetX = 5
	local anchorOffsetY = 5


	-- Cooldown
	if (TradeSkillSkillCooldown:GetText()) then
		TradeSkillSkillCooldown:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY+5) -- +5 looks better

		anchorTo = TradeSkillSkillCooldown
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Description
	if (strlen(TradeSkillDescription:GetText()) <= 2) then  -- <= 2 because there is the text " " in it when empty
		TradeSkillDescription:Hide()
	else
		TradeSkillDescription:Show()
		TradeSkillDescription:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)

		anchorTo = TradeSkillDescription
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Requirements
	if (TradeSkillRequirementText:GetText()) then
		TradeSkillRequirementLabel:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)

		anchorTo = TradeSkillRequirementText
		anchorOffsetX = 0
		anchorOffsetY = -15
	end

	-- Reagents
	TradeSkillReagentLabel:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", anchorOffsetX, anchorOffsetY)
end


-- Hook functions
hooksecurefunc("TradeSkillFrame_Update", BTSUi.TradeSkillFrame_Update)
hooksecurefunc("TradeSkillFrame_SetSelection", BTSUi.TradeSkillFrame_SetSelection)
hooksecurefunc("TradeSkillOnlyShowMakeable", BTSUi.TradeSkillOnlyShowMakeable)
hooksecurefunc("TradeSkillOnlyShowSkillUps", BTSUi.TradeSkillOnlyShowSkillUps)


-- Update the filterdropdowns when the Filterbar is closed
local originalTradeSkillFilterBarExitButtonOnHideHandler = TradeSkillFilterBarExitButton:GetScript("OnHide")
TradeSkillFilterBarExitButton:SetScript("OnHide", function(...)

	if (originalTradeSkillFilterBarExitButtonOnHideHandler) then
		originalTradeSkillFilterBarExitButtonOnHideHandler(...)
	end

	UIDropDownMenu_Initialize(BTSUiSlotFilterDropDown, BTSUi.TradeSkillInvSlotDropDown_Initialize)
	UIDropDownMenu_SetSelectedID(BTSUiSlotFilterDropDown, 1);

	UIDropDownMenu_Initialize(BTSUiSubClassFilterDropDown, BTSUi.TradeSkillSubClassDropDown_Initialize)
	UIDropDownMenu_SetSelectedID(BTSUiSubClassFilterDropDown, 1);

end
)

end
end)
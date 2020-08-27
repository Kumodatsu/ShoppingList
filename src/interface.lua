local addon_name, SL = ...
local M = {}

local entry_width      = 220
local entry_height     = 32
local entries_per_view = 8

local buttons = {}

local list_frame = CreateFrame("ScrollFrame", "SL_ListFrame", UIParent,
    "FauxScrollFrameTemplate")

local update_view = function(self)
    if not self:IsVisible() then
        return
    end
    local item_ids = {}
    for item_id in pairs(SL.Shopping.ShoppingList) do
        table.insert(item_ids, item_id)
    end
    table.sort(item_ids)
    FauxScrollFrame_Update(self, #item_ids, entries_per_view, entry_height)
    local offset = FauxScrollFrame_GetOffset(self)
    for line = 1, entries_per_view do
        local button = buttons[line]
        if line + offset > #item_ids then
            button:Hide()
        else
            local item   = SL.Shopping.ShoppingList[item_ids[line + offset]]
            local got_em = item.Obtained >= item.Required
            button:SetText(
                string.format("|c%s%s (%d/%d)",
                    got_em and "FF11FF33" or "FF2299FF",
                    item.Name, item.Obtained, item.Required)
            )
            button.texture:SetTexture(item.Texture)
            button:Show()
        end
    end
    self:Show()
end

list_frame:SetBackdrop {
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile     = 1,
    tileSize = 32,
    edgeSize = 32,
    insets   = {
        left   = 11,
        right  = 12,
        top    = 12,
        bottom = 11
    }
}

list_frame:SetWidth(entry_width + 23)
list_frame:SetHeight(entries_per_view * entry_height + 23)
list_frame:SetPoint("CENTER", UIParent, "CENTER")
list_frame:EnableMouse(true)
list_frame:SetMovable(true)
list_frame:RegisterForDrag("LeftButton")
list_frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
list_frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
list_frame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, entry_height, update_view)
end)
list_frame:SetClampedToScreen(true)

for i = 1, entries_per_view do
    local button = CreateFrame("Button", nil, list_frame)
    if i == 1 then
        button:SetPoint("TOP", list_frame, "TOP", 0, -12)
    else
        button:SetPoint("TOP", buttons[i - 1], "BOTTOM")
    end
    button:SetNormalFontObject "GameFontNormal"
    button:SetSize(entry_width, entry_height)
    button.texture = button:CreateTexture()
    button.texture:SetPoint("TOPLEFT")
    button.texture:SetWidth(32)
    button.texture:SetHeight(32)
    button.texture:SetTexture(nil)
    buttons[i] = button
end

table.insert(SL.Shopping.OnListUpdated, function() update_view(list_frame) end)

--[[
list_frame:SetFrameStrata("FULLSCREEN_DIALOG")

list_frame.texture = list_frame:CreateTexture()
list_frame.texture:SetPoint("TOPLEFT", 11, -12)
list_frame.texture:SetWidth(32)
list_frame.texture:SetHeight(32)
list_frame.texture:SetTexture(134213)

list_frame.text = list_frame:CreateFontString(nil, "ARTWORK")
list_frame.text:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
list_frame.text:SetPoint("TOPLEFT", 46, -12)
list_frame.text:SetText "|cff9d9d9d|Hitem:3299::::::::20:257::::::|h[Fractured Canine]|h|r"
]]

list_frame:Show()

list_frame:RegisterEvent("BAG_UPDATE")
list_frame.OnEvent = function(self, event, arg1)
    if event == "BAG_UPDATE" and arg1 > -2 then
        SL.Shopping.update_list()
    end
end
list_frame:SetScript("OnEvent", list_frame.OnEvent)

M.ToggleListFrame = function()
    if list_frame:IsVisible() then
        list_frame:Hide()
    else
        list_frame:Show()
        update_view(list_frame)
    end
end

SL.Interface = M

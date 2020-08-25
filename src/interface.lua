local addon_name, SL = ...
local M = {}

local list_frame = CreateFrame("Frame", "SL_ListFrame", UIParent)
list_frame:SetWidth(384)
list_frame:SetHeight(512)
list_frame:SetPoint("CENTER", UIParent, "CENTER")
list_frame:SetFrameStrata("HIGH")
list_frame:SetFrameLevel(5)

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
    end
end

SL.Interface = M

-- Grab the new main action bar frame (Midnight UI)
local MainActionBar = _G["MainActionBar"] or _G["MainMenuBar"] -- fallback
if not MainActionBar then
    return
end

-- Create a frame to listen for events
local f = CreateFrame("Frame")

-- Register combat and vehicle events
f:RegisterEvent("PLAYER_LOGIN")           -- Event for logging in
f:RegisterEvent("PLAYER_ENTERING_WORLD")  -- Event for entering world
f:RegisterEvent("PLAYER_REGEN_DISABLED")  -- Event for entering combat
f:RegisterEvent("PLAYER_REGEN_ENABLED")   -- Event for leaving combat
f:RegisterEvent("UNIT_ENTERED_VEHICLE")   -- Event for entering a vehicle
f:RegisterEvent("UNIT_EXITED_VEHICLE")    -- Event for exiting a vehicle

-- Runs each time something has to change
local function RefreshVisibility()
    local vis
    if InCombatLockdown() then
        -- Show in combat
        vis = "show"
    else
        -- Hide when out of combat
        vis = "hide"
    end
    -- Update the visibility driver
    RegisterStateDriver(MainActionBar, "visibility", "[vehicleui]show;[combat]show;hide")
end

-- Function to handle the events
f:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_LOGIN" then
        -- Set initial visibility rule on login
        RefreshVisibility()
    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Enter combat
        RefreshVisibility()
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Leave combat
        RefreshVisibility()
    elseif event == "UNIT_ENTERED_VEHICLE" and unit == "player" then
        RegisterStateDriver(MainActionBar, "visibility", "show")
    elseif event == "UNIT_EXITED_VEHICLE" and unit == "player" then
        RefreshVisibility()
    end
end)

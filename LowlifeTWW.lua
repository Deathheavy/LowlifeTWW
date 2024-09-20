local frame = CreateFrame("Frame")
-- Define a table to hold saved variables
LowlifeTWW_SavedVars = LowlifeTWW_SavedVars or {}

-- Print the current version of the addon and the command functionality
local version = "0.3"

print("|cFF00FF00LowlifeTWW|r |cFFFFFF00Addon v" .. version .. " loaded, use  |cFFFF0000 /lowlife '0 - 100'|r to change the threshold|r")

-- Configuration for sound and initial threshold
local threshold = LowlifeTWW_SavedVars.threshold or 30 -- Default health percentage threshold
local soundFile = "Interface\\AddOns\\LowlifeTWW\\defaultsound.mp3" -- Path to the sound file

-- State variable to prevent repeated sound play
local soundPlayed = false

-- Function to check health and play sound
local function CheckHealth()
    local healthPercent = (UnitHealth("player") / UnitHealthMax("player")) * 100

    if healthPercent < threshold and not soundPlayed then
        PlaySoundFile(soundFile, "Master") -- This plays the sound file through the Master channel.
        soundPlayed = true
    elseif healthPercent >= threshold then
        -- Reset soundPlayed flag when health goes above threshold
        soundPlayed = false
    end
end

-- Register events
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_HEALTH")

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_LOGIN" then
        -- Initial health check
        CheckHealth()
    elseif event == "UNIT_HEALTH" and arg1 == "player" then
        -- Health changed, check the health
        CheckHealth()
    end
end)

-- Function to handle chat commands
local function HandleChatCommand(msg)
    -- Update the local threshold variable from saved variables
    local savedThreshold = LowlifeTWW_SavedVars.threshold or 30
    
    if msg == "" then
        -- If no argument is provided, print the current threshold
        print("|cFF00FF00LowlifeTWW|r |cFFFFFF00Current health threshold is |cFFFF0000" .. savedThreshold .. "%|r")
    else
        -- Attempt to parse the new threshold value
        local newThreshold = tonumber(msg)
        if newThreshold then
            if newThreshold >= 0 and newThreshold <= 100 then
                -- Update the saved threshold value
                LowlifeTWW_SavedVars.threshold = newThreshold
                -- Also update the local threshold variable
                threshold = newThreshold
                print("|cFF00FF00LowlifeTWW|r |cFFFFFF00Health threshold set to |cFFFF0000" .. threshold .. "%|r")
            else
                print("|cFF00FF00LowlifeTWW|r |cFFFFFF00Please enter a number between |cFFFF0000 0 and 100|r")
            end
        else
            print("|cFF00FF00LowlifeTWW|r Invalid input. Please enter a number.")
        end
    end
end

-- Register the chat command
SLASH_LOWLIFFE1 = "/lowlife"
SlashCmdList["LOWLIFFE"] = HandleChatCommand
local RCLI = CreateFrame("Frame", "RCLI")

local convertOnPartyJoin = false

local function FindRaidIndex(player)
    for i = 1, GetNumRaidMembers() do
        local name, rank, subgroup = GetRaidRosterInfo(i)
        if name:upper() == player:upper() then
            return i, subgroup
        end
    end
end

local function Promote(args)
    local player = table.remove(args, 1)
    local role = table.remove(args,1)
    
    if player == nil or player == "" then
        print("You must specify a player to promote.")
    else
        if role == nil or role == "" then
            PromoteToAssistant(player, false)
        elseif role == "leader" then
            PromoteToLeader(player, false)
        elseif role == "looter" then
            SetLootMethod("master", player)
        end
    end
end

local function Demote(args)
    local player = table.remove(args, 1)
    if player == nil or player == "" then
        print("You must specify a player to demote.")
    else
        DemoteAssistant(player, false)
        local method, partyMaster, raidMaster = GetLootMethod()
        local index = FindRaidIndex(player)
        if method == "master" and index == raidMaster then
            SetLootMethod("master", "player")
        end
    end
end

local function Convert()
    if not UnitInParty("player") then
        print("You are not in a party.")
    elseif IsPartyLeader() ~= 1 then
        print("You are not the party leader.")
    elseif not UnitInRaid("player") then
        print("You are already in a raid.")
    else
        ConvertToRaid()
    end
end

local function Kick(args)
    local player = table.remove(args, 1)
    if player == nil or player == "" then
        print("You must specify a player to kick.")
    else
        UninviteUnit(player)
    end
end

local function Invite(args)
    if not UnitInRaid("player") then
        convertOnPartyJoin = true
    end
    
    for num, player in pairs(args) do
        InviteUnit(player)
    end
end

local function Move(args)
    local player = table.remove(args, 1)
    local group = table.remove(args, 1)
    
    local raidindex, curgroup = FindRaidIndex(player)
    
    if curgroup == group then
        print(player, "is already in group", group, ".")
    else
        SetRaidSubgroup(raidindex, group)
    end
end

local function Swap(args)
    local player1 = table.remove(args, 1)
    local player2 = table.remove(args, 1)
    
    local raidindex1 = FindRaidIndex(player1)
    print("player1", player1, "index1", raidindex1)
    local raidIndex2 = FindRaidIndex(player2)
    print("player2", player2, "index2", raidindex2)

    if raidindex1 == nil then
        print(player1, "is not in the raid.")
    elseif raidindex2 == nil then 
        print(player2, "is not in the raid.")
    elseif raidindex1 == raidindex2 then
        print("You must specify two players to swap.")
    else
        SwapRaidSubgroup(raidindex1, raidindex2)
    end
end

local function ParseCli(msg)
    local args = {strsplit(" ", msg)}
    local cmd = table.remove(args, 1)
    if cmd == "" or cmd == "help" then
        print("RCLI")
        print("====")
    elseif cmd == "promote" then
        Promote(args)
    elseif cmd == "invite" then
        Invite(args)
    elseif cmd == "kick" then
        Kick(args)
    elseif cmd == "convert" then
        Convert()
    elseif cmd == "move" then
        Move(args)
    elseif cmd == "swap" then
        Swap(args)
    elseif cmd == "demote" then
        Demote(args)
    end
end

SLASH_RCLI1 = "/rcli"
SlashCmdList["RCLI"] = ParseCli

local function HandlePartyJoin(self, event, ...)
    if convertOnPartyJoin then
        if not UnitInRaid("player") then
            convertOnPartyJoin = false
            ConvertToRaid()
        end
    end
end

SLASH_RELOAD1 = "/rl"
SlashCmdList["RELOAD"] = function(msg)
    ReloadUI()
end

RCLI:SetScript("OnEvent", HandlePartyJoin)
RCLI:RegisterEvent("PARTY_MEMBERS_CHANGED")
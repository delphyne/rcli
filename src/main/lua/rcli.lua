local RCLI = CreateFrame("Frame", "RCLI")

local ItemQualityByName = {
    Poor = 0,
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
    Heirloom = 6
}

-- local ItemQualityByNumber = {}
-- for k,v in pairs(ItemQualityByName) do
--     ItemQualityByNumber[v + 1] = k
-- end

local convertOnPartyJoin = false
local overflowInviteMembers = {}

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
            SetLootThreshold(ItemQualityByName["Epic"])
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
    elseif UnitInRaid("player") then
        print("You are already in a raid.")
    else
        ConvertToRaid()
    end
end

local function Kick(args)
    if #(args) == 0 then
        print("You must specify a player to kick.")
    end
    for num, player in pairs(args) do
        if UnitInRaid(player) == nil then
            print(player, "is not in your raid.")
        else
            UninviteUnit(player)
        end
    end
end


local function Invite(args)
    local players = args
    if not UnitInRaid("player") then
        convertOnPartyJoin = true
        local maxInvite = 5 - GetNumPartyMembers()
        players = {unpack(args, 1, maxInvite)}
        overflowInviteMembers = {unpack(args, maxInvite + 1)}
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
    local raidindex2 = FindRaidIndex(player2)
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
        print(" RCLI (by Delphyne of Eredar)")
        print(" http://code.google.com/p/rcli/")
        print("================================")
        print("c[onvert]")
        print("d[emote] <player> [...]")
        print("i[nv[ite]] <player> [...]")
        print("k[ick] <player> [...]")
        print("m[ove] <player> <group>")
        print("p[romote] <player> [leader|looter]")
        print("s[wap] <player1> <player2>")
    elseif cmd == "promote" then
        Promote(args)
    elseif cmd == "invite" or cmd == "inv" or cmd == "i" then
        Invite(args)
    elseif cmd == "kick" or cmd == "k" then
        Kick(args)
    elseif cmd == "convert" or cmd == "c" then
        Convert()
    elseif cmd == "move" or cmd == "m" then
        Move(args)
    elseif cmd == "swap" or cmd == "s" then
        Swap(args)
    elseif cmd == "demote" or cmd == "d" then
        Demote(args)
    end
end

local function HandlePartyJoin(self, event, ...)
    if convertOnPartyJoin then
        if not UnitInRaid("player") then
            ConvertToRaid()
        end
        if UnitInRaid("player") then
            convertOnPartyJoin = false
            Invite(overflowInviteMembers)
            wipe(overFlowInviteMembers)
        end 
    end
end

SLASH_RCLI1 = "/rcli"
SlashCmdList["RCLI"] = ParseCli

SLASH_RELOAD1 = "/rl"
SlashCmdList["RELOAD"] = function(msg)
    ReloadUI()
end

RCLI:SetScript("OnEvent", HandlePartyJoin)
RCLI:RegisterEvent("PARTY_MEMBERS_CHANGED")
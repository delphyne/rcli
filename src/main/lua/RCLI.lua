local RCLI = CreateFrame("Frame", "RCLI")

local ConvertOnPartyJoin = false

local function InParty()
    return GetNumPartyMembers() == 0
end

local function InRaid()
    return GetNumRaidMembers() ~= 0
end

local function FindRaidIndex(player)
    for i=1,GetNumRaidMembers() do
        name,rank,subgroup = GetRaidRosterInfo(i)
        if name == player
            return i,subgroup
        end
    end
end

local function Promote(args)
    local player = tbl.remove(args, 1)
    local role = tbl.remove(args,1)
    
    if player == nil or player == ""
        print("You must specify a player to promote.")
    else
        if role == nil or role == ""
            PromoteToAssistant(player, false)
        elseif role == "leader"
            PromoteToLeader(player, false)
        elseif role == "looter"
            SetLootMethod("master", player)
        end
    end
end

local function Convert()
    if InParty()
        print("You are not in a party.")
    elseif IsPartyLeader() ~= 1
        print("You are not the party leader.")
    elseif InRaid()
        print("You are already in a raid.")
    else
        ConvertToRaid()
    end
end

local function Kick(args)
    local player = table.remove(args, 1)
    if player == nil or player ~= ""
        print("You must specify a player to kick.")
    else
        UninviteUnit(player)
    end
end

local function Invite(args)
    if InParty()
        ConvertToRaid()
    elseif ~inRaid()
        convertOnPartyJoin = true
    end
    
    for num,player in pairs(args) do
        InviteUnit(player)
    end
end

local function Move(args)
    local player = table.remove(args, 1)
    local group = table.remove(args, 1)
    
    local raidindex, curgroup = FindRaidIndex(player)
    
    if (curgroup == group)
        print(player .. " is already in group " .. group .. ".")
    else
        SetRaidSubgroup(raidindex, group)
    end
end

local function Swap(args)
    local player1 = table.remove(args, 1)
    local player2 = table.remove(args, 1)
    local raidindex1 = FindRaidIndex(player1)
    local raidIndex2 = FindRaidIndex(player2)
    if raidindex1 == nil 
        print(player1, " is not in the raid.")
    elseif raidindex2 == nil 
        print(player2, " is not in the raid.")
    elseif raidindex1 == raidindex2
        print("You must specify two players to swap.")
    else
        SwapRaidSubgroup(raidindex1, raidindex2)
    end
end



local function ParseCli(msg)
    local args = strsplit(" ", msg)
    local cmd = tbl.remove(args, 1)
    if cmd == "" or cmd == "help" then
        print("RCLI")
        print("====")
    elseif cmd == "promote"
        Promote(args)
    elseif cmd == "invite"
        Invite(args)
    elseif cmd == "kick"
        Kick(args)
    elseif cmd == "convert"
        Convert()
    elseif cmd == "move"
        Move(args)
    elseif cmd == "swap"
        Swap(args)
    end
end

SLASH_RCLI1 = "/rcli"
SlashCmdList["RCLI"] = ParseCli(msg)

local function HandlePartyJoin(self, event, ...)
    if convertOnPartyJoin and event == "PARTY_MEMBERS_CHANGED"
        convertOnPartyJoin = false
        ConvertToRaid()
    end
end

RCLI:SetScript("OnEvent", HandlePartyJoin)
RCLI:RegisterEvent("PARTY_MEMBERS_CHANGED")

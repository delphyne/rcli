# Commands #

Each command has one or more aliases that you may use in place of the full command.  All examples provided will use the full name for clarity of intent.  When specifying a player, case is ignored.

---


## help ##
**Usage:** `/rcli help`

> Display an abbreviated version of this text.

---


## convert ##
**Alias:** `c`

**Usage:** `/rcli convert`

Converts your current party to a raid

---


## demote ##
**Alias:** `d`

**Usage:** `/rcli demote <player> [...]`

Removes the _Raid Assistant_ and _Master Looter_ roles from a raid member.

  * `/rcli demote ereyni`
> Removes the _Raid Assistant_ role from Ereyni.  If Ereyni is currently the _Master Looter_ this command assigns the _Master Looter_ role to yourself.

  * `/rcli demote ereyni delphyne`
> Removes the _Raid Assistant_ role from Ereyni and Delphyne.  If either are currently in the _Master Looter_ role, the _Master Looter_ roll will be assigned to you.

---


## invite ##
**Alias:** `inv`

**Alias:** `i`

**Usage:** `/rcli invite <player> [...]`

Invites all listed players to your party, and converts the party to the raid when the first person in your party joins.

  * `/rcli invite ereyni`
> Invites Ereyni to your party and converts the party to a raid as soon as Ereyni accepts your invitation.

  * `/rcli invite ereyni delphyne`
> Invites Ereyni and Delphyne to your party and converts the party to a raid as soon as any member accepts your invitation.

  * `/rcli invite ereyni delphyne mithrael azarie infamoos elizabet syrrah amarile jerra`
> Invites Ereyni, Delphyne, Mithrael, and Azarie to your party.  As soon as any member joins the party, it is converted to a raid and the remaining players are invited to your raid.

---


## kick ##
**Alias:** `k`

**Usage:** `/rcli kick <player> [...]`

Removes a raid member from the raid.

  * `/rcli kick ereyni`
> Removes Ereyni from the raid.

  * `/rcli kick ereyni delphyne`
> Removes Ereyni and Delphyne from the raid.

---


## move ##
**Alias:** `m`

**Usage:** `/rcli move <player> <group>`

Moves a raid member from their current group to the specified group.

  * `/rcli move ereyni 2`
> Moves Ereyni to the second raid group if there is sufficient room.

---


## promote ##
**Alias:** `p`

**Usage:** `/rcli promote <player> [looter|leader]`

Promotes a raid member to the _Raid Assistant_, _Master Looter_, or _Raid Leader_ role.

  * `/rcli promote ereyni`
> Assigns Ereyni the _Raid Assistant_ role.  This role allows the user to mark targets, issue and observe ready checks, and invite and remove party members.

  * `/rcli promote ereyni looter`
> Changes the loot mode to _Master Looter_ and assigns the _Master Looter_ role to Ereyni.  This action sets the loot threshold to _Epic_.

  * `/rcli promote ereyni leader`
> Assigns Ereyni the _Raid Leader_ role.

---


## swap ##
**Alias:** `s`

**Usage:** `/rcli swap <player1> <player2>`

Switches two raid members' place within the raid.

  * `/rcli swap ereyni delphyne`
> Switches Ereyni and Delphyne's raid subgroups.

---

PlayerMaxRank()
{
    #ifdef ZM
        MaxRankXP = Int(TableLookup("mp/zm_shotgun_ranktable.csv", 0, 49, 7));
        stat      = "totalXP";
    #endif
    #ifdef MP
        MaxRankXP = Int(TableLookup("mp/cp_ranktable.csv", 0, self GetRankedPlayerData(common_scripts\utility::func_46AE(), "prestige") < 10 ? 44 : 999, 7));
        stat      = "experience";
    #endif
    
    self SetRankedPlayerData(common_scripts\utility::func_46AE(), stat, MaxRankXP);
    self iPrintln("Max Rank ^2Set");
}

UnlockAll()
{
    self iPrintln("Unlock All ^2Started");
    foreach(challengeRef, challengeData in level.challengeInfo) //Complete Challenges/Unlock Weapon Camos
    {
        finalTarget = 0;
        finalTier = 0;
        
        for(tierId = 1;isDefined(challengeData["targetval"][tierId]); tierId++)
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier   = tierId + 1;
        }
        
        self SetRankedPlayerData(common_scripts\utility::func_46AE(), "challengeProgress", challengeRef, finalTarget);
        self SetRankedPlayerData(common_scripts\utility::func_46AE(), "challengeState", challengeRef, finalTier);
    }
    
    #ifdef MP
    for(a=36;a<935;a++) //Max Weapon Rank/Unlock Weapon Attachments
    {
        weapon = TableLookupByRow("mp/weaponlevelingdivisionsoverhaul.csv", a, 0);
        if(IsSubStr(weapon, "_mp"))
        {
            maxRank   = GetWeaponMaxRank(weapon);
            maxRankXP = GetWeaponMaxXP(weapon);
            
            self SetRankedPlayerData(common_scripts\utility::func_46AE(), "weaponStats", weapon, "prestigeLevel", 5);
            self SetRankedPlayerData(common_scripts\utility::func_46AE(), "weaponStats", weapon, "level", maxRank);
            self SetRankedPlayerData(common_scripts\utility::func_46AE(), "weaponStats", weapon, "experience", maxRankXP);
        }
        wait .01; //Since People Seemed To Have Issues With Stats Being Set Too Fast. This Will Slow It down A lot.
    }

    divisions = ["infantry", "airborne", "armored", "mountain", "expeditionary", "resistance", "grenadier", "commando"];
    for(a=0;a<divisions.size;a++) //Max Division Rank
    {
        self SetRankedPlayerData(common_scripts\utility::func_46AE(), "divisionStats", divisions[a], "prestigeLevel", 4);
        self SetRankedPlayerData(common_scripts\utility::func_46AE(), "divisionStats", divisions[a], "level", 3);
        self SetRankedPlayerData(common_scripts\utility::func_46AE(), "divisionStats", divisions[a], "experience", 149650);
    }
    #endif
    
    self iPrintln("Unlock All ^2Complete");
}

GetWeaponMaxRank(weapon)
{
    rank = Int(TableLookup("mp/weaponlevelingdivisionsoverhaul.csv", 0, weapon, 1));
    return rank;
}

GetWeaponMaxXP(weapon)
{
    row   = Int(TableLookupRowNum("mp/weaponlevelingdivisionsoverhaul.csv", 0, weapon));
    size  = GetWeaponMaxRank(weapon);
    maxXP = Int(TableLookupByRow("mp/weaponlevelingdivisionsoverhaul.csv", row + size, 1));
    
    return maxXP;
}
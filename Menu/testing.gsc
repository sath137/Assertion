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
        
        self SetRankedPlayerData(common_scripts\utility::func_46A8(), "challengeProgress", challengeRef, finalTarget);
        self SetRankedPlayerData(common_scripts\utility::func_46A8(), "challengeState", challengeRef, finalTier);
        
        wait .01;
    }
    
    for(a=36;a<935;a++) //Max Weapon Rank/Unlock Weapon Attachments
    {
        weapon = TableLookupByRow("mp/weaponlevelingdivisionsoverhaul.csv", a, 0);
        if(IsSubStr(weapon, "_mp"))
        {
            maxRank   = GetWeaponMaxRank(weapon);
            maxRankXP = GetWeaponMaxXP(weapon);
            
            self SetRankedPlayerData(common_scripts\utility::func_46A8(), "weaponStats", weapon, "prestigeLevel", 5);
            self SetRankedPlayerData(common_scripts\utility::func_46A8(), "weaponStats", weapon, "level", maxRank);
            self SetRankedPlayerData(common_scripts\utility::func_46A8(), "weaponStats", weapon, "experience", maxRankXP);
        }
    }

    divisions = ["infantry", "airborne", "armored", "mountain", "expeditionary", "resistance", "grenadier", "commando"];
    for(a=0;a<divisions.size;a++) //Max Division Rank
    {
        self SetRankedPlayerData(common_scripts\utility::func_46A8(), "divisionStats", divisions[a], "prestigeLevel", 4);
        self SetRankedPlayerData(common_scripts\utility::func_46A8(), "divisionStats", divisions[a], "level", 3);
        self SetRankedPlayerData(common_scripts\utility::func_46A8(), "divisionStats", divisions[a], "experience", 149650);
    }
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
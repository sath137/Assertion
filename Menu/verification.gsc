setVerification(a, player, msg)
{
    if(player IsHost() || player getVerification() == a || player == self)
    {
        if(isDefined(msg))
        {
            if(player IsHost())
                return self iPrintln("^1ERROR: ^7You Can't Change The Status Of The Host");
            if(player getVerification() == a)
                return self iPrintln("^1ERROR: ^7Player's Verification Already Set To ^2" + level.MenuStatus[a]);
            if(player == self)
                return self iPrintln("^1ERROR: ^7You Can't Change Your Own Status");
        }
        return;
    }
    
    player.playerSetting["verification"] = level.MenuStatus[a];
    player iPrintln("Your Status Has Been Set To ^2" + player.playerSetting["verification"]);
    player.menuParent = [];
    if(player isInMenu())
        player closeMenu1();
    player.menu["currentMenu"] = "Main";
    player.menu["curs"][player.menu["currentMenu"]] = 0;
    
    player runMenuIndex("Main");
    if(player getVerification() > 0)
        player thread WelcomeMessage("Welcome To ^1" + level.menuName + ",Status: ^1" + player.playerSetting["verification"] + ",[{+speed_throw}] & [{+melee}] To ^1Open");
}

SetVerificationAllPlayers(a, msg)
{
    foreach(player in level.players)
        self setVerification(a, player);
    if(IsDefined(msg))
        self iPrintln("All Players Verification Set To ^2" + level.MenuStatus[a]);
}

getVerification()
{
    if(!isDefined(self.playerSetting["verification"]))
        return 0;
    
    for(a=0;a<level.MenuStatus.size;a++)
        if(self.playerSetting["verification"] == level.MenuStatus[a])
            return a;
}

hasMenu()
{
    if(self getVerification() > 0)
        return true;
    return false;
}
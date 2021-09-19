/*
*    Infinity Loader :: The Best GSC IDE!
*
*    Project : Assertion
*    Author : CF4_99
*    Game : Call of Duty: WWII
*    Description : Starts Multiplayer code execution!
*    Date : 9/18/2021 6:46:26 PM
*
*/

/*
    World War 2 Assertion Menu Base
    Developer: CF4_99
    
    NOTE: Some Parts Of The Base Aren't Very Noob Friendly.
    I don't intend to simplify anything. I am just putting something out there for people to use.
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    #ifdef WW2
        if(GetDvarInt("4017", 0))
            return;
    #endif
    level.strings = [];
    level thread InitializeVarsPrecaches();
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connecting", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    if(self isHost())
        self thread FixOverFlow();
    
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;
        self thread playerSetup();
    }
}

InitializeVarsPrecaches()
{
    if(isDefined(level.DefineOnce))
        return;
    level.DefineOnce  = true;
    
    level.menuName   = "Assertion";
    level.AutoVerify = 0;
    level.MenuStatus = StrTok("None,Verified,VIP,Co-Host,Admin,Host", ",");
    level.colorNames = StrTok("Red,Blue,Purple,Green,Yellow,Orange", ",");
    level.colors     = StrTok("175,0,0,0,0,255,100,0,255,0,175,0,215,215,0,255,155,0", ",");
}

playerSetup()
{
    if(isDefined(self.menuThreaded))
        return;
    
    self defineVariables();
    if(self IsHost())
    {
        self.playerSetting["verification"] = level.MenuStatus[(level.MenuStatus.size - 1)];
        self FreezeControls(false);
    }
    else
    {
        if(!isDefined(self.playerSetting["verification"]))
            self.playerSetting["verification"] = level.MenuStatus[level.AutoVerify];
    }
    
    if(self getVerification() > 0)
        self thread WelcomeMessage("Welcome To ^1" + level.menuName + ",Status: ^1" + self.playerSetting["verification"] + ",[{+speed_throw}] & [{+melee}] To ^1Open");
    self thread menuMonitor();
    self.menuThreaded = true;
}

WelcomeMessage(message)
{
    if(isDefined(self.welcomeDisplaying))
        return;
    self.welcomeDisplaying = true;
    
    self endon("disconnect");
    WelcomeMessage = [];
    msg            = StrTok(message, ",");
    for(a=0;a<msg.size;a++)
    {
        WelcomeMessage[a] = self createText("mphubfont", 1.1, 0, "", "CENTER", "CENTER", 800, 30 + (a * 15), 0, (1, 1, 1));
        WelcomeMessage[a] thread SetTextFX(msg[a], 5);
        WelcomeMessage[a] thread hudMoveX(0, .4);
        wait .5;
    }
    wait 4;
    
    self.welcomeDisplaying = undefined;
}
 
defineVariables()
{
    if(isDefined(self.DefinedVariables))
        return;
    self.DefinedVariables = true;
    
    if(!isDefined(self.menu))
        self.menu = [];
    if(!isDefined(self.playerSetting))
        self.playerSetting = [];
    
    self.playerSetting["isInMenu"] = undefined;
    self.menu["currentMenu"] = "";
    
    //Menu Design Variables
    self thread LoadMenuVars();
}
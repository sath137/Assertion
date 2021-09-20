runMenuIndex(menu)
{
    self endon("disconnect");
    
    switch(menu)
    {
        case "Main":
            self addMenu(menu, "Main Menu");
            if(self getVerification() > 0) //Verified
            {
                self addOpt("Sub Menu", ::newMenu, "Sub Menu " + self GetEntityNumber());
                self addOpt("Menu Theme", ::newMenu, "Menu Theme");
                if(self getVerification() > 1) //VIP
                {
                    if(self getVerification() > 2) //Co-Host
                    {
                        if(self getVerification() > 3) //Admin
                        {
                            if(self IsHost())
                                self addOpt("Host Menu", ::newMenu, "Host Menu");
                            self addOpt("Player Menu", ::newMenu, "Players");
                            self addOpt("All Players Menu", ::newMenu, "All Players");
                        }
                    }
                }
            }
            break;
        case "Menu Theme":
            self addMenu(menu, "Menu Theme");
                for(a=0;a<level.colorNames.size;a++)
                    self addOpt(level.colorNames[a], ::MenuTheme, divideColor(int(level.colors[(3 * a)]), int(level.colors[((3 * a) + 1)]), int(level.colors[((3 * a) + 2)])));
            break;
        case "Host Menu":
            self addMenu(menu, "Host Menu");
                self addOpt("Disconnect", ::disconnect);
            break;
        case "All Players":
            self addMenu(menu, "All Players");
                self addOpt("Verification", ::newMenu, "All Players Verification");
            break;
        case "All Players Verification":
            self addMenu(menu, "Verification");
                for(a=0;a<(level.MenuStatus.size - 2);a++)
                    self addOpt(level.MenuStatus[a], ::SetVerificationAllPlayers, a, true);
            break;
        case "Players":
            players = GetPlayerArray();
            
            self addMenu(menu, "Players");
                foreach(player in players)
                {
                    if(player IsHost() && !self IsHost()) //This Will Make It So No One Can See The Host In The Player Menu Besides The Host.
                        continue;
                    if(!isDefined(player.playerSetting["verification"])) //If A Player Doesn't Have A Verification Set, They Won't Show. Mainly Happens If They Are Still Connecting
                        player.playerSetting["verification"] = level.MenuStatus[level.AutoVerify];
                    
                    self addOpt("[^2" + player.playerSetting["verification"] + "^7]" + player getName(), ::newMenu, "Player Options " + player GetEntityNumber());
                }
            break;
        default:
            foundplayer = false;
            players     = GetPlayerArray();
            
            foreach(player in players)
            {
                sepmenu = StrTok(menu, " ");
                if(Int(sepmenu[(sepmenu.size - 1)]) == player GetEntityNumber())
                {
                    foundplayer = true;
                    self MenuOptionsPlayer(menu, player);
                }
            }
            
            if(!foundplayer)
            {
                self addMenu(menu, "404 ERROR");
                    self addOpt("Page Not Found");
            }
            break;
    }
}

MenuOptionsPlayer(menu, player)
{
    self endon("disconnect");
    
    sepmenu = StrTok(menu, " " + player GetEntityNumber());
    newmenu = "";
    for(a=0;a<sepmenu.size;a++)
    {
        newmenu += sepmenu[a];
        if(a != (sepmenu.size - 1))
            newmenu += " ";
    }
    
    switch(newmenu)
    {
        case "Sub Menu":
            self addMenu(menu, "Sub Menu");
                self addOptBool(player.BoolTest, "Bool Option", ::BoolTest, player);
                for(a=0;a<25;a++)
                    self addOpt("Option " + (a + 2));
            break;
        case "Player Options":
            self addMenu(menu, "[^2" + player.playerSetting["verification"] + "^7]" + player getName());
                self addOpt("Verification", ::newMenu, "Verification " + player GetEntityNumber());
                self addOpt("Sub Menu", ::newMenu, "Sub Menu " + player GetEntityNumber());
            break;
        case "Verification":
            self addMenu(menu, "Verification");
                for(a=0;a<(level.MenuStatus.size - 2);a++)
                    self addOptBool(player getVerification() == a, level.MenuStatus[a], ::setVerification, a, player, true);
            break;
        default:
            self addMenu(menu, "404 ERROR");
                self addOpt("Page Not Found");
            break;
    }
}

menuMonitor()
{
    self endon("disconnect");
    
    while(true)
    {
        if(self getVerification() > 0)
        {
            if(!self isInMenu())
            {
                if(self AdsButtonPressed() && self MeleeButtonPressed() && !isDefined(self.menu["DisableMenuControls"]))
                {
                    self openMenu1();
                    wait .25;
                }
            }
            else if(self isInMenu() && !isDefined(self.menu["DisableMenuControls"]))
            {
                if(self AdsButtonPressed() || self AttackButtonPressed())
                {
                    if(!self AdsButtonPressed() || !self AttackButtonPressed())
                    {
                        curs = self getCursor();
                        menu = self getCurrent();
                        
                        self.menu["curs"][menu] += self AttackButtonPressed();
                        self.menu["curs"][menu] -= self AdsButtonPressed();
                        
                        if(curs != self.menu["curs"][menu])
                            self scrollMenu((self AttackButtonPressed() ? 1 : -1), curs);
                        wait .13;
                    }
                }
                else if(self UseButtonPressed())
                {
                    menu = self getCurrent();
                    curs = self getCursor();
                    
                    if(isDefined(self.menu["items"][menu].func[curs]))
                    {
                        if(self.menu["items"][menu].func[curs] == ::newMenu)
                            self MenuArrays(self BackMenu());
                        self thread [[ self.menu["items"][menu].func[curs] ]](self.menu["items"][menu].input1[curs], self.menu["items"][menu].input2[curs], self.menu["items"][menu].input3[curs], self.menu["items"][menu].input4[curs]);
                        
                        if(isDefined(self.menu["items"][menu].bool[curs]))
                        {
                            wait .05;
                            self RefreshMenu(menu, curs); //Will Refresh That Option For Every Player That Is Able To See It.
                        }
                        wait .15;
                    }
                }
                else if(self MeleeButtonPressed())
                {
                    if(self getCurrent() == "Main")
                        self closeMenu1();
                    else
                        self newMenu();
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

drawText()
{
    self endon("menuClosed");
    self endon("disconnect");
    self StopScrolling();
    
    self DestroyOpts();
    if(!isDefined(self.menu["curs"][self getCurrent()]))
        self.menu["curs"][self getCurrent()] = 0;
    
    text  = self.menu["items"][self getCurrent()].name;
    start = 0;
    if(self getCursor() > (text.size - 7) && text.size > 11 || self getCursor() > 5 && self getCursor() < (text.size - 6) && text.size > 11)
        start = (self getCursor() > (text.size - 9) && text.size > 11) ? (text.size - 11) : (self getCursor() - 5);
    
    if(text.size > 0)
    {
        numOpts = text.size;
        if(numOpts >= 11)
            numOpts = 11;
        
        for(a=0;a<numOpts;a++)
        {
            color = (isDefined(self.menu["items"][self getCurrent()].bool[(a + start)]) && isDefined(self.menu_B[self getCurrent()][(a + start)]) && self.menu_B[self getCurrent()][(a + start)]) ? self.menu["Bool_Color"] : (1, 1, 1);
            self.menu["ui"]["text"][(a + start)] = self createText("objective", 1.1, 5, text[(a + start)], "CENTER", "CENTER", self.menu["X"], (self.menu["Y"] + (a * 20)), 1, color);
        }
    }
    
    color = (isDefined(self.menu["items"][self getCurrent()].bool[self getCursor()]) && isDefined(self.menu_B[self getCurrent()][self getCursor()]) && self.menu_B[self getCurrent()][self getCursor()]) ? self.menu["Bool_Color"] : self.menu["Main_Color"];
    self.menu["ui"]["text"][self getCursor()].FontScale = 1.4;
    self.menu["ui"]["text"][self getCursor()].color = color;
}

scrollMenu(dir, OldCurs)
{
    self endon("menuClosed");
    self endon("disconnect");
    
    arry = self.menu["items"][self getCurrent()].name;
    curs = self getCursor();
    
    if(curs < 0 || curs > (arry.size - 1))
    {
        self StopScrolling();
        self setCursor((curs < 0) ? (arry.size - 1) : 0);
        curs = getCursor();
        
        OldCurs = curs;
        if(arry.size > 11)
            self RefreshMenu();
    }
    else if(curs < (arry.size - 6) && OldCurs > 5 || curs > 5 && OldCurs < (arry.size - 6))
    {
        self thread SetMenuScrolling(.16);
        for(a=0;a<arry.size;a++)
            if(isDefined(self.menu["ui"]["text"][a]))
                self.menu["ui"]["text"][a] thread hudMoveY(self.menu["ui"]["text"][a].y - (20 * dir), .16);
        if(isDefined(self.menu["ui"]["text"][(curs + (-6 * dir))]))
            self.menu["ui"]["text"][(curs + (-6 * dir))] thread hudFadenDestroy(0, .16);
        
        color = (isDefined(self.menu["items"][self getCurrent()].bool[(curs + (5 * dir))]) && isDefined(self.menu_B[self getCurrent()][(curs + (5 * dir))]) && self.menu_B[self getCurrent()][(curs + (5 * dir))]) ? self.menu["Bool_Color"] : (1, 1, 1);
        self.menu["ui"]["text"][(curs + (5 * dir))] = self createText("objective", 1.1, 5, arry[(curs + (5 * dir))], "CENTER", "CENTER", self.menu["X"], self.menu["ui"]["text"][curs].y + (120 * dir), 0, color);
        
        if(isDefined(self.menu["ui"]["text"][(curs + (5 * dir))]))
        {
            self.menu["ui"]["text"][(curs + (5 * dir))] thread hudFade(1, .1);
            self.menu["ui"]["text"][(curs + (5 * dir))] thread hudMoveY(self.menu["ui"]["text"][curs].y + (100 * dir), .16);
        }
    }
    
    for(a=0;a<arry.size;a++)
        if(isDefined(self.menu["ui"]["text"][a]))
        {
            color = (isDefined(self.menu["items"][self getCurrent()].bool[a]) && isDefined(self.menu_B[self getCurrent()][a]) && self.menu_B[self getCurrent()][a]) ? self.menu["Bool_Color"] : (1, 1, 1);
            self.menu["ui"]["text"][a].color = color;
            if(self.menu["ui"]["text"][a].FontScale != 1.1)
                self.menu["ui"]["text"][a] ChangeFontscaleOverTime1(1.1, .05);
        }
    color = (isDefined(self.menu["items"][self getCurrent()].bool[curs]) && isDefined(self.menu_B[self getCurrent()][curs]) && self.menu_B[self getCurrent()][curs]) ? self.menu["Bool_Color"] : self.menu["Main_Color"];
    self.menu["ui"]["text"][curs].color = color;
    self.menu["ui"]["text"][curs] ChangeFontscaleOverTime1(1.4, .1);
}

SetMenuScrolling(time)
{
    self notify("StopScrolling");
    
    self endon("disconnect");
    self endon("menuClosed");
    self endon("StopScrolling");
    
    self.menu["isScrolling"] = true;
    wait time;
    self.menu["isScrolling"] = undefined;
}

StopScrolling()
{
    self notify("StopScrolling");
    self.menu["isScrolling"] = undefined;
}

SetMenuTitle(title)
{
    if(!isDefined(self.menu["ui"]["title"]))
        return;
    
    if(!isDefined(title))
        title = self.menu["items"][self getCurrent()].title;
    self.menu["ui"]["title"] SetSafeText(title);
}

openMenu1(menu)
{
    self VisionSetNakedForPlayer("ac130_inverted", 0.25);
    if(!isDefined(menu) || isDefined(menu) && menu == "")
        menu = (isDefined(self.menu["currentMenu"]) && self.menu["currentMenu"] != "") ? self.menu["currentMenu"] : "Main";
    self.menu["ui"]["title"] = self createText("mphubfont", 1.5, 5, "", "CENTER", "CENTER", self.menu["X"], (self.menu["Y"] - 30), 1, self.menu["Main_Color"]);
    self.menu["currentMenu"] = menu;
    self runMenuIndex(menu);
    self SetMenuTitle();
    self drawText();
    self.playerSetting["isInMenu"] = true;
}

closeMenu1()
{
    self DestroyOpts();
    self notify("menuClosed");
    
    destroyAll(self.menu["ui"]);
    self.playerSetting["isInMenu"] = undefined;
    self VisionSetNakedForPlayer("", 0.25);
}

RefreshMenu(menu, curs)
{
    if(isDefined(menu) && !isDefined(curs) || !isDefined(menu) && isDefined(curs))
        return;
    
    if(self hasMenu() && self isInMenu())
    {
        if(isDefined(menu) && isDefined(curs))
        {
            //The Main Goal Here Is To Make Sure Whatever Bool Option Was Toggled, Gets Refreshed For Everyone That Is Able To See The Option
            foreach(player in level.players)
            {
                if(player hasMenu() && player isInMenu() && player getCurrent() == menu && !isDefined(player.menu["isScrolling"]))
                {
                    if(isDefined(player.menu["ui"]["text"][curs]))
                    {
                        player runMenuIndex(menu);
                        player SetMenuTitle();
                        player drawText();
                    }
                }
            }
        }
        else
        {
            self SetMenuTitle();
            self drawText();
        }
    }
}

DestroyOpts()
{
    destroyAll(self.menu["ui"]["text"]);
}

BoolTest(player)
{
    player.BoolTest = isDefined(player.BoolTest) ? undefined : true;
}
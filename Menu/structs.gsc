MenuArrays(menu)
{
    if(!isDefined(self.menu["items"]))
        self.menu["items"] = [];
    if(!isDefined(self.menu["items"][menu]))
        self.menu["items"][menu] = SpawnStruct();
    if(!isDefined(self.menuParent))
        self.menuParent = [];
    if(!isDefined(self.menu["curs"]))
        self.menu["curs"] = [];
    
    self.menu["items"][menu].name = [];
    self.menu["items"][menu].func = [];
    self.menu["items"][menu].input1 = [];
    self.menu["items"][menu].input2 = [];
    self.menu["items"][menu].input3 = [];
    self.menu["items"][menu].input4 = [];
    self.menu["items"][menu].bool = [];
    
    if(!isDefined(self.menu_B))
        self.menu_B = [];
    if(!isDefined(self.menu_B[menu]))
        self.menu_B[menu] = [];
}

addMenu(menu, title)
{
    self MenuArrays(menu);
    if(isDefined(title))
        self.menu["items"][menu].title = title;
    if(!isDefined(self.temp))
        self.temp = [];
    self.temp["memory"] = menu;
}

addOpt(name, func, input1, input2, input3, input4)
{
    menu  = self.temp["memory"];
    count = self.menu["items"][menu].name.size;
    
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    self.menu["items"][menu].input1[count] = input1;
    self.menu["items"][menu].input2[count] = input2;
    self.menu["items"][menu].input3[count] = input3;
    self.menu["items"][menu].input4[count] = input4;
}

addOptBool(var, name, func, input1, input2, input3, input4)
{
    menu  = self.temp["memory"];
    count = self.menu["items"][menu].name.size;
    
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    self.menu["items"][menu].input1[count] = input1;
    self.menu["items"][menu].input2[count] = input2;
    self.menu["items"][menu].input3[count] = input3;
    self.menu["items"][menu].input4[count] = input4;
    self.menu["items"][menu].bool[count] = true;
    
    self.menu_B[menu][count] = (isDefined(var) && var) ? true : undefined;
}

newMenu(menu)
{
    self endon("menuClosed");
    self StopScrolling();
    
    backMenu = self BackMenu();
    if(!isDefined(menu))
    {
        if(isDefined(backMenu))
            menu = backMenu;
        self.menuParent[(self.menuParent.size - 1)] = undefined;
    }
    else
    {
        self.menuParent[self.menuParent.size] = self getCurrent();
        if(isDefined(backMenu))
            self MenuArrays(backMenu);
    }
    
    self.menu["currentMenu"] = menu;
    self runMenuIndex(menu);
    self DestroyOpts();
    self drawText();
    self SetMenuTitle();
}
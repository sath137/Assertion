MenuTheme(color)
{
    self.menu["Main_Color"] = color;
    
    self.menu["ui"]["text"][self getCursor()].color = color;
    self.menu["ui"]["title"].color = color;
}

LoadMenuVars()
{
    self.menu["Main_Color"] = divideColor(255, 0, 0);
    self.menu["Bool_Color"] = divideColor(0, 200, 0);
    
    self.menu["X"] = 0;
    self.menu["Y"] = -150;
}
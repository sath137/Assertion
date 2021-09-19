createText(font, fontSize, sort, text, align, relative, x, y, alpha, color)
{
    textElem                = self maps\mp\gametypes\_hud_util::func_27ED(font, fontSize);
    textElem.hideWhenInMenu = true;
    textElem.archived       = false;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    textElem maps\mp\gametypes\_hud_util::func_8707(align, relative, x, y);
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    
    return textElem;
}
 
createRectangle(align, relative, x, y, width, height, color, sort, alpha, shader)
{
    uiElement                = NewClientHudElem(self);
    uiElement.elemType       = "icon";
    uiElement.children       = [];
    uiElement.hideWhenInMenu = true;
    uiElement.archived       = true;
    uiElement.width          = width;
    uiElement.height         = height;
    uiElement.align          = align;
    uiElement.relative       = relative;
    uiElement.xOffset        = 0;
    uiElement.yOffset        = 0;
    uiElement.sort           = sort;
    uiElement.color          = color;
    uiElement.alpha          = alpha;
    uiElement.shader         = shader;
    uiElement.foreground     = true;
    
    uiElement maps\mp\gametypes\_hud_util::func_86EF(level.var_A012);
    uiElement SetShader(shader, width, height);
    uiElement.hidden = false;
    uiElement maps\mp\gametypes\_hud_util::func_8707(align, relative, x, y);
    
    return uiElement;
}

hudMoveY(y, time)
{
    self MoveOverTime(time);
    self.y = y;
    wait time;
}

hudMoveX(x, time)
{
    self MoveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveXY(x, y, time)
{
    self MoveOverTime(time);
    self.x = x;
    self.y = y;
    wait time;
}

hudFade(alpha, time)
{
    self FadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudFadenDestroy(alpha, time)
{
    self hudFade(alpha, time);
    self destroy();
}

hudFadeColor(color, time)
{
    self FadeOverTime(time);
    self.color = color;
}

ChangeFontscaleOverTime1(scale, time)
{
    self ChangeFontscaleOverTime(time);
    self.fontScale = scale;
}

divideColor(c1, c2, c3)
{
    return (c1 / 255, c2 / 255, c3 / 255);
}

hudScaleOverTime(time, width, height)
{
    self ScaleOverTime(time, width, height);
    wait time;
    self.width = width;
    self.height = height;
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = GetArrayKeys(array);
    for(a=0;a<keys.size;a++)
        if(isDefined(array[keys[a]][0]))
            for(e=0;e<array[keys[a]].size;e++)
                array[keys[a]][e] destroy();
        else
            array[keys[a]] destroy();
}

ToUpper(string)
{
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final    = "";
    
    for(e=0;e<string.size;e++)
    { 
        char = ToLower(string[e]);
        if(IsSubStr(ToLower(alphabet), char)) 
        {
            for(a=0;a<alphabet.size;a++)
                if(char == ToLower(alphabet[a]))
                    final += alphabet[a];
        }
        else
            final += string[e];
    }
    return final;            
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a=(name.size - 1);a>=0;a--)
        if(name[a] == "]")
            break;
    return GetSubStr(name, (a + 1));
}

destroyAfter(time)
{
    wait time;
    if(isDefined(self))
        self destroy();
}

isInMenu()
{
    if(!isDefined(self.playerSetting["isInMenu"]))
        return false;
    return true;
}

isInArray(array, text)
{
    for(a=0;a<array.size;a++)
        if(array[a] == text)
            return true;
    return false;
}

getCurrent()
{
    return self.menu["currentMenu"];
}

getCursor()
{
    return self.menu["curs"][self getCurrent()];
}

setCursor(curs)
{
    self.menu["curs"][self getCurrent()] = curs;
}

BackMenu()
{
    return self.menuParent[(self.menuParent.size - 1)];
}

disconnect()
{
    ExitLevel(false);
}

GetPlayerArray()
{
    return GetEntArray("player", "classname");
}

SetTextFX(text, time)
{
    if(!isDefined(time))
        time = 3;
    self SetSafeText(text);
    self thread hudFade(1, .5);
    self SetPulseFx(int(1.5 * 25), int(time * 1000), 1000);
    wait time;
    self hudFade(0, .5);
    self destroy();
}
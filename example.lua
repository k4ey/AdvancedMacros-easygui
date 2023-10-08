---@class Gui
---@source ./guiManager.lua
local Gui = run("./guiManager.lua")
local g = Gui.new()
local f = g:newForm({
    {name="isSomething",type="checkbox", height = 50, width = 50, label = "checkbox", checked = true, textSize = 5},
    {name="isSomethingElse",type="checkbox", height = 50, width = 50, label = "checkbox2", checked = true, textSize = 5},
    {name="isSomethingElseElse",type="checkbox", height = 50, width = 50, label = "checkbox1", checked = true, textSize = 5},
    {name="itsName",type="input", height = 35, width = 100, label = "input1"},
    {name="position",type="formButton", textSize = 5, height = 50, width = 50, label = "callback button", callback=function ()
        return {getPlayerBlockPos()}
    end},
    {name="", type="submit", height = 50, width = 50, label = "checkbo", textSize = 5}
}, function (...)
        log(...)
end)
local g2 = Gui.new()
g2:newButton("area",10,50,50,function (...)
    local self = ...
    self:newTextLabel("choose things for your area",5)
    local f = self:newForm({
        {name="isSomething",type="checkbox", height = 50, width = 50, label = "checkbox", checked = true, textSize = 5},
        {name="isSomethingElse",type="checkbox", height = 50, width = 50, label = "checkbox2", checked = true, textSize = 5},
        {name="isSomethingElseElse",type="checkbox", height = 50, width = 50, label = "checkbox1", checked = true, textSize = 5},
        {name="itsName",type="input", height = 35, width = 100, label = "input1"},
        {name="position",type="formButton", textSize = 5, height = 50, width = 50, label = "callback button", callback=function ()
            return {getPlayerBlockPos()}
        end},
        {name="", type="submit", height = 50, width = 50, label = "checkbo", textSize = 5}
    }, function (...)
            log(...)
        end)
end)
g:newButton("change gui",5,50,50,function (...)
    local self = ...
    self:openAnotherGui(g2)
end)
local g3 = Gui.new()
g3:newTextLabel("hi",5)
for i=1,5 do
    g3:newButton("hi"..i,5,50,50,function ()
    end)
end

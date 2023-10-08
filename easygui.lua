
---@class Gui
local Gui = {}
Gui.__index = Gui
function Gui.new()
    ---@class Gui
    local self = setmetatable({}, Gui)

    self.gui = gui.new()

    ---@type number
    self.x = 0
    ---@type number
    self.y = 0

    ---@type number
    self.marginX = 10
    ---@type number
    self.marginY = 15

    ---@type number, number
    self.maxX, self.maxY = self.gui.getSize()

    self.elements = {}
    return self
end


---opens the gui
function Gui:open()
    self.gui.open()
end

---closes the gui
function Gui:close()
    self.gui.close()
end

---Opens another gui
---@param gui Gui
function Gui:openAnotherGui(gui)
    self.gui.close()
    gui.gui.open()
end

---Calculates suitable position for an element
---@param width integer
---@param height integer
function Gui:calculatePosition(width, height)
    local x,y = 0,0
    if self.x + width + self.marginX >= self.maxX then
        y = self.y + height + self.marginY
        x = 0
    else
        x = self.x + width + self.marginX
        y = self.y
    end
    return x,y
end

---Puts the element at the next empty position and updates the positioning
function Gui:putGroup(group)
    local x,y = self:calculatePosition(group.getWidth(),group.getHeight())
    self.x = x
    self.y = y
    group.move(x - group.getWidth() ,y)
end

---creates a button
---@param text string
---@param textSize integer
---@param width integer
---@param height integer
---@param callback function
---@return table
function Gui:newButton(text, textSize, width, height, callback)
    local group = self.gui.newGroup()

    local rect = self.gui.newRectangle(0, 0, width, height)
    rect.setOnMouseClick(function ()
        callback(self,group)
    end)


    group.getWidth = rect.getWidth
    group.getHeight = rect.getHeight
    group.getValue = function ()
        return group.value
    end

    local t = self.gui.newText(text,0,0)
    t.setTextSize(textSize)
    t.setParent(group)
    rect.setParent(group)

    self.elements[#self.elements+1] = group
    self:putGroup(group)
    return group
end

---Creates new checkbox for forms
---@param label string
---@param textSize integer
---@param width integer
---@param height integer
---@param checked boolean
---@return table
function Gui:newCheckbox(label, textSize, width, height, checked)
    local group = self.gui.newGroup()

    local rect = self.gui.newRectangle(0, 0, width, height)


    group.getWidth = rect.getWidth
    group.getHeight = rect.getHeight
    group.checked = checked or false
    group.getValue = function ()
        return group.checked
    end

    local box = self.gui.newBox(0, 0, width, height)
    if group.checked then
        box.setColor(0,1,0)
    else
        box.setColor(1,0,0)
    end
    rect.setOnMouseClick(function ()
        group.checked = not group.checked
        if group.checked then
            box.setColor(0,1,0)
        else
            box.setColor(1,0,0)
        end
    end)


    local t = self.gui.newText(label,0,0)
    t.setTextSize(textSize)
    t.setParent(group)
    rect.setParent(group)
    box.setParent(group)

    self.elements[#self.elements+1] = group
    self:putGroup(group)
    return group
end

---Creates new input
---@param label string
---@param width integer
---@param height integer
---@param callback function
function Gui:newInput(label, width, height, callback)
    local group = self.gui.newGroup()

    local text = self.gui.newText(label, 0,0)
    local textField = self.gui.newMinecraftTextField(0, 0, width, height)
    textField.setY(textField.getY() + text.getHeight())

    textField.setOnKeyPressed(function (...)
        local _, keycode = ...
        if keycode == 28 then
            callback(self, textField.getText(), group)
        end
    end)


    group.getWidth = textField.getWidth
    group.getHeight = function ()
        return textField.getHeight() + text.getHeight()
    end
    group.getValue = function ()
        return textField.getText()
    end



    textField.setParent(group)
    text.setParent(group)

    self.elements[#self.elements+1] = group
    self:putGroup(group)
    return group
end

---TODO add a "button" which allows you to set values from a callback. This will allow us to write to quickly save player pos and other things...
---@alias FormElementName "input" | "checkbox" | "formButton" | "submit"

---@class FormElement
---@field name string
---@field type FormElementName
---@field label string
---@field width integer
---@field height integer
---@field textSize? integer
---@field checked? boolean
---@field callback? function

---Accepts a list of FormElements
---@param elements FormElement[]
---@param submitCb function
function Gui:newForm(elements, submitCb)
    local formElements = {}
    local elem
    for _, element in pairs(elements) do
        if element.type == "input" then
            elem = self:newInput(element.label, element.width, element.height, function () end)
        elseif element.type == "checkbox" then
            elem = self:newCheckbox(element.label, element.textSize, element.width, element.height, element.checked)
        elseif element.type == "formButton" then
            elem = self:newButton(element.label, element.textSize, element.width, element.height, function (...)
                local _, parent = ...
                parent.value = element.callback()
            end)
        elseif element.type == "submit" then
            elem = self:newButton(element.label, element.textSize, element.width, element.height, function ()
                local values = {}
                for name, formElem in pairs(formElements) do
                    values[name] = formElem.getValue and formElem.getValue()
                end
                submitCb(values)
            end)
        end
        assert(formElements[element.name] == nil, "names must be distinct!")
        formElements[element.name] = elem
    end
end

---Creates new text label, its used mainly for titles, forces all the next elements to be placed under it
---also this is pretty buggy so use with caution lol im only adding it cuz it suits my needs
---@param text string
---@param textSize integer
---@return table
function Gui:newTextLabel(text, textSize)
    local group = self.gui.newGroup()
    local t = self.gui.newText(text,0,0)
    t.setTextSize(textSize)
    t.setParent(group)

    group.getWidth = t.getWidth
    group.getHeight = t.getHeight


    self.elements[#self.elements+1] = group
    group.move(self:calculatePosition(group.getWidth(),group.getHeight()))
    self.y = self.y + group.getHeight()
    return group
end

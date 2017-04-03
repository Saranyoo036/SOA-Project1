require("google-translate")
local widget = require "widget"
local JSON = require "json"
local bg, imgBtn, imgTsl, imgChg, imgDown
local LngCode, toLngCode, tempBtn
local btnLng, btnToLng, bgLng, bgToLng, textField, LngText, toLngText, selectLng, selectGroup, mainGroup
local init,showSelect,hideSelect,translate,swap
local language = {"English","Thai","Arabic","Italian","Spanish","Romanian"}
local languageCode = {"en","th","ar","it","es","ro"}
local cx = display.contentCenterX
local cy = display.contentCenterY
local width = display.contentWidth
local height = display.contentHeight
local url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20161004T093932Z.fb9e4c1519f9ece3.52397fb9a67f2016a332a2dcbddf6c4cca277bb7&"

local function networkListener( event )
    LngText.text = textField.text
    textField.text = ""
    imgDown.isVisible = true
    if ( event.isError ) then
        toLngText:setFillColor( 1, 0, 0, 0.7 )
        toLngText.text = "Network Error"
    else
        response = JSON.decode(event.response)
        if(response["code"] == 200 and LngText.text ~= response["text"][1]) then
            reqTranslate( response["text"][1], btnToLng.id )
            toLngText:setFillColor( 1, 1, 1 )
            toLngText.text = response["text"][1]
        else
            toLngText:setFillColor( 1, 0, 0, 0.7 )
            toLngText.text = "Can't Translate"
        end
    end
end

function swap(event)
    if(event.phase == "began") then
        b1, b2 = btnLng:getLabel(), btnToLng:getLabel()
        btnLng:setLabel(b2)
        btnToLng:setLabel(b1)
        btnLng.id, btnToLng.id = btnToLng.id, btnLng.id
    end
end

function translate(event)
    if(event.phase == "began") then
        if(btnLng.id ~= btnToLng.id) then
            if(textField.text ~= "") then
                request = url.."lang="..btnLng.id.."-"..btnToLng.id.."&text="..textField.text
                network.request(request, "GET", networkListener, {} )
                print(request)
            end
        end
    end
end

function showSelect()
    textField.isVisible = false
    bg.isVisible = true
    selectGroup.isVisible = true
    transition.to( selectGroup, { time = 200 , xScale = 1, yScale = 1, alpha = 1 } )
    selectGroup.id = true
end

function hideSelect()
    textField.isVisible = true
    selectGroup.isVisible = false
    bg.isVisible = false
    selectGroup:scale(0,0)
    selectGroup.alpha = 0
    selectGroup.id = false
end

function handleSelecltLng(event)
    if(event.phase == "began") then
        tempBtn:setLabel(event.target:getLabel())
        tempBtn.id = event.target.id
        hideSelect()
    end
end

function handleButtonEvent(event)
    if(event.phase == "began") then
        hideSelect()
        tempBtn = event.target
        showSelect()
    end
end

function init()
    title = display.newText( "Translate", cx, 10, native.systemFontBold, 50 )
    title:setFillColor( 1, 1, 1, 0.7 )
    mainGroup = display.newGroup()
    btnLng = widget.newButton({
        label = language[1],
        id = languageCode[1],
        width = width/2 - 50,
        height = 40,
        shape = "roundedRect",
        cornerRadius = 2,
        labelColor = { default={1,1,1} },
        fillColor = { default={42/255,123/255,255/255,1}, over={42/255,123/255,255/255,0.4} },
        strokeWidth = 4,
        onEvent = handleButtonEvent
    })
    btnToLng = widget.newButton({
        label = language[2],
        id = languageCode[2],
        width = width/2-50,
        height = 40,
        shape = "roundedRect",
        cornerRadius = 2,
        labelColor = { default={1,1,1} },
        fillColor = { default={42/255,123/255,255/255,1}, over={42/255,123/255,255/255,0.4} },
        strokeWidth = 4,
        onEvent = handleButtonEvent
    })
    b = display.newGroup()
    btnLng.x = btnLng.width-30
    btnToLng.x = cx+btnLng.width-30
    imgSwap = display.newImage("change.png",cx,20)
    imgSwap:scale(0.5,0.5)
    b:insert(btnLng)
    b:insert(btnToLng)
    b:insert(imgSwap)
    b.y = 60

    bgToLng = display.newRect( cx, cy+100, width, 400 )
    bgToLng:setFillColor(42/255,123/255,255/255,1)

    bgLng = display.newRect( cx, cy-50, width, 150 )
    bgLng:setFillColor(1)

    textField = native.newTextField( cx, bgLng.y, width-50, 50 )
    textField.align = "center"
    vertices = { cx,cy,cx-20,cy-20,cx+20,cy-20 }
    local t = display.newPolygon( cx ,cy+35,vertices )
    t:setFillColor(1)
    LngText = display.newText( "", cx, bgToLng.y, native.systemFontBold, 30 )
    toLngText = display.newText( "", cx, bgToLng.y+100, native.systemFontBold, 30 )
    imgDown = display.newPolygon( cx ,bgToLng.y+50,vertices )
    imgDown.isVisible = false
    bgToLng:addEventListener("touch",translate)
    imgSwap:addEventListener("touch",swap)
    ------------------------------
    bg = display.newRect( cx, cy, width, height+200 )
    bg:setFillColor(0,0,0,0.5)
    selectGroup = display.newGroup()
    tbg = display.newRect( selectGroup, 0, 0, width-50, height-100 )
    selectLng = {}
    y = -130
    for i=1,#language do
        selectLng[i] = widget.newButton({
            label = language[i],
            id = languageCode[i],
            width = width-50,
            height = 40,
            shape = "roundedRect",
            cornerRadius = 2,
            labelColor = { default={0,0,0} },
            fillColor = { default={42/255,123/255,255/255,0.3}, over={42/255,123/255,255/255,0.2} },
            strokeWidth = 4,
            onEvent = handleSelecltLng
        })
        selectLng[i].x = 0
        selectLng[i].y = y
        selectGroup:insert(selectLng[i])
        y = y + 50
    end
    selectGroup.x = cx
    selectGroup.y = cy
    hideSelect()
end

init()

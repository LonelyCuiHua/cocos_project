
local MainScene = class("MainScene", function()
	return display.newScene("MainScene")
end)

local Global = Global
local iGridSize = Global.iGridSize
local iPlayWidth = Global.iPlayWidth
local iPlayHeight = Global.iPlayHeight
local tNumColor = Global.tNumColor

local c4b = Global.c4b
local tMouseDown = {}

function MainScene:ctor()
    -- local oDraw = cc.DrawNode:create()
    -- self:addChild(oDraw)
    -- a:设置透明度 1-255，越大越透明
    -- oDraw:drawRect({x = 0, y = 0}, {x = 100, y = 100}, { r = 153, g = 75, b = 244, a = 1 }) 
    -- oDraw:drawSolidRect(cc.p(0, 0), cc.p(640, 960), c4b(205,133,63,1))

    self:DrawAll()
    self.GridMgr = GridMgr.new(self)
    self.GridMgr:NextTurn()


    self:ProcessTouchInput()
end

function MainScene:DrawAll()
    local tVisiblesize = cc.Director:getInstance():getVisibleSize()-- 获取可视屏幕尺寸
    local oDraw = cc.DrawNode:create()
    self:addChild(oDraw)
    oDraw:drawSolidRect(cc.p(0, 0), cc.p(tVisiblesize.width, tVisiblesize.height), c4b(205,170,125,255))
    for x = 0, iPlayWidth -1 do
        for y = 0, iPlayHeight -1 do
            Global.DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(x, y)), cc.p(Global.Grid2Pos(x+1, y+1)), 10, c4b(238,216,174,255))
        end
    end

    self.oReset = GridSprite.new(self, 3, 4, "重置")
    -- self.oGrid.sp:runAction(cc.MoveTo:create(0.1, cc.p(oGrid:GetPos(0, 0))))




    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(0, 0)), cc.p(Global.Grid2Pos(1, 1)), 20, c4b(255,160,122,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(1, 0)), cc.p(Global.Grid2Pos(2, 1)), 20, c4b(244,164,96,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(2, 0)), cc.p(Global.Grid2Pos(3, 1)), 20, c4b(255,127,80,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(3, 0)), cc.p(Global.Grid2Pos(4, 1)), 20, c4b(178,34,34,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(0, 1)), cc.p(Global.Grid2Pos(1, 2)), 20, c4b(250,128,114,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(1, 1)), cc.p(Global.Grid2Pos(2, 2)), 20, c4b(255,140,0,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(2, 1)), cc.p(Global.Grid2Pos(3, 2)), 20, c4b(255,69,0,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(3, 1)), cc.p(Global.Grid2Pos(4, 2)), 20, c4b(165,42,42,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(0, 2)), cc.p(Global.Grid2Pos(1, 3)), 20, c4b(255,165,0,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(1, 2)), cc.p(Global.Grid2Pos(2, 3)), 20, c4b(218,165,32,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(2, 2)), cc.p(Global.Grid2Pos(3, 3)), 20, c4b(255,215,0,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(3, 2)), cc.p(Global.Grid2Pos(4, 3)), 20, c4b(210,180,140,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(0, 3)), cc.p(Global.Grid2Pos(1, 4)), 20, c4b(135,206,235,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(1, 3)), cc.p(Global.Grid2Pos(2, 4)), 20, c4b(0,191,255,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(2, 3)), cc.p(Global.Grid2Pos(3, 4)), 20, c4b(70,130,180,255))
    -- self:DrawOneGrid(oDraw, cc.p(Global.Grid2Pos(3, 3)), cc.p(Global.Grid2Pos(4, 4)), 20, c4b(95,158,160,255))
end

function MainScene:ProcessTouchInput()
    local function onMouseDown(touch, event)
        -- print("onMouseDown=============")
        local oLocation = touch:getLocation()
        -- print(oLocation.x, oLocation.y)
        tMouseDown = {x = oLocation.x, y = oLocation.y}
        if self.oReset:IsInGrid(oLocation.x, oLocation.y) then
            self.GridMgr:Clear()
            self.GridMgr:NextTurn()
            return false
        end
        return true
    end
    local function onMouseUp(touch, event)
        -- print("=============onMouseUp")
        local oLocation = touch:getLocation()
        -- print(oLocation.x, oLocation.y)
        if not next(tMouseDown) then 
            print("????????????")
            return 
        end
        local iMouseUpX = oLocation.x
        local iMouseUpY = oLocation.y
        local iDeltaX = tMouseDown.x - iMouseUpX
        local iDeltaY = tMouseDown.y - iMouseUpY
        -- print("iDeltaX:"..iDeltaX.."  iDeltaY:"..iDeltaY)
        -- -------------
        -- |(0,0)
        -- |
        -- |
        -- |
        --点击的屏幕原点在左上角 
        if math.abs(iDeltaX) > math.abs(iDeltaY) then
            if iDeltaX > 0 then
                -- left
                -- print("left")
                self.GridMgr:MoveDir("left")
            elseif iDeltaX < 0 then
                -- right
                -- print("right")
                self.GridMgr:MoveDir("right")
            end
        else
            if iDeltaY < 0 then
                -- up
                -- print("up")
                self.GridMgr:MoveDir("up")
            elseif iDeltaY > 0 then
                -- down
                -- print("down")
                self.GridMgr:MoveDir("down")
            end
        end
        tMouseDown = {}
    end
    local oListener = cc.EventListenerTouchOneByOne:create()
    oListener:registerScriptHandler(onMouseDown, cc.Handler.EVENT_TOUCH_BEGAN)
    oListener:registerScriptHandler(onMouseUp, cc.Handler.EVENT_TOUCH_ENDED)
    -- local oListener = cc.EventListenerMouse:create()
    -- oListener:registerScriptHandler(onMouseDown, cc.Handler.EVENT_MOUSE_DOWN)
    -- oListener:registerScriptHandler(onMouseUp, cc.Handler.EVENT_MOUSE_UP)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(oListener, self)
end

return MainScene


local MainScene = class("MainScene", function ()
	return display.newScene("MainScene")
end)

local spriteFrameCache = cc.SpriteFrameCache:getInstance()

local tPressKeyCode = {}
local iPressTime = 0

function MainScene:ctor()
    -- -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    -- -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)

    
    -- 添加精灵帧缓存
    spriteFrameCache:addSpriteFrames("Brid.plist", "Brid.png")

    local bg = display.newSprite()
    local oFrame = spriteFrameCache:getSpriteFrame("bird_bg.png")
    bg:setSpriteFrame(oFrame)
    bg:setPosition(display.cx, display.cy)

    local oDraw = cc.DrawNode:create()
    local iSRectX = display.cx-bg:getContentSize().width*0.5
    local iSRectY = display.cy-bg:getContentSize().height*0.5
    local iERectX = display.cx+bg:getContentSize().width*0.5
    local iERectY = display.cy+bg:getContentSize().height*0.5
    oDraw:drawSolidRect(cc.p(iSRectX, iSRectY), cc.p(iERectX, iERectY), cc.c4b(1,1,1,1))
    -- create一个遮罩，超出规定区域的sprite不显示
    local oClipping = cc.ClippingNode:create(oDraw)
    oClipping:addChild(bg)
    self:addChild(oClipping)

    

    self.Bird = BridEntity.new(oClipping)
    self.Obstacle = Obstacle.new(oClipping, bg, self.Bird)
    self:Update()
    self:ProcessKeyInput()
end

function MainScene:ProcessKeyInput()
	local function fKeyboardPressed(keyCode, event)
		self.iPressTimeId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
			tPressKeyCode[keyCode] = true
			iPressTime = iPressTime + 1
		end, 0.2, false)
		-- tPressKeyCode[keyCode] = true
		if keyCode == 59 then --空格
			if self.iFallTimeId then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.iFallTimeId)
				self.iFallTimeId = nil
			end
			self.Bird:Jump(self.Update, self)
		end
	end
	local function fKeyboardReleased(keyCode, event)
		-- print("fKeyboardReleased--------"..keyCode)
		tPressKeyCode[keyCode] = nil
		if keyCode == 59 then --空格
			iPressTime = 0
			if self.iPressTimeId then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.iPressTimeId)
				self.iPressTimeId = nil
			end
		end
	end
	local oListener1 = cc.EventListenerKeyboard:create()
	local oListener2 = cc.EventListenerTouchOneByOne:create()
	oListener1:registerScriptHandler(fKeyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	oListener1:registerScriptHandler(fKeyboardReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
	local oEventDispatcher = self:getEventDispatcher()
	oEventDispatcher:addEventListenerWithSceneGraphPriority(oListener1, self)
	-- oEventDispatcher:addEventListenerWithSceneGraphPriority(oListener2, self)
	local function fScheduleCallBack()
		for iKeyCode, bPressed in pairs(tPressKeyCode) do
			if bPressed then
				if iKeyCode == 59 then
					if self.iFallTimeId then
						cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.iFallTimeId)
						self.iFallTimeId = nil
					end
					self.Bird:Jump(self.Update, self, iPressTime)
				end
			end
		end
	end
	local oSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(fScheduleCallBack, 0.2, false)

end

function MainScene:Update()
	local function fScheduleCallBack1()
		if self.Bird then
			-- self.Bird:Move(-2)
			self.Bird:TurnDir("down")
			self.Bird:FreeFalling(1)
		end
	end
	
	if self.iFallTimeId then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.iFallTimeId)
		self.iFallTimeId = nil
	end
	self.iFallTimeId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(fScheduleCallBack1, 0.2, false)
	
end

return MainScene

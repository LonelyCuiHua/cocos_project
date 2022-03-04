--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local Obstacle = class("Obstacle")

local spriteFrameCache = cc.SpriteFrameCache:getInstance()

function Obstacle:ctor(node, spBg, oBird)
	self.node = node
	self.iPlayHeight = spBg:getContentSize().height
	self.iPlayWidth = spBg:getContentSize().width
	self.oBird = oBird
	self.iSpeed = 10
	self.iMoveT = 0
	self.tObstacle = {}
	self:Add()
	self:Update()
end

function Obstacle:Update()
	local function fScheduleCallBack()
		self:Move()
		if self:CheckCollide() or self.oBird.sp:getPositionY() < 0 then
			print("================GameOver")
			self:Reset()
			self.oBird:Reset()
		end
		self.iMoveT = self.iMoveT + 1
		if self.iMoveT * self.iSpeed > 200 then
			self.iMoveT = 0
			self:Add()
		end
	end
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(fScheduleCallBack, 0.2, false)
end

function Obstacle:Move()
	local tRemoveList = {}
	for k, tSp in ipairs(self.tObstacle) do
		local spUp = tSp.spUp
		local spDown = tSp.spDown
		local iUpMoveX = spUp:getPositionX()-self.iSpeed
		local iUpMoveY = spUp:getPositionY()
		local iDownMoveX = spDown:getPositionX()-self.iSpeed
		local iDownMoveY = spDown:getPositionY()
		local oMove1 = cc.MoveTo:create(0.2, cc.p(iUpMoveX, iUpMoveY))
		local oMove2 = cc.MoveTo:create(0.2, cc.p(iDownMoveX, iDownMoveY))
		spUp:runAction(oMove1)
		spDown:runAction(oMove2)
		if iUpMoveX <= (display.cx-(self.iPlayWidth+spUp:getContentSize().width)*0.5) then
			table.insert(tRemoveList, k)
		end
	end
	table.sort(tRemoveList, function(a, b)
		return a > b
	end)
	for _, k in ipairs(tRemoveList) do
		local tSp = self.tObstacle[k]
		local spUp = tSp.spUp
		local spDown = tSp.spDown
		self.node:removeChild(spUp)
		self.node:removeChild(spDown)
		table.remove(self.tObstacle, k)
	end
end

function Obstacle:Add()
	local oUpFrame = spriteFrameCache:getSpriteFrame("obstacle_up.png")
	local oDownFrame = spriteFrameCache:getSpriteFrame("obstacle_down.png")
	local spUp = display.newSprite()
	local spDown = display.newSprite()
	spUp:setSpriteFrame(oUpFrame)
	spDown:setSpriteFrame(oDownFrame)
	local iUpY, iDownY = self:GetRandomPos(spUp:getContentSize().height, spDown:getContentSize().height)
	local iUpX = display.cx+(self.iPlayWidth+spUp:getContentSize().width)*0.5  
	-- local iUpY = display.top-spUp:getContentSize().height*0.5
	local iDownX = display.cx+(self.iPlayWidth+spDown:getContentSize().width)*0.5
	-- local iDownY = display.bottom+spDown:getContentSize().height*0.5
	spUp:setPosition(iUpX, iUpY)
	spDown:setPosition(iDownX, iDownY)
	spUp:addTo(self.node)
	spDown:addTo(self.node)
	local tData = {}
	tData.spUp = spUp
	tData.spDown = spDown
	table.insert(self.tObstacle, tData)
end

function Obstacle:GetRandomPos(iUpH, iDownH)
	local iOffect = self.oBird.iBirdH + math.random(self.oBird.iBirdH*2, self.oBird.iBirdH*3)
	local iPos = math.random(iOffect+100, self.iPlayHeight-iOffect-10)
	local iUpPos = iPos + iOffect*0.5 + iUpH*0.5
	local iDownPos = iPos - iOffect*0.5 - iDownH*0.5
	return iUpPos, iDownPos
end

local function CheckRectCollide(iRight, iLeft, iTop, iBottom)
	if iRight < iLeft then
		return false
	end
	if iTop < iBottom then
		return false
	end
	return true
end

function Obstacle:CheckCollide()
	local iBirdT = self.oBird.sp:getPositionY() + self.oBird.iBirdH*0.5
	local iBirdB = self.oBird.sp:getPositionY() - self.oBird.iBirdH*0.5
	local iBirdL = self.oBird.sp:getPositionX() - self.oBird.iBirdW*0.5
	local iBirdR = self.oBird.sp:getPositionX() + self.oBird.iBirdW*0.5
	for k, tSp in ipairs(self.tObstacle) do
		local spUp = tSp.spUp
		local spDown = tSp.spDown
		local iUpT = spUp:getPositionY() + spUp:getContentSize().height*0.5
		local iUpB = spUp:getPositionY() - spUp:getContentSize().height*0.5
		local iUpL = spUp:getPositionX() - spUp:getContentSize().width*0.5
		local iUpR = spUp:getPositionX() + spUp:getContentSize().width*0.5
		local iDownT = spDown:getPositionY() + spDown:getContentSize().height*0.5
		local iDownB = spDown:getPositionY() - spDown:getContentSize().height*0.5
		local iDownL = spDown:getPositionX() - spDown:getContentSize().width*0.5
		local iDownR = spDown:getPositionX() + spDown:getContentSize().width*0.5
		
		local iRight1 = math.min(iBirdR, iUpR)
		local iLeft1 = math.max(iBirdL, iUpL)
		local iTop1 = math.min(iBirdT, iUpT)
		local iBottom1 = math.max(iBirdB, iUpB)
		local iRight2 = math.min(iBirdR, iDownR)
		local iLeft2 = math.max(iBirdL, iDownL)
		local iTop2 = math.min(iBirdT, iDownT)
		local iBottom2 = math.max(iBirdB, iDownB)
		if CheckRectCollide(iRight1, iLeft1, iTop1, iBottom1) or CheckRectCollide(iRight2, iLeft2, iTop2, iBottom2) then
			return true
		end
	end 
	return false
end

function Obstacle:Reset()
	for k, tSp in ipairs(self.tObstacle) do
		local spUp = tSp.spUp
		local spDown = tSp.spDown
		self.node:removeChild(spUp)
		self.node:removeChild(spDown)
	end
	self.tObstacle = {}
end

return Obstacle

--endregion

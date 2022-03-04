--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local BridEntity = class("BridEntity")

local spriteFrameCache = cc.SpriteFrameCache:getInstance()

local iPress = 0

function BridEntity:ctor(node)
	self.node = node
	self.v0 = -5
	self.vt = 0
	self.t = 0
	self.h1 = 0
	self.h2 = 0
	self.sp = display.newSprite()
	self.sp:setPosition(display.cx, display.cy)
	self.sp:addTo(node)
	self:InitFly(0.2, -1)
end

function BridEntity:TurnDir(sDir)
	if sDir == "down" then
		self.sp:setRotation(45)
	elseif sDir == "up" then
		self.sp:setRotation(-45)
	end
end

function BridEntity:FreeFalling(iDeltaT, iMoveT)
	local g = 9.8
	self.t = self.t + (iDeltaT or 0)
	self.vt = self.v0 - g * self.t
	self.h1 = self.h2
	self.h2 = self.v0 * self.t - 0.5 * g * self.t * self.t
	self:Move(self.h2 - self.h1, iMoveT)
end

function BridEntity:Jump(fCallBack, object, iPressTime)
	self:TurnDir("up")
	if self.sp then
		self.h1 = 0
		self.h2 = 0
		if self.vt < 0 then
			self.v0 = 40 + self.vt
		else
			-- self.v0 = 40 + math.ldexp(1, (iPressTime or 0)) -- 1*(2的iPressTime次方)
			self.v0 = 40
		end
		self.t = 0
		iPress = iPress + 1
		
		if self.oAnimate then
			self.sp:stopAction(self.oAnimate)
		end
		
		self:InitFly(0.1, 1, function ()
			self.oAnimate = nil
			iPress = iPress - 1
			if iPress <= 0 then
				self:InitFly(0.3, -1)
				self.v0 = -5
				self.vt = 0
				self.t = 0
				self.h1 = 0
				self.h2 = 0
				fCallBack(object)
			end
		end)
		-- self:Move(5)
		self:FreeFalling(1, 0.3)
	end
end

function BridEntity:Move(iDistance, iMoveT)
	iDistance = iDistance or 0
	local moveAction = cc.MoveTo:create((iMoveT or 0.2), cc.p(self.sp:getPositionX(), self.sp:getPositionY()+iDistance))
	-- self.sp:setPosition(self.sp:getPositionX(), self.sp:getPositionY()+iDistance)
	self.sp:runAction(moveAction)
end

function BridEntity:Reset()
	self.v0 = -5
	self.vt = 0
	self.t = 0
	self.h1 = 0
	self.h2 = 0
	self.sp:setPosition(display.cx, display.cy)
end

function BridEntity:InitFly(iDelay, iLoop, fCallBack)
	-- display.newSprite("bird_hero")
    local oFrame1 = spriteFrameCache:getSpriteFrame("bird_hero.png")
    local oFrame2 = spriteFrameCache:getSpriteFrame("bird_hero2.png")
    local oFrame3 = spriteFrameCache:getSpriteFrame("bird_hero3.png")
    local spBird = display.newSprite()
    spBird:setSpriteFrame(oFrame1)
    self.iBirdW = spBird:getContentSize().width
    self.iBirdH = spBird:getContentSize().height

    --使用精灵帧实现动画
    --使用精灵帧实现动画
    --使用精灵帧实现动画
    -- 加载的是.plist的资源
    local oAnimation = cc.Animation:createWithSpriteFrames({oFrame1, oFrame2, oFrame3}, (iDelay or 0.2), (iLoop or 1))
    -- oAnimation:addSpriteFrame(oFrame1) --加入序列帧动画
    -- oAnimation:addSpriteFrame(oFrame2) --加入序列帧动画
    -- oAnimation:addSpriteFrame(oFrame3) --加入序列帧动画
    oAnimation:setRestoreOriginalFrame(true) -- 播放结束时是否返回第一帧， sp创建时是一个空的，所以第一帧是空的
    self.oAnimate = cc.Animate:create(oAnimation)
    if fCallBack then
    	local oSequence = cc.Sequence:create(self.oAnimate, cc.CallFunc:create(fCallBack))
    	self.sp:runAction(oSequence)
    else
    	self.sp:runAction(self.oAnimate)
    end
    

    -- 使用普通方式实现动画
    -- 使用普通方式实现动画
    -- 使用普通方式实现动画
    -- 加载的是图片资源.png，不是.plist
    -- local oAnimation = cc.Animation:create() --创建动画
    -- oAnimation:addSpriteFrameWithFile("bird_hero.png") -- 加入序列帧动画
    -- oAnimation:addSpriteFrameWithFile("bird_hero2.png") -- 加入序列帧动画
    -- oAnimation:addSpriteFrameWithFile("bird_hero3.png") -- 加入序列帧动画
    -- oAnimation:setRestoreOriginalFrame(true) -- 播放结束时是否返回第一帧
    -- oAnimation:setLoops(-1) -- 设置播放次数，为-1使表示无限循环
    -- oAnimation:setDelayPerUnit(0.2) --两帧之间的播放间隔
    -- local oAnimate = cc.Animate:create(oAnimation) --创建动画动作 对象
    -- self.sp:runAction(oAnimate)
end

return BridEntity

--endregion

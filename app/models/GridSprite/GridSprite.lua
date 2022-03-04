--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GridSprite = class("GridSprite")

local Global = Global
local iGridSize = Global.iGridSize
local tNumColor = Global.tNumColor
local tNumSize = Global.tNumSize

function GridSprite:ctor(node, x, y, iNum)
	self.node = node
	self.x = x
	self.y = y
	self.iNum = iNum
	self.sp = display.newSprite()
	self.Draw = cc.DrawNode:create()
	self.Label = cc.Label:createWithSystemFont(iNum, "Arial", (tNumSize[iNum] or 50))
	self.node:addChild(self.sp)
	self.sp:addChild(self.Draw)
	self.sp:addChild(self.Label)
	self.sp:setPosition(self:SetRealPos(x, y, 20))

end

function GridSprite:SetRealPos(x, y, iOffect)
	local iStartPosX, iStartPosY = Global.Grid2Pos(x, y)
	local iEndPosX, iEndPosY = Global.Grid2Pos(x+1, y+1)
	local iSRectX = iOffect - (iEndPosX - iStartPosX) * 0.5
	local iSRectY = iOffect - (iEndPosY - iStartPosY) * 0.5
	local iERectX = iGridSize - iOffect - (iEndPosX - iStartPosX) * 0.5
	local iERectY = iGridSize - iOffect - (iEndPosY - iStartPosY) * 0.5
	self.Draw:drawSolidRect(cc.p(iSRectX, iSRectY), cc.p(iERectX, iERectY), (tNumColor[self.iNum] or Global.c4b(210,180,140,255)))
	return (iStartPosX+iEndPosX)*0.5, (iStartPosY+iEndPosY)*0.5
end

function GridSprite:GetRealPos(x, y)
	local iStartPosX, iStartPosY = Global.Grid2Pos(x, y)
	local iEndPosX, iEndPosY = Global.Grid2Pos(x+1, y+1)
	return (iStartPosX+iEndPosX)*0.5, (iStartPosY+iEndPosY)*0.5
end

function GridSprite:SetPos(x, y)
	self.sp:setPosition(self:SetRealPos(x, y, 20))
end

function GridSprite:GetPos(x, y)
	return self:GetRealPos(x, y)
end

function GridSprite:IsInGrid(iPosX, iPosY)
	local iStartPosX, iStartPosY = Global.Grid2Pos(self.x, self.y)
	local iEndPosX, iEndPosY = Global.Grid2Pos(self.x+1, self.y+1)
	if iPosX <= iEndPosX and iPosX >= iStartPosX and iPosY <= iEndPosY and iPosY >= iStartPosY then
		return true
	end
	return false
end

function GridSprite:Destory()
	self.node:removeChild(self.sp)
	self.sp = nil
end

return GridSprite

--endregion

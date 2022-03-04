--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GridMgr = class("GridMgr")

local Global = Global
local iPlayWidth = Global.iPlayWidth
local iPlayHeight = Global.iPlayHeight
local MakePosKey = Global.MakePosKey

local tCountToWeight = {
	{1, 90},
	{2, 10},
}
local tValueToWeight = {
	{2, 70},
	{4, 30},
}

local tIndex2Pos = {
	-- [1] = MakePosKey(0, 3),
	-- [2] = MakePosKey(1, 3),
	-- [3] = MakePosKey(2, 3),
	-- [4] = MakePosKey(3, 3),
	-- [5] = MakePosKey(0, 2),
	-- [6] = MakePosKey(1, 2),
	-- [7] = MakePosKey(2, 2),
	-- [8] = MakePosKey(3, 2),
	-- [9] = MakePosKey(0, 1),
	-- [10] = MakePosKey(1, 1),
	-- [11] = MakePosKey(2, 1),
	-- [12] = MakePosKey(3, 1),
	-- [13] = MakePosKey(0, 0),
	-- [14] = MakePosKey(1, 0),
	-- [15] = MakePosKey(2, 0),
	-- [16] = MakePosKey(3, 0),
	[1] = {0, 3},
	[2] = {1, 3},
	[3] = {2, 3},
	[4] = {3, 3},
	[5] = {0, 2},
	[6] = {1, 2},
	[7] = {2, 2},
	[8] = {3, 2},
	[9] = {0, 1},
	[10] = {1, 1},
	[11] = {2, 1},
	[12] = {3, 1},
	[13] = {0, 0},
	[14] = {1, 0},
	[15] = {2, 0},
	[16] = {3, 0},
}

local tPos2Index = {
	["left"] = {
		{ 1,  2,  3,  4},
		{ 5,  6,  7,  8},
		{ 9, 10, 11, 12},
		{13, 14, 15, 16},
	},
	["right"] = {
		{ 4,  3,  2,  1},
		{ 8,  7,  6,  5},
		{12, 11, 10,  9},
		{16, 15, 14, 13},
	},
	["up"] = {
		{ 1,  5,  9, 13},
		{ 2,  6, 10, 14},
		{ 3,  7, 11, 15},
		{ 4,  8, 12, 16},
	},
	["down"] = {
		{13,  9,  5,  1},
		{14, 10,  6,  2},
		{15, 11,  7,  3},
		{16, 12,  8,  4},
	},
}
--  1, 2, 3, 4
--  5, 6, 7, 8
--  9,10,11,12
-- 13,14,15,16


function GridMgr:ctor(node)
	self.node = node
	self.tGrid = {}
	-- self.tEmptyGrid = {}
end

function GridMgr:GetGridNum()
	local iLen = 0
	for _, _ in pairs(self.tGrid) do
		iLen = iLen + 1
	end
	return iLen
end

function GridMgr:AddOneGrid(iIndex, iValue)
	local tPos = tIndex2Pos[iIndex]
	if not tPos then return end
	local sPosKey = MakePosKey(tPos[1], tPos[2])
	if self.tGrid[sPosKey] then return end
	local oGrid = GridSprite.new(self.node, tPos[1], tPos[2], iValue)
	self.tGrid[sPosKey] = oGrid
end

function GridMgr:UpdateOneGrid(iIndex, iValue)
	local tPos = tIndex2Pos[iIndex]
	if not tPos then return end
	local sPosKey = MakePosKey(tPos[1], tPos[2])
	if not self.tGrid[sPosKey] then 
		self:AddOneGrid(iIndex, iValue)
		return 
	end
	if iValue == 0 then
		self.tGrid[sPosKey]:Destory()
		self.tGrid[sPosKey] = nil
		return
	end
	self.tGrid[sPosKey]:Destory()
	local oGrid = GridSprite.new(self.node, tPos[1], tPos[2], iValue)
	self.tGrid[sPosKey] = oGrid
end

function GridMgr:NextTurn()
	if self:IsOver() then
		print("OVER!!!!!!!!!!!!!!!!!!!!!")
		return
	end
	local iGridNum = self:GetGridNum()
	local iCount = self:GetRandomCount(2)
	if iGridNum == iPlayWidth * iPlayHeight - 1 then
		iCount = self:GetRandomCount(1)
	end
	for i = 1, iCount do
		local iIndex, iValue = self:GetRandomPosAndVal()
		self:UpdateOneGrid(iIndex, iValue)
	end
end

function GridMgr:GetRandomCount(iMax)
	if iMax <= 1 then return 1 end
	local iAllWeight = 0
	for _, tData in pairs(tCountToWeight) do
		iAllWeight = iAllWeight + tData[2] or 0
	end
	local iRand = math.random(1, iAllWeight)
	local iCount
	for _, tData in ipairs(tCountToWeight) do
		if iRand <= tData[2] then
			iCount = tData[1]
			break
		end
		iRand = iRand - tData[2]
	end
	iCount = iCount or 1
	return iCount
end

function GridMgr:GetRandomPosAndVal()
	local iLen = self:GetGridNum()
	if iLen >= iPlayWidth * iPlayHeight then return end
	local tEmptyGrid = {}
	local iLen = 0
	for iIndex, tPos in pairs(tIndex2Pos) do
		local sPosKey = MakePosKey(tPos[1], tPos[2])
		if not self.tGrid[sPosKey] then
			table.insert(tEmptyGrid, iIndex)
			iLen = iLen + 1
		end
	end

	local iKey = math.random(1, iLen)
	local iAllWeight = 0
	for _, tData in pairs(tValueToWeight) do
		iAllWeight = iAllWeight + tData[2] or 0
	end
	local iRand = math.random(1, iAllWeight)
	local iValue
	for _, tData in ipairs(tValueToWeight) do
		if iRand <= tData[2] then
			iValue = tData[1]
			break
		end
		iRand = iRand - tData[2]
	end
	iValue = iValue or 2
	return tEmptyGrid[iKey], iValue
end

function GridMgr:IsOver()
	if self:GetGridNum() >= iPlayWidth * iPlayHeight then
		return true
	end
	return false
end

function GridMgr:MoveDir(sDir)
	local tIndexData = tPos2Index[sDir]
	if not tIndexData then return end
	local tPosValue, tMoveValue = self:GetMoveResult(tIndexData)
	local iMoveLen = 0
	for i, tData in pairs(tMoveValue) do
		for iInit, iNext in pairs(tData) do
			iMoveLen = iMoveLen + 1
		end
	end
	local function fcallNextTurn()
		for i, tData in pairs(tMoveValue) do
			for iInit, iNext in pairs(tData) do
				if iInit ~= iNext then
					self:NextTurn()
					return
				end
			end
		end
	end
	for i, tIndex in ipairs(tIndexData) do
		for k, iIndex in ipairs(tIndex) do
			if tMoveValue[i][k] then
				local iNextIndex = tIndex[tMoveValue[i][k]]
				local tCurPos = tIndex2Pos[iIndex]
				local tNextPos = tIndex2Pos[iNextIndex]
				local sCurPosKey = MakePosKey(tCurPos[1], tCurPos[2])
				local oGrid = self.tGrid[sCurPosKey]
				if oGrid then
					iMoveLen = iMoveLen - 1
					local function fcallback(iMoveLen)
						self:UpdateOneGrid(iIndex, 0)
						self:UpdateOneGrid(iNextIndex, tPosValue[i][tMoveValue[i][k]])
						if iMoveLen <= 0 then
							fcallNextTurn()
						end
					end 
					local moveAction = cc.MoveTo:create(0.1, cc.p(oGrid:GetPos(tNextPos[1], tNextPos[2])))
					local Seq = cc.Sequence:create(moveAction, cc.CallFunc:create(handler(iMoveLen, fcallback)))
					oGrid.sp:runAction(Seq)
					
				end
			end
		end
	end
	
	
end

function GridMgr:GetMoveResult(tIndexData)
	local tPosValue = {}
	local tMoveValue = {}
	for i, tIndex in ipairs(tIndexData) do
		local tPosValue1 = {} -- 初始位置 {0,2,2,4}
		local tPosValue2 = {} -- 第一次移动 {2,2,4}
		local tPosValue3 = {} -- 第二次移动 {4,0,4}
		local tPosValue4 = {} -- 第三次移动 {4,4}
		for k, iIndex in ipairs(tIndex) do
			local tPos = tIndex2Pos[iIndex]
			local sPosKey = MakePosKey(tPos[1], tPos[2])
			tPosValue1[k] = 0
			if self.tGrid[sPosKey] then
				tPosValue1[k] = self.tGrid[sPosKey].iNum
			end
		end
		local tMovePos = {}
		for k, iValue in ipairs(tPosValue1) do
			if iValue ~= 0 then
				table.insert(tPosValue2, iValue)
				tMovePos[k] = #tPosValue2
			end
		end
		for k, iValue in ipairs(tPosValue2) do
			if iValue ~= 0 then
				if tPosValue2[k + 1] and tPosValue2[k + 1] == iValue then
					tPosValue2[k + 1] = 0
					table.insert(tPosValue3, iValue * 2)
				else
					table.insert(tPosValue3, iValue)
				end
			else
				table.insert(tPosValue3, 0)
				for iInit, iNext in pairs(tMovePos) do
					if iNext == k then
						tMovePos[iInit] = iNext - 1
					end
				end
			end
		end
		for k, iValue in ipairs(tPosValue3) do
			if iValue ~= 0 then
				table.insert(tPosValue4, iValue)
				for iInit, iNext in pairs(tMovePos) do
					if iNext == k then
						tMovePos[iInit] = #tPosValue4
					end
				end
			end
		end
		tPosValue[i] = tPosValue4
		tMoveValue[i] = tMovePos
	end
	
	return tPosValue, tMoveValue
end


function GridMgr:Clear()
	for k, v in pairs(self.tGrid) do
		v:Destory()
	end
	self.tGrid = {}
end

return GridMgr

--endregion

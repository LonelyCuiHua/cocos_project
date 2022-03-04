--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local Global = {}

local scaleRate = 1

Global.iGridSize = 140
Global.iPlayWidth = 4
Global.iPlayHeight = 4

function Global.Grid2Pos(x, y)
 	local origin = cc.Director:getInstance():getVisibleOrigin()
 	local visibleSize = cc.Director:getInstance():getVisibleSize()
 	local iGridSize = Global.iGridSize
 	local iPlayWidth = Global.iPlayWidth
 	local iPlayHeight = Global.iPlayHeight
 	local iPosX = origin.x + visibleSize.width*0.5 - iPlayWidth*iGridSize*0.5 + x*iGridSize*scaleRate
 	local iPosY = origin.y + visibleSize.height*0.5 - iPlayHeight*iGridSize*0.5 + y*iGridSize*scaleRate
 	return iPosX, iPosY
end 

function Global.c4b(r, g, b, a)
    return {r = r/255, g = g/255, b = b/255, a = a/255}
end

function Global.DrawOneGrid(oDraw, tOrigin, tDestination, iOffect, tC4b)
    if not oDraw then return end
    oDraw:drawSolidRect(cc.p(tOrigin.x+iOffect, tOrigin.y+iOffect), cc.p(tDestination.x-iOffect, tDestination.y-iOffect), tC4b)
end

function Global.MakePosKey(x, y)
    return string.format("%s-%s", x, y)
end

Global.tNumColor = {
	[2] = Global.c4b(210,180,140,255),
	[4] = Global.c4b(244,164,96,255),
	[8] = Global.c4b(255,127,80,255),
	[16] = Global.c4b(250,128,114,255),
	[32] = Global.c4b(255,140,0,255),
	[64] = Global.c4b(218,165,32,255),
	[128] = Global.c4b(255,69,0,255),
	[256] = Global.c4b(135,206,235,255),
	[512] = Global.c4b(0,191,255,255),
	[1024] = Global.c4b(70,130,180,255),
	[2048] = Global.c4b(255,215,0,255),
	[4096] = Global.c4b(178,34,34,255),
	[8192] = Global.c4b(95,158,160,255),
	[16384] = Global.c4b(255,160,122,255),
	[32768] = Global.c4b(255,165,0,255),
	[65536] = Global.c4b(165,42,42,255),
}

Global.tNumSize = {
	[2] = Global.iGridSize * 0.8,
	[4] = Global.iGridSize * 0.8,
	[8] = Global.iGridSize * 0.8,
	[16] = Global.iGridSize * 0.6,
	[32] = Global.iGridSize * 0.6,
	[64] = Global.iGridSize * 0.6,
	[128] = Global.iGridSize * 0.4,
	[256] = Global.iGridSize * 0.4,
	[512] = Global.iGridSize * 0.4,
	[1024] = Global.iGridSize * 0.3,
	[2048] = Global.iGridSize * 0.3,
	[4096] = Global.iGridSize * 0.3,
	[8192] = Global.iGridSize * 0.3,
	[16384] = Global.iGridSize * 0.2,
	[32768] = Global.iGridSize * 0.2,
	[65536] = Global.iGridSize * 0.2,
}

return Global

--endregion

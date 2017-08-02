include("shared/const.lua");
include("shared/util.lua");

include("client/hud.lua");
include("client/game.lua");
include("client/names.lua");
include("client/classes.lua");
include("client/needs.lua");
include("client/events.lua");
include("client/commands.lua");
include("client/messages.lua");

gabion = {};

local trans = 0;
local maxtrans = 180;
local oldOrigin = Vector(0,0,0);
local oldAngle = Angle(0,0,0);

function GM:Initialize()
	paraGame.Initialize();
end

function GM:CalcView(ply,pos,ang,fov)
	local rag = ply:GetRagdollEntity();
	
	if IsEntity(rag) then
		local att = rag:GetAttachment(rag:LookupAttachment("eyes"));

		if(att ~= nil) then
			return self.BaseClass:CalcView(ply,att.Pos,att.Ang,fov);	
		end
		
	end
	
	return self.BaseClass:CalcView(ply,pos,ang,fov);
end
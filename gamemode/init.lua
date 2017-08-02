include("shared/const.lua");
include("shared/materials.lua");
include("shared/util.lua");

include("server/game.lua");
include("server/classes.lua");
include("server/needs.lua");
include("server/weapons.lua");
include("server/weight.lua");
include("server/names.lua");
include("server/costumes.lua");
include("server/commands.lua");
include("server/messages.lua");
include("server/events.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("client/classes.lua");
AddCSLuaFile("client/commands.lua");
AddCSLuaFile("client/events.lua");
AddCSLuaFile("client/game.lua");
AddCSLuaFile("client/hud.lua");
AddCSLuaFile("client/messages.lua");
AddCSLuaFile("client/needs.lua");
AddCSLuaFile("client/names.lua");
AddCSLuaFile("shared/const.lua");
AddCSLuaFile("shared/materials.lua");
AddCSLuaFile("shared/util.lua");

resource.AddFile("resource/fonts/denton.ttf");

function GM:Initialize()
	paraGame.Initialize();
	
	paraMaterials.AddResources();
	paraMaterials.Precache();
	
end


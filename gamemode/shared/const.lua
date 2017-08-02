-- Game Const
paraGame = {};

paraGame.ROUND_INIT = 0;
paraGame.ROUND_PREGAME = 1;
paraGame.ROUND_GAME = 2;
paraGame.ROUND_POSTGAME = 3;
paraGame.ROUND_DEATHMATCH = 4;

paraGame.TIME_PREROUND = 30;
paraGame.TIME_ROUND = 600;
paraGame.TIME_POSTROUND = 15;

paraGame.TEAM_NONE = 0;
paraGame.TEAM_HUMANS = 1;
paraGame.TEAM_ALIENS = 2;

-- Classes Const
paraClasses = {};

paraClasses.CLASS_SPECTATOR = 0;
paraClasses.CLASS_HUMAN = 1;
paraClasses.CLASS_ALIENHOST = 2;
paraClasses.CLASS_ALIENBROOD = 3;
paraClasses.CLASS_ALIENGRUNT = 4;
paraClasses.CLASS_ROBOT = 5;

-- Human Constants
paraClasses.HUMAN_SPEED = 260;
paraClasses.HUMAN_SPRINT = 300;
paraClasses.HUMAN_TOTALWEIGHT = 100;

paraClasses.HUMAN_WEAPON = "weapon_mor_crowbar";

-- Alien Constants
paraClasses.ALIENHOST_REGEN = 7;
paraClasses.ALIENHOST_REGENDELAY = 5;

paraClasses.ALIENBROOD_REGEN = 5;
paraClasses.ALIENBROOD_REGENDELAY = 7;

paraClasses.ALIENHOST_SPEED = 400;
paraClasses.ALIENHOST_SPRINT = 530;
paraClasses.ALIENHOST_TOTALWEIGHT = 150;

paraClasses.ALIENBROOD_SPEED = 380;
paraClasses.ALIENBROOD_SPRINT = 480;
paraClasses.ALIENBROOD_TOTALWEIGHT = 130;

paraClasses.ALIENFORM_WEAPON = "weapon_alienform";
paraClasses.ALIENGRUNT_WEAPON = "weapon_aliengrunt";

--paraClasses.ALIEN_NIGHTVISION_COLOR = Color(255, 165, 50, 255);
paraClasses.ALIEN_NIGHTVISION_COLOR = Color(130, 140, 20, 255);

-- Costumes const
paraCostumes = {};

paraCostumes.DEFAULT_MODEL = Model("models/player/corpse1.mdl");

-- Needs const
paraNeeds = {};

paraNeeds.NEED_NONE = 0;
paraNeeds.NEED_INFEST = 1;
paraNeeds.NEED_SHOWER = 2;
paraNeeds.NEED_SLEEP = 3;
paraNeeds.NEED_PISS = 4;
paraNeeds.NEED_EAT = 5;

paraNeeds.STATUS_DISABLED = 0;
paraNeeds.STATUS_WAITING = 1;
paraNeeds.STATUS_HASNEED = 2;
paraNeeds.STATUS_WORKING = 3;

paraNeeds.HEAL_AMOUNT = 15;

if(CLIENT) then
	paraNeeds.ICONS = {};
	
	paraNeeds.ICONS[paraNeeds.NEED_SHOWER] = surface.GetTextureID("materials/vgui/wash.vtf");
	paraNeeds.ICONS[paraNeeds.NEED_SLEEP] = surface.GetTextureID("materials/vgui/sleep.vtf");
	paraNeeds.ICONS[paraNeeds.NEED_PISS] = surface.GetTextureID("materials/vgui/wc.vtf");
	paraNeeds.ICONS[paraNeeds.NEED_EAT] = surface.GetTextureID("materials/vgui/eat.vtf");
end
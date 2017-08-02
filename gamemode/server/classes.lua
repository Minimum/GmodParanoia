paraClasses.AlienSpawns = {};

paraClasses.RobotAlliance = 0;

-- Init
function paraClasses.Initialize()
	paraClasses.AlienSpawns = ents.FindByClass("spawn_spawn");
	
	return;
end

-- Change Player Class

function paraClasses.SetSpectator(pl)
	local info = pl.paraInfo;
	
	info.classType = paraClasses.CLASS_SPECTATOR;
	
	paraMessages.sendPlayerClassAll(pl);
	
	return;
end

function paraClasses.SetHuman(pl)
	local info = pl.paraInfo;
	
	paraCostumes.SelectHumanModel(pl);
	
	info.classType = paraClasses.CLASS_HUMAN;
	
	paraMessages.sendPlayerClassAll(pl);
	
	paraNeeds.StartRound(pl);
	
	return;
end

function paraClasses.SetAlienHost(pl)
	local info = pl.paraInfo;
	
	paraCostumes.SelectAlienFormModel(pl);
	
	-- Class Info
	info.classType = paraClasses.CLASS_ALIENHOST;
	info.alienForm = false;
	
	paraMessages.sendPlayerClassAll(pl);
	
	-- Need Info
	info.needType = paraNeeds.NEED_INFEST;
	info.needTime = 0;
	
	paraNeeds.SendNeed(pl);
	
	return;
end

function paraClasses.SetAlienBrood(pl)
	local info = pl.paraInfo;
	
	paraCostumes.SelectAlienFormModel(pl);
	
	-- Class Info
	info.classType = paraClasses.CLASS_ALIENBROOD;
	info.alienForm = false;
	
	paraMessages.sendPlayerClassAll(pl);
	
	-- Need Info
	info.needType = paraNeeds.NEED_INFEST;
	info.needTime = 0;
	
	paraNeeds.SendNeed(pl);
	
	return;
end

function paraClasses.SetAlienGrunt(pl)
	local info = pl.paraInfo;
	
	paraCostumes.SelectAlienGruntModel(pl);
	
	-- Class Info
	info.classType = paraClasses.CLASS_ALIENGRUNT;
	
	paraMessages.sendPlayerClassAll(pl);
	
	-- Need Info
	info.needType = paraNeeds.NEED_INFEST;
	info.needTime = 0;
	
	-- Name Info
	info.showName = false;
	
	local nameId = pl:EntIndex();
	
	for k, x in pairs(player.GetAll()) do
		if(x.paraInfo.classType == paraClasses.CLASS_HUMAN) then
			net.Start("PARA_PlayerName");
				net.WriteUInt(nameId, 16);
				net.WriteString("UNKNOWN LIFEFORM");
			net.Send(x);
		end
	end
	
	paraNeeds.SendNeed(pl);
	
	return;
end

function paraClasses.SetRobot(pl)
	local info = pl.paraInfo;
	
	paraCostumes.SelectRobotModel(pl);
	
	info.classType = paraClasses.CLASS_ROBOT;
	info.robotAlliance = false;
	
	paraMessages.sendPlayerClassAll(pl);
	
	return;
end

-- Spawn Loadouts

function paraClasses.PlayerSpawn(player)
	local info = player.paraInfo;
	
	if(info.classType == paraClasses.CLASS_HUMAN) then
		paraClasses.HumanSpawn(player);
	elseif(info.classType == paraClasses.CLASS_ALIENHOST) then
		paraClasses.AlienHostSpawn(player);
	elseif(info.classType == paraClasses.CLASS_ALIENBROOD) then
		paraClasses.AlienBroodSpawn(player);
	elseif(info.classType == paraClasses.CLASS_ALIENGRUNT) then
		paraClasses.AlienGruntSpawn(player);
	elseif(info.classType == paraClasses.CLASS_ROBOT) then
		paraClasses.RobotSpawn(player);
	end
	
	return;
end

function paraClasses.HumanSpawn(player)
	local info = player.paraInfo;
	
	-- Set Speed
	GAMEMODE:SetPlayerSpeed(player, paraClasses.HUMAN_SPEED, paraClasses.HUMAN_SPRINT);
	info.walkSpeed = paraClasses.HUMAN_SPEED;
	info.runSpeed = paraClasses.HUMAN_SPRINT;
	info.weightTotal = paraClasses.HUMAN_TOTALWEIGHT;
	
	-- Basic Loadout
	player:Give(paraClasses.HUMAN_WEAPON);
	
	player:SetModel(info.costumeHuman);
	
	return;
end

function paraClasses.AlienHostSpawn(player)
	local info = player.paraInfo;

	-- Basic Loadout
	player:Give(paraClasses.HUMAN_WEAPON);
	
	-- Set Speed
	GAMEMODE:SetPlayerSpeed(player, paraClasses.HUMAN_SPEED, paraClasses.HUMAN_SPRINT);
	info.walkSpeed = paraClasses.HUMAN_SPEED;
	info.runSpeed = paraClasses.HUMAN_SPRINT;
	info.weightTotal = paraClasses.ALIENHOST_TOTALWEIGHT;
	
	if(info.infestPos ~= nil) then
		-- Teleport to Infest Spawnpoint
		player:SetPos(info.infestPos);
		
		info.infestPos = nil;
	else
		-- Teleport to Alien Spawnpoint
		paraClasses.TeleportAlienSpawn(player);
	end
	
	player:SetModel(info.costumeHuman);
	
	return;
end

function paraClasses.AlienBroodSpawn(player)
	local info = player.paraInfo;

	-- Basic Loadout
	player:Give(paraClasses.HUMAN_WEAPON);
	
	-- Set Speed
	GAMEMODE:SetPlayerSpeed(player, paraClasses.HUMAN_SPEED, paraClasses.HUMAN_SPRINT);
	info.walkSpeed = paraClasses.HUMAN_SPEED;
	info.runSpeed = paraClasses.HUMAN_SPRINT;
	info.weightTotal = paraClasses.ALIENBROOD_TOTALWEIGHT;
	
	if(info.infestPos ~= nil) then
		-- Teleport to Infest Spawnpoint
		player:SetPos(info.infestPos);
		
		info.infestPos = nil;
	else
		-- Teleport to Alien Spawnpoint
		paraClasses.TeleportAlienSpawn(player);
		
	end
	
	player:SetModel(info.costumeHuman);
	
	return;
end

function paraClasses.AlienGruntSpawn(player)
	local info = player.paraInfo;

	-- Loadout
	player:Give(paraClasses.ALIENGRUNT_WEAPON);
	
	-- Set Speed
	GAMEMODE:SetPlayerSpeed(player, paraClasses.HUMAN_SPEED, paraClasses.HUMAN_SPRINT);
	info.weightTotal = 100;
	
	-- Teleport to Alien Spawnpoint
	paraClasses.TeleportAlienSpawn(player);
	
	player:SetModel(info.costumeAlienGrunt);
	
	return;
end

function paraClasses.RobotSpawn(player)
	-- TODO VERSION 2

	return;
end

-- Player Think

function paraClasses.PlayerThink(player)
	local info = player.paraInfo;
	
	if(info.classType == paraClasses.CLASS_HUMAN) then
		paraClasses.HumanThink(player);
	elseif(info.classType == paraClasses.CLASS_ALIENHOST) then
		paraClasses.AlienHostThink(player);
	elseif(info.classType == paraClasses.CLASS_ALIENBROOD) then
		paraClasses.AlienBroodThink(player);
	elseif(info.classType == paraClasses.CLASS_ALIENGRUNT) then
		paraClasses.AlienGruntThink(player);
	elseif(info.classType == paraClasses.CLASS_ROBOT) then
		paraClasses.RobotThink(player);
	end
	
	return;
end

function paraClasses.HumanThink(player)
	paraNeeds.PlayerThink(player);
	
	return;
end

function paraClasses.AlienHostThink(player)
	local info = player.paraInfo;
	local health = player:Health();
	
	-- Regen
	if(info.alienForm == true) then
		if(info.alienFormTime % 2 == 0) then
			if(health < 100-paraClasses.ALIENHOST_REGEN) then
				player:SetHealth(health + paraClasses.ALIENHOST_REGEN);
			else
				player:SetHealth(100);
			end
			
			paraClasses.AlienBreathe(player);
		end
		
		info.alienFormTime = info.alienFormTime + 1;
	end
	
	return;
end

function paraClasses.AlienBroodThink(player)
	local info = player.paraInfo;
	local health = player:Health();

	-- Regen
	if(info.alienForm == true) then
		if(info.alienFormTime % 3 == 0) then
			if(health < 100-paraClasses.ALIENBROOD_REGEN) then
				player:SetHealth(health + paraClasses.ALIENBROOD_REGEN);
			else
				player:SetHealth(100);
			end
			
			paraClasses.AlienBreathe(player);
		end
		
		info.alienFormTime = info.alienFormTime + 1;
	end
	
	return;
end

function paraClasses.AlienGruntThink(player)
	-- regen
	
	return;
end

function paraClasses.RobotThink(player)
	-- TODO VERSION 2
	return;
end

function paraClasses.AlienTransform(pl)
	local info = pl.paraInfo;
	
	if(info.alienForm == true) then
		pl:SetModel(info.costumeHuman);
	
		info.alienForm = false;
		
		pl:StripWeapon(paraClasses.ALIENFORM_WEAPON);
		
		paraWeight.CheckWeight(pl);
		
		info.showName = true;
	else
		pl:EmitSound(paraMaterials.SOUND_ALIENSCREAM, 350, 100);
		
		pl:Flashlight(false);
		
		pl:SetModel(info.costumeAlienForm);
		
		if(info.classType == paraClasses.CLASS_ALIENHOST) then
			GAMEMODE:SetPlayerSpeed(pl, paraClasses.ALIENHOST_SPEED, paraClasses.ALIENHOST_SPRINT);
		else
			GAMEMODE:SetPlayerSpeed(pl, paraClasses.ALIENBROOD_SPEED, paraClasses.ALIENBROOD_SPRINT);
		end
	
		pl:Give(paraClasses.ALIENFORM_WEAPON);
		pl:SelectWeapon(paraClasses.ALIENFORM_WEAPON);
	
		info.alienFormTime = 0;
		info.alienForm = true;
		
		info.showName = false;
	end
	
	paraMessages.sendPlayerAlienFormAll(pl);

	return;
end

-- Events
function paraClasses.AlienBreathe(player)
	local rand = math.random(1, 4);
	
	player:EmitSound("npc/barnacle/barnacle_pull"..rand..".wav", 350, 100);
	
	return;
end

function paraClasses.TeleportAlienSpawn(player)
	local numSpawns = table.getn(paraClasses.AlienSpawns);

	if(numSpawns > 0) then
		local rand = math.random(1, numSpawns);
	
		player:SetPos(paraClasses.AlienSpawns[rand]);
	end
	
	return;
end
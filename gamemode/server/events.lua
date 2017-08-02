paraEvents = {};

function GM:Think()
	for k, pl in pairs(player.GetAll()) do
		if(pl.paraInfo.alienForm == true and pl:GetActiveWeapon():GetClass() ~= "weapon_alienform") then
			paraClasses.AlienTransform(pl);
		end
	end
end

function GM:GetFallDamage(player, speed)
	local damage = 0;

	if(GetConVarNumber("mp_falldamage") == 1) then
		-- Half "speed" for aliens in alien form
		if(player.paraInfo.alienForm == true) then
			speed = speed / 2;
		end
		
		speed = speed - 580;
		damage = speed * (100/(1024-580));
	end
	
	return damage;
end

function GM:DoPlayerDeath(victim, killer, dmg)
	local victimInfo = victim.paraInfo;
	local victimPos = victim:GetPos();

	-- Death Variables
	victimInfo.deathPos = victimPos;

	-- Drop Weapons
	for k, weapon in pairs(victim:GetWeapons()) do
		if(weapon:GetClass() ~= "weapon_alienform" and weapon:GetClass() ~= "weapon_aliengrunt" and weapon:GetClass() ~= "weapon_crowbar") then
			local weaponInfo = {};
			weaponInfo.classname = weapon:GetClass();
			weaponInfo.ammotype = weapon:GetPrimaryAmmoType();
			weaponInfo.clip = weapon:Clip1();
			weaponInfo.reserve = 0;
			weaponInfo.model = weapon.WorldModel;
			
			if(weaponInfo.model ~= nil) then
				paraWeapons.SpawnGroundWeapon(weaponInfo, victimPos);
			end
		end
	end
	
	victim:StripWeapons();
	
	-- Drop Ammo
	local ammoInfo = paraWeapons.GetAmmoInfo(victim);
	if(ammoInfo ~= nil) then
		paraWeapons.SpawnGroundAmmo(ammoInfo, victimPos);
	end
	victim:RemoveAllAmmo();
	
	-- check death info
	if(paraGame.RoundStatus == paraGame.ROUND_GAME) then
		paraEvents.GamePlayerDeath(victim, killer, dmg);
	end
	
	-- Reset Variables
	victimInfo.alienForm = false;
	
	victim:CreateRagdoll();
	
	return;
end

--function GM:PlayerDeath(victim, weapon, killer)
	
--end

function GM:PlayerAuthed(pl, authId, UniqueID)
	paraMessages.sendRoundStatus(pl);
	paraMessages.sendRoundTime(pl);
	paraMessages.sendPlayerWeight(pl);
	
	-- Send player info
	paraMessages.sendPlayerNeed(pl);
	paraMessages.sendPlayerNeedStatus(pl);
	
	for k, v in pairs(player.GetAll()) do
		paraMessages.sendPlayerClass(pl, v);
		paraMessages.sendPlayerName(pl, v);
		paraMessages.sendPlayerAlienForm(pl, v);
	end
	
	pl.paraSettings = {};
	
	paraCostumes.PlayerInit(pl);
	paraNames.PlayerInit(pl);
	
	--paraClasses.PlayerSpawn(pl);
	
	return;
end

function GM:PlayerInitialSpawn(pl)
	if(pl.paraSettings == nil) then
		pl.paraSettings = {};
	end

	if(paraGame.RoundStatus == paraGame.ROUND_GAME) then
		paraGame.InitPlayerInfoLate(pl);
	else
		paraGame.InitPlayerInfo(pl);
	end

	for k, x in pairs(player.GetAll()) do
		if(pl ~= x) then
			paraNames.SendName(pl, x);
			paraMessages.sendPlayerClass(pl, x);
			paraMessages.sendPlayerAlienForm(pl, x);
		end
	end

	paraClasses.PlayerSpawn(pl);
	
	return;
end

function GM:PlayerSpawn(pl)	
	paraClasses.PlayerSpawn(pl);
	paraEvents.GamePlayerSpawn(pl);
	
	return;
end

function GM:PlayerSetModel(pl)
	local model = paraMaterials.MODEL_PLAYERDEFAULT;
	local info = pl.paraInfo;
	
	if(info.classType == paraClasses.CLASS_HUMAN) then
		model = info.costumeHuman;
	elseif(info.classType == paraClasses.CLASS_ALIENHOST or info.classType == paraClasses.CLASS_ALIENBROOD) then
		if(info.alienForm) then
			model = info.costumeAlienForm;
		else
			model = info.costumeHuman;
		end
	elseif(info.classType == paraClasses.CLASS_ALIENGRUNT) then
		model = info.costumeAlienGrunt;
	end

	util.PrecacheModel(model);
	pl:SetModel(model);
end

function GM:PlayerSay(pl, text, public)

end

function GM:PlayerDisconnected(pl)
	if(paraGame.RoundStatus == paraGame.ROUND_GAME) then
		paraGame.CheckRoundEnd();
	end
	
	return;
end

function GM:PlayerLoadout(player)
	return;
end

function GM:PlayerSwitchFlashlight(pl, switchOn)
	local info = pl.paraInfo;
	local usable = true;
	
	if(info.alienForm or info.classType == paraClasses.CLASS_ALIENGRUNT) then
		usable = false;
	end

	return usable;
end

--function GM:OnPlayerHitGround( pl )
 
 --    local boom = ents.Create( "env_explosion" )
 --    boom:SetPos( pl:GetPos( ) )
 --    boom:Spawn( )
 --    boom:Fire( "explode", "", 0 )
 
--end

function GM:PlayerShouldTakeDamage(victim, attacker)
	local damage = true;
	local victimInfo = victim.paraInfo;
	local attackerInfo = attacker.paraInfo;
	
	if(victim:IsPlayer() and attacker:IsPlayer()) then
		if(attackerInfo.alienForm == true) then
			if(victimInfo.classType == paraClasses.CLASS_ALIENHOST or victimInfo.classType == paraClasses.CLASS_ALIENBROOD or victimInfo.classType == paraClasses.CLASS_ALIENGRUNT) then
				damage = false;
			end
		elseif(victimInfo.alienForm == true and attackerInfo.classType == paraClasses.CLASS_ALIENGRUNT) then
			damage = false;
		end
	end
	
	return damage;
end

function paraEvents.GamePlayerDeath(victim, killer, dmg)
	local victimInfo = victim.paraInfo;
	local killerInfo = killer.paraInfo;
	
	victimInfo.classPast = victimInfo.classType;
		
	if(victimInfo.classType == paraClasses.CLASS_HUMAN) then
		-- Human Death
		if(killerInfo.classType == paraClasses.CLASS_HUMAN) then
			paraClasses.SetAlienGrunt(victim);
			
		elseif(killerInfo.classType == paraClasses.CLASS_ALIENHOST or killerInfo.classType == paraClasses.CLASS_ALIENBROOD) then
			if(killerInfo.alienForm) then
				paraClasses.SetAlienBrood(victim);
				
				victimInfo.alienInfested = true;
			else
				paraClasses.SetAlienGrunt(victim);
			end
		
		elseif(killerInfo.classType == paraClasses.CLASS_ALIENGRUNT) then
			paraClasses.SetAlienGrunt(victim);
		
		end
	elseif(victimInfo.classType == paraClasses.CLASS_ALIENHOST or victimInfo.classType == paraClasses.CLASS_ALIENBROOD) then
		-- Alien Death
		victim:SetModel(victimInfo.costumeAlienForm);
		
		paraClasses.SetAlienGrunt(victim);
	
	elseif(victimInfo.classType == paraClasses.CLASS_ALIENGRUNT) then
		-- Alien Grunt Death
	
	end
		
	paraGame.CheckRoundEnd();
	
	return;
end

function paraEvents.GamePlayerSpawn(pl)
	local info = pl.paraInfo;
	
	if(info.classPast == paraClasses.CLASS_ALIENHOST or info.classPast == paraClasses.CLASS_ALIENBROOD) then
		-- generate corpse;
	end
	
	if(info.alienInfested) then
		-- teleport to last death point
		local nearbyEnts = ents.FindInSphere(info.deathPos, 32);
		
		if(nearbyEnts == nil) then
			pl:SetPos(info.deathPos);
		end
		
		info.alienInfested = false;
	end
	
	return;
end
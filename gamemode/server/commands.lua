paraCommands = {};

function paraCommands.DropWeapon(pl)
	local weapon = pl:GetActiveWeapon();
	
	if(weapon:GetClass() ~= paraClasses.ALIENFORM_WEAPON and weapon:GetClass() ~= paraClasses.ALIENGRUNT_WEAPON and weapon:GetClass() ~= paraClasses.HUMAN_WEAPON) then
		local weaponInfo = {};
		weaponInfo.classname = weapon:GetClass();
		weaponInfo.ammotype = weapon:GetPrimaryAmmoType();
		weaponInfo.clip = weapon:Clip1();
		weaponInfo.reserve = 0;
		weaponInfo.model = weapon.WorldModel;
		
		local pos = pl:EyePos();
		
		local ent = paraWeapons.SpawnGroundWeapon(weaponInfo, pos);
		
		local ang = pl:GetAngles():Right():Angle();
		
		ent:SetAngles(ang);
		
		local force = pl:GetAimVector() * 200.0 + pl:GetVelocity();
		
		local phys = ent:GetPhysicsObject();
		
		if(phys ~= nil and phys:IsValid()) then
			phys:SetVelocity(force);
		end
		
		pl:StripWeapon(weapon:GetClass());
		
		paraWeight.CheckWeight(pl);
	end
	
	return;
end
concommand.Add("para_dropweapon", paraCommands.DropWeapon);

function paraCommands.Action(pl)
	local info = pl.paraInfo;
	
	if(info.classType == paraClasses.CLASS_HUMAN) then
		paraNeeds.TryNeed(pl);
	elseif(info.classType == paraClasses.CLASS_ALIENHOST or info.classType == paraClasses.CLASS_ALIENBROOD) then
		paraClasses.AlienTransform(pl);
	end
	
	return;
end
concommand.Add("para_action", paraCommands.Action);

function paraCommands.SpawnWeapon(pl, cmd, args)
	if(pl:IsPlayer()) then
		local weaponInfo = paraWeapons.FindWeapon(args[1]);
		
		if(weaponInfo ~= nil) then
			paraWeapons.SpawnGroundWeapon(weaponInfo, pl:GetPos());
		end
	end
	
	return;
end
concommand.Add("para_spawnweapon", paraCommands.SpawnWeapon);

-- para_setcustommodel <PLAYER> <MODELTYPE> <MODEL>
function paraCommands.SetCustomModel(pl, cmd, args)
	-- TODO check for admin

	if(pl:IsPlayer()) then
		if(args[1] ~= nil and args[2] ~= nil and args[3] ~= nil) then
			local target = paraUtil.FindPlayerByName(args[1]);
			
			if(target ~= nil) then
				local modelType = string.lower(args[2]);
			
				if(modelType == "human") then
					paraCostumes.SetCustomHumanModel(target, args[3]);
				elseif(modelType == "alienform") then
					paraCostumes.SetCustomAlienFormModel(target, args[3]);
				elseif(modelType == "aliengrunt") then
					paraCostumes.SetCustomAlienGruntModel(target, args[3]);
				elseif(modelType == "robot") then
					paraCostumes.SetCustomRobotModel(target, args[3]);
				else
					pl:PrintMessage(HUD_PRINTCONSOLE, "[paraCostumes] Invalid model type!\nModel Types: human, alienform, aliengrunt, robot");
				end
			else
				pl:PrintMessage(HUD_PRINTCONSOLE, "[paraCostumes] Player not found!");
			end
		else
			pl:PrintMessage(HUD_PRINTCONSOLE, "Usage: para_setcustommodel <PLAYER> <MODELTYPE> <MODEL>");
		end
	end
	
	return;
end
concommand.Add("para_setcustommodel", paraCommands.SetCustomModel);

-- para_setcustomname <PLAYER> <NAME>
function paraCommands.SetCustomName(pl, cmd, args)
	-- TODO check for admin

	if(pl:IsPlayer()) then
		if(args[1] ~= nil and args[2] ~= nil) then
			local target = paraUtil.FindPlayerByName(args[1]);
			
			if(target ~= nil) then
				paraNames.SetCustomName(target, args[2]);
				
				pl:PrintMessage(HUD_PRINTCONSOLE, "[paraNames] Set "..pl:GetName().."'s custom name to "..args[2]..".");
			else
				pl:PrintMessage(HUD_PRINTCONSOLE, "[paraNames] Player not found!");
			end
		else
			pl:PrintMessage(HUD_PRINTCONSOLE, "Usage: para_setcustomname <PLAYER> <NAME>");
		end
	end
	
	return;
end
concommand.Add("para_setcustomname", paraCommands.SetCustomName);

-- para_setclass <PLAYER> <CLASS>
function paraCommands.SetClass(pl, cmd, args)
	-- TODO check for admin; output messages to client

	if(pl:IsPlayer()) then
		
		if(args[1] ~= nil and args[2] ~= nil) then
			local target = paraUtil.FindPlayerByName(args[1]);
			
			if(target ~= nil) then
				local class = string.lower(args[2]);
			
				if(class == "human") then
					paraClasses.SetHuman(target);
				elseif(class == "alienhost") then
					paraClasses.SetAlienHost(target);
				elseif(class == "alienbrood") then
					paraClasses.SetAlienBrood(target);
				elseif(class == "aliengrunt") then
					paraClasses.SetAlienGrunt(target);
				elseif(class == "robot") then
					paraClasses.SetRobot(target);
				else
					pl:PrintMessage(HUD_PRINTCONSOLE, "[paraClasses] Invalid class!\nClasses: human, alienhost, alienbrood, aliengrunt, robot");
				end
			else
				pl:PrintMessage(HUD_PRINTCONSOLE, "[paraClasses] Player not found!");
			end
		else
			pl:PrintMessage(HUD_PRINTCONSOLE, "Usage: para_setclass <PLAYER> <CLASS>");
		end
	end
	
	return;
end
concommand.Add("para_setclass", paraCommands.SetClass);

-- para_setroundtime <SECONDS>
function paraCommands.SetRoundTime(pl, cmd, args)
	-- TODO check for admin; output messages to client

	if(args[1] ~= nil) then
		local seconds = tonumber(args[1]);
		
		paraGame.SetRoundTime(seconds);
	end
	
	return;
end
concommand.Add("para_setroundtime", paraCommands.SetRoundTime);

function paraCommands.GetDir(pl, cmd, args)

	if(args[1] ~= nil) then
		local files, dirs = file.Find(args[1], "GAME");
		local path = string.gsub(args[1], "*", "");
		
		for x=1, table.getn(dirs), 1 do
			print(dirs[x]);
		end
		
		for x=1, table.getn(files), 1 do
			print(path ..files[x]);
		end
	end
	
	return;
end
concommand.Add("para_getdir", paraCommands.GetDir);
paraWeapons = {};

paraWeapons.AMMO_MODEL = "models/Items/BoxSRounds.mdl";

paraWeapons.Primaries = {};
paraWeapons.Secondaries = {};
paraWeapons.Items = {};
paraWeapons.Specials = {};

paraWeapons.MaxAmmo = {};
paraWeapons.MaxAmmo["Pistol"] = 120;		-- Pistols
paraWeapons.MaxAmmo["357"] = 60;			-- Heavy Pistols
paraWeapons.MaxAmmo["SMG1"] = 400;			-- SMGs
paraWeapons.MaxAmmo["AR2"] = 240;			-- Rifles
paraWeapons.MaxAmmo["Buckshot"] = 100;		-- Shotguns
paraWeapons.MaxAmmo["XBowBolt"] = 40;		-- Specials
paraWeapons.MaxAmmo["Battery"] = 100;		-- Battery?

paraWeapons.StartSpawnNum = 0;

function paraWeapons.Initialize()
	wep = paraWeapons.CreateWeaponInfo("weapon_glowstick", "XBowBolt", 1, 0, "models/glowstick/stick.mdl");
	paraWeapons.RegisterItem(wep);
	paraWeight.RegisterWeapon("weapon_glowstick", 0);
	
	-- Assault Rifles
	wep = paraWeapons.CreateWeaponInfo("gab_ak47", "AR2", 30, 150, "models/weapons/w_rif_ak47.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_ak47", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_aug", "AR2", 30, 150, "models/weapons/w_rif_aug.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_aug", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_m4a1", "AR2", 30, 150, "models/weapons/w_rif_m4a1.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_m4a1", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_famas", "AR2", 30, 150, "models/weapons/w_rif_famas.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_famas", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_galil", "AR2", 30, 150, "models/weapons/w_rif_galil.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_galil", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_m3", "buckshot", 8, 40, "models/weapons/w_shot_m3super90.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_m3", 40);
	
	wep = paraWeapons.CreateWeaponInfo("gab_acr", "AR2", 30, 150, "models/weapons/w_masada_acr.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_acr", 40);
	
	-- SMGs
	wep = paraWeapons.CreateWeaponInfo("gab_ump45", "smg1", 30, 150, "models/weapons/w_smg_ump45.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_ump45", 30);
	
	wep = paraWeapons.CreateWeaponInfo("gab_sten", "smg1", 30, 150, "models/weapons/w_sten.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_sten", 30);
	
	wep = paraWeapons.CreateWeaponInfo("gab_uzi", "smg1", 30, 150, "models/weapons/w_uzi_imi.mdl");
	paraWeapons.RegisterPrimary(wep);
	paraWeight.RegisterWeapon("gab_uzi", 30);
	
	-- Machine Pistols
	wep = paraWeapons.CreateWeaponInfo("gab_tmp", "smg1", 30, 150, "models/weapons/w_smg_tmp.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_tmp", 20);
	
	wep = paraWeapons.CreateWeaponInfo("gab_mac10", "smg1", 32, 160, "models/weapons/w_smg_mac10.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_mac10", 20);
	
	-- Pistols
	wep = paraWeapons.CreateWeaponInfo("gab_fiveseven", "pistol", 20, 80, "models/weapons/w_pist_fiveseven.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_fiveseven", 10);
	
	wep = paraWeapons.CreateWeaponInfo("gab_usp", "pistol", 12, 72, "models/weapons/w_pist_usp.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_usp", 10);
	
	wep = paraWeapons.CreateWeaponInfo("gab_colt1911", "pistol", 7, 70, "models/weapons/s_dmgf_co1911.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_colt1911", 10);
	
	wep = paraWeapons.CreateWeaponInfo("gab_glock18", "pistol", 18, 108, "models/weapons/w_dmg_glock.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_glock18", 10);
	
	wep = paraWeapons.CreateWeaponInfo("gab_coltpython", "357", 6, 30, "models/weapons/w_colt_python.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_coltpython", 15);
	
	wep = paraWeapons.CreateWeaponInfo("gab_deagle", "357", 7, 35, "models/weapons/w_tcom_deagle.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_deagle", 15);
	
	wep = paraWeapons.CreateWeaponInfo("gab_ragingbull", "357", 6, 30, "models/weapons/w_taurus_raging_bull.mdl");
	paraWeapons.RegisterSecondary(wep);
	paraWeight.RegisterWeapon("gab_ragingbull", 15);
	
	-- Special Purpose
	wep = paraWeapons.CreateWeaponInfo("gab_contender", "AR2", 1, 60, "models/weapons/w_g2_contender.mdl");
	paraWeapons.RegisterSpecial(wep);
	paraWeight.RegisterWeapon("gab_contender", 10);
	
	-- Custom
	
	wep = paraWeapons.CreateWeaponInfo("weapon_srsparky32", "XBowBolt", 0, 0, "models/weapons/w_rif_lr300.mdl");
	paraWeapons.RegisterSpecial(wep);
	
	wep = paraWeapons.CreateWeaponInfo("gab_awp", "AR2", 10, 120, "models/weapons/w_rif_lr300.mdl");
	paraWeapons.RegisterSpecial(wep);
	
	return;
end

function paraWeapons.InitialSpawn(pos, ang)
	local iteration = paraWeapons.StartSpawnNum % 5;
	local weapon = nil;

	if(iteration == 0 or iteration == 1) then
		local total = table.getn(paraWeapons.Primaries);
	
		if(total > 0) then
			local rand = math.random(1, total);
			weapon = paraWeapons.SpawnGroundWeapon(paraWeapons.Primaries[rand], pos);
		end
		
	elseif(iteration == 2 or iteration == 3) then
		local total = table.getn(paraWeapons.Secondaries);
	
		if(total > 0) then
			local rand = math.random(1, total);
			weapon = paraWeapons.SpawnGroundWeapon(paraWeapons.Secondaries[rand], pos);
		end
		
	else
		local total = table.getn(paraWeapons.Items);
	
		if(total > 0) then
			local rand = math.random(1, total);
			weapon = paraWeapons.SpawnGroundWeapon(paraWeapons.Items[rand], pos);
		end
		
	end
	
	paraWeapons.StartSpawnNum = paraWeapons.StartSpawnNum + 1;
	
	if(weapon == nil) then
		paraWeapons.InitialSpawn(pos, ang);
	else
		weapon:SetAngles(ang);
	end
	
	return;
end

function paraWeapons.RegisterPrimary(weapon)
	paraWeapons.Primaries[table.getn(paraWeapons.Primaries)+1] = weapon;
	
	return;
end

function paraWeapons.RegisterSecondary(weapon)
	paraWeapons.Secondaries[table.getn(paraWeapons.Secondaries)+1] = weapon;
	
	return;
end

function paraWeapons.RegisterItem(weapon)
	paraWeapons.Items[table.getn(paraWeapons.Items)+1] = weapon;
	
	return;
end

function paraWeapons.RegisterSpecial(weapon)
	paraWeapons.Specials[table.getn(paraWeapons.Specials)+1] = weapon;
	
	return;
end

function paraWeapons.FindWeapon(weapon)
	local weaponInfo = nil;

	for k, weaponIndex in pairs(paraWeapons.Primaries) do
		if(weaponIndex.classname == weapon) then
			weaponInfo = weaponIndex;
			break;
		end
	end
	
	if(weaponInfo == nil) then
		for k, weaponIndex in pairs(paraWeapons.Secondaries) do
			if(weaponIndex.classname == weapon) then
				weaponInfo = weaponIndex;
				break;
			end
		end
		
		if(weaponInfo == nil) then
			for k, weaponIndex in pairs(paraWeapons.Items) do
				if(weaponIndex.classname == weapon) then
					weaponInfo = weaponIndex;
					break;
				end
			end
			
			if(weaponInfo == nil) then
				for k, weaponIndex in pairs(paraWeapons.Specials) do
					if(weaponIndex.classname == weapon) then
						weaponInfo = weaponIndex;
						break;
					end
				end
			end
		end
	end
	
	return weaponInfo;
end

function paraWeapons.SpawnGroundWeapon(weaponInfo, pos)
	local ent = ents.Create("groundweapon");
	
	ent.WeaponClassname = weaponInfo.classname;
	ent.WeaponAmmoType = weaponInfo.ammotype;
	ent.WeaponClip = weaponInfo.clip;
	ent.WeaponReserve = weaponInfo.reserve;
	
	ent:SetModel(weaponInfo.model);
	ent:PhysicsInit(SOLID_VPHYSICS);
	ent:SetMoveType(MOVETYPE_VPHYSICS);
	ent:SetSolid(SOLID_VPHYSICS);
	ent:SetUseType(SIMPLE_USE);
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
	
	ent:SetPos(pos);
	ent:Spawn();
	
	local phys = ent:GetPhysicsObject();
	
	if(phys ~= nil and phys:IsValid()) then
		phys:Wake();
	end
	
	return ent;
end

function paraWeapons.SpawnGroundAmmo(ammoInfo, pos)
	local ent = ents.Create("groundammo");
	
	ent.AmmoInfo = ammoInfo;
	
	ent:SetModel(paraWeapons.AMMO_MODEL);
	ent:PhysicsInit(SOLID_VPHYSICS);
	ent:SetMoveType(MOVETYPE_VPHYSICS);
	ent:SetSolid(SOLID_VPHYSICS);
	ent:SetUseType(SIMPLE_USE);
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	
	ent:SetPos(pos);
	ent:Spawn();
	
	local phys = ent:GetPhysicsObject();
	
	if(psys ~= nil and phys:IsValid()) then
		phys:Wake();
	end
	
	return ent;
end

function paraWeapons.CreateWeaponInfo(classname, ammotype, clip, reserve, model)
	local weaponInfo = {};
	
	-- WeaponInfo Object:
	-- WeaponInfo.classname
	-- WeaponInfo.ammotype
	-- WeaponInfo.clip
	-- WeaponInfo.reserve
	-- WeaponInfo.model
	
	weaponInfo.classname = classname;
	weaponInfo.ammotype = ammotype;
	weaponInfo.clip = clip;
	weaponInfo.reserve = reserve;
	weaponInfo.model = model;
	
	return weaponInfo;
end

function paraWeapons.GetAmmoInfo(pl)
	local ammoInfo = {};
	local nullInfo = true;
	
	for ammoType, ammo in pairs(paraWeapons.MaxAmmo) do
		ammoInfo[ammoType] = pl:GetAmmoCount(ammoType);
		
		if(ammoInfo[ammoType] > 0) then
			nullInfo = false;
		end
	end
	
	if(nullInfo) then
		ammoInfo = nil;
	end
	
	return ammoInfo;
end
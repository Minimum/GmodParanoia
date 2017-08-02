paraWeight = {};

paraWeight.Weapons = {};

paraWeight.MAX_ENCUMBERENCE = 0.45;

function paraWeight.RegisterWeapon(classname, weight)
	paraWeight.Weapons[classname] = weight;
	
	return;
end

function paraWeight.CheckWeight(pl)
	local info = pl.paraInfo;
	
	if(info.alienForm == false) then
		local weight = 0;
		
		for k, weapon in pairs(pl:GetWeapons()) do
			local weaponWeight = paraWeight.Weapons[weapon:GetClass()];
		
			if(weaponWeight ~= nil) then
				weight = weight + weaponWeight;
			end
		end
		
		pl:SetWalkSpeed(info.walkSpeed - (info.walkSpeed * (weight / info.weightTotal) * paraWeight.MAX_ENCUMBERENCE));
		pl:SetRunSpeed(info.runSpeed - (info.runSpeed * (weight / info.weightTotal) * paraWeight.MAX_ENCUMBERENCE));
	end
	
	return;
end

function paraWeight.PlayerHasInventory(pl)
	local inventory = true;
	local info = pl.paraInfo;
	
	if(pl:Alive() == false or info.classType == paraClasses.CLASS_ALIENGRUNT or info.alienForm == true) then
		inventory = false;
	end
	
	return inventory;
end

function paraWeight.PlayerHasSpace(pl, weapon)
	local info = pl.paraInfo;
	local hasSpace = true;
	local weight = paraWeight.Weapons[weapon];
	
	if(weight ~= nil) then
		for k, weapon in pairs(pl:GetWeapons()) do
			local weaponWeight = paraWeight.Weapons[weapon:GetClass()];
			
			if(weaponWeight ~= nil) then
				weight = weight + weaponWeight;
			end
		end
		
		if(weight > info.weightTotal) then
			hasSpace = false;
		end
	end
	
	return hasSpace;
end
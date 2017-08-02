paraNeeds.TIME_NEED = 150;
paraNeeds.TIME_WAIT = 45;
paraNeeds.TIME_WORK = 8;

paraNeeds.MapNeeds = {};
paraNeeds.MapNeedTypes = {};
paraNeeds.MapNeedPositions = {};
paraNeeds.MapNumNeeds = 0;

paraNeeds.Initialized = false;

util.AddNetworkString("PARA_PlayerNeed");
util.AddNetworkString("PARA_PlayerNeedStatus");
util.AddNetworkString("PARA_PlayerNeedPos");
util.AddNetworkString("PARA_PlayerNeedTime");

function paraNeeds.Initialize()
	local needNum = 0;
	local needMin = 0;
	local needMax = 0;
	
	paraNeeds.MapNeeds = {};
	paraNeeds.MapNeedTypes = {};

	local showerNeeds = ents.FindByClass("need_shower");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		needMin, needMax = showerNeeds[1]:WorldSpaceAABB();
		
		paraNeeds.MapNeeds[needNum] = showerNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_SHOWER;
		paraNeeds.MapNeedPositions[needNum] = needMax - ((needMax - needMin) / 2);
	end
	
	local bedNeeds = ents.FindByClass("need_bedroom");
	if(table.getn(bedNeeds) > 0) then
		needNum = needNum + 1;
		
		needMin, needMax = bedNeeds[1]:WorldSpaceAABB();
		
		paraNeeds.MapNeeds[needNum] = bedNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_SLEEP;
		paraNeeds.MapNeedPositions[needNum] = needMax - ((needMax - needMin) / 2);
	end
	
	local bathroomNeeds = ents.FindByClass("need_toilet");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		needMin, needMax = bathroomNeeds[1]:WorldSpaceAABB();
		
		paraNeeds.MapNeeds[needNum] = bathroomNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_PISS;
		paraNeeds.MapNeedPositions[needNum] = needMax - ((needMax - needMin) / 2);
	end
	
	local eatNeeds = ents.FindByClass("need_restaurant");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		needMin, needMax = eatNeeds[1]:WorldSpaceAABB();
		
		paraNeeds.MapNeeds[needNum] = eatNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_EAT;
		paraNeeds.MapNeedPositions[needNum] = needMax - ((needMax - needMin) / 2);
	end
	
	paraNeeds.MapNumNeeds = needNum;
	
	paraNeeds.Initialized = true;
	
	return;
end

function paraNeeds.StartRound(pl)
	local info = pl.paraInfo;
	
	if(paraNeeds.MapNumNeeds > 0) then
		info.needWait = paraNeeds.TIME_WAIT;
	else
		info.needWait = paraGame.TIME_ROUND;
	end
	
	info.needType = paraNeeds.NEED_NONE;
	info.needTime = paraNeeds.TIME_WAIT;
	info.needStatus = paraNeeds.STATUS_WAITING;
	
	paraNeeds.SendNeed(pl);
	
	return;
end

function paraNeeds.AssignNeed(pl)
	local info = pl.paraInfo;
	local oldTime = info.needTime - paraNeeds.TIME_WAIT;
	local rand = math.random(1, paraNeeds.MapNumNeeds);
	
	info.needType = paraNeeds.MapNeedTypes[rand];
	
	if(oldTime > 0) then
		info.needTime = oldTime + paraNeeds.TIME_NEED;
	else
		info.needTime = paraNeeds.TIME_NEED;
	end
	
	info.needStatus = paraNeeds.STATUS_HASNEED;
	
	local needPos = paraNeeds.MapNeedPositions[rand];
	
	paraNeeds.SendNeed(pl);
	paraNeeds.SendNeedStatus(pl);
	paraNeeds.SendNeedPos(pl, needPos);
	
	return;
end

function paraNeeds.FindNeed()
	-- ???
	-- seriously i have no idea what i was going to use this for
	-- for need hud?
end

function paraNeeds.PlayerThink(pl)
	local info = pl.paraInfo;
	
	if(info.needStatus == paraNeeds.STATUS_WAITING) then
		-- Waiting for new need
		if(info.needWait == 0) then
			paraNeeds.AssignNeed(pl);
		else
			info.needWait = info.needWait - 1;
		end
	
	elseif(info.needStatus == paraNeeds.STATUS_HASNEED) then
		-- Has a pending need
		if(info.needTime == 0) then
			local health = pl:Health();
			
			if(health > 1) then
				pl:TakeDamage(1, pl);
			end
			
		else
			info.needTime = info.needTime - 1;
			
			if(info.needTime % 30 == 0) then
				paraNeeds.SendNeedTime(pl);
			end
			
		end
		
	elseif(info.needStatus == paraNeeds.STATUS_WORKING) then
		-- Is working on current need
		if(info.needWorking == 0) then
			paraNeeds.EndTask(pl);
		else
			info.needWorking = info.needWorking - 1;
		end
	end

	return;
end

function paraNeeds.TryNeed(pl)
	local info = pl.paraInfo;
	
	if(info.needType == info.needArea) then
		paraNeeds.StartTask(pl);
	end
	
	return;
end

function paraNeeds.StartTask(pl)
	local info = pl.paraInfo;

	pl:Freeze(true);

	info.needStatus = paraNeeds.STATUS_WORKING;
	info.needWorking = paraNeeds.TIME_WORK;
	
	paraNeeds.SendNeedStatus(pl);
	
	return;
end

function paraNeeds.EndTask(pl)
	local info = pl.paraInfo;
	local health = pl:Health();

	pl:Freeze(false);
	
	if(health+paraNeeds.HEAL_AMOUNT > pl:GetMaxHealth()) then
		pl:SetHealth(pl:GetMaxHealth());
	else
		pl:SetHealth(health + paraNeeds.HEAL_AMOUNT);
	end
	
	info.needStatus = paraNeeds.STATUS_WAITING;
	info.needWait = paraNeeds.TIME_WAIT;
	info.needType = paraNeeds.NEED_NONE;

	paraNeeds.SendNeedStatus(pl);
	
	return;
end

function paraNeeds.SendNeed(pl)
	local info = pl.paraInfo;
	
	net.Start("PARA_PlayerNeed");
		net.WriteUInt(info.needType, 8);
		net.WriteUInt(info.needTime, 32);
	net.Send(pl);
	
	return;
end

function paraNeeds.SendNeedStatus(pl)
	local info = pl.paraInfo;

	net.Start("PARA_PlayerNeedStatus");
		net.WriteUInt(info.needStatus, 8);
	net.Send(pl);
	
	return;
end

function paraNeeds.SendNeedPos(pl, pos)
	net.Start("PARA_PlayerNeedPos");
		net.WriteVector(pos);
	net.Send(pl);
	
	return;
end

function paraNeeds.SendNeedTime(pl)
	local info = pl.paraInfo;

	net.Start("PARA_PlayerNeedTime");
		net.WriteUInt(info.needTime, 32);
	net.Send(pl);
	
	return;
end
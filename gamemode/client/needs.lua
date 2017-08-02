paraNeeds.NeedType = paraNeeds.NEED_NONE;
paraNeeds.NeedTime = 0;
paraNeeds.NeedStatus = paraNeeds.NEED_DISABLED;

paraNeeds.MapNeeds = {};
paraNeeds.MapNeedTypes = {};
paraNeeds.MapNumNeeds = 0;

paraNeeds.TrackerEnabled = false;
paraNeeds.TrackerPosition = {};

-- TODO: why doesnt this find any ents?
function paraNeeds.Initialize()
	local needNum = 0;

	local showerNeeds = ents.FindByClass("need_shower");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		paraNeeds.MapNeeds[needNum] = showerNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_SHOWER;
	end
	
	local bedNeeds = ents.FindByClass("need_bedroom");
	if(table.getn(bedNeeds) > 0) then
		needNum = needNum + 1;
		
		paraNeeds.MapNeeds[needNum] = bedNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_SLEEP;
	end
	
	local bathroomNeeds = ents.FindByClass("need_toilet");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		paraNeeds.MapNeeds[needNum] = bathroomNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_PISS;
	end
	
	local eatNeeds = ents.FindByClass("need_restaurant");
	if(table.getn(showerNeeds) > 0) then
		needNum = needNum + 1;
		
		paraNeeds.MapNeeds[needNum] = eatNeeds;
		paraNeeds.MapNeedTypes[needNum] = paraNeeds.NEED_EAT;
	end
	
	paraNeeds.MapNumNeeds = needNum;
	
	return;
end

function paraNeeds.SyncNeed(needType, needTime)
	paraNeeds.NeedType = needType;
	paraNeeds.NeedTime = needTime;
	
	if(paraNeeds.NeedType == paraNeeds.NEED_NONE) then
		paraHud.NeedText = "NONE";
		paraHud.NeedAltText = "";
	elseif(paraNeeds.NeedType == paraNeeds.NEED_INFEST) then
		paraHud.NeedText = "KILL";
		paraHud.NeedAltText = "";
	elseif(paraNeeds.NeedType == paraNeeds.NEED_SHOWER) then
		paraHud.NeedText = "WASH";
		paraHud.NeedAltText = paraUtil.SecondsToMinutes(needTime);
	elseif(paraNeeds.NeedType == paraNeeds.NEED_SLEEP) then
		paraHud.NeedText = "REST";
		paraHud.NeedAltText = paraUtil.SecondsToMinutes(needTime);
	elseif(paraNeeds.NeedType == paraNeeds.NEED_PISS) then
		paraHud.NeedText = "PISS";
		paraHud.NeedAltText = paraUtil.SecondsToMinutes(needTime);
	elseif(paraNeeds.NeedType == paraNeeds.NEED_EAT) then
		paraHud.NeedText = "EAT";
		paraHud.NeedAltText = paraUtil.SecondsToMinutes(needTime);
	end
	
	paraNeeds.TrackerEnabled = false;
	
	return;
end

function paraNeeds.RoundLoop()
	-- TODO: Clean this up
	if(paraNeeds.NeedType == paraNeeds.NEED_INFEST) then
		-- display human count
	elseif(paraNeeds.NeedTime > 0 and paraNeeds.NeedType ~= paraNeeds.NEED_NONE and paraNeeds.NeedStatus == paraNeeds.STATUS_HASNEED) then
		paraNeeds.NeedTime = paraNeeds.NeedTime - 1;
		
		paraHud.NeedAltText = paraUtil.SecondsToMinutes(paraNeeds.NeedTime);
	end
	
	return;
end

function paraNeeds.UpdateNeedTracker()
	paraNeeds.TrackerEnabled = false;
	
	for k=1, paraNeeds.MapNumNeeds, 1 do
		if(paraNeeds.MapNeedTypes[k] == paraNeeds.NeedType) then
			paraNeeds.TrackerPosition = paraNeeds.MapNeeds[k][1]:GetPos();
			
			paraNeeds.TrackerEnabled = true;
		end
	end
	
	return;
end

function paraNeeds.ShowNeed()
	if(paraNeeds.TrackerEnabled == true) then
		local pos = paraNeeds.TrackerPosition:ToScreen();
		
		pos.x = math.Clamp(pos.x,0,ScrW());
		pos.y = math.Clamp(pos.y,0,ScrH());
		
		surface.SetTexture(paraNeeds.ICONS[paraNeeds.NeedType]);
		surface.SetDrawColor(255,255,255,192);
		surface.DrawTexturedRect(pos.x - 32/2, pos.y - 32/2, 32, 32);
	end
	
	return;
end

function paraNeeds.ReceiveNeed(len)
	local needType = net.ReadUInt(8);
	local needTime = net.ReadUInt(32);
	
	paraNeeds.SyncNeed(needType, needTime);
	
	print("GET PARA_PlayerNeed | "..needType.." | "..needTime);
	
	return;
end
net.Receive("PARA_PlayerNeed", paraNeeds.ReceiveNeed);

function paraNeeds.ReceiveNeedStatus(len)
	paraNeeds.NeedStatus = net.ReadUInt(8);
	
	if(paraNeeds.NeedStatus == paraNeeds.STATUS_WAITING) then
		paraNeeds.SyncNeed(paraNeeds.NEED_NONE, 0);
	end
	
	print("GET PARA_PlayerNeedStatus | "..paraNeeds.NeedStatus);
	
	return;
end
net.Receive("PARA_PlayerNeedStatus", paraNeeds.ReceiveNeedStatus);

function paraNeeds.ReceiveNeedPos(len)
	paraNeeds.TrackerPosition = net.ReadVector();
	paraNeeds.TrackerEnabled = true;
	
	print("GET PARA_PlayerNeedPos | "..paraNeeds.TrackerPosition.x.." "..paraNeeds.TrackerPosition.y.." "..paraNeeds.TrackerPosition.z);
	
	return;
end
net.Receive("PARA_PlayerNeedPos", paraNeeds.ReceiveNeedPos);

function paraNeeds.ReceiveNeedTime(len)
	paraNeeds.NeedTime = net.ReadUInt(32);
	
	print("GET PARA_PlayerNeedTime | "..paraNeeds.NeedTime);
	
	return;
end
net.Receive("PARA_PlayerNeedTime", paraNeeds.ReceiveNeedTime);
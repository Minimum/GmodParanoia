paraUtil = {};

function paraUtil.FindPlayerByName(name)
	local foundPlayer = nil;
	local totalHits = 0;
	local search = string.lower(name);
	
	for k, v in pairs(player.GetAll()) do
		if(string.find(string.lower(v:Nick()), search) ~= nil) then
			foundPlayer = v;
			totalHits = totalHits + 1;
		end 
	end
	
	if(totalHits > 1) then
		foundPlayer = nil;
	end
	
	return foundPlayer;
end

function paraUtil.FormatTimer(time)
	local timer = "";
	local days = math.floor(time / 86400);
	local hours = math.floor((time % 86400) / 3600);
	local minutes = math.floor((time % 3600) / 60);
	local seconds = time % 60;
	
	if(days > 0) then
		timer = timer .. days .. ':';
		
		if(hours < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. hours .. ':';
		
		if(minutes < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. minutes .. ':';
		
		if(seconds < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. seconds;
	elseif(hours > 0) then
		timer = timer .. hours .. ':';
		
		if(minutes < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. minutes .. ':';
		
		if(seconds < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. seconds;
	else
		timer = timer .. minutes .. ':';
		
		if(seconds < 10) then
			timer = timer .. '0';
		end
		
		timer = timer .. seconds;
	end
	
	return timer;
end

function paraUtil.SecondsToMinutes(seconds)
	local time = math.floor(seconds / 60)..':';
	local secs = seconds % 60;
	
	if(secs < 10) then
		time = time..'0'..secs; 
	else
		time = time..secs;
	end
	
	return time;
end

function paraUtil.copy(object)
	local object2 = {};
	for k,v in pairs(object) do
		object2[k] = v;
	end
	
	return object2;
end
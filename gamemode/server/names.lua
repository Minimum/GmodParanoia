paraNames = {};

paraNames.FILE_PATH = "data/para/names.txt";

paraNames.GENDER_NONE = 0;
paraNames.GENDER_MALE = 1;
paraNames.GENDER_FEMALE = 2;

paraNames.FirstNames = {};
paraNames.LastNames = {};

paraNames.MaleNames = 0;
paraNames.FemaleNames = 0;
paraNames.NumFirstNames = 0;
paraNames.NumLastNames = 0;

util.AddNetworkString("PARA_PlayerName");

function paraNames.Initialize()
	local STATUS_READNAME = 0;
	local STATUS_READTYPE = 1;
	local STATUS_READGENDER = 2;
	
	local TYPE_INVALID = 0;
	local TYPE_FIRST = 1;
	local TYPE_LAST = 2;
	
	local nameFile = file.Read(paraNames.FILE_PATH, true);
	local name = {};
	local status = STATUS_READNAME;
	local type = TYPE_INVALID;
	
	name.name = "";
	
	--NAME|TYPE|GENDER\n
	-- Types:
	-- F - First Name
	-- L - Last Name
	-- Genders:
	-- M - Male
	-- F - Female
	-- B - Both
	
	if(nameFile ~= nil) then
		for i = 1, #nameFile do
			local symbol = nameFile:sub(i,i);
			
			if(symbol ~= '\n') then
				if(status == STATUS_READNAME) then
					if(symbol == '|') then
						status = STATUS_READTYPE;
					else
						name.name = name.name..symbol;
					end
				elseif(status == STATUS_READTYPE) then
					if(symbol:upper() == 'F') then
						type = TYPE_FIRST;
					elseif(symbol:upper() == 'L') then
						type = TYPE_LAST;
					elseif(symbol == '|') then
						if(type == TYPE_FIRST) then
							status = STATUS_READGENDER;			
						end
					end
				elseif(status == STATUS_READGENDER) then
					if(symbol:upper() == 'M') then
						name.male = true;
						name.female = false;
					elseif(symbol:upper() == 'F') then
						name.male = false;
						name.female = true;
					elseif(symbol:upper() == 'B') then
						name.male = true;
						name.female = true;
					end
				end
			else
				if(type == TYPE_FIRST and name.male ~= nil and name.female ~= nil) then
					paraNames.AddFirstName(name);
				elseif(type == TYPE_LAST) then
					paraNames.AddLastName(name);
				end
				
				name = {};
				name.name = "";
				type = TYPE_INVALID;
				
				status = STATUS_READNAME;
			end
		end
		
		if(type == TYPE_FIRST and name.male ~= nil and name.female ~= nil) then
			paraNames.AddFirstName(name);
		elseif(type == TYPE_LAST) then
			paraNames.AddLastName(name);
		end
	end
	
	-- Create SQL Tables
	sql.Query("CREATE TABLE IF NOT EXISTS para_player_names(id INTEGER PRIMARY KEY ASC, authid TEXT, name TEXT, color_r INTEGER, color_g INTEGER, color_b INTEGER);"); 
	
	return;
end

function paraNames.PlayerInit(pl)
	local authId = pl:SteamID();
	local settings = pl.paraSettings;
	
	local result = sql.Query("SELECT name FROM para_player_names WHERE authid="..sql.SQLStr(authId)..";");

	if(result) then
		for id, row in pairs(result) do
			if(string.len(row["name"]) > 0) then
				settings.name = row["name"];
			end
		end
	else
		sql.Query("INSERT INTO para_player_names (authid) VALUES ("..sql.SQLStr(authId)..");");
	end
	
	return;
end

function paraNames.AddFirstName(name)
	paraNames.NumFirstNames = paraNames.NumFirstNames + 1;

	paraNames.FirstNames[paraNames.NumFirstNames] = name;

	if(name.male == true) then
		paraNames.MaleNames = paraNames.MaleNames + 1;
	end

	if(name.female == true) then
		paraNames.FemaleNames = paraNames.FemaleNames + 1;
	end

	return;
end

function paraNames.AddLastName(name)
	paraNames.NumLastNames = paraNames.NumLastNames + 1;
	
	paraNames.LastNames[paraNames.NumLastNames] = name;
	
	return;
end

function paraNames.GenerateName(gender)
	local firstNameId;
	local lastNameId;
	local name = "";

	if(gender == paraNames.GENDER_MALE) then
		firstNameId = math.random(0, paraNames.MaleNames-1);
	else
		firstNameId = math.random(0, paraNames.FemaleNames-1);
	end
	
	for x=1, paraNames.NumFirstNames do
		if(gender == paraNames.GENDER_MALE) then
			if(paraNames.FirstNames[x].male == true) then
				if(firstNameId == 0) then
					name = name .. paraNames.FirstNames[x].name;

					break;
				else
					firstNameId = firstNameId - 1;
				end
			end
		else
			if(paraNames.FirstNames[x].female == true) then
				if(firstNameId == 0) then
					name = name .. paraNames.FirstNames[x].name;

					break;
				else
					firstNameId = firstNameId - 1;
				end
			end
		end
	end
	
	local failsafe = 0;
	
	while (failsafe <= 5) do
		lastNameId = math.random(1, paraNames.NumLastNames);

		if(paraNames.LastNames[lastNameId] ~= name) then
			name = name .. " " .. paraNames.LastNames[lastNameId].name;

			break;
		elseif(failsafe == 5) then
			name = name .. " " .. paraNames.LastNames[lastNameId].name;
		end
		
		failsafe = failsafe + 1;
	end
	
	return name;
end

function paraNames.NewName(pl)
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	local name = "Joe Schmo";
	local gender = (math.random(1,100) % 2) + 1;
	
	if(settings.gender ~= nil) then
		gender = settings.gender;
	end

	if(settings.name ~= nil) then
		name = settings.name;
	else
		name = paraNames.GenerateName(gender);
	end

	info.name = name;
	info.gender = gender;
	info.showName = true;
	
	paraMessages.sendPlayerNameAll(pl);

	return;
end

function paraNames.SetCustomName(pl, name)
	local authId = pl:SteamID();
	local info = pl.paraInfo;
	local settings = pl.paraSettings;

	sql.Query("UPDATE para_player_names SET name="..sql.SQLStr(name).." WHERE authid="..sql.SQLStr(authId)..";");
	
	if(string.len(name) > 0) then
		settings.name = name;
	else
		settings.name = nil;
	end
	
	return;
end

function paraNames.SendName(pl, nameOwner)
	local info = nameOwner.paraInfo;
	
	net.Start("PARA_PlayerName");
		net.WriteUInt(nameOwner:EntIndex(), 16);
		net.WriteString(info.name);
	net.Send(pl);
	
	return;
end

function paraNames.SendNameAll(pl)
	local info = pl.paraInfo;
	
	net.Start("PARA_PlayerName");
		net.WriteUInt(pl:EntIndex(), 16);
		net.WriteString(info.name);
	net.Broadcast();
	
	return;
end
paraCostumes.HumanMaleModels = {};
paraCostumes.HumanFemaleModels = {};
paraCostumes.AlienFormModels = {};
paraCostumes.AlienGruntModels = {};
paraCostumes.RobotModels = {};

paraCostumes.CustomHumanMaleModels = {};
paraCostumes.CustomHumanFemaleModels = {};
paraCostumes.CustomAlienFormModels = {};
paraCostumes.CustomAlienGruntModels = {};
paraCostumes.CustomRobotModels = {};

paraCostumes.MATFILE_PATH = "data/para/costume_materials.txt";

function paraCostumes.Initialize()
	-- Humans
	paraCostumes.AddHumanMaleModel("models/player/Group01/male_06.mdl");
	paraCostumes.AddHumanMaleModel("models/player/Group01/male_07.mdl");
	paraCostumes.AddHumanMaleModel("models/player/Group01/male_08.mdl");
	paraCostumes.AddHumanMaleModel("models/player/Group01/male_09.mdl");
	paraCostumes.AddHumanFemaleModel("models/player/Group01/Female_01.mdl");
	paraCostumes.AddHumanFemaleModel("models/player/Group01/Female_02.mdl");
	paraCostumes.AddHumanFemaleModel("models/player/Group01/Female_03.mdl");
	paraCostumes.AddHumanFemaleModel("models/player/Group01/Female_04.mdl");
	paraCostumes.AddHumanFemaleModel("models/player/Group01/Female_06.mdl");
	
	
	-- Alien Forms
	paraCostumes.AddAlienFormModel("models/player/corpse1.mdl");
	
	-- Alien Grunts
	paraCostumes.AddAlienGruntModel("models/player/classic.mdl");
	
	-- Robots
	
	-- Add Material Resources
	paraCostumes.LoadMaterials();
	
	-- Create SQL Tables
	sql.Query("CREATE TABLE IF NOT EXISTS para_player_costumes(id INTEGER PRIMARY KEY ASC, authid TEXT, human TEXT, alienform TEXT, aliengrunt TEXT, robot TEXT);"); 
	
	return;
end

function paraCostumes.LoadMaterials()
	local matFile = file.Read(paraCostumes.MATFILE_PATH, true);
	local material = "";
	local comment = false;
	local escape = false;
	local ignoreLine = false;
	
	if(matFile ~= nil) then
		
		for i = 1, #matFile do
			local symbol = matFile:sub(i,i);
			
			if(symbol ~= '\n') then
				-- Read Char
				if(ignoreLine == false) then
					if(escape) then
						material = material..symbol;
						
						escape = false;
					else
						if(comment) then
							if(symbol == '/') then
								ignoreLine = true;
							else
								material = material..'/'..symbol;
								comment = false;
							end
						else
							if(symbol == '/') then
								comment = true;
							elseif(symbol == '\\') then
								escape = true;
							else
								material = material..symbol;
							end
						end
					end
				end
			else
				-- New line
				ignoreLine = false;
				escape = false;
				comment = false;
				
				if(string.len(material) > 0) then
					resource.AddFile(material);
				end
				
				material = "";
			end
		end
		
		if(string.len(material) > 0) then
			resource.AddFile(material);
		end
		
	end
	
	return;
end

function paraCostumes.PlayerInit(pl)
	local authId = pl:SteamID();
	local settings = pl.paraSettings;
	
	local result = sql.Query("SELECT human, alienform, aliengrunt, robot FROM para_player_costumes WHERE authid = "..sql.SQLStr(authId)..";");
	
	if(result) then
		for id, row in pairs(result) do
			if(string.len(row["human"]) > 0) then
				local found, gender = paraCostumes.FindHumanModel(row["human"]);
			
				if(found) then
					settings.costumeHuman = row["human"];
					settings.gender = gender;
				end
			end
			
			if(string.len(row["alienform"]) > 0) then
				local found = paraCostumes.FindAlienFormModel(row["alienform"]);
				
				if(found) then
					settings.costumeAlienForm = row["alienform"];
				end
			end
			
			if(string.len(row["aliengrunt"]) > 0) then
				local found = paraCostumes.FindAlienGruntModel(row["aliengrunt"]);
				
				if(found) then
					settings.costumeAlienGrunt = row["aliengrunt"];
				end
			end
			
			if(string.len(row["robot"]) > 0) then
				local found = paraCostumes.FindRobotModel(row["robot"]);
				
				if(found) then
					settings.costumeRobot = row["robot"];
				end
			end
		end
	else
		sql.Query("INSERT INTO para_player_costumes (authid) VALUES ("..sql.SQLStr(authId)..");");
	end
	
	-- Precache Models
	for x=1, table.getn(paraCostumes.HumanMaleModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.HumanMaleModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.CustomHumanMaleModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.CustomHumanMaleModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.HumanFemaleModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.HumanFemaleModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.CustomHumanFemaleModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.CustomHumanFemaleModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.AlienFormModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.AlienFormModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.CustomAlienFormModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.CustomAlienFormModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.AlienGruntModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.AlienGruntModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.CustomAlienGruntModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.CustomAlienGruntModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.RobotModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.RobotModels[x]);
	end
	
	for x=1, table.getn(paraCostumes.CustomRobotModels), 1 do
		paraMessages.sendPrecacheModel(pl, paraCostumes.CustomRobotModels[x]);
	end
	
	return;
end

function paraCostumes.AddHumanMaleModel(model, custom)
	model = Model(model);
	resource.AddFile(model);

	if(custom == nil or custom == false) then
		paraCostumes.HumanMaleModels[table.getn(paraCostumes.HumanMaleModels)+1] = model;
	else
		paraCostumes.CustomHumanMaleModels[table.getn(paraCostumes.CustomHumanMaleModels)+1] = model;
	end
	
	return;
end

function paraCostumes.AddHumanFemaleModel(model, custom)
	model = Model(model);
	resource.AddFile(model);
	
	if(custom == nil or custom == false) then
		paraCostumes.HumanFemaleModels[table.getn(paraCostumes.HumanFemaleModels)+1] = model;
	else
		paraCostumes.CustomHumanFemaleModels[table.getn(paraCostumes.CustomHumanFemaleModels)+1] = model;
	end
	
	return;
end

function paraCostumes.AddAlienFormModel(model, custom)
	model = Model(model);
	resource.AddFile(model);
	
	if(custom == nil or custom == false) then
		paraCostumes.AlienFormModels[table.getn(paraCostumes.AlienFormModels)+1] = model;
	else
		paraCostumes.CustomAlienFormModels[table.getn(paraCostumes.CustomAlienFormModels)+1] = model;
	end
	
	return;
end

function paraCostumes.AddAlienGruntModel(model, custom)
	model = Model(model);
	resource.AddFile(model);
	
	if(custom == nil or custom == false) then
		paraCostumes.AlienGruntModels[table.getn(paraCostumes.AlienGruntModels)+1] = model;
	else
		paraCostumes.CustomAlienGruntModels[table.getn(paraCostumes.CustomAlienGruntModels)+1] = model;
	end
	
	return;
end

function paraCostumes.AddRobotModel(model, custom)
	model = Model(model);
	resource.AddFile(model);
	
	if(custom == nil or custom == false) then
		paraCostumes.RobotModels[table.getn(paraCostumes.RobotModels)+1] = model;
	else
		paraCostumes.CustomRobotModels[table.getn(paraCostumes.CustomRobotModels)+1] = model;
	end
	
	return;
end

function paraCostumes.SelectHumanModel(pl)
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	
	if(settings.costumeHuman ~= nil) then
		-- Custom Model
		info.costumeHuman = settings.costumeHuman;
	else
		-- Standard Model
		if(info.gender == paraNames.GENDER_MALE) then
			local rand = math.random(1,table.getn(paraCostumes.HumanMaleModels));
			info.costumeHuman = paraCostumes.HumanMaleModels[rand];
		elseif(info.gender == paraNames.GENDER_FEMALE) then
			local rand = math.random(1,table.getn(paraCostumes.HumanFemaleModels));
			info.costumeHuman = paraCostumes.HumanFemaleModels[rand];
		else
			info.costumeHuman = paraCostumes.DEFAULT_MODEL;
		end
	end
	
	return;
end

function paraCostumes.SelectAlienFormModel(pl)
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	
	if(settings.costumeAlienForm ~= nil) then
		-- Custom Model
		info.costumeAlienForm = settings.costumeAlienForm;
	else
		-- Standard Model
		local rand = math.random(1,table.getn(paraCostumes.AlienFormModels));
		info.costumeAlienForm = paraCostumes.AlienFormModels[rand];
	end
	
	return;
end

function paraCostumes.SelectAlienGruntModel(pl)
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	
	if(settings.costumeAlienGrunt ~= nil) then
		-- Custom Model
		info.costumeAlienGrunt = settings.costumeAlienGrunt;
	else
		-- Standard Model
		local rand = math.random(1,table.getn(paraCostumes.AlienGruntModels));
		info.costumeAlienGrunt = paraCostumes.AlienGruntModels[rand];
	end
	
	return;
end

function paraCostumes.SelectRobotModel(pl)
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	
	if(settings.costumeCustomRobot ~= nil) then
		-- Custom Model
		info.costumeRobot = settings.costumeRobot;
	else
		-- Standard Model
		local rand = math.random(1,table.getn(paraCostumes.RobotModels));
		info.costumeRobot = paraCostumes.RobotModels[rand];
	end
	
	return;
end

function paraCostumes.FindHumanModel(model)
	local found = false;
	local gender = paraNames.GENDER_NONE;

	-- Male
	for x=1, table.getn(paraCostumes.HumanMaleModels), 1 do
		if(paraCostumes.HumanMaleModels[x] == model) then
			found = true;
			gender = paraNames.GENDER_MALE;
			
			break;
		end
	end
	
	if(found == false) then
		-- Custom Male
		for x=1, table.getn(paraCostumes.CustomHumanMaleModels), 1 do
			if(paraCostumes.CustomHumanMaleModels[x] == model) then
				found = true;
				gender = paraNames.GENDER_MALE;
				
				break;
			end
		end
	
		if(found == false) then
			-- Female
			for x=1, table.getn(paraCostumes.HumanFemaleModels), 1 do
				if(paraCostumes.HumanFemaleModels[x] == model) then
					found = true;
					gender = paraNames.GENDER_FEMALE;
					
					break;
				end
			end
			
			if(found == false) then
				-- Custom Female
				for x=1, table.getn(paraCostumes.CustomHumanFemaleModels), 1 do
					if(paraCostumes.CustomHumanFemaleModels[x] == model) then
						found = true;
						gender = paraNames.GENDER_FEMALE;
						
						break;
					end
				end
				
			end
		end
	end
	
	return found, gender;
end

function paraCostumes.FindAlienFormModel(model)
	local found = false;
	
	for x=1, table.getn(paraCostumes.AlienFormModels), 1 do
		if(paraCostumes.AlienFormModels[x] == model) then
			found = true;
			
			break;
		end
	end
	
	if(found == false) then
		for x=1, table.getn(paraCostumes.CustomAlienFormModels), 1 do
			if(paraCostumes.CustomAlienFormModels[x] == model) then
				found = true;
				
				break;
			end
		end
	end
	
	return found;
end

function paraCostumes.FindAlienGruntModel(model)
	local found = false;

	for x=1, table.getn(paraCostumes.AlienGruntModels), 1 do
		if(paraCostumes.AlienGruntModels[x] == model) then
			found = true;
			
			break;
		end
	end
	
	if(found == false) then
		for x=1, table.getn(paraCostumes.CustomAlienGruntModels), 1 do
			if(paraCostumes.CustomAlienGruntModels[x] == model) then
				found = true;
				
				break;
			end
		end
	end

	return found;
end

function paraCostumes.FindRobotModel(model)
	local found = false;
	
	for x=1, table.getn(paraCostumes.RobotModels), 1 do
		if(paraCostumes.RobotModels[x] == model) then
			found = true;
			
			break;
		end
	end
	
	if(found == false) then
		for x=1, table.getn(paraCostumes.CustomRobotModels), 1 do
			if(paraCostumes.CustomRobotModels[x] == model) then
				found = true;
				
				break;
			end
		end
	end
	
	return found;
end

function paraCostumes.SetCustomHumanModel(pl, model)
	local authId = pl:SteamID();
	local info = pl.paraInfo;
	local settings = pl.paraSettings;
	
	sql.Query("UPDATE para_player_costumes SET human="..sql.SQLStr(model).." WHERE authid="..sql.SQLStr(authId)..";");
	
	local found, gender = paraCostumes.FindHumanModel(model);
	
	if(found) then
		settings.costumeHuman = model;
		settings.gender = gender;
	end
	
	return found;
end

function paraCostumes.SetCustomAlienFormModel(pl, model)
	local authId = pl:SteamID();
	local info = pl.paraInfo;
	local settings = pl.paraSettings;

	sql.Query("UPDATE para_player_costumes SET alienform="..sql.SQLStr(model).." WHERE authid="..sql.SQLStr(authId)..";");
	
	local found = paraCostumes.FindAlienFormModel(model);
	
	if(found) then
		settings.costumeAlienForm = model;
	end
	
	return found;
end

function paraCostumes.SetCustomAlienGruntModel(pl, model)
	local authId = pl:SteamID();
	local info = pl.paraInfo;
	local settings = pl.paraSettings;

	sql.Query("UPDATE para_player_costumes SET aliengrunt="..sql.SQLStr(model).." WHERE authid="..sql.SQLStr(authId)..";");
	
	local found = paraCostumes.FindAlienGruntModel(model);
	
	if(found) then
		settings.costumeAlienGrunt = model;
	end
	
	return found;
end

function paraCostumes.SetCustomRobotModel(pl, model)
	local authId = pl:SteamID();
	local info = pl.paraInfo;
	local settings = pl.paraSettings;

	sql.Query("UPDATE para_player_costumes SET robot="..sql.SQLStr(model).." WHERE authid="..sql.SQLStr(authId)..";");
	
	local found = paraCostumes.FindRobotModel(model);
	
	if(found) then
		settings.costumeRobot = model;
	end
	
	return found;
end
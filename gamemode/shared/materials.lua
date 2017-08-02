paraMaterials = {};

paraMaterials.MATFILE_PATH = "data/para/materials.txt";

-- Models
paraMaterials.MODEL_PLAYERDEFAULT = "models/player/corpse1.mdl";				-- Player Placeholder

-- Textures

-- Sounds
paraMaterials.SOUND_ALIENSCREAM = "npc/stalker/go_alert2a.wav";					-- Alien Scream

-- Precaching
function paraMaterials.Precache()
	-- Models
	--util.PrecacheModel(paraMaterials.MODEL_CORPSE);
	--util.PrecacheModel("models/player/hellknight/hellknight.mdl");
	--util.PrecacheModel("models/player/verdugo/verdugo.mdl");
	--util.PrecacheModel("models/slash/tali/talizorah.mdl");

	-- Textures
	
	-- Sounds
	util.PrecacheSound(paraMaterials.SOUND_ALIENSCREAM);
	util.PrecacheSound("npc/barnacle/barnacle_pull1.wav");						-- Alien Breath
	util.PrecacheSound("npc/barnacle/barnacle_pull2.wav");						-- Alien Breath
	util.PrecacheSound("npc/barnacle/barnacle_pull3.wav");						-- Alien Breath
	util.PrecacheSound("npc/barnacle/barnacle_pull4.wav");						-- Alien Breath
	
	--player_manager.AddValidModel("PARA_ALIENFORM_1", "models/player/verdugo/verdugo.mdl");
	--player_manager.AddValidModel("PARA_ALIENGRUNT_1", "models/player/hellknight/hellknight.mdl");
	
	return;
end

-- Downloads
function paraMaterials.AddResources()
	-- Models

	-- Textures
	resource.AddFile("materials/vgui/wash.vmt");
	resource.AddFile("materials/vgui/sleep.vmt");
	resource.AddFile("materials/vgui/wc.vmt");
	resource.AddFile("materials/vgui/eat.vmt");
	
	-- Sounds
	resource.AddFile("resource/fonts/Denton.ttf");
	
	local matFile = file.Read(paraMaterials.MATFILE_PATH, true);
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
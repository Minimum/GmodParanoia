paraGame.PLAYERS_PER_ALIEN = 8;

paraGame.RoundStatus = paraGame.ROUND_INIT;
paraGame.RoundTime = 0;

paraGame.CleanupIgnoreEnts = {};

function paraGame.Initialize()
	paraNames.Initialize();				-- Names
	--paraNeeds.Initialize();				-- Needs
	paraClasses.Initialize();			-- Classes (Human, Alien, etc.)
	paraWeapons.Initialize();			-- Weapon Spawns
	paraCostumes.Initialize();			-- Costumes (Player Models)
	
	timer.Create("ParaPreroundLoop", 1.0, 0, paraGame.PreroundLoop);
	timer.Stop("ParaPreroundLoop");
	
	timer.Create("ParaRoundLoop", 1.0, 0, paraGame.RoundLoop);
	timer.Stop("ParaRoundLoop");
	
	timer.Create("ParaPostroundLoop", 1.0, 0, paraGame.PostroundLoop);
	timer.Stop("ParaPostroundLoop");
	
	timer.Simple(1.0, paraGame.StartWorld);
end 

-- run loops every second
-- Preround loop
-- round loop
-- postround loop
function paraGame.PreroundLoop()
	local players = 0;
	
	for k, v in pairs(player.GetAll()) do
		players = players + 1;
	end
	
	if(players > 0) then
		if(paraGame.RoundTime > 0) then
			paraGame.RoundTime = paraGame.RoundTime - 1;
		else
			paraGame.StartRound();
		end
	else
		paraGame.RoundTime = paraGame.TIME_PREROUND;
	end

	return;
end

function paraGame.RoundLoop()
	for k, pl in pairs(player.GetAll()) do
		paraClasses.PlayerThink(pl);
	end
	
	if(paraGame.RoundTime % 60 == 0) then
		paraMessages.sendRoundTimeAll();
	end
	
	if(paraGame.RoundTime > 0) then
		paraGame.RoundTime = paraGame.RoundTime - 1;
	else
		paraGame.EndRound(paraGame.TEAM_HUMANS);
	end

	return;
end

function paraGame.PostroundLoop()
	if(paraGame.RoundTime > 0) then
		paraGame.RoundTime = paraGame.RoundTime - 1;
	else
		paraGame.StartWorld();
	end
	
	return;
end

function paraGame.StartWorld()
	if(paraNeeds.Initialized == false) then
		paraNeeds.Initialize();
	end

	-- Despawn Players
	for k, pl in pairs(player.GetAll()) do
		pl:KillSilent();
	end
	
	-- Clean up Entities
	game.CleanUpMap();
	
	-- Reset Robot
	paraClasses.RobotAlliance = paraGame.TEAM_HUMANS;
	
	-- Spawn Weapons/Items
	--paraWeapons.StartWorld();
	
	paraNeeds.Initialize();
	
	-- Reset Player Info / Spawn Players
	for k, pl in pairs(player.GetAll()) do
		paraGame.InitPlayerInfo(pl);
		pl:Spawn();
	end
	
	-- Set Round Start Timer
	paraGame.RoundStatus = paraGame.ROUND_PREGAME;
	paraGame.RoundTime = paraGame.TIME_PREROUND;
	
	-- Send Round Start
	paraMessages.sendPreroundStartAll();
	
	timer.Stop("ParaPostroundLoop");
	timer.Start("ParaPreroundLoop");
	
	return;
end

function paraGame.StartRound()
	local players = 0;
	
	-- Spawn dead players
	for k, pl in pairs(player.GetAll()) do
		if(pl:Alive() == false) then
			pl:Spawn();
		else
			pl:SetHealth(100);
		end
		
		players = players + 1;
	end

	-- Select alien(s)
	local aliens = math.ceil(players / paraGame.PLAYERS_PER_ALIEN);
	
	for k=1, aliens, 1 do
		paraGame.ChooseAlien();
	end
	
	-- Set Round End Timer
	paraGame.RoundStatus = paraGame.ROUND_GAME;
	paraGame.RoundTime = paraGame.TIME_ROUND;
	
	-- Send Round Start
	paraMessages.sendRoundStartAll();
	
	timer.Stop("ParaPreroundLoop");
	timer.Start("ParaRoundLoop");
	
	return;
end

function paraGame.EndRound(winner)
	-- Set New Round Timer
	paraGame.RoundStatus = paraGame.ROUND_POSTGAME;
	paraGame.RoundTime = paraGame.TIME_POSTROUND;
	
	-- Send Round End
	paraMessages.sendPostroundStartAll(winner);
	
	timer.Stop("ParaRoundLoop");
	timer.Start("ParaPostroundLoop");
	
	return;
end

function paraGame.PlayerThink(pl)
	local info = pl.paraInfo;
	
	paraClasses.PlayerThink(pl);
	
	return;
end

function paraGame.InitPlayerInfo(pl)
	pl.paraInfo = {};

	paraNames.NewName(pl);
	paraClasses.SetHuman(pl);
	
	paraNames.SendNameAll(pl);
	
	hook.Call("PlayerSetModel", GAMEMODE, pl);
	
	return;
end

function paraGame.InitPlayerInfoLate(pl)
	pl.paraInfo = {};

	pl.paraInfo.name = "";
	pl.paraInfo.gender = 0;

	paraNames.NewName(pl);
	paraClasses.SetAlienGrunt(pl);
	
	hook.Call("PlayerSetModel", GAMEMODE, pl);
	
	-- Messages
	paraNames.SendNameAll(pl);
	
	return;
end

function paraGame.CheckRoundEnd()
	local humans = 0;
	local aliens = 0;
	
	for k, pl in pairs(player.GetAll()) do
		if(pl.paraInfo.classType == paraClasses.CLASS_ALIENHOST or pl.paraInfo.classType == paraClasses.CLASS_ALIENBROOD) then
			aliens = aliens + 1;
		elseif(pl.paraInfo.classType == paraClasses.CLASS_HUMAN) then
			humans = humans + 1;
		elseif(pl.paraInfo.classType == paraClasses.CLASS_ROBOT) then
			-- if alliance == humans then humans++
		end
	end

	if(humans == 0 and aliens > 0) then
		paraGame.EndRound(paraGame.TEAM_ALIENS);
	elseif(aliens == 0 and humans > 0) then
		paraGame.EndRound(paraGame.TEAM_HUMANS);
	elseif(aliens == 0 and humans == 0) then
		paraGame.EndRound(paraGame.TEAM_NONE);
	end
	
	return;
end

function paraGame.ChooseAlien()
	local humans = {};
	local numHumans = 0;

	for k, pl in pairs(player.GetAll()) do
		if(pl.paraInfo.classType == paraClasses.CLASS_HUMAN) then
			numHumans = numHumans + 1;
			humans[numHumans] = pl;
		end
	end
	
	local rand = math.random(1, numHumans);
	
	paraClasses.SetAlienHost(humans[rand]);
	
	return;
end

function paraGame.SetRoundTime(seconds)
	paraGame.RoundTime = seconds;
	
	paraMessages.sendRoundTimeAll();
	
	return;
end
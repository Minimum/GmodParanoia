paraGame.RoundStatus = paraGame.ROUND_INIT;
paraGame.RoundTime = 0;

paraGame.PlayerInfo = {};

function paraGame.Initialize()
	paraNeeds.Initialize();

	for k, v in pairs(player.GetAll()) do
		local id = v:EntIndex();
		
		if(paraGame.PlayerInfo[id] == nil) then
			paraGame.PlayerInfo[id] = {};
		end
	end

	timer.Create("ParaRoundLoop", 1.0, 0, paraGame.RoundLoop);
	timer.Stop("ParaRoundLoop");
end

function paraGame.SyncRoundTime(time)
	timer.Stop("ParaRoundLoop");
	
	paraGame.RoundTime = time;
	
	-- Update HUD Timer
	paraHud.TimeText = paraUtil.FormatTimer(paraGame.RoundTime);
	
	timer.Start("ParaRoundLoop");
end

function paraGame.RoundLoop()
	if(paraGame.RoundTime > 0) then
		paraGame.RoundTime = paraGame.RoundTime - 1;
	
		-- Update HUD Timer
		paraHud.TimeText = paraUtil.FormatTimer(paraGame.RoundTime);
	end
	
	paraNeeds.RoundLoop();
	
	return;
end
paraMessages = {};

-- PARA_PlayerNeed
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's current need and time.
function paraMessages.receivePlayerNeed(message)
	local needType = message:ReadShort();
	local needTime = message:ReadShort();
	
	paraNeeds.SyncNeed(needType, needTime);
	
	return;
end
usermessage.Hook("PARA_PlayerNeed", paraMessages.receivePlayerNeed);

-- PARA_PlayerClass
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's current class.
function paraMessages.receivePlayerClass(message)
	local plId = message:ReadShort();
	local classType = message:ReadShort();
	
	if(paraGame.PlayerInfo[plId] == nil) then
		paraGame.PlayerInfo[plId] = {};
	end
	
	paraGame.PlayerInfo[plId].classType = classType;
	paraGame.PlayerInfo[plId].alienForm = false;
	
	-- TODO: quick fix, finish later
	if(player.GetByID(plId) == LocalPlayer()) then
		if(classType == paraClasses.CLASS_HUMAN) then
			paraHud.CurrentColor = paraHud.COLOR_HUMAN;
			--paraHud.ClassText = "Human";
		elseif(classType == paraClasses.CLASS_ALIENHOST) then
			paraHud.CurrentColor = paraHud.COLOR_ALIENHOST;
			--paraHud.ClassText = "Alien Host";
		elseif(classType == paraClasses.CLASS_ALIENBROOD) then
			paraHud.CurrentColor = paraHud.COLOR_ALIENBROOD;
			--paraHud.ClassText = "Alien Brood";
		elseif(classType == paraClasses.CLASS_ALIENGRUNT) then
			paraHud.CurrentColor = paraHud.COLOR_ALIENFORM;
			--paraHud.ClassText = "Alien Grunt";
		end
	end
	
	return;
end
usermessage.Hook("PARA_PlayerClass", paraMessages.receivePlayerClass);

function paraMessages.receivePlayerWeight()

end

function paraMessages.receivePlayerName(message)
	local plId = message:ReadShort();
	local name = message:ReadString();
	
	if(paraGame.PlayerInfo[plId] == nil) then
		paraGame.PlayerInfo[plId] = {};
	end
	
	-- TODO: Create CL_Names Class
	if(player.GetByID(plId) == LocalPlayer()) then
		paraHud.ClassText = name;
	end
	
	paraGame.PlayerInfo[plId].name = name;
	paraGame.PlayerInfo[plId].showName = true;
	
	return;
end
usermessage.Hook("PARA_PlayerName", paraMessages.receivePlayerName);

function paraMessages.receivePlayerShowName(message)
	local plId = message:ReadShort();
	local showName = message:ReadBool();
	
	local pl = player.GetByID(plId);
	local info = pl.paraInfo;
	
	if(info == nil) then
		info = {};
	end
	
	info.showName = showName;
	
	pl.paraInfo = info;
	
	return;
end
usermessage.Hook("PARA_PlayerShowName", paraMessages.receivePlayerShowName);

function paraMessages.receivePlayerAlienForm(message)
	local plId = message:ReadShort();
	local alienForm = message:ReadBool();
	
	if(paraGame.PlayerInfo[plId] == nil) then
		paraGame.PlayerInfo[plId] = {};
	end
	
	paraGame.PlayerInfo[plId].alienForm = alienForm;
	
	return;
end
usermessage.Hook("PARA_PlayerAlienForm", paraMessages.receivePlayerAlienForm);

-- PARA_NeedTime
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round time.
function paraMessages.receiveNeedTime()

end

-- PARA_RoundTime
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round time.
function paraMessages.receiveRoundTime(message)
	paraGame.SyncRoundTime(message:ReadShort());
	
	return;
end
usermessage.Hook("PARA_RoundTime", paraMessages.receiveRoundTime);

-- PARA_RoundTimeLong
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round time as a long int.
function paraMessages.receiveRoundTimeLong(message)
	paraGame.SyncRoundTime(message:ReadLong());
	
	return;
end
usermessage.Hook("PARA_RoundTimeLong", paraMessages.receiveRoundTimeLong);

function paraMessages.receiveRoundStatus(message)
	local status = message:ReadShort();
	
	paraGame.RoundStatus = status;
	
	if(status == paraGame.ROUND_PREGAME) then
		paraHud.TimeTitle = "Preround";
	elseif(status == paraGame.ROUND_GAME) then
		paraHud.TimeTitle = "Extraction";
	elseif(status == paraGame.ROUND_POSTGAME) then
		paraHud.TimeTitle = "Postround";
	end
	
	paraHud.ShowWinner = false;
	
	return;
end
usermessage.Hook("PARA_RoundStatus", paraMessages.receiveRoundStatus);

-- PARA_Preround
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.receivePreroundStart(message)
	local time = message:ReadShort();
	
	paraGame.RoundStatus = paraGame.ROUND_PREGAME;
	paraGame.SyncRoundTime(time);
	paraHud.TimeTitle = "Preround";
	paraHud.ShowWinner = false;
	
	return;
end
usermessage.Hook("PARA_PreroundStart", paraMessages.receivePreroundStart);

-- PARA_RoundStart
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.receiveRoundStart(message)
	local time = message:ReadShort();
	
	paraGame.RoundStatus = paraGame.ROUND_GAME;
	paraGame.SyncRoundTime(time);
	paraHud.TimeTitle = "Extraction";
	
	LocalPlayer():EmitSound("music/HL2_song8.mp3", 100, 100);
	
	return;
end
usermessage.Hook("PARA_RoundStart", paraMessages.receiveRoundStart);

-- PARA_Postround
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.receivePostroundStart(message)
	local time = message:ReadShort();
	local winner = message:ReadShort();
	
	paraGame.RoundStatus = paraGame.ROUND_POSTGAME;
	paraGame.SyncRoundTime(time);
	paraHud.TimeTitle = "Postround";
	paraHud.ShowWinner = true;
	
	if(winner == paraGame.TEAM_HUMANS) then
		paraHud.WinnerText = "HUMANS WIN";
	elseif(winner == paraGame.TEAM_ALIENS) then
		paraHud.WinnerText = "ALIENS WIN";
	else
		paraHud.WinnerText = "ROUND DRAW";
	end
	
	return;
end
usermessage.Hook("PARA_PostroundStart", paraMessages.receivePostroundStart);

function paraMessages.receivePrecacheModel(message)
	local model = message:ReadString();
	
	util.PrecacheModel(model);
	
	return;
end
usermessage.Hook("PARA_PrecacheModel", paraMessages.receivePrecacheModel);

-- PARA_PlayerRequestTransform
-- Server -> Client [ ]
-- Client -> Server [X]
-- Receives a player's request to transform.
function paraMessages.sendPlayerRequestTransform()

end

-- PARA_PlayerDropWeapon
-- Server -> Client [ ]
-- Client -> Server [X]
-- Receives a player's request to transform.
function paraMessages.SendPlayerDropWeapon()
	net.Start("PARA_PlayerDropWeapon");
	net.Send();
end
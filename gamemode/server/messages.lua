paraMessages = {};

-- PARA_PlayerNeed
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's current need and time.
function paraMessages.sendPlayerNeed(pl)
	local info = pl.paraInfo;

	umsg.Start("PARA_PlayerNeed", pl);
		umsg.Short(info.needType);
		umsg.Short(info.needTime);
	umsg.End();
	
	return;
end

-- PARA_PlayerNeedStatus
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's need status.
function paraMessages.sendPlayerNeedStatus(pl)
	local info = pl.paraInfo;

	umsg.Start("PARA_PlayerNeedStatus", pl);
		umsg.Short(info.needStatus);
	umsg.End();
	
	return;
end


-- PARA_PlayerClass
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's current class.
function paraMessages.sendPlayerClass(pl, classOwner)
	local info = classOwner.paraInfo;

	umsg.Start("PARA_PlayerClass", pl);
		umsg.Short(classOwner:EntIndex());
		umsg.Short(info.classType);
	umsg.End();
	
	return;
end

function paraMessages.sendPlayerClassAll(classOwner)
	local info = classOwner.paraInfo;
	local id = classOwner:EntIndex();

	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_PlayerClass", v);
			umsg.Short(id);
			umsg.Short(info.classType);
		umsg.End();
	end
	
	return;
end

-- PARA_PlayerWeight
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's current weight.
function paraMessages.sendPlayerWeight(pl)
	local info = pl.paraInfo;

	umsg.Start("PARA_PlayerWeight", pl);
		umsg.Short(info.weightCurrent);
	umsg.End();
	
	return;
end

-- PARA_PlayerName
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends a player's name.
function paraMessages.sendPlayerName(pl, nameOwner)
	local info = nameOwner.paraInfo;
	
	umsg.Start("PARA_PlayerName", pl);
		umsg.Short(nameOwner:EntIndex());
		umsg.String(info.name);
	umsg.End();
	
	return;
end

function paraMessages.sendPlayerNameAll(nameOwner)
	local info = nameOwner.paraInfo;
	local id = nameOwner:EntIndex();
	
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_PlayerName", v);
			umsg.Short(id);
			umsg.String(info.name);
		umsg.End();
	end
	
	return;
end

-- PARA_PlayerAlienForm
-- Server -> Client [X]
-- Client -> Server [ ]
-- Tells the client when a player goes in or out of alien form.
function paraMessages.sendPlayerAlienForm(pl, owner)
	local info = owner.paraInfo;
	local id = owner:EntIndex();
	
	umsg.Start("PARA_PlayerAlienForm", pl);
		umsg.Short(id);
		umsg.Bool(info.alienForm);
	umsg.End();
	
	return;
end

function paraMessages.sendPlayerAlienFormAll(owner)
	local info = owner.paraInfo;
	local id = owner:EntIndex();
	
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_PlayerAlienForm", v);
			umsg.Short(id);
			umsg.Bool(info.alienForm);
		umsg.End();
	end
	
	return;
end

-- PARA_RoundTime
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round time.
function paraMessages.sendRoundTime(pl)
	if(paraGame.RoundTime <= 32767) then
		umsg.Start("PARA_RoundTime", pl);
			umsg.Short(paraGame.RoundTime);
		umsg.End();
	else
		paraMessages.sendRoundTimeLong(pl);
	end
	
	return;
end

function paraMessages.sendRoundTimeAll()
	if(paraGame.RoundTime <= 32767) then
		for k, v in pairs(player.GetAll()) do
			umsg.Start("PARA_RoundTime", v);
				umsg.Short(paraGame.RoundTime);
			umsg.End();
		end
	else
		paraMessages.sendRoundTimeLongAll();
	end
	
	return;
end

-- PARA_RoundTimeLong
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round time as a long int.
function paraMessages.sendRoundTimeLong(pl)
	umsg.Start("PARA_RoundTimeLong", pl);
		umsg.Long(paraGame.RoundTime);
	umsg.End();
	
	return;
end

function paraMessages.sendRoundTimeLongAll()
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_RoundTimeLong", v);
			umsg.Long(paraGame.RoundTime);
		umsg.End();
	end
	
	return;
end

-- PARA_PreroundStart
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.sendPreroundStart(pl)
	umsg.Start("PARA_PreroundStart", pl);
		umsg.Short(paraGame.RoundTime);
	umsg.End();
	
	return;
end

function paraMessages.sendPreroundStartAll()
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_PreroundStart", pl);
			umsg.Short(paraGame.RoundTime);
		umsg.End();
	end
	
	return;
end

-- PARA_RoundStart
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.sendRoundStart(pl)
	umsg.Start("PARA_RoundStart", pl);
		umsg.Short(paraGame.RoundTime);
	umsg.End();
	
	return;
end

function paraMessages.sendRoundStartAll()
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_RoundStart", pl);
			umsg.Short(paraGame.RoundTime);
		umsg.End();
	end
	
	return;
end

-- PARA_PostroundStart
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.sendPostroundStart(pl)
	umsg.Start("PARA_PostroundStart", pl);
		umsg.Short(paraGame.RoundTime);
	umsg.End();
	
	return;
end

function paraMessages.sendPostroundStartAll(winner)
	for k, v in pairs(player.GetAll()) do
		umsg.Start("PARA_PostroundStart", pl);
			umsg.Short(paraGame.RoundTime);
			umsg.Short(winner);
		umsg.End();
	end
	
	return;
end

-- PARA_RoundStatus
-- Server -> Client [X]
-- Client -> Server [ ]
-- Sends the current round status.
function paraMessages.sendRoundStatus(pl)
	umsg.Start("PARA_RoundStatus", pl);
		umsg.Short(paraGame.RoundStatus);
	umsg.End();
	
	return;
end

-- PARA_PrecacheModel
-- Server -> Client [X]
-- Client -> Server [ ]
-- Tells the client to precache a model.
function paraMessages.sendPrecacheModel(pl, model)
	umsg.Start("PARA_PrecacheModel", pl);
		umsg.String(model);
	umsg.End();
	
	return;
end

-- GMOD 13 Placeholder

-- PARA_PlayerRequestTransform
-- Server -> Client [ ]
-- Client -> Server [X]
-- Receives a player's request to transform.
function paraMessages.receivePlayerRequestTransform(pl)

end

-- PARA_PlayerDropWeapon
-- Server -> Client [ ]
-- Client -> Server [X]
-- Receives a player's request to drop a weapon.
function paraMessages.ReceivePlayerDropWeapon(pl)
	paraCommands.DropWeapon(pl);
	
	return;
end
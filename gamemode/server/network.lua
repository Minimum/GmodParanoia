paraNetwork = {};

function paraNetwork.sendPlayerNeed(pl)
	local info = pl.paraInfo;
	
	net.Start("PARA_PlayerNeed");
		umsg.Short(info.needType);
		umsg.Short(info.needTime);
	net.Send(pl);
	
	return;
end
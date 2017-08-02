paraNames = {};

paraNames.players = {};

function paraNames.ReceiveName(len)
	local id = net.ReadUInt(16);
	local name = net.ReadString();
	
	if(paraNames.players[id] == nil) then
		paraNames.players[id] = {};
	end
	
	if(player.GetByID(id) == LocalPlayer()) then
		paraHud.ClassText = name;
	end
	
	paraNames.players[id].name = name;
	paraNames.players[id].showName = true;
	
	print("GET PARA_PlayerName | "..id.." | "..name);
	
	return;
end
net.Receive("PARA_PlayerName", paraNames.ReceiveName);
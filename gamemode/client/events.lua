function GM:PlayerAuthed(pl, SteamID, UniqueID)
	--pl.paraInfo = {};
end

function GM:StartChat()
	paraCommands.ActionKeyEnabled = false;
	
	return false;
end

function GM:FinishChat()
	paraCommands.ActionKeyEnabled = true;

	return;
end
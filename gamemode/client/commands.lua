paraCommands = {};

paraCommands.DropWeaponKey = KEY_G;
paraCommands.ActionKey = KEY_Q;

paraCommands.DropWeaponKeyPressed = false;
paraCommands.ActionKeyPressed = false;

paraCommands.ActionKeyEnabled = true;

function GM:PlayerBindPress(player, bind, pressed)
	local block = false;

	if(pressed) then
		if(bind == "impulse 201") then
			block = true;
		end
	else
	
	end
	
	return block;
end

function GM:Think()
	if(input.IsKeyDown(paraCommands.DropWeaponKey)) then
		if(paraCommands.DropWeaponKeyPressed == false and paraCommands.ActionKeyEnabled == true and gui.IsGameUIVisible() == false) then
			RunConsoleCommand("para_dropweapon");
			
			paraCommands.DropWeaponKeyPressed = true;
		end
	else
		paraCommands.DropWeaponKeyPressed = false;
	end
	
	if(input.IsKeyDown(paraCommands.ActionKey)) then
		if(paraCommands.ActionKeyPressed == false and paraCommands.ActionKeyEnabled == true and gui.IsGameUIVisible() == false) then
			RunConsoleCommand("para_action");
			
			paraCommands.ActionKeyPressed = true;
		end
	else
		paraCommands.ActionKeyPressed = false;
	end
	
	return;
end
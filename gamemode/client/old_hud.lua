paraHud = {};

paraHud.SUPER_SIZE = 0.05/2;			-- 3D Hud Scale (Def: 0.05)
paraHud.SUPER_DISTANCE = 25/2;			-- 3D Hud Distance (Def: 25)
paraHud.SUPER_ANGLE = 20;				-- 3D Hud Angle (Def: 20)

-- Colors
paraHud.COLOR_HUMAN = 1;				-- 150 175 255 : The Specialists (Human)
paraHud.COLOR_ALIENFORM = 2;			-- 229 178 85 : Jensen (Alien, Alien Form)
paraHud.COLOR_ALIENHOST = 3;			-- 137 195 62 : Green (Alien Host, Human Form)
paraHud.COLOR_ALIENBROOD = 4;			-- 137 195 140 : Teal (Alien Brood, Human Form)

paraHud.SUPER_COLOR = Color(150, 175, 255, 255);

paraHud.COLOR_THEMES = {};
paraHud.COLOR_THEMES[1] = Color(150, 175, 255, 255);
paraHud.COLOR_THEMES[2] = Color(229, 178, 85, 255);
paraHud.COLOR_THEMES[3] = Color(137, 195, 62, 255);
paraHud.COLOR_THEMES[4] = Color(137, 195, 140, 255);

paraHud.HUD_FONT = "Denton";

paraHud.CurrentColor = paraHud.COLOR_ALIENHOST;
paraHud.ClassText = "Human";
paraHud.HealthBlink = 60;
paraHud.HealthBlinkDirection = false;

paraHud.ScreenWidth = 0;
paraHud.ScreenHeight = 0;
paraHud.ScreenFOV = 0;

-- 15 DEGREES

-- 16:9 FOV90 (2/2/1) 0.4 DIFF
-- 16:9 FOV75 (2.4/2/1)

-- 16:10 FOV90 (2.15/2/1) 0.45 DIFF
-- 16:10 FOV75 (2.6/2/1)

-- 4:3 FOV90 (2.6/2/1) 0.55 DIFF
-- 4:3 FOV75 (3.15/2/1)

surface.CreateFont("arial", 128, 550, true, false, "gab_test1", false, false, 0);
surface.CreateFont(paraHud.HUD_FONT, 32, 550, true, false, "gab_test2", false, false, 0);	-- paraHud1
surface.CreateFont(paraHud.HUD_FONT, 64, 550, true, false, "gab_test3", false, false, 0);	-- paraHud2
surface.CreateFont(paraHud.HUD_FONT, 128, 550, true, false, "gab_test5", false, false, 0);	-- paraHud3
surface.CreateFont("csd", 80, 550, true, false, "gab_test4", false, false, 0);



function GM:HUDPaint()
	--paraHud.Health();
	--paraHud.Need();
	--paraHud.Test3D();

	paraHud.CheckDimensions();
	
	paraHud.SetTheme(2);

	-- Draw 3D Hud
	--cam.Start3D(EyePos(), EyeAngles())
		--paraHud.SuperHud();
	--cam.End3D()
	--paraHud.GetPlayerInfo();
end

function GM:HUDShouldDraw(name)
	local draw = true;

	if(name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo") then
		draw = false;
	end
	
	return draw;
end

function paraHud.CheckDimensions()
	local width = ScrW();
	local height = ScrH();
	local fov = LocalPlayer():GetFOV();
	
	if(paraHud.ScreenWidth ~= width or paraHud.ScreenHeight ~= height or (fov >= 75 and paraHud.ScreenFOV ~= fov)) then
		paraHud.ChangeRatios(width, height, fov);
	end

	return;
end

function paraHud.ChangeRatios(width, height, fov)
	local fovDiff = fov - 75;

	if(width / height == 16 / 9) then
		paraHud.SUPER_SIZE = 0.05 / (2.4 - 0.4 * (fovDiff / 15));
		--print("Changed to 16:9 mode!");
	elseif(width / height == 16 / 10) then
		paraHud.SUPER_SIZE = 0.05 / (2.6 - 0.45 * (fovDiff / 15));
		--print("Changed to 16:10 mode!");
	else
		paraHud.SUPER_SIZE = 0.05 / (3.15 - 0.55 * (fovDiff / 15));
		--print("Changed to 4:3 mode!");
	end

	paraHud.ScreenWidth = width;
	paraHud.ScreenHeight = height;
	paraHud.ScreenFOV = fov;

	return;
end

function paraHud.Health3D(pl, pos, ang, color)
	local health = pl:Health();
	local healthColor = paraHud.HealthColor(health, color);
	
	if(health > 0) then
		cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/4 );
			draw.DrawText(health, "gab_test5", -440*4, 182*4, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		cam.End3D2D();
		
		surface.SetFont("gab_test5");

		cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
			draw.DrawText("/100", "gab_test2", (-440*2)+(surface.GetTextSize(health)/2), 194*2, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
			draw.DrawText(paraHud.ClassText, "gab_test2", -440*2, 212*2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		cam.End3D2D();
	else
		cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/4 );
			draw.DrawText("Fatal", "gab_test5", -440*4, 182*4, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		cam.End3D2D();
		
		surface.SetFont("gab_test5");

		cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
			draw.DrawText("UNKNOWN", "gab_test2", -440*2, 212*2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		cam.End3D2D();
	end

	return;
end

function paraHud.Weapon3D(pl, pos, ang, color)
	local weapon = pl:GetActiveWeapon();

	if(weapon ~= nil) then
		local weaponType = weapon:GetPrintName();
		local weaponMag = weapon:Clip1();
		local weaponAmmo = pl:GetAmmoCount(weapon:GetPrimaryAmmoType());

		if(weaponMag < 0) then
			if(weaponAmmo > 0) then
				-- Basic
				cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/4 );
					draw.DrawText(weaponAmmo, "gab_test5", 440*4, 182*4, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();

				cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
					draw.DrawText(weaponType, "gab_test2", 440*2, 212*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();
			else
				-- Melee
				cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
					draw.DrawText(weaponType, "gab_test2", 440*2, 212*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();
			end
		elseif(weaponAmmo < 1 and weaponMag < 1) then
			-- No Ammo
			cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
				draw.DrawText(weaponType, "gab_test2", 440*2, 212*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();
		else
			-- Full
			cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/2 );
				draw.DrawText("/"..weaponAmmo, "gab_test2", 440*2, 194*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				draw.DrawText(weaponType, "gab_test2", 440*2, 212*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();

			surface.SetFont("gab_test2");
			
			cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/4 );
				draw.DrawText(weaponMag, "gab_test5", (440*4)-(surface.GetTextSize("/"..weaponAmmo)*2), 182*4, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();
		end
	end

	return;
end

function paraHud.Need3D(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/(4*1.1) );
		draw.DrawText("KILL", "gab_test5", -460*4, -257*4, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("gab_test5");

	cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/(2*1.1) );
		draw.DrawText("10x", "gab_test2", (-458*2)+(surface.GetTextSize("PISS")/2), -255*2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
		draw.DrawText("Need", "gab_test2", -460*2, -270*2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();
end

function paraHud.Time3D(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/(4*1.1) );
		draw.DrawText("5:12", "gab_test5", 460*4, -255*4, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("gab_test5");

	cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/(2*1.1) );
		draw.DrawText("Extraction", "gab_test2", 460*2, -270*2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();
end

function paraHud.Inventory3D(pl, pos, ang, color)

	cam.Start3D2D( pos, ang, paraHud.SUPER_SIZE/4 );
		draw.DrawText(os.date( "%a, %I:%M:%S %p" ), "gab_test5", 0, 300*4, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
		draw.DrawText(os.date( "%m/%d/20%y" ), "gab_test5", 0, 325*4, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
		surface.SetDrawColor(paraHud.CurrentColor);

		surface.DrawLine(-200*4, 285*4, 200*4, 285*4); -- Top
		surface.DrawLine(-200*4, 360*4, 200*4, 360*4); -- Bottom
		surface.DrawLine(-200*4, 285*4, -200*4, 360*4); -- Left
		surface.DrawLine(200*4, 285*4, 200*4, 360*4); -- Right
	cam.End3D2D();

	return;
end

function paraHud.SuperHud()
	local pl = LocalPlayer();
	local plAng = EyeAngles();
	local plPos = EyePos();
	local plHealth = pl:Health();

	if(pl:Alive() == false) then
		local rag = pl:GetRagdollEntity();
	
		if ValidEntity(rag) then
			local att = rag:GetAttachment(rag:LookupAttachment("eyes"));
			plAng = rag:EyeAngles();
			--plAng = att.Ang;
			plPos = att.Pos;
		end
	end

	local pos = plPos;
	local centerAng = Angle(plAng.p, plAng.y, 0);

	pos = pos + (centerAng:Forward() * paraHud.SUPER_DISTANCE);

	centerAng:RotateAroundAxis( centerAng:Right(), 90 );
	centerAng:RotateAroundAxis( centerAng:Up(), -90 );

	local leftAng = Angle(centerAng.p, centerAng.y, centerAng.r);
	local rightAng = Angle(centerAng.p, centerAng.y, centerAng.r);

	leftAng:RotateAroundAxis( leftAng:Right(), paraHud.SUPER_ANGLE*-1 );
	rightAng:RotateAroundAxis( rightAng:Right(), paraHud.SUPER_ANGLE );

	local centerAngUp = Angle(plAng.p, plAng.y, 0);

	centerAngUp:RotateAroundAxis( centerAngUp:Right(), 98 );
	centerAngUp:RotateAroundAxis( centerAngUp:Up(), -90 );

	local leftAngUp = Angle(centerAngUp.p, centerAngUp.y, centerAngUp.r);
	local rightAngUp = Angle(centerAngUp.p, centerAngUp.y, centerAngUp.r);

	leftAngUp:RotateAroundAxis( leftAngUp:Right(), paraHud.SUPER_ANGLE*-1 );
	rightAngUp:RotateAroundAxis( rightAngUp:Right(), paraHud.SUPER_ANGLE );
	
	local hudColor = paraHud.COLOR_THEMES[paraHud.CurrentColor];

	if(pl:Alive() == true and plHealth > 0) then
		cam.Start3D(plPos, plAng);
			cam.IgnoreZ(true);
			paraHud.Health3D(pl, pos, leftAng, hudColor);
			paraHud.Weapon3D(pl, pos, rightAng, hudColor);
			paraHud.Need3D(pl, pos, leftAngUp, hudColor);
			paraHud.Time3D(pl, pos, rightAngUp, hudColor);
			--paraHud.Inventory3D(pl, pos, centerAng, paraHud.CurrentColor);
			cam.IgnoreZ(false);
		cam.End3D();
	else
		cam.Start3D(plPos, plAng);
			cam.IgnoreZ(true);
			paraHud.Health3D(pl, pos, leftAng, hudColor);
			--paraHud.Weapon3D(pl, pos, rightAng, hudColor);
			paraHud.Need3D(pl, pos, leftAngUp, hudColor);
			paraHud.Time3D(pl, pos, rightAngUp, hudColor);
			cam.IgnoreZ(false);
		cam.End3D();
	end
end
--hook.Add("PostDrawTranslucentRenderables","HoloHud",paraHud.SuperHud);
--hook.Add("PostDrawOpaqueRenderables","HoloHud2",paraHud.SuperHud);
--hook.Add("PostDrawViewModel","HoloHud",paraHud.SuperHud);

function GM:RenderScreenspaceEffects()
	paraHud.SuperHud();
end

function paraHud.DeathHud()
	local pl = LocalPlayer();
	local rag = pl:GetRagdollEntity();
	local plAng = EyeAngles();
	local plPos = EyePos();
	local plHealth = pl:Health();
	
	if ValidEntity(rag) then
		local att = rag:GetAttachment(rag:LookupAttachment("eyes"));
			
		plAng = att.Ang;
		plPos = att.Pos;
	end

	local pos = plPos;
	local centerAng = Angle(plAng.p, plAng.y, 0);

	pos = pos + (centerAng:Forward() * paraHud.SUPER_DISTANCE);

	centerAng:RotateAroundAxis( centerAng:Right(), 90 );
	centerAng:RotateAroundAxis( centerAng:Up(), -90 );

	local leftAng = Angle(centerAng.p, centerAng.y, centerAng.r);
	local rightAng = Angle(centerAng.p, centerAng.y, centerAng.r);

	leftAng:RotateAroundAxis( leftAng:Right(), paraHud.SUPER_ANGLE*-1 );
	rightAng:RotateAroundAxis( rightAng:Right(), paraHud.SUPER_ANGLE );

	local centerAngUp = Angle(plAng.p, plAng.y, 0);

	centerAngUp:RotateAroundAxis( centerAngUp:Right(), 98 );
	centerAngUp:RotateAroundAxis( centerAngUp:Up(), -90 );

	local leftAngUp = Angle(centerAngUp.p, centerAngUp.y, centerAngUp.r);
	local rightAngUp = Angle(centerAngUp.p, centerAngUp.y, centerAngUp.r);

	leftAngUp:RotateAroundAxis( leftAngUp:Right(), paraHud.SUPER_ANGLE*-1 );
	rightAngUp:RotateAroundAxis( rightAngUp:Right(), paraHud.SUPER_ANGLE );

	local colorRed = ((100-plHealth) / 100 * (255 - paraHud.SUPER_COLOR['r'])) + paraHud.SUPER_COLOR['r'];
	local colorGreen = ((plHealth) / 100 * paraHud.SUPER_COLOR['g'] * 0.45) + paraHud.SUPER_COLOR['g'] * 0.55;
	local colorBlue = ((plHealth) / 100 * paraHud.SUPER_COLOR['b'] * 0.45) + paraHud.SUPER_COLOR['b'] * 0.55;
	
	paraHud.CurrentColor = Color(colorRed, colorGreen, colorBlue, 220);

	cam.Start3D(plPos, plAng);
		cam.IgnoreZ(true);
		paraHud.Health3D(pl, pos, leftAng);
		cam.IgnoreZ(false);
	cam.End3D();
end

function paraHud.HealthColor(health, color)
	local colorRed = ((100-health) / 100 * (255 - color['r'])) + color['r'];
	local colorGreen = ((health) / 100 * color['g'] * 0.80) + color['g'] * 0.20;
	local colorBlue = ((health) / 100 * color['b'] * 0.80) + color['b'] * 0.20;
	
	local alpha = color['a'];
	
	if(health < 20) then
		if(paraHud.HealthBlinkDirection == false) then
			if(paraHud.HealthBlink == 0) then
				paraHud.HealthBlinkDirection = true;
				paraHud.HealthBlink = paraHud.HealthBlink + 1;
			else
				paraHud.HealthBlink = paraHud.HealthBlink - 1;
			end
		else
			if(paraHud.HealthBlink == 200) then
				paraHud.HealthBlinkDirection = false;
				paraHud.HealthBlink = paraHud.HealthBlink - 1;
			else
				paraHud.HealthBlink = paraHud.HealthBlink + 1;
			end
		end
		
		alpha = alpha * math.min(paraHud.HealthBlink / 60, 1.0);
	end
	
	return Color(colorRed, colorGreen, colorBlue, alpha);
end

function paraHud.SetTheme(class)
	if(class == 2) then
		paraHud.ClassText = "Alien Host";
		paraHud.CurrentColor = paraHud.COLOR_ALIENHOST;
	elseif(class == 3) then
		paraHud.ClassText = "Alien Brood";
		paraHud.CurrentColor = paraHud.COLOR_ALIENBROOD;
	elseif(class == 4) then
		paraHud.ClassText = "Alien Grunt";
		paraHud.CurrentColor = paraHud.COLOR_ALIENFORM;
	else
		paraHud.ClassText = "Human";
		paraHud.CurrentColor = paraHud.COLOR_HUMAN;
	end
	
	return;
end
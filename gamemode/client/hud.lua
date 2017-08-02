paraHud = {};

paraHud.SUPER_SIZE = 0.05/2;			-- 3D Hud Scale (Def: 0.05)
paraHud.SUPER_DISTANCE = 25/2;			-- 3D Hud Distance (Def: 25)
paraHud.SUPER_ANGLE = 20;				-- 3D Hud Angle (Def: 20)

paraHud.HUDTEXT1_SIZE = paraHud.SUPER_SIZE/2;
paraHud.HUDTEXT3_SIZE = paraHud.SUPER_SIZE/4;

paraHud.HUDTEXT1_TOPSIZE = paraHud.SUPER_SIZE/2.2;
paraHud.HUDTEXT3_TOPSIZE = paraHud.SUPER_SIZE/4.4;

paraHud.COLOR_HUMAN = 1;				-- 150 175 255 : The Specialists (Human)
paraHud.COLOR_ALIENFORM = 2;			-- 229 178 85 : Jensen (Alien, Alien Form)
paraHud.COLOR_ALIENHOST = 3;			-- 137 195 62 : Green (Alien Host, Human Form)
paraHud.COLOR_ALIENBROOD = 4;			-- 137 195 140 : Teal (Alien Brood, Human Form)

paraHud.COLOR_THEMES = {};
paraHud.COLOR_THEMES[paraHud.COLOR_HUMAN] = Color(150, 175, 255, 255);
paraHud.COLOR_THEMES[paraHud.COLOR_ALIENFORM] = Color(229, 178, 85, 255);
paraHud.COLOR_THEMES[paraHud.COLOR_ALIENHOST] = Color(137, 195, 62, 255);
paraHud.COLOR_THEMES[paraHud.COLOR_ALIENBROOD] = Color(137, 195, 140, 255);

paraHud.HUD_FONT = "Denton";

paraHud.TARGET_PLAYERDIST = 500;
paraHud.TARGET_WEAPONDIST = 50;

paraHud.ShowTime = true;
paraHud.ShowNeed = true;
paraHud.ShowHealth = true;
paraHud.ShowWeapon = true;
paraHud.ShowWinner = false;

paraHud.CurrentColor = paraHud.COLOR_ALIENHOST;
paraHud.ClassText = "Human";
paraHud.TimeTitle = "Extraction";
paraHud.TimeText = "5:12";
paraHud.NeedText = "NONE";
paraHud.NeedAltText = "";
paraHud.WinnerText = "ROUND DRAW";

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

surface.CreateFont("paraHud1", {
	font 		= paraHud.HUD_FONT,
	size 		= 32,
	weight 		= 550,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
});

surface.CreateFont("paraHud2", {
	font 		= paraHud.HUD_FONT,
	size 		= 64,
	weight 		= 550,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
});

surface.CreateFont("paraHud3", {
	font 		= paraHud.HUD_FONT,
	size 		= 128,
	weight 		= 550,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
});

function GM:HUDPaint()
	paraHud.CheckDimensions();
	
	paraNeeds.ShowNeed();
end

function GM:HUDShouldDraw(name)
	local draw = true;

	if(name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo") then
		draw = false;
	end
	
	return draw;
end

function GM:HUDDrawTargetID()
	return false;
end

function GM:RenderScreenspaceEffects()
	local id = LocalPlayer():EntIndex();

	if(paraGame.PlayerInfo[id] ~= nil and ( (paraGame.PlayerInfo[id].alienForm ~= nil and paraGame.PlayerInfo[id].alienForm) or (paraGame.PlayerInfo[id].classType ~= nil and paraGame.PlayerInfo[id].classType == paraClasses.CLASS_ALIENGRUNT) )) then
		paraClasses.AlienVision2();
	end
	
	paraHud.ShowHud();
	
	if(paraGame.PlayerInfo[id] ~= nil and ( (paraGame.PlayerInfo[id].alienForm ~= nil and paraGame.PlayerInfo[id].alienForm) or (paraGame.PlayerInfo[id].classType ~= nil and paraGame.PlayerInfo[id].classType == paraClasses.CLASS_ALIENGRUNT) )) then
		--paraClasses.AlienVision();
	end
	
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
	elseif(width / height == 16 / 10) then
		paraHud.SUPER_SIZE = 0.05 / (2.6 - 0.45 * (fovDiff / 15));
	else
		paraHud.SUPER_SIZE = 0.05 / (3.15 - 0.55 * (fovDiff / 15));
	end
	
	paraHud.HUDTEXT1_SIZE = paraHud.SUPER_SIZE/2;
	paraHud.HUDTEXT3_SIZE = paraHud.SUPER_SIZE/4;

	paraHud.HUDTEXT1_TOPSIZE = paraHud.SUPER_SIZE/2.2;
	paraHud.HUDTEXT3_TOPSIZE = paraHud.SUPER_SIZE/4.4;

	paraHud.ScreenWidth = width;
	paraHud.ScreenHeight = height;
	paraHud.ScreenFOV = fov;

	return;
end

function paraHud.ShowHud()
	local pl = LocalPlayer();

	if(pl:Alive() == true and pl:Health() > 0) then
		paraHud.AliveHud();
	else
		paraHud.DeadHud();
	end
	
	return;
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

-- 3D Hud (Alive)

function paraHud.AliveHud()
	local pl = LocalPlayer();
	local plAng = EyeAngles();
	local plPos = EyePos();
	local plHealth = pl:Health();

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

	cam.Start3D(plPos, plAng);
		cam.IgnoreZ(true);
		--paraHud.TargetAlive(pl, hudColor);
		if(paraHud.ShowHealth) then
			paraHud.HealthAlive(pl, pos, leftAng, hudColor);
		end
		
		if(paraHud.ShowWeapon) then
			paraHud.WeaponAlive(pl, pos, rightAng, hudColor);
		end
		
		if(paraHud.ShowNeed) then
			paraHud.NeedAlive(pl, pos, leftAngUp, hudColor);
		end
		
		if(paraHud.ShowTime) then
			paraHud.TimeAlive(pl, pos, rightAngUp, hudColor);
		end
		
		if(paraHud.ShowWinner) then
			paraHud.WinnerHud(pl, pos, centerAng, hudColor);
		end
		
		paraHud.TargetAlive(pl, pos, centerAng, hudColor);
		
		--paraHud.Inventory3D(pl, pos, centerAng, paraHud.CurrentColor);
		cam.IgnoreZ(false);
	cam.End3D();
	
	return;
end

function paraHud.HealthAlive(pl, pos, ang, color)
	local health = pl:Health();
	local healthColor = paraHud.HealthColor(health, color);
	
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_SIZE );
		-- (-440, 182) * 4
		draw.DrawText(health, "paraHud3", -1760, 728, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
		-- (-440, 194) * 2
		draw.DrawText("/100", "paraHud1", -880 + (surface.GetTextSize(health)/2), 388, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		-- (-440, 212) * 2
		draw.DrawText(paraHud.ClassText, "paraHud1", -880, 424, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
	cam.End3D2D();

	return;
end

function paraHud.WeaponAlive(pl, pos, ang, color)
	local weapon = pl:GetActiveWeapon();

	if(weapon ~= nil and weapon:IsWeapon() == true) then
		local weaponType = weapon:GetPrintName();
		local weaponMag = weapon:Clip1();
		local weaponAmmo = pl:GetAmmoCount(weapon:GetPrimaryAmmoType());
		
		if(weaponMag < 0) then
			if(weaponAmmo > 0) then
				-- Basic
				cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_SIZE );
					-- (440, 182) * 4
					draw.DrawText(weaponAmmo, "paraHud3", 1760, 728, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();

				cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
					-- (440, 212) * 2
					draw.DrawText(weaponType, "paraHud1", 880, 424, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();
			else
				-- Melee
				cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
					-- (440, 212) * 2
					draw.DrawText(weaponType, "paraHud1", 880, 424, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				cam.End3D2D();
			end
		elseif(weaponAmmo < 1 and weaponMag < 1) then
			-- No Ammo
			cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
				-- (440, 212) * 2
				draw.DrawText(weaponType, "paraHud1", 880, 424, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();
		else
			-- Full
			cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
				-- (440, 194) * 2
				draw.DrawText("/"..weaponAmmo, "paraHud1", 880, 388, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
				-- (440, 212) * 2
				draw.DrawText(weaponType, "paraHud1", 880, 424, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();

			surface.SetFont("paraHud1");
			
			cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_SIZE );
				-- (440, 182) * 4
				draw.DrawText(weaponMag, "paraHud3", 1760-(surface.GetTextSize("/"..weaponAmmo)*2), 728, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
			cam.End3D2D();
		end
	end

	return;
end

function paraHud.NeedAlive(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_TOPSIZE );
		-- (-460, -257) * 4
		draw.DrawText(paraHud.NeedText, "paraHud3", -1840, -1028, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_TOPSIZE );
		-- (-458, -255) * 2
		draw.DrawText(paraHud.NeedAltText, "paraHud1", -916+(surface.GetTextSize(paraHud.NeedText)/2), -508, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
		-- (-460, -270) * 2
		draw.DrawText("Need", "paraHud1", -920, -540, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();
	
	return;
end

function paraHud.TimeAlive(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_TOPSIZE );
		-- (460, -255) * 4
		draw.DrawText(paraHud.TimeText, "paraHud3", 1840, -1020, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_TOPSIZE );
		-- (460, -270) * 2
		draw.DrawText(paraHud.TimeTitle, "paraHud1", 920, -540, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();
	
	return;
end

function paraHud.TargetAlive(pl, hudPos, hudAng, color)
	-- TODO make an actual func for this
	if(paraNeeds.NeedStatus == paraNeeds.STATUS_WORKING) then
		cam.Start3D2D( hudPos, hudAng, paraHud.HUDTEXT3_TOPSIZE );
			draw.DrawText("Completing Task", "paraHud3", 0, 200, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
		cam.End3D2D();
	else
		local pos = pl:GetShootPos();
		local ang = pl:GetAimVector();
		local tracedata = {};
		tracedata.start = pos;
		tracedata.endpos = pos + (ang * paraHud.TARGET_WEAPONDIST);
		tracedata.filter = pl;
		local trace = util.TraceLine(tracedata);
		local ent = trace.Entity;
		
		-- TODO better optimize this, being lazy
		if(trace.Hit and trace.HitNonWorld and ent:GetClass() == "groundweapon") then
			-- Weapon Info
			cam.Start3D2D( hudPos, hudAng, paraHud.HUDTEXT3_TOPSIZE );
				draw.DrawText("WEPON", "paraHud3", 0, 200, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
			cam.End3D2D();
			
		else
			tracedata.endpos = pos + (ang * paraHud.TARGET_PLAYERDIST);
			trace = util.TraceLine(tracedata);
			ent = trace.Entity;
			
			if(trace.Hit and trace.HitNonWorld and ent:IsPlayer()) then
				-- Player Info
				local name = "";
				local info = paraGame.PlayerInfo[ent:EntIndex()];
				
				if(info ~= nil and info.name ~= nil and info.alienForm == false) then
					name = info.name;
				end
				
				cam.Start3D2D( hudPos, hudAng, paraHud.HUDTEXT3_TOPSIZE );
					draw.DrawText(name, "paraHud3", 0, 200, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
				cam.End3D2D();
			end
			
		end
	end
	
	return;
end

-- 3D Hud (Dead)

function paraHud.DeadHud()
	local pl = LocalPlayer();
	local rag = pl:GetRagdollEntity();

	if IsEntity(rag) then
		local att = rag:GetAttachment(rag:LookupAttachment("eyes"));
		local plAng = pl:EyeAngles();
		local plPos = pl:EyePos();

		if(att ~= nil) then
			local plAng = rag:EyeAngles();
			local plPos = att.Pos;
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
		
		cam.Start3D(plPos, plAng);
			cam.IgnoreZ(true);
			paraHud.HealthDead(pl, pos, leftAng, hudColor);
			paraHud.WeaponDead(pl, pos, rightAng, hudColor);
			paraHud.NeedDead(pl, pos, leftAngUp, hudColor);
			paraHud.TimeDead(pl, pos, rightAngUp, hudColor);
			
			if(paraHud.ShowWinner) then
				paraHud.WinnerHud(pl, pos, centerAng, hudColor);
			end
			cam.IgnoreZ(false);
		cam.End3D();
	end

	return;
end

function paraHud.HealthDead(pl, pos, ang, color)
	local healthColor = paraHud.HealthColor(0, color);
	
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_SIZE );
		-- (-440, 182) * 4
		draw.DrawText("FATAL", "paraHud3", -1760, 728, healthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
		-- (-440, 212) * 2
		draw.DrawText(paraHud.ClassText, "paraHud1", -880, 424, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
	cam.End3D2D();

	return;
end

function paraHud.WeaponDead(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_SIZE );
		-- (440, 212) * 2
		draw.DrawText("ERROR", "paraHud1", 880, 424, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
	cam.End3D2D();

	return;
end

function paraHud.NeedDead(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_TOPSIZE );
		-- (-460, -257) * 4
		draw.DrawText("NULL", "paraHud3", -1840, -1028, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_TOPSIZE );
		-- (-458, -255) * 2
		draw.DrawText("4:04", "paraHud1", -916+(surface.GetTextSize("NULL")/2), -508, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
		-- (-460, -270) * 2
		draw.DrawText("Need", "paraHud1", -920, -540, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	cam.End3D2D();
end

function paraHud.TimeDead(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_TOPSIZE );
		-- (460, -255) * 4
		draw.DrawText(paraHud.TimeText, "paraHud3", 1840, -1020, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();

	surface.SetFont("paraHud3");

	cam.Start3D2D( pos, ang, paraHud.HUDTEXT1_TOPSIZE );
		-- (460, -270) * 2
		draw.DrawText("Extinction", "paraHud1", 920, -540, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
	cam.End3D2D();
end

-- 3D Hud (Ambigous)
function paraHud.WinnerHud(pl, pos, ang, color)
	cam.Start3D2D( pos, ang, paraHud.HUDTEXT3_TOPSIZE );
		-- (460, -255) * 4
		draw.DrawText(paraHud.WinnerText, "paraHud3", 0, -1000, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
	cam.End3D2D();
	
	return;
end
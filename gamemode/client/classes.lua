local matOutline = CreateMaterial( "BlackOutline", "UnlitGeneric", { [ "$basetexture" ] = "vgui/black" } )

local matOutline2 = CreateMaterial( "RedOutline", "UnlitGeneric", { [ "$basetexture" ] = "vgui/red" } )
local matOutline3 = CreateMaterial( "YellowOutline", "UnlitGeneric", { [ "$basetexture" ] = "vgui/yellow" } )

function paraClasses.AlienVision()	
	local dlight = DynamicLight(LocalPlayer():EntIndex());
	
	if(dlight) then
			dlight.Pos = LocalPlayer():GetShootPos();
			dlight.r = paraClasses.ALIEN_NIGHTVISION_COLOR.r;
			dlight.g = paraClasses.ALIEN_NIGHTVISION_COLOR.g;
			dlight.b = paraClasses.ALIEN_NIGHTVISION_COLOR.b;
			dlight.Brightness = 0.1;
			dlight.Size = 1500;
			dlight.Decay = 1500;
			dlight.DieTime = CurTime() + 0.1;
			dlight.Style = 0;
	end
	
	return;
end

function paraClasses.AlienTracking()
	-- stencil objects
	cam.Start3D(EyePos(), EyeAngles());
	
	render.ClearStencil();
	render.SetStencilEnable(true);
	
	-- General
	render.SetStencilFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilReferenceValue(1);
	
	-- Sketch Outline
	render.SetStencilZFailOperation(STENCILOPERATION_REPLACE);
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE);
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS);
	
	for _, ent in pairs(ents.FindByClass("player")) do
		-- TODO: check distance
		ent:SetModelScale(1.1, 0.0);
		ent:DrawModel();
		ent:SetModelScale(1.0, 0.0);
	end
	
	-- Sketch Center
	render.SetStencilPassOperation(STENCILOPERATION_ZERO);
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS);
	
	for _, ent in pairs(ents.FindByClass("player")) do
		ent:DrawModel();
	end
	
	-- Draw Stencil
	render.SetStencilFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP);
	render.SetStencilPassOperation(STENCILOPERATION_KEEP);
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
	
	-- Outline
	render.SetMaterial(matOutline3);
	render.DrawScreenQuad();
	
	render.SetStencilEnable(false);
	
	cam.End3D();
	
	return;
end

function paraClasses.AlienVision2()
	paraClasses.AlienVision();

	local tab = {}
	tab[ "$pp_colour_addr" ] = 0.0118; -- 3
	tab[ "$pp_colour_addg" ] = 0.0275; -- 7
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_brightness" ] = -0.08;
	tab[ "$pp_colour_contrast" ] = 1.15;
	tab[ "$pp_colour_colour" ] = 1.0;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	
	DrawColorModify(tab);
	
	paraClasses.AlienTracking();
	
	-- Glow Code
	for _, ent in pairs(ents.FindByClass("groundweapon")) do
		cam.Start3D(EyePos(), EyeAngles());
			render.SuppressEngineLighting(true);
			render.SetLightingOrigin(ent:GetPos());
			render.ResetModelLighting(BOX_TOP, 1.0, 1.0, 0.0);
			render.SetColorModulation(1.0, 1.0, 0.0);
			ent:DrawModel();
			render.SuppressEngineLighting(false);
		cam.End3D();
	end
	
	for _, ent in pairs(ents.FindByClass("player")) do
		cam.Start3D(EyePos(), EyeAngles());
			render.SuppressEngineLighting(true);
			render.SetLightingOrigin(ent:GetPos());
			render.ResetModelLighting(BOX_TOP, 1.0, 1.0, 0.0);
			render.SetColorModulation(1.0, 1.0, 0.0);
			ent:DrawModel();
			render.SuppressEngineLighting(false);
		cam.End3D();
	end
	
	return;
end
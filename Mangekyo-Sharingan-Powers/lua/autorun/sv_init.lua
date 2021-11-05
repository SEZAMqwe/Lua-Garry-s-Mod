if SERVER then
	
	local files = file.Find( 'server/*.lua', 'LUA' )
	table.foreach( files, function( key, gui )
		include( 'server/' .. gui )
	end )
	
	local files = file.Find( 'client/*.lua', 'LUA' )
	table.foreach( files, function( key, gui )
		AddCSLuaFile( 'client/' .. gui )
	end )
	
end
	
	
if CLIENT then

	local files = file.Find( 'client/*.lua', 'LUA' )
	table.foreach( files, function( key, gui )
		include( 'client/' .. gui )
	end )
	
end

local function Amat(plr,user)
	local OurEnt = plr
	local part = EffectData()
	if OurEnt ~= NULL then
		part:SetStart(OurEnt:GetPos() + Vector(0,0,70))
	
		part:SetOrigin(OurEnt:GetPos() + Vector(0,0,30))
		
		part:SetEntity(OurEnt)
		part:SetScale(1)
	
		util.Effect("Amaterasu", part)
	end
	if (plr:GetVar("Susanoo")~=true) && (IsValid(plr)) && (plr~=NULL) && (SERVER) then
		plr:TakeDamage(1,user)
	end
end
hook.Add("Amaterasu","Effect", Amat)

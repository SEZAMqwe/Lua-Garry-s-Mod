SWEP.PrintName			= "Mangekyo itachi"
SWEP.Author			= "VimeR"
SWEP.Instructions		= ""
SWEP.Category = "uchih eyes"

SWEP.Spawnable = true
SWEP.AdminOnly = false


SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"



SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 2
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true


SWEP.HoldType = "normal"
SWEP.UseHands = true	
SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_arms.mdl"



function SWEP:Amat(target)
	hook.Run("Amaterasu",target,self.Owner)
end

function SWEP:PrimaryAttack()
	local target=self.Owner:GetEyeTrace().Entity
	if(target:IsWorld()) then
	 

	else
		self:Amat(target,self.Owner)
        if self.Owner:GetVar("amaterasuS") == false then
			self.Owner:SetVar("amaterasuS",true)
			sound.Play("amaterasu_itachi", self.Owner:GetPos())
		end
	end
end


function SWEP:Reload()

end

if (CLIENT) then 
	net.Receive( "PrintMessage", function() 
		local user = net.ReadEntity()
		if user:GetVar("tsukuyomi") != true then
			chat.AddText( Color( 250, 250, 250), 'Итачи: Я все таки смог погрузить ', Color( 250, 250, 250), user:Nick(), ' в цукуёми' )
		end
	end) 

	net.Receive( "end_tsukuyomi", function()
		local user = net.ReadEntity() 
		chat.AddText( Color( 250, 250, 250), 'Итачи: ', Color( 250, 250, 250), user:Nick(), ' покинул цукуёми' )
	end)

	net.Receive( "f_tsukuyomi", function() 
		local user = net.ReadEntity()
		chat.AddText( Color( 250, 250, 250), 'Итачи: ', Color( 250, 250, 250), user:Nick(), ' уже находится в цукуёми' )
	end)
end

function SWEP:SecondaryAttack()
	if (SERVER) then
		local goal = self.Owner:GetEyeTrace().Entity
		if goal:IsWorld() != true then
			if goal:IsPlayer() == true then
				self:SetNextSecondaryFire( CurTime() + 6 )
				if goal:GetVar("tsukuyomi") != true then
					sound.Play("start_tsukuyomi", self.Owner:GetPos()) 
					net.Start( 'net.tsukuyomi' )
						net.WriteEntity(self.Owner)
					net.Send(goal)
					-----------------------------------------
					net.Start( 'PrintMessage' )
						net.WriteEntity(goal)
					net.Send(self.Owner)
					goal:SetVar("tsukuyomi",true)
					-- self.Owner:SetHealth(self.Owner:Health() - 40)
					-- if self.Owner:Health() < 0 then
					-- 	self.Owner:Kill()
					-- end
				else
					net.Start( 'f_tsukuyomi' )
						net.WriteEntity(goal)
					net.Send(self.Owner)
				end
			end	
		else 

		end
		self.Owner:SetVar("amaterasuS",false)
		net.Receive( "net.setPos", function() 
			local ply = net.ReadEntity()
			local Pos = net.ReadVector()
			local activeweapon = 'none'
				if ply:Alive() == false then
					ply:Spawn()
					ply:SelectWeapon( activeweapon )
					sound.Play("end_tsukuyomi", self.Owner:GetPos()) 
					ply:SetPos(Pos)
					local Health = ply:Health() / 2
					ply:SetHealth( Health ) 
					net.Start( 'end_tsukuyomi' )
						net.WriteEntity(ply)
					net.Send(self.Owner)
				else
					ply:SelectWeapon( activeweapon )
					sound.Play("end_tsukuyomi", self.Owner:GetPos()) 
					local Health = ply:Health() / 2
					ply:SetHealth( Health ) 
					ply:SetPos(Pos)
					net.Start( 'end_tsukuyomi' )
						net.WriteEntity(ply)
					net.Send(self.Owner)
				end
		end )
	end
end


function SWEP:OnRemove()
	
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )		 -- Анимации держания оружия от третьего лица.
	if CLIENT then 
		self.Owner:SetVar("Susanoo_i",false)
		self.Owner:SetVar("SusanooEntity_i",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
end

function SWEP:Think()
	if (SERVER) then
		util.AddNetworkString( 'net.tsukuyomi' )
		util.AddNetworkString( 'net.setPos' )
		util.AddNetworkString( 'PrintMessage' )
		util.AddNetworkString( 'f_tsukuyomi' )
		util.AddNetworkString( 'end_tsukuyomi' )
		for k, f in pairs( ents.FindInSphere( v:GetPos(), 70 ) ) do
			if f:IsPlayer() == true then
				if f:GetVar("tsukuyomi") == false then
					net.Start( 'end_tsukuyomi' )
						net.WriteEntity(f)
					net.Send(self.Owner)
				end
			end
		end
		
		
        local v = self.Owner
		if v:Alive() == true then
			if v:GetVar("Susanoo_i") == true then
				if v:GetVar("SusanooEntity_i") != nil then
					v:GetVar("SusanooEntity_i"):SetPos( v:GetPos() + Vector(-20, -27, 0) )
				end
			end
			if v:KeyPressed( IN_RELOAD ) then
				if v:GetVar("Susanoo_i") == true then
					v:SetVar("Susanoo_i",false)
					v:GetVar("SusanooEntity_i"):Remove()
				end
				if v:GetVar("Susanoo_i") == false then
					if IsValid(v:GetVar("SusanooEntity_i")) != true then
						v:SetVar("Health_do_susanoo_i",v:Health())
						sound.Play("sasukesusanoo", v:GetPos())
						local ribs_i = ents.Create("prop_dynamic") 
						ribs_i:SetModel("models/props_phx/construct/metal_wire_angle180x2.mdl")
						ribs_i:SetPos( v:GetPos() + Vector(-20, 0, 0) )
						ribs_i:Spawn()
						ribs_i:SetColor(Color( 220, 0, 255, 208))
						v:SetHealth(v:Health() * 8.5)
						v:SetVar("Susanoo_i",true)
						v:SetVar("SusanooEntity_i",ribs_i)
						v:GetVar("SusanooEntity_i"):SetColor(Color( 255, 165, 0, 10))
						v:GetVar("SusanooEntity_i"):SetMaterial("models/debug/debugwhite")
					else
						v:GetVar("SusanooEntity_i"):Remove()
						v:SetHealth(v:GetVar("Health_do_susanoo_i"))
						v:SetVar("SusanooEntity_i",nil)
						-- v:SetHealth(v:GetMaxHealth() - 15 )
					end
					v:SetVar("amaterasuS",false)
				end
			end
		end
	end
end



function SWEP:Holster( wep )
	if SERVER then
		local Owner = self.Owner
		if Owner:Alive() == true then
			if Owner:GetVar("Susanoo_i") == true then
				Owner:SetVar("Susanoo_i",false)
				local ent = Owner:GetVar("SusanooEntity_i")
				ent:Remove()
				Owner:SetHealth(Owner:GetVar("Health_do_susanoo_i"))
				Owner:SetVar("SusanooEntity_i",nil)
			end
		else
			if Owner:GetVar("SusanooEntity_i") != nil then
				local ent = Owner:GetVar("SusanooEntity_i")
				ent:Remove()
				Owner:SetVar("SusanooEntity_i",nil)

			end
		end
		self.Owner:SetVar("amaterasuS",false)
	end
	return true
end



function SWEP:Deploy()
	sound.Add( {
		name = "amaterasu_itachi",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/mangekyo/amaterasu_itachi.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "end_tsukuyomi",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/tsukuyomi/end_of_tsukuyomi.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "start_tsukuyomi",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/tsukuyomi/start_of_tsukuyomi.wav"
	} )
	---------------------------------------------------------------------------------------------

	if SERVER then 
		self.Owner:SetVar("Susanoo_i",false)
		self.Owner:SetVar("SusanooEntity_i",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
	self:SetWeaponHoldType( self.HoldType )
    return
end

function SWEP:Equip(Var)
    if SERVER then 
		Var:SetVar("Susanoo_i",false)
		Var:SetVar("SusanooEntity_i",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
end
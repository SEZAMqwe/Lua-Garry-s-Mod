SWEP.PrintName			= "Mangekyo Sharingan / rinnegan sasuke"
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

SWEP.Slot			= 4
SWEP.SlotPos			= 5
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
			sound.Play("amaterasu", self.Owner:GetPos())
			self.Owner:SetVar("amaterasuS",true)
		end
	end
end


function SWEP:Reload()

end



function SWEP:SecondaryAttack()
	if (SERVER) then
		local goal=self.Owner:GetEyeTrace().Entity
		if goal:IsWorld() != true then
			self:SetNextSecondaryFire( CurTime() + 5 )
			local OwnerAng = self.Owner:GetAngles()
			local OwnerPos = self.Owner:GetPos()
			
			local goalAng = goal:GetAngles()
			local goalPos = goal:GetPos()
			if goal:IsPlayer() != true then
				sound.Play("amenotecicara", self.Owner:GetPos())
				self.Owner:SetPos(goalPos + Vector(0, 0, 6))
				-- self.Owner:SetAngles(goalAng)
				
				goal:SetPos(OwnerPos + Vector(0, 0, 6))
				goal:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, goal:GetPhysicsObject():GetMass() * -9.80665 ) )
			else
				sound.Play("amenotecicara", self.Owner:GetPos())
				self.Owner:SetPos(goalPos + Vector(0, 0, 6))
				-- self.Owner:SetEyeAngles(goalAng)
				
				goal:SetPos(OwnerPos + Vector(0, 0, 6))
				goal:SetEyeAngles(OwnerAng)
			end
		end
		self.Owner:SetVar("amaterasuS",false)
	end

end

function SWEP:OnRemove()

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )		 -- Анимации держания оружия от третьего лица.
	if CLIENT then 
		self.Owner:SetVar("Susanoo_S",false)
		self.Owner:SetVar("susanooEntity_S",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
end

function SWEP:Think()
	if (SERVER) then
		local v = self.Owner
		if v:Alive() == true then
			if v:GetVar("Susanoo_S") == true then
				if v:GetVar("susanooEntity_S") != nil then
					v:GetVar("susanooEntity_S"):SetPos( v:GetPos() + Vector(-20, -27, 0) )
				end
			end
			if IsValid(v) != nil then
					if v:KeyPressed( IN_RELOAD ) then
						if v:GetVar("Susanoo_S") == true then
							v:SetVar("Susanoo_S",false)
							hook.Remove('Think', 'ribs_S')
							v:GetVar("susanooEntity_S"):Remove()
						end
						if v:GetVar("Susanoo_S") == false then
							if IsValid(v:GetVar("susanooEntity_S")) != true then
								v:SetVar("Health_do_susanoo_s",v:Health())
								sound.Play("sasukesusanoo", v:GetPos())
								local ribs_s = ents.Create("prop_dynamic") 
								ribs_s:SetModel("models/props_phx/construct/metal_wire_angle180x2.mdl")
								ribs_s:SetPos( v:GetPos() + Vector(-20, 0, 0) )
								ribs_s:Spawn()
								ribs_s:SetColor(Color( 220, 0, 255, 208))
								v:SetHealth(v:Health() * 6.5)
								v:SetVar("Susanoo_S",true)
								v:SetVar("susanooEntity_S",ribs_s)
								v:GetVar("susanooEntity_S"):SetColor(Color( 220, 0, 255, 10))
								v:GetVar("susanooEntity_S"):SetMaterial("models/debug/debugwhite")
							else
								v:GetVar("susanooEntity_S"):Remove()
								v:SetVar("susanooEntity_S",nil)
								v:SetHealth( v:GetVar("Health_do_susanoo_s") )
							end
						end
					end
			end
		end
	end
end



function SWEP:Holster( wep )
	if SERVER then
		local Owner = self.Owner
		if Owner:Alive() == true then
			if Owner:GetVar("Susanoo_S") == true then
				Owner:SetVar("Susanoo_S",false)
				local ent = Owner:GetVar("susanooEntity_S")
				ent:Remove()
				Owner:SetHealth(Owner:GetVar("Health_do_susanoo_s"))
				Owner:SetVar("susanooEntity_S",nil)
			end
		else
			if Owner:GetVar("susanooEntity_S") != nil then
				local ent = Owner:GetVar("susanooEntity_S")
				ent:Remove()
				Owner:SetVar("susanooEntity_S",nil)
			end
		end
		self.Owner:SetVar("amaterasuS",false)
	end
	return true
end



function SWEP:Deploy()
	sound.Add( {
		name = "amaterasu",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/mangekyo/amaterasu.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "amenotecicara",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/rinnegan/sasuke_rinnegan_sound.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "sasukesusanoo",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/mangekyo/sasuke_susanoo.wav"
	} )
    ---------------------------------------------------------------------------------------------
	if SERVER then 
		self.Owner:SetVar("Susanoo_S",false)
		self.Owner:SetVar("susanooEntity_S",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
	self:SetWeaponHoldType( self.HoldType )
    return
end

function SWEP:Equip(Var)
    if SERVER then 
		Var:SetVar("Susanoo_S",false)
		Var:SetVar("susanooEntity_S",nil)
		self.Owner:SetVar("amaterasuS",false)
    end
end

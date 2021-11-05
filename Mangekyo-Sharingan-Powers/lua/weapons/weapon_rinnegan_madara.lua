SWEP.PrintName			= "Rinnegan madara"
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

SWEP.Slot			= 3
SWEP.SlotPos			= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true


SWEP.HoldType = "normal"
SWEP.UseHands = true	
SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_arms.mdl"


function SWEP:PrimaryAttack()
	if (SERVER) then
		local v = self.Owner
		local target=v:GetEyeTrace().Entity
		if v:GetVar("metr_nu") == 1 then
			v:SetVar("metr_nu",2)
			local metr2 = ents.Create("prop_physics") 
			metr2:SetModel("models/hunter/misc/sphere375x375.mdl")
			if target:IsWorld() == true then
				local target_world = v:GetEyeTrace().HitPos
				metr2:SetPos( target_world + Vector(0, 0, 800) )
			else
				metr2:SetPos( target:GetPos() + Vector(0, 0, 700) )
			end
			metr2:Spawn()
			metr2:SetMaterial("models/props_pipes/GutterMetal01a")
			v:SetVar("metr_e_m_2",metr2)
			timer.Simple( 20, function()
				if v:GetVar("metr_e_m_1") != nil then
					v:GetVar("metr_e_m_1"):Remove()
				end
				if v:GetVar("metr_e_m_2") != nil then
					v:GetVar("metr_e_m_2"):Remove()
				end
				v:SetVar("metr_nu",0)
				v:SetVar("metr_e_m_1",nil)
				v:SetVar("metr_e_m_2",nil)
			end)
		end
		if v:GetVar("metr_nu") == 0 then
			sound.Play("chibaku_tensei", v:GetPos())
			v:SetVar("genjutsu_cd", true  )
			v:SetVar("limbo_cd", true  )
			local metr1 = ents.Create("prop_physics") 
			metr1:SetModel("models/hunter/misc/sphere375x375.mdl")
			if target:IsWorld() == true then
				local target_world = v:GetEyeTrace().HitPos
				metr1:SetPos( target_world + Vector(0, 0, 800) )
			else
				metr1:SetPos( target:GetPos() + Vector(0, 0, 700) )
			end
			metr1:Spawn()
			metr1:SetMaterial("models/props_pipes/GutterMetal01a")
			v:SetVar("metr_e_m_1",metr1)
			v:SetVar("metr_nu",3)
			timer.Simple( 5, function()
				v:SetVar("metr_nu",1)
			end)
		end
	end
end


function SWEP:Reload()
	if (SERVER) then
		
	end
end



function SWEP:SecondaryAttack()
	if (SERVER) then
		if self.Owner:GetVar("limbo") == false  then
			local ent = self.Owner:GetEyeTrace().Entity
			if ent:IsPlayer() == true then
				if self.Owner:GetVar('limbo_cd') == true then
					sound.Play("limbo_hengoku", self.Owner:GetPos())
					self.Owner:SetVar("limbo_cd", false  )
				end
				ent:SetHealth(ent:Health() - math.random( 18, 25, 27, 50 ))
				self.Owner:SetVar("limbo",true )
				if ent:Health() < 0 then
                    ent:Kill()
				end
				timer.Simple( 2, function()
					self.Owner:SetVar("limbo",false )
				end)
			end
			self.Owner:SetVar("genjutsu_cd", true  )
		end
	end
end


function SWEP:OnRemove()
	
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )		 -- Анимации держания оружия от третьего лица.
	if CLIENT then 
		self.Owner:SetVar("Susanoo_m",false)
		self.Owner:SetVar("SusanooEntity_m",nil)
		self.Owner:SetVar("metr_e_m_1",nil)
		self.Owner:SetVar("metr_e_m_2",nil)
		self.Owner:SetVar("metr_m",false)
		self.Owner:SetVar("limbo",false)
		self.Owner:SetVar("genjutsu_cd", true  )
		self.Owner:SetVar("limbo_cd", true  )
    end
end

function SWEP:Think()
	if (SERVER) then
		local v = self.Owner
		for i, f in ipairs( player.GetAll() ) do
			if f:GetVar("genjutsu_m") == true then
				if f:Alive() == true then
					f:Freeze( true )
				else
					f:Freeze( false  )
					f:SetVar("genjutsu_m", false )
				end
			else
			end
			if f:GetVar("genjutsu_m") == false then
				f:Freeze( false )
			end
		end
		if v:Alive() == true then
			if v:GetVar("Susanoo_m") == true then
				if v:GetVar("SusanooEntity_m") != nil then
					v:GetVar("SusanooEntity_m"):SetPos( v:GetPos() + Vector(-20, -27, 0) )
				end
			end
			if v:KeyPressed( IN_USE ) then
				local ent = v:GetEyeTrace().Entity
				if ent:IsPlayer() == true then
					if v:GetPos():Distance(ent:GetPos()) < 500 then
						if ent:GetVar("genjutsu_m") != true then
							ent:SetVar("genjutsu_m", true )
							timer.Simple( 20, function()
								ent:SetVar("genjutsu_m", false  )
							end)
							if v:GetVar('genjutsu_cd') == true then
								sound.Play("genjutsu", v:GetPos())
								v:SetVar("genjutsu_cd", false  )
							end
						end
					end
				end
			end
			local v = self.Owner
			if v:KeyPressed( IN_RELOAD ) then
				if v:GetVar("Susanoo_m") == true then
					v:SetVar("Susanoo_m",false)
					v:GetVar("SusanooEntity_m"):Remove()
				end
				if v:GetVar("Susanoo_m") == false then
					if IsValid(v:GetVar("SusanooEntity_m")) != true then
						v:SetVar("Health_do_susanoo_m",v:Health())
						sound.Play("sasukesusanoo", v:GetPos())
						local ribs_m = ents.Create("prop_dynamic") 
						ribs_m:SetModel("models/props_phx/construct/metal_wire_angle180x2.mdl")
						ribs_m:SetPos( v:GetPos() + Vector(-20, 0, 0) )
						ribs_m:Spawn()
						ribs_m:SetColor(Color( 220, 0, 255, 208))
						v:SetHealth(v:Health() * 6.8)
						v:SetVar("Susanoo_m",true)
						v:SetVar("SusanooEntity_m",ribs_m)
						v:GetVar("SusanooEntity_m"):SetColor(Color( 0, 26, 255, 208))
						v:GetVar("SusanooEntity_m"):SetMaterial("models/debug/debugwhite")
					else
						v:GetVar("SusanooEntity_m"):Remove()
						v:SetVar("SusanooEntity_m",nil)
						v:SetHealth(v:GetVar("Health_do_susanoo_m"))
					end
				end
				v:SetVar("genjutsu_cd", true  )
				v:SetVar("limbo_cd", true  )
			end
		end
	end
end



function SWEP:Holster( wep )
	if SERVER then
		local Owner = self.Owner
		if Owner:Alive() == true then
			if Owner:GetVar("Susanoo_m") == true then
				Owner:SetVar("Susanoo_m",false)
				local ent = Owner:GetVar("SusanooEntity_m")
				ent:Remove()
				Owner:SetHealth(Owner:GetVar("Health_do_susanoo_m"))
				Owner:SetVar("SusanooEntity_m",nil)
			end
		else
			if Owner:GetVar("SusanooEntity_m") != nil then
				local ent = Owner:GetVar("SusanooEntity_m")
				ent:Remove()
				Owner:SetVar("SusanooEntity_m",nil)
			end
		end
		self.Owner:SetVar("metr_m",false)
		self.Owner:SetVar("limbo",false)
		self.Owner:SetVar("genjutsu_cd", true  )
		self.Owner:SetVar("limbo_cd", true  )
	end
	return true
end

function SWEP:Deploy()
	sound.Add( {
		name = "chibaku_tensei",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/rinnegan/chibaku_tensei.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "genjutsu",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/rinnegan/genjutsu.wav"
	} )
	---------------------------------------------------------------------------------------------
	sound.Add( {
		name = "limbo_hengoku",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/rinnegan/limbo_hengoku.wav"
	} )
	---------------------------------------------------------------------------------------------
	if SERVER then 
		self.Owner:SetVar("Susanoo_m",false)
		self.Owner:SetVar("SusanooEntity_m",nil)
		self.Owner:SetVar("metr_m",false)
		self.Owner:SetVar("metr_nu",0)
		self.Owner:SetVar("limbo",false)
		self.Owner:SetVar("genjutsu_cd", true  )
		self.Owner:SetVar("limbo_cd", true  )
    end
	self:SetWeaponHoldType( self.HoldType )
    return
end

function SWEP:Equip(Var)
    if SERVER then 
		Var:SetVar("Susanoo_m",false)
		Var:SetVar("SusanooEntity_m",nil)
		Var:SetVar("metr_nu",0)
		Var:SetVar("metr_m",false)
		Var:SetVar("limbo",false)
		Var:SetVar("genjutsu_cd", true  )
		Var:SetVar("limbo_cd", true  )
    end
end
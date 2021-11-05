SWEP.PrintName			= "Mangekyo / obito_kakashi"
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

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true


SWEP.HoldType = "normal"
SWEP.UseHands = true	
SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_arms.mdl"

local cd_PrimaryAttack = 5
local cd_SecondaryFire = 5
local imer = 6 + 1 
local imer_tp = 15 + 1
function SWEP:PrimaryAttack()
	if (SERVER) then	
		self.Owner:SetVar("camui_pass",true)
		local target=self.Owner:GetEyeTrace().Entity
		self.target = target
		self:SetNextPrimaryFire( CurTime() + cd_PrimaryAttack )
	end
end


function SWEP:Reload()

end

function SWEP:SecondaryAttack()
	if (SERVER) then	
		local Pos = self.Owner:GetEyeTrace().HitPos
		sound.Play("Obito_kamui", self.Owner:GetPos())
		sound.Play("Obito_kamui", Pos)
		self.Owner:SetPos(Pos)
		self:SetNextSecondaryFire( CurTime() + cd_SecondaryFire )
	end
end

function SWEP:OnRemove()

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )		 -- Анимации держания оружия от третьего лица.
	if CLIENT then 
		self.Owner:SetVar("Susanoo_O",false)
		self.Owner:SetVar("susanooEntity_O",nil)
    end
end

function SWEP:Think()
	if (SERVER) then
		util.AddNetworkString( 'Kamui_measurements' )
		if self.Owner:GetVar("camui_pass") == true then
			if timer.Exists( 'camui_timer' ) == false then
				if self.Owner:GetEyeTrace().Entity:IsPlayer() == true then
					if self.Owner:GetEyeTrace().Entity == self.target then
						self.Owner:EmitSound("kakashi_kamui")
						self.target:EmitSound("kakashi_kamui")
						self.kamui_ball = ents.Create("prop_dynamic") 
						self.kamui_ball:SetModel("models/props_phx/construct/metal_wire_angle180x2.mdl")
						self.kamui_ball:SetPos( self.Owner:GetPos() + Vector(0, 0, -500) )
						self.kamui_ball:Spawn()
						self.kamui_ball:SetColor(Color( 0, 0, 0))
						self.kamui_ball:SetMaterial("models/debug/debugwhite") 
						timer.Create( "camui_timer", 1, imer, function()
							if self.target:IsPlayer() == true then
								if self.Owner:GetEyeTrace().Entity == self.target then
									self.kamui_ball:SetPos( self.target:GetPos() + Vector(0, 0, 30) )
									self.target:SetHealth(self.target:Health() - math.random( 3, 4, 7, 20 ) )
									if self.target:Health() < 0 then
										self.target:Kill()
									end
									if self.target:Alive() == true then
										if timer.RepsLeft( "camui_timer" ) == 0 then
											self.Owner:SetVar("camui_pass",false)
											self.target.Pos = self.target:GetPos()
											self.target:SetPos(self.target:GetPos() + Vector(0, 0, -500))
											net.Start( 'Kamui_measurements' )
												net.WriteEntity(ply)
											net.Send(self.target)
											timer.Create( "camui_timer_tp", 1, imer_tp, function() 
												if timer.RepsLeft( "camui_timer_tp" ) == 0 then
													self.kamui_ball:Remove()
													local hoo = 'hook.Remove( "HUDPaint", "HUDPaint_DrawBox" )'
													self.target:SendLua( hoo )
													self.target:SetPos(self.target.Pos)
													self.target:SetHealth( self.target:Health() / 2 )
												end
											end)
										end
									end
								else
									self.kamui_ball:Remove()
									timer.Remove( "camui_timer" )
								end
							else
								if self.Owner:GetEyeTrace().Entity == self.target then
									self.kamui_ball:SetPos( self.target:GetPos() + Vector(0, 0, 30) )
									if timer.RepsLeft( "camui_timer" ) == 0 then
										self.Owner:SetVar("camui_pass",false)
										self.target.Pos = self.target:GetPos()
										self.target:SetPos(self.target:GetPos() + Vector(0, 0, -500))
										timer.Create( "camui_timer_tp", 1, imer_tp, function() 
											if timer.RepsLeft( "camui_timer_tp" ) == 0 then
												self.kamui_ball:Remove()
												self.target:SetPos(self.target.Pos)
											end
										end)
									end
								else
									self.kamui_ball:Remove()
									timer.Remove( "camui_timer" )
								end
							end
						end)
					end
				else
					timer.Create( "camui_timer", 1, imer, function() 
						if self.Owner:GetEyeTrace().Entity == self.target then
							if timer.RepsLeft( "camui_timer" ) == 0 then
								self.target.Pos = self.target:GetPos()
								self.target:SetPos(self.target:GetPos() + Vector(0, 0, -500))
								timer.Create( "camui_timer_tp", 1, imer_tp, function() 
									if timer.RepsLeft( "camui_timer_tp" ) == 0 then
										if timer.RepsLeft( "camui_timer_tp" ) == 0 then
											self.target:SetPos(self.target.Pos)
										end
									end
								end)
							end
						else
							timer.Remove( "camui_timer" )
						end
					end)
					self.Owner:SetVar("camui_pass",true)
				end
			end 
		end
	end
	if (SERVER) then
		local v = self.Owner
		if IsValid() != nil then
			if v:GetVar("Susanoo_O") == true then
				if v:GetVar("susanooEntity_O") != nil then
					v:GetVar("susanooEntity_O"):SetPos( v:GetPos() + Vector(-20, -27, 0) )
				end
			end
			if v:KeyPressed( IN_RELOAD ) then
				if v:GetVar("Susanoo_O") == true then
					v:SetVar("Susanoo_O",false)
					hook.Remove('Think', 'ribs_O')
					v:GetVar("susanooEntity_O"):Remove()
				end
				if v:GetVar("Susanoo_O") == false then
					if IsValid(v:GetVar("susanooEntity_O")) != true then
						v:SetVar("Health_do_susanoo_O",v:Health())
						sound.Play("sasukesusanoo", v:GetPos())
						local ribs_O = ents.Create("prop_dynamic") 
						ribs_O:SetModel("models/props_phx/construct/metal_wire_angle180x2.mdl")
						ribs_O:SetPos( v:GetPos() + Vector(-20, 0, 0) )
						ribs_O:Spawn()
						ribs_O:SetColor(Color( 220, 0, 255, 208))
						v:SetHealth(v:Health() * 5.5)
						v:SetVar("Susanoo_O",true)
						v:SetVar("susanooEntity_O",ribs_O)
						v:GetVar("susanooEntity_O"):SetColor(Color( 0, 153, 255))
						v:GetVar("susanooEntity_O"):SetMaterial("models/debug/debugwhite")
					else
						v:GetVar("susanooEntity_O"):Remove()
						hook.Remove('Think', 'ribs_O')
						v:SetVar("susanooEntity_O",nil)
						v:SetHealth(v:GetVar("Health_do_susanoo_O"))
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
			if Owner:GetVar("Susanoo_O") == true then
				Owner:SetVar("Susanoo_O",false)
				local ent = Owner:GetVar("susanooEntity_O")
				ent:Remove()
				Owner:SetHealth(Owner:GetVar("Health_do_susanoo_O"))
				Owner:SetVar("susanooEntity_O",nil)
			end
		else
			if Owner:GetVar("susanooEntity_O") != nil then
				local ent = Owner:GetVar("susanooEntity_O")
				ent:Remove()
				Owner:SetVar("susanooEntity_O",nil)
			end
		end
		if self.Owner:GetVar("camui_pass") == true then
			self.kamui_ball:Remove()
		end
	end
	return true
end

function SWEP:Deploy()
	sound.Add( {
		name = "Obito_kamui",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/mangekyo/Obito_kamui.wav"
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
	sound.Add( {
		name = "kakashi_kamui",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "staticvoid/mangekyo/kakashi_kamui.wav"
	} )
	if SERVER then 
		self.Owner:SetVar("Susanoo_O",false)
		self.Owner:SetVar("susanooEntity_O",nil)
    end
	self:SetWeaponHoldType( self.HoldType )
    return
end

function SWEP:Equip(Var)
    if SERVER then 
		Var:SetVar("Susanoo_O",false)
		Var:SetVar("susanooEntity_O",nil)
    end
end

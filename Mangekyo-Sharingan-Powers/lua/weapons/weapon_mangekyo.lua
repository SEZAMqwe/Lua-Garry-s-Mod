SWEP.PrintName			= "Mangekyo Sharingan sasuke"
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


function SWEP:Amat(target)
	hook.Run("Amaterasu",target,self.Owner)
end

function SWEP:PrimaryAttack()
	

	local target=self.Owner:GetEyeTrace().Entity
	
	print(self.Owner:GetPos())
	if(target:IsWorld()) then
	 
		Msg("Entity is the World!\n");

	else
		self:Amat(target,self.Owner)
		print(target)
		--sound.Play("amaterasu", self.Owner:GetPos())
	end
	
	
end


function SWEP:Reload()
	if ( SERVER ) then
	    self.Owner:SetModelScale( self.Owner:GetModelScale() * 1.25, 1 )
    end
end


function SWEP:SecondaryAttack()
	self.Owner:SetLegacyTransform( true )
end



function SWEP:OnRemove()

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )		 -- Анимации держания оружия от третьего лица.
end

function SWEP:Think()

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
    sound.Play("amaterasu", self.Owner:GetPos())
    self:SetWeaponHoldType( self.HoldType )	
end


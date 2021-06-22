AddCSLuaFile()

ENT.PrintName		= 'Shuffle Shield'
ENT.Base			= 'base_gmodentity'
ENT.Type			= 'anim'
ENT.Model			= 'models/hunter/misc/sphere2x2.mdl'
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT
ENT.RechargeTime	= 150									-- Recharge time, in seconds
ENT.Spawnable		= false


local wepoffset = Vector(0,0,36)







if SERVER then

	function ENT:Initialize(owner)
		if !IsValid(owner) then return end
		local owwep = owner:GetWeapon('weapon_shield_activator')
		if !IsValid(owwep) then return end
		self:SetModel(self.Model)
		--self:PhysicsInitSphere(self.Radius,'no_decal')
		--self:PhysicsInit(SOLID_NONE)
		--self:SetModelScale(self.Radius/48)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:PhysWake()
		self:Activate()
		self:AddEffects(EF_NOSHADOW)
		self:SetShieldOwner(owner)
		owner:SetNWEntity('CShield',self)
		self:SetOwner(owner)
		self:SetPos(owner:GetPos()+wepoffset)
		self:SetParent(owwep)
		self:ToggleShield(true)
	end


	function ENT:Think()
	end

end


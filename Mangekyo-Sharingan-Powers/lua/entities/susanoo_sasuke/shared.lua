AddCSLuaFile()

ENT.PrintName		= 'Shuffle Shield'
ENT.Base			= 'base_gmodentity'
ENT.Type			= 'anim'
ENT.Model			= 'models/hunter/misc/sphere2x2.mdl'
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT
ENT.Spawnable		= false



if SERVER then

	function ENT:Initialize(owner)
		self:SetModel( "models/hunter/blocks/cube1x2x1.mdl" ) -- модель энтити
		self:PhysicsInit( SOLID_VPHYSICS ) -- физика энтити
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_NONE ) -- коллизия энтити
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		self:SetTrigger( true )
	end


	function ENT:Think()
	end
	
	function ENT:StartTouch( ent )
		ent:SetVar("old_COLLISION",ent:GetCollisionGroup())
		ent:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )
	end
	
	function ENT:Touch( ent )
		ent:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )
	end
	
	function ENT:EndTouch( ent )
		ent:SetCollisionGroup( ent:GetVar("old_COLLISION") )
	end
end


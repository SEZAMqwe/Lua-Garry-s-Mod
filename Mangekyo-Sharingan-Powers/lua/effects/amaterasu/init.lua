function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( Pos )
	
	for i = 1,1 do

		local particle = emitter:Add( "particles/balloon_bit", Pos + Vector( 0,0,0 ) ) 
		 
		if particle == nil then particle = emitter:Add( "particles/balloon_bit", Pos + Vector(   0,0,0 ) ) end
		
		if (particle) then
			particle:SetVelocity(Vector(0,math.random(0,4),math.random(-70,100)))
			particle:SetLifeTime(0.070167793975311) 
			particle:SetDieTime(1.0091910484963) 
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(38.298842577954) 
			particle:SetEndSize(7.3033515166126)
			particle:SetAngles( Angle(68.802419427511,88.822227852508,73.319371552285) )
			particle:SetAngleVelocity( Angle(28.570580814508,40.774585868962,37.368921322068) ) 
			particle:SetRoll(math.Rand( 0, 360 ))
			particle:SetColor(0,0,0,255)
			particle:SetGravity( Vector(0,0,0) ) 
			particle:SetAirResistance(-57.20519919191 )  
			particle:SetCollide(false)
			particle:SetBounce(0)
		end
	end

	emitter:Finish()
		
end

function EFFECT:Think()		
	return false
end

function EFFECT:Render()
end
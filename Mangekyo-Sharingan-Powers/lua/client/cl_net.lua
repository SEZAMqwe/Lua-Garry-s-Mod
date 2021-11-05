net.Receive( "net.tsukuyomi", function() 
	local username = net.ReadEntity()
	local username_Susanoo = username:GetVar("SusanooEntity_i")
	local ply = LocalPlayer()
    local plypos = ply:GetPos()
	local pattern = Material("pp/texturize/pattern1.png")
	if ply:GetVar("tsukuyomi") != true then

		username:SetNoDraw( true )
		username:GetActiveWeapon():SetNoDraw( true )
		username_Susanoo:SetNoDraw( true  )
		username:DrawShadow( false  )
		username:GetActiveWeapon():DrawShadow( false  )

		ply:SetVar("tsukuyomi",true)


		timer.Create( "UniqueName1", 1, 60, function() 
			if ply:Alive() == true then
				if username:GetActiveWeapon():GetClass() != 'weapon_mangekyo_itachi' then
					username:GetActiveWeapon():SetNoDraw( true )
				end	
				username:SetNoDraw( true )
				username:GetActiveWeapon():SetNoDraw( true )
				username_Susanoo:SetNoDraw( true  )
				username:DrawShadow( false  )
				username:GetActiveWeapon():DrawShadow( false  )	
				if timer.RepsLeft( "UniqueName1" ) == 10 then
					hook.Add( "RenderScreenspaceEffects", "Texturize", function()

					DrawTexturize( 1, pattern )

					end )
				end
				if timer.RepsLeft( "UniqueName1" ) == 0 then
					hook.Remove('RenderScreenspaceEffects', 'Texturize')
					username:SetNoDraw( false )
					username:GetActiveWeapon():SetNoDraw( false )
					username_Susanoo:SetNoDraw( false )
					username:DrawShadow( true   )
					username:GetActiveWeapon():DrawShadow( true   )
					
					ply:SetVar("tsukuyomi",false)

					net.Start( 'net.setPos' )
						net.WriteEntity(ply)
						net.WriteVector( plypos )
					net.SendToServer()
				end
			else
			    timer.Stop('UniqueName1')
				username:SetNoDraw( false )
				username:GetActiveWeapon():SetNoDraw( false )
				username_Susanoo:SetNoDraw( false )
				username:DrawShadow( true   )
				username:GetActiveWeapon():DrawShadow( true   )
			    ply:SetVar("tsukuyomi",false)
			end
	    end )
	end
end )
local imer = 6 + 1 
net.Receive( "Kamui_measurements", function() 
	hook.Add( "HUDPaint", "HUDPaint_DrawBox", function()
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, ScrW(),  ScrH() )
	end )
end)


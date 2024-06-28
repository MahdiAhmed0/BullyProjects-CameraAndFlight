-- Main function:
function main()
	-- Setup variables:
	local t
	local on = false
	local cp,ch = 0,0
	local dist = 100
	local show = false
	local fc,fcx,fcy,fcz = false
	
	-- Main loop:
	while true do
		-- Wait (suspend script):
		Wait(0)
		
		-- Toggle:
		if IsButtonBeingReleased(3,0) then
			if t and GetTimer() < t + 500 then
				if on then
					on = false
					PlayerSetControl(1)
					PedSetEffectedByGravity(gPlayer,true)
					CameraReturnToPlayer()
					PedSetActionNode(gPlayer,"/Global","Globals.act")
					PedLockTarget(gPlayer,-1)
				else
					on = true
					cp,ch = 0,PedGetHeading(gPlayer)
					fc,fcx,fcy,fcz = false,nil,nil,nil
				end
			else
				t = GetTimer()
			end
		end
		
		-- Move player/camera:
		if on then
			-- Set control:
			PlayerSetControl(0)
			
			-- Set gravity:
			PedSetEffectedByGravity(gPlayer,false)
			
			-- Set action node:
			if not PedIsPlaying(gPlayer,"/Global/1_06/HoboFly",true) then
				PedSetActionNode(gPlayer,"/Global/1_06/HoboFly","Act/Conv/1_06.act")
			end
			
			-- Set camera zoom:
			dist = dist + (GetStickValue(0,0)-GetStickValue(1,0))
			
			-- Move camera:
			cp = cp + GetStickValue(19,0)/25
			ch = ch + GetStickValue(18,0)/20
			
			-- Get player position:
			local px,py,pz = PlayerGetPosXYZ()
			
			-- Get movement:
			local speed = IsButtonPressed(7,0) and 7 or 1
			local x1,y1 = F_GetForwardDir2D(ch,GetStickValue(17,0)/10*speed)
			local x2,y2 = F_GetForwardDir2D(ch+math.pi/2,GetStickValue(16,0)/10*speed)
			local z = (GetStickValue(12,0)-GetStickValue(10,0))/10*speed
			
			-- Check if the free camera is being toggled, is active, or is not:
			if IsButtonBeingPressed(9,0) then
				-- Toggle free cam:
				fc = not fc
				if fc then
					-- Initialize free camera:
					local cx,cy,cz = F_GetForwardDir3D(cp,ch,-dist*0.04)
					fcx,fcy,fcz = px+cx,py+cy,pz+cz+1.5
				else
					-- Turn off free camera:
					fc,fcx,fcy,fcz = false,nil,nil,nil
				end
			elseif fc then
				-- Move free camera:
				fcx,fcy,fcz = fcx+x1+x2,fcy+y1+y2,fcz+z
			else
				-- Move player:
				px,py,pz = px+x1+x2,py+y1+y2,pz+z
				
				-- Set position:
				PlayerFaceHeading(ch)
				PlayerSetPosSimple(px,py,pz)
			end
			
			-- Set camera:
			local cx,cy,cz = F_GetForwardDir3D(cp,ch,-dist*0.04)
			local camx,camy,camz = fcx or px+cx,fcy or py+cy,fcz or pz+cz+1.5
			local lookx,looky,lookz = fcx and fcx - cx or px,fcy and fcy - cy or py,fcz and fcz - cz or pz+1.5
			CameraSetXYZ(camx,camy,camz,lookx,looky,lookz)
			
			-- Create projectile:
			if IsButtonBeingPressed(6,0) then
				local x,y,z = F_GetForwardDir3D(cp,ch,0.5)
				CreateProjectile(325,fcx or px+x,fcy or py+y,fcz or pz+z+0.9,x,y,z,50)
			end
			
			-- Show text:
			if IsButtonBeingPressed(8,0) then
				show = not show
			end
			if show then
				TextPrintString(
					string.format("Area: %.0f\n",AreaGetVisible())..
					string.format("Player Pos: %.2f, ",px)..string.format("%.2f, ",py)..string.format("%.2f\n",pz)..
					string.format("Camera Pos: %.2f, ",camx)..string.format("%.2f, ",camy)..string.format("%.2f\n",camz)..
					string.format("Camera Look: %.2f, ",lookx)..string.format("%.2f, ",looky)..string.format("%.2f",lookz)
				,0,2)
			end
		end
	end
end

-- Other functions:
function F_GetForwardDir2D(h,dist)
	return -math.sin(h)*dist,math.cos(h)*dist
end
function F_GetForwardDir3D(p,h,dist)
	return math.cos(p)*-math.sin(h)*dist,math.cos(p)*math.cos(h)*dist,math.sin(p)*dist
end

-- STimeCycle functions:
F_AttendedClass = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		return 
	end
	SetSkippedClass(false)
	PlayerSetPunishmentPoints(0)
end

F_MissedClass = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		return 
	end
	SetSkippedClass(true)
	StatAddToInt(166)
end

F_AttendedCurfew = function()
	if not PedInConversation(gPlayer) and not MissionActive() then
		TextPrintString("You got home in time for curfew", 4)
	end
end

F_MissedCurfew = function()
	if not PedInConversation(gPlayer) and not MissionActive() then
		TextPrint("TM_TIRED5", 4, 2)
	end
end

F_StartClass = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		return 
	end
	F_RingSchoolBell()
	local l_6_0 = PlayerGetPunishmentPoints() + GetSkippingPunishment()
end

F_EndClass = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		return 
	end
	F_RingSchoolBell()
end

F_StartMorning = function()
	F_UpdateTimeCycle()
end

F_EndMorning = function()
	F_UpdateTimeCycle()
end

F_StartLunch = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		F_UpdateTimeCycle()
		return 
	end
	F_UpdateTimeCycle()
end

F_EndLunch = function()
	F_UpdateTimeCycle()
end

F_StartAfternoon = function()
	F_UpdateTimeCycle()
end

F_EndAfternoon = function()
	F_UpdateTimeCycle()
end

F_StartEvening = function()
	F_UpdateTimeCycle()
end

F_EndEvening = function()
	F_UpdateTimeCycle()
end

F_StartCurfew_SlightlyTired = function()
	F_UpdateTimeCycle()
end

F_StartCurfew_Tired = function()
	F_UpdateTimeCycle()
end

F_StartCurfew_MoreTired = function()
	F_UpdateTimeCycle()
end

F_StartCurfew_TooTired = function()
	F_UpdateTimeCycle()
end

F_EndCurfew_TooTired = function()
	F_UpdateTimeCycle()
end

F_EndTired = function()
	F_UpdateTimeCycle()
end

F_Nothing = function()
end

F_ClassWarning = function()
	if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
		return 
	end
	local l_23_0 = math.random(1, 2)
end

F_UpdateTimeCycle = function()
	if not IsMissionCompleated("1_B") then
		local l_24_0 = GetCurrentDay(false)
		if l_24_0 < 0 or l_24_0 > 2 then
			SetCurrentDay(0)
		end
	end
	F_UpdateCurfew()
end

F_UpdateCurfew = function()
	local l_25_0 = shared.gCurfewRules
	if not l_25_0 then
		l_25_0 = F_CurfewDefaultRules
	end
	l_25_0()
end

F_CurfewDefaultRules = function()
	local l_26_0 = ClockGet()
	if l_26_0 >= 23 or l_26_0 < 7 then
		shared.gCurfew = true
	else
		shared.gCurfew = false
	end
end
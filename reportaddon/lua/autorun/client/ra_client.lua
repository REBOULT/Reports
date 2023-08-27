surface.CreateFont( "RAFont", {
	font = "fu.20",
	size = 20,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

local dRBox = draw.RoundedBoxEx
local dText = draw.SimpleText
local dLine = surface.DrawLine
local drawTxt = draw.SimpleText
local drawRBox = draw.RoundedBox

local colorW = Color(255,255,255,255) -- White
local colorT = Color(0,0,0,0) -- Transparent
local colorDB = Color(0,170,250,90) -- Dark blue
local colorLB = Color(50,150,200,255) -- Light Blue
local colorFG = Color(100,100,200,50) -- Flat Green
local colorFR = Color(0,170,255,255) 
local colorB = Color(0,0,0,255) -- Black
local colorR = Color(0,170,255,255)
local colorSBB = Color(100,100,100,255) -- Scroll bar buttons
local colorSG = Color(100,100,100,255) -- Scroll bar grip
local colorTB = Color(0,0,0,100) -- Transparent black
local colorHead = Color(0, 170, 255, 255)
local colorHeadT = Color(0, 170,255, 200)
local colorOB = Color(100,100,200,50) -- other blue
local colorDDB = Color(0,170,250,90) -- Dark blue
local colorSBB = Color(100,100,100,255) -- Scroll bar buttons
local colorSG = Color(100,100,100,255) -- Scroll bar grip
local colorG = Color(80, 80, 80, 255) -- Grey
local colorCONC = Color(100, 100, 100, 255) -- CONCRETE

local lang = BigLanguage
local reportAddonFuncs = {}

function reportAddonFuncs.reportPlayersList()
	local reportPlayers = {}

	if reportconfig.adminList == true then
		for k, v in pairs(player.GetAll()) do
			local playerName = v:Nick()
			local playerSID = v:SteamID64()
			local playerGroup = v:GetUserGroup()
			local playerTeam = v:Team()

			table.insert(reportPlayers, {["nick"] = playerName, ["sid"] = playerSID, ["group"] = playerGroup, ["team"] = playerTeam, ["uid"] = v})
		end

		return reportPlayers
	else
		for k, v in pairs(player.GetAll()) do
			if isAdmin(v) != true then
				local playerName = v:Nick()
				local playerSID = v:SteamID64()
				local playerGroup = v:GetUserGroup()
				local playerTeam = v:Team()

				table.insert(reportPlayers, {["nick"] = playerName, ["sid"] = playerSID, ["group"] = playerGroup, ["team"] = playerTeam, ["uid"] = v})
			end
		end

		return reportPlayers
	end
end

net.Receive("newWarnNoti",function()
	local warned = net.ReadString()
	local warner = net.ReadString()
	local reason = net.ReadString()

	chat.AddText( Color(255,255,255,255), "RA Warns: ", colorR , warned, Color(255,255,255,255), " "..lang["has_been_warned_by"].." ", colorR, warner, colorW, " "..lang["for"].." " , colorR, reason )
end)

net.Receive("bootReportMenu",function()
	local reportReasons = net.ReadTable()
	local jobText = lang["job"]
	local reportedName = LocalPlayer():Nick()
	local reportedSID = LocalPlayer():SteamID64()

	local RAFNorton = vgui.Create("DFrame")
		RAFNorton:SetSize(600,590)
		RAFNorton:SetPos((ScrW()/2-300),ScrH())
		RAFNorton:MoveTo(ScrW()/2-300,ScrH()/2-300, 1, 0, -1, function() end)
		RAFNorton:SetVisible(true)
		RAFNorton:SetDraggable(true)
		RAFNorton:ShowCloseButton(false)
		RAFNorton:MakePopup()
		RAFNorton:SetTitle("")
		if reportconfig.jobsToRoles == true then 
			jobText = lang["role"]
		end
		
		RAFNorton.Paint = function(self, w, h)
			drawRBox(0,0,30, 600, 565, colorDDB)
			drawRBox(0,0,0, 600, 58, colorHead)
			drawRBox(0,0,56, 600, 2, colorTB)
			drawRBox(0,10,65,193.3,30,colorLB)
			drawRBox(0,203.3,65,193.3,30,colorOB)
			drawRBox(0,396.6,65,194,30,colorLB)
			drawRBox(0,10,93, 580, 2, colorTB)
			dText("Жалобы","RAFont",300,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			dText(lang["name"],"RAFont",15,78,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			dText(lang["rank"],"RAFont",299.5,78,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			dText(jobText,"RAFont",492.5,78,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end

	local RAFClose = vgui.Create ("DButton", RAFNorton)
		RAFClose:SetPos(550,8)
		RAFClose:SetSize(60,30)
		RAFClose:SetText("")
		RAFClose.Paint = function (s, w, h)
			dRBox(0,22.5,0,15,3, colorW,true,true,true,true)
			dRBox(0,22.5,0+6,15,3, colorW,true,true,true,true)
			dRBox(0,22.5,0+12,15,3, colorW,true,true,true,true)
		end
		RAFClose.DoClick = function()
			RAFNorton:Remove()
		end		

	local RAFLeeming = vgui.Create("DButton", RAFNorton)
		RAFLeeming:SetPos(10,347)
		RAFLeeming:SetSize(580,30)
		RAFLeeming:SetText("")
		RAFLeeming.Paint = function(self,w,h)
			if plyselected == self then
				dRBox(0,0,0,w,h,colorFR)
			else
				dRBox(0,0,0,w,h,colorG)
			end
			drawRBox(0,0,h-2,w,2,colorTB)
			dText(lang["nobody"],"RAFont",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		RAFLeeming.DoClick = function(self)
			plyselected = self
			reported = LocalPlayer()
		end

	local RAFShawbury = vgui.Create("DScrollPanel", RAFNorton)
		RAFShawbury:SetSize(580,240)
		RAFShawbury:SetPos(10,100)
			
	local RAFBenson = RAFShawbury:GetVBar()
		function RAFBenson:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorTB )
		end
		function RAFBenson.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function RAFBenson.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function RAFBenson.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSG )
		end

	local RAFDigby = vgui.Create("DListLayout", RAFShawbury)
		RAFDigby:SetPos(0,0)
		RAFDigby:SetSize(580,3840) -- 3840 as that's the equivalent to 128 players
		local sizeShrinker = 0

		if #player.GetAll() > 8 then
			sizeShrinker = 20
		end
		for _, v in pairs(reportAddonFuncs.reportPlayersList()) do
			local RAFMona = vgui.Create("DButton", RAFDigby)
				RAFMona:SetSize(580,30)
				RAFMona:SetText("")
				local playerName = v["nick"]
				local playerSID = v["sid"]
				local nameLength = string.len(playerName)
				local playerRank = v["group"]
				local jobName = lang["classified"]

				if reportconfig.showJobs == true then
					jobName = team.GetName(v["team"])
				end

				if nameLength > 18 then
					playerName = string.sub(v["nick"],1,18)														
				end
									
				RAFMona.Paint = function(self,w,h)
					if plyselected == self then
						drawRBox(0,0,0,w-sizeShrinker,28,colorFR)
					else
						drawRBox(0,0,0,193,28,colorG)
						drawRBox(0,193,0,193,28,colorCONC)
						drawRBox(0,386,0,194-sizeShrinker,28,colorG)
					end
					drawRBox(0,0,h-4,w-sizeShrinker,2,colorTB)
					dText(playerName,"RAFont",35,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					dText(playerRank,"RAFont",289.5,13,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					dText(jobName,"RAFont",482.5,13,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end
				RAFMona.DoClick = function(self)
					plyselected = self
					reportedName = playerName
					reportedSID = playerSID
				end
			
			local RAFTain = vgui.Create( "AvatarImage", RAFMona )
				RAFTain:SetSize(24,24)
				RAFTain:SetPos(5,2)
				RAFTain:SetPlayer(v["uid"],48)
		end

	local ReportReasonScrollbar = vgui.Create("DScrollPanel", RAFNorton)
		ReportReasonScrollbar:SetSize(580,80)
		ReportReasonScrollbar:SetPos(10,385)
				
	local ReportReasonScrollbarColours = ReportReasonScrollbar:GetVBar()
		function ReportReasonScrollbarColours:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorTB )
		end
		function ReportReasonScrollbarColours.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function ReportReasonScrollbarColours.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function ReportReasonScrollbarColours.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSG )
		end

	local wShrink = 0

	if #reportReasons > 8 then
		wShrink = 3
	end

	local grid = vgui.Create( "DGrid", ReportReasonScrollbar )
		grid:SetPos(0,0)
		grid:SetCols(4)
		grid:SetRowHeight(40)
		grid:SetColWide(147-(wShrink*2))

	for k, v in pairs(reportReasons) do
		local but = vgui.Create("DButton")
			but:SetText("")
			but:SetSize(140-wShrink,37.5)
			but.Paint = function(self,w,h)
				if selected == self then
					drawRBox(0,0,0,w,h,colorFR)
				else
					drawRBox(0,0,0,w,h,colorG)
				end
				drawRBox(0,0,h-2,w,2,colorTB)
				dText(v,"RAFont",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			but.DoClick = function(self)
				selected = self
				reason = k
			end
			grid:AddItem(but)
	end

	local RAFTextEntry = vgui.Create("DTextEntry", RAFNorton)
		RAFTextEntry:SetPos(10,470)
		RAFTextEntry:SetSize(580,70)
		RAFTextEntry:SetFont("RAFont")
		RAFTextEntry:SetTextColor(colorB)
		RAFTextEntry:SetText(lang["enter_message"])
		RAFTextEntry:SetMultiline(true)

	local RAFWyton = vgui.Create("DButton", RAFNorton)
		RAFWyton:SetSize(285,30)
		RAFWyton:SetPos(10,550)
		RAFWyton:SetText("")
		RAFWyton.Paint = function(_,w,h)
			drawRBox(0, 0, 0, w, h, colorFR)
			drawRBox(0,0,h-2,w,2,colorTB)
			dText(lang["cancel"],"RAFont",140,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)	 -- Draws text
		end
		RAFWyton.DoClick = function()
			RAFNorton:Remove()
		end

	local RAFBoulmer = vgui.Create("DButton", RAFNorton)
		RAFBoulmer:SetSize(285,30)
		RAFBoulmer:SetPos(305,550)
		RAFBoulmer:SetText("")
		RAFBoulmer.Paint = function(_,w,h)
			drawRBox( 0, 0, 0, w, h, colorFG)
			drawRBox(0,0,h-2,w,2,colorTB)
			dText(lang["submit"],"RAFont",140,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) -- Draws text
		end
		RAFBoulmer.DoClick = function()
			if reported == nil then
				reported = LocalPlayer()
			end

			if reason == nil then
				reason = 8
			end

			if extranotes == lang["enter_message"] or extranotes == nil then
				extranotes = lang["no_extra_notes"]
			end
			net.Start("newReport")
				net.WriteString(reportedName)
				net.WriteString(reportedSID)			
				net.WriteInt(reason, 5)
				net.WriteString(RAFTextEntry:GetValue())
			net.SendToServer()
			RAFNorton:Remove()
		end
end)

net.Receive("playerRating",function()
	local StaffName = net.ReadString()
	local staffID = net.ReadString()

	if IsValid(RAFRateYourDate) then
		RAFRateYourDate:Remove() 
	end

	RAFRateYourDate = vgui.Create("DFrame")
		RAFRateYourDate:SetSize(260,115)
		RAFRateYourDate:SetPos(ScrW()-280,ScrH()/2)
		RAFRateYourDate:ShowCloseButton(false)
		RAFRateYourDate:SetTitle("")
		RAFRateYourDate.Paint = function(self, w, h)
			drawRBox(0, 0, 30, w, h-30, colorDDB) 
			drawRBox(0, 0, 0, w, 30, colorHead)
			drawRBox(0, 0, 28, w, 2, colorTB)
			dText(lang["rate_the_staff"],"RAFont",130,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			dText(lang["want_did_you_think_of"].." ".. StaffName.. "?","MiniRAFont",130,95,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end

	local RAFRateOne = vgui.Create("DButton", RAFRateYourDate)
		RAFRateOne:SetPos(5,30)
		RAFRateOne:SetSize(50,50)
		RAFRateOne:SetText("")
		RAFRateOne.Paint = function()
			dRBox(4, 0, 0, 50, 50,colorT,false, false, false, false)
			if RAFRateOne:IsHovered() then
				RAFStarImage:SetImage("1star.png")
			end
		end
		RAFRateOne.DoClick = function()
			net.Start("playerRatingReview")
				net.WriteInt(1,3)
				net.WriteString(staffID)
			net.SendToServer()
			RAFRateYourDate:Remove()
		end

	local RAFRateTwo = vgui.Create("DButton", RAFRateYourDate)
		RAFRateTwo:SetPos(55,30)
		RAFRateTwo:SetSize(50,50)
		RAFRateTwo:SetText("")
		RAFRateTwo.Paint = function()
			dRBox(4, 0, 0, 50, 50,colorT,false, false, false, false)
			if RAFRateTwo:IsHovered() then
				RAFStarImage:SetImage("2stars.png")
			end
		end
		RAFRateTwo.DoClick = function()
			net.Start("playerRatingReview")
				net.WriteInt(2,3)
				net.WriteString(staffID)
			net.SendToServer()
			RAFRateYourDate:Remove()
		end

	local RAFRateThree = vgui.Create("DButton", RAFRateYourDate)
		RAFRateThree:SetPos(105,30)
		RAFRateThree:SetSize(50,50)
		RAFRateThree:SetText("")
		RAFRateThree.Paint = function()
			dRBox(4, 0, 0, 50, 50,colorT,false, false, false, false) -- Draw's a box
			if RAFRateThree:IsHovered() then
				RAFStarImage:SetImage("3stars.png")
			end
		end
		RAFRateThree.DoClick = function()
			net.Start("playerRatingReview")
				net.WriteInt(3,3)
				net.WriteString(staffID)
			net.SendToServer()
			RAFRateYourDate:Remove()
		end

	local RAFRateFour = vgui.Create("DButton", RAFRateYourDate)
		RAFRateFour:SetPos(155,30)
		RAFRateFour:SetSize(50,50)
		RAFRateFour:SetText("")
		RAFRateFour.Paint = function()
			dRBox(4, 0, 0, 50, 50,colorT,false, false, false, false) -- Draw's a box
			if RAFRateFour:IsHovered() then
				RAFStarImage:SetImage("4stars.png")
			end
		end
		RAFRateFour.DoClick = function()
			net.Start("playerRatingReview")
				net.WriteInt(4,3)
				net.WriteString(staffID)
			net.SendToServer()
			RAFRateYourDate:Remove()
		end

	local RAFRateFive = vgui.Create("DButton", RAFRateYourDate)
		RAFRateFive:SetPos(205,30)
		RAFRateFive:SetSize(50,50)
		RAFRateFive:SetText("")
		RAFRateFive.Paint = function()
			dRBox(4, 0, 0, 50, 50,colorT,false, false, false, false) -- Draw's a box
			if RAFRateFive:IsHovered() then
				RAFStarImage:SetImage("5stars.png")
			end
		end
		RAFRateFive.DoClick = function()
			net.Start("playerRatingReview")
				net.WriteInt(5,3)
				net.WriteString(staffID)
			net.SendToServer()
			RAFRateYourDate:Remove()
		end

	RAFStarImage = vgui.Create("DImage", RAFRateYourDate)
		RAFStarImage:SetPos(5,25)
		RAFStarImage:SetSize(250,75)
		RAFStarImage:SetImage("3stars.png")

	local RAFRateClose = vgui.Create ("DButton", RAFRateYourDate)
		RAFRateClose:SetPos(215,8)
		RAFRateClose:SetSize(60,30)
		RAFRateClose:SetText("")
		RAFRateClose.Paint = function()
			dRBox(0,22.5,0,15,3, colorW,true,true,true,true) -- Draw's a box
			dRBox(0,22.5,0+6,15,3, colorW,true,true,true,true) -- Draw's a box
			dRBox(0,22.5,0+12,15,3, colorW,true,true,true,true) -- Draw's a box
		end
		RAFRateClose.DoClick = function()
			RAFRateYourDate:Remove()
		end
end)


local firstLog = 0
local lastLog = 49

net.Receive("cleintWarnPanel",function()
	local warns = net.ReadTable()
	local wShirnk = 0
	local lenShrink = 0
	local currentWarns = #warns

	if #warns > 8 then
		wShirnk = 20
		lenShrink = 2
	end

	local function makeNewWarn(warn)
		local RAWarn = vgui.Create("DButton", RAWarnList)
			local warned = warn["warned"]
			local warner = warn["warnedBy"]
			local warnReason = warn["warnReason"]
			local warnTime1 = string.sub(warn["warnTime"],1,8)
			local warnTime2 = string.sub(warn["warnTime"],14,21)
		
			if string.len(warned) > 13 then
				warned = (string.sub(warned, 1, 14).."...")
			end

			if string.len(warner) > 13 then
				warner = (string.sub(warner, 1, 14).."...")
			end

			if string.len(warnReason) > 34-lenShrink then 
				warnReason = (string.sub(warnReason, 1, 35-lenShrink).."...")
			end

			RAWarn:SetSize(790-wShirnk,40)
			RAWarn:SetText("")
			RAWarn.Paint = function(self)
				if warnSelected == self then
					drawRBox(0,0,0,790-wShirnk,35,colorFG)
					drawRBox(0,0,33,790-wShirnk,2,colorTB)
				else
					drawRBox(0,0,0,150,35,colorG)
					drawRBox(0,150,0,150,35,colorCONC)
					drawRBox(0,300,0,150,35,colorG)
					drawRBox(0,450,0,340-wShirnk,35,colorCONC)
					drawRBox(0,0,33,790-wShirnk,2,colorTB)
				end			
					drawTxt(warnTime1, "RAFont", 75, 10, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					drawTxt(warnTime2, "RAFontLog", 75, 25, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					drawTxt(warned, "RAFont", 155, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(warner, "RAFont", 305, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(warnReason, "RAFont", 455, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			RAWarn.DoClick = function(self)
				RAWarnListScrollBar:SetSize(790,275)
				warnSelected = self

				if IsValid(RAWarnFullDetails) then
					RAWarnFullDetails:Remove()
				end

				RAWarnFullDetails = vgui.Create("DPanel", RAWarnMenu)
					RAWarnFullDetails:SetPos(5,385)
					RAWarnFullDetails:SetSize(790,75)
					RAWarnFullDetails.Paint = function()
						drawTxt(lang["warned"].." "..warn["warned"],"RAFont",5,10,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						drawTxt(lang["warner"].." "..warn["warnedBy"],"RAFont",5,30,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					end

				local RAWarnRichTextNote = vgui.Create("RichText",RAWarnFullDetails)
					RAWarnRichTextNote:SetPos(3,40)
					RAWarnRichTextNote:SetSize(790,40)
					RAWarnRichTextNote.PerformLayout = function( self )
						self:SetFontInternal("RAFont")
						self:SetFGColor(colorW)
					end
					RAWarnRichTextNote:AppendText(lang["reason"].." "..warn["warnReason"])
			end
	end


	if IsValid(RAWarnMenu) then
		RAWarnList:Remove()

		RAWarnList = vgui.Create("DListLayout", RAWarnListScrollBar)
			RAWarnList:SetPos(0,0)
			RAWarnList:SetSize(790,(#warns*40))
			for _, warn in pairs(warns) do
				makeNewWarn(warn)
			end
	else
		RAWarnMenu = vgui.Create( "DFrame" )
			RAWarnMenu:SetSize(800,500)
			RAWarnMenu:SetPos(ScrW()/2-400,ScrH()/2-250)
			RAWarnMenu:SetVisible(true)
			RAWarnMenu:SetDraggable(true) 
			RAWarnMenu:ShowCloseButton(false)
			RAWarnMenu:MakePopup()
			RAWarnMenu:SetTitle("")
			RAWarnMenu.Paint = function(_, w)
				drawRBox(0,0,30,w,470,colorDDB) 
				drawRBox(0,0,0,w,60,colorHead)
				drawRBox(0,0,55,w,5,colorTB)
				drawTxt("Предупреждения","RAFTitle",(w/2),15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt(lang["total_warns"].." "..currentWarns,"RAFTitle",795,45,colorW,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)			
				drawRBox(0,5,65,150,35,colorLB)
				drawRBox(0,155,65,150,35,colorOB)
				drawRBox(0,305,65,150,35,colorLB)
				drawRBox(0,455,65,340,35,colorOB)
				drawRBox(0,5,97,790,3,colorTB)
				drawTxt(lang["time"],"RAFTitle",80,80,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)			
				drawTxt(lang["warned2"],"RAFTitle",160,80,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)			
				drawTxt(lang["warner2"],"RAFTitle",310,80,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)			
				drawTxt(lang["reason2"],"RAFTitle",460,80,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)			
			end

		local RAClose = vgui.Create("DButton", RAWarnMenu)
			RAClose:SetPos(780,8)
			RAClose:SetSize(15,15)
			RAClose:SetText("")
			RAClose.Paint = function (s, w, h)
				drawRBox(0,0,0,15,3,colorW)
				drawRBox(0,0,6,15,3,colorW)
				drawRBox(0,0,12,15,3,colorW)
			end
			RAClose.DoClick = function()
				RAWarnMenu:Remove()
			end

		RAWarnListScrollBar = vgui.Create("DScrollPanel", RAWarnMenu)
			RAWarnListScrollBar:SetPos(5,105)
			RAWarnListScrollBar:SetSize(790,355)

		local RAWarnListScrollBarColours = RAWarnListScrollBar:GetVBar()
			function RAWarnListScrollBarColours:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorTB )
			end
			function RAWarnListScrollBarColours.btnUp:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAWarnListScrollBarColours.btnDown:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAWarnListScrollBarColours.btnGrip:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSG )
			end

		RAWarnList = vgui.Create("DListLayout", RAWarnListScrollBar)
			RAWarnList:SetPos(0,0)
			RAWarnList:SetSize(790,(#warns*40))
			for _, warn in pairs(warns) do
				makeNewWarn(warn)
			end

		local r = 72
		local g = 93
		local b = 114
		local r1 = r
		local g1 = g
		local b1 = b
		local r2 = r
		local g2 = g
		local b2 = b
		local newr = 39
		local newg = 174
		local newb = 96
	
		local RAWarnPrevPage = vgui.Create("DButton", RAWarnMenu)
			RAWarnPrevPage:SetPos(5,465)
			RAWarnPrevPage:SetSize(390,30)
			RAWarnPrevPage:SetText(lang["prev_page"])
			RAWarnPrevPage:SetFont("RAFont")
			RAWarnPrevPage:SetTextColor(colorW)
			RAWarnPrevPage.Paint = function(_, w, h)
				drawRBox(0,0,0,w,h,Color(r1, g1, b1, 255))

				if RAWarnPrevPage:IsHovered() then
					r1 = Lerp(0.1, r1, newr)
					g1 = Lerp(0.1, g1, newg)
					b1 = Lerp(0.1, b1, newb)
				else
					r1 = r
					g1 = g
					b1 = b
				end
			end
			RAWarnPrevPage.DoClick = function()
				if firstLog > 48 then
					firstLog = firstLog - 50
					lastLog = lastLog - 50
				end

				net.Start("cleintWarnPanel")
					net.WriteDouble(firstLog)
					net.WriteDouble(lastLog)
				net.SendToServer()
			end

		local RAWarnNextPage = vgui.Create("DButton", RAWarnMenu)
			RAWarnNextPage:SetPos(405,465)
			RAWarnNextPage:SetSize(390,30)
			RAWarnNextPage:SetText(lang["next_page"])
			RAWarnNextPage:SetFont("RAFont")
			RAWarnNextPage:SetTextColor(colorW)
			RAWarnNextPage.Paint = function(_, w, h)
				drawRBox(0,0,0,w,h,Color(r2, g2, b2, 255))

				if RAWarnNextPage:IsHovered() then
					r2 = Lerp(0.1, r2, newr)
					g2 = Lerp(0.1, g2, newg)
					b2 = Lerp(0.1, b2, newb)
				else
					r2 = r
					g2 = g
					b2 = b
				end
			end
			RAWarnNextPage.DoClick = function()
				firstLog = firstLog + 50
				lastLog = lastLog + 50

				net.Start("cleintWarnPanel")
					net.WriteDouble(firstLog)
					net.WriteDouble(lastLog)
				net.SendToServer()
			end
	end
end)

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/
surface.CreateFont( "RAFontLog", {
	font = "fu.20",
	size = 17,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

surface.CreateFont( "MiniRAFont", {
	font = "fu.15",
	size = 16,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

surface.CreateFont( "TinyRAFont", {
	font = "fu.15",
	size = 15,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

surface.CreateFont( "TinyerRAFont", {
	font = "fu.15",
	size = 13,
	weight = 50,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

surface.CreateFont( "RAFOverKill", {
	font = "fu.25",
	size = 25,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

surface.CreateFont( "RAFTitle", {
	font = "fu.20",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}	)

local nMsg = net
local drawTxt = draw.SimpleText
local drawRBoxEx = draw.RoundedBoxEx
local drawRBox = draw.RoundedBox
local drawLine = surface.DrawLine

local colorW = Color(255,255,255,255) -- White
local colorT = Color(0,0,0,0) -- Transparent
local colorDB = Color(0,170,250,90) -- Dark blue
local colorDDB = Color(0,170,250,90) -- Dark blue
local colorDDBT = Color(0,170,250,90) -- Dark blue trans
local colorDBT = Color(20,60,80,200) -- Dark blue transparent
local colorG = Color(80, 80, 80, 255) -- Grey
local colorCONC = Color(100, 100, 100, 255) -- CONCRETE
local colorLB = Color(30,150,220,120) -- Light Blue
local colorFG = Color(100,100,200,50) -- Flat Green
local colorFR = Color(0,170,255,255) 
local colorB = Color(0,0,0,255) -- Black
local colorR = Color(0,170,255,255) 
local colorSBB = Color(120,120,120,255) -- Scroll bar buttons
local colorSG = Color(120,120,120,255) -- Scroll bar grip
local colorTB = Color(0,0,0,100) -- Transparent black
local colorNS = Color(100,100,200,50) -- Not sure lol, weird mix between red and greem
local colorMWC = Color(0,100,200,255) -- More werid colors
local colorP = Color(150,80,180,255) -- Purple
local colorMBC = Color(0, 170, 100, 255)
local colorHead = Color(100,100,200,50)
local colorHeadT = Color(100,100,200,50)
local colorOB = Color(40, 120, 180, 255) -- other blue
local colorMB = Color(0,170,250,90) -- Midnight blue
local colorPL = Color(160, 90, 190) -- Purple lighter

local lang = BigLanguage

local function RAFMximiseBox(delete)
	if IsValid(RAFMaximise) then
		RAFMaximise:Remove() 
	end

	RAFMaximise = vgui.Create("DButton", RAFRunway)
		RAFMaximise:SetPos(10,10)
		RAFMaximise:SetSize(100,25)
		RAFMaximise:SetText("")
		RAFMaximise.Paint = function(_,w,h)
			drawRBoxEx(0,0,0,w,h,colorCONC,false,false,false,false)
			drawTxt(lang["return"],"RAFont",w/2,12,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawRBoxEx(0,0,23,w,2,colorTB,false,false,false,false) -- right shade
		end
		RAFMaximise.DoClick = function()
			delete:Remove()
			RAFSaxa:MoveTo(ScrW()/2-300,ScrH()/2-300, 1, 0, -1, function() RAFSaxa:SetSize(600,600) end)
			RAFMaximise:Remove() 
		end
end

nMsg.Receive("bootReportAdminMenu",function()
	local ActiveReports = nMsg.ReadTable()
	local ClaimedReports = nMsg.ReadTable()
	local staffcount = nMsg.ReadInt(32)

	RAFSaxa = vgui.Create( "DFrame" )
		RAFSaxa:SetSize(600,598)
		RAFSaxa:SetPos(ScrW()/2-300,ScrH()/2-300)
		RAFSaxa:SetDraggable(true)
		RAFSaxa:ShowCloseButton(false) 
		RAFSaxa:MakePopup()
		RAFSaxa:SetTitle("")
		RAFSaxa.Paint = function(_,w,h)
			drawRBox(0,0,30,w,h-30,colorDDB) 
			drawRBox(0,0,0,w,58,colorHead)
			drawRBox(0,00,56,w,2,colorTB)
			drawTxt("Жалобы","RAFTitle",w/2,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt(lang["current_open_reports"].." "..#ActiveReports,"RAFont",12,45,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["staff_online"].." "..staffcount,"RAFont",588,45,colorW,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			drawRBox(0,10,65,195,30,colorLB)
			drawRBox(0,205,65,195,30,colorOB)
			drawRBox(0,400,65,190,30,colorLB)
			drawRBox(0,10,93,w-20,2,colorTB)
			drawTxt(lang["reporter"],"RAFont",15,78,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["reported"],"RAFont",210,78,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["reason2"],"RAFont",405,78,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawRBox(0,10,95,195,245,colorMBC)
			drawRBox(0,205,95,195,245,colorDB)
			drawRBox(0,400,95,190,245,colorMBC)
			drawRBox(0,0,345,w,30,colorHead)
			drawRBox(0,0,373,w,2,colorTB)
			drawTxt(lang["current_claimed_reports"].." "..#ClaimedReports,"RAFont",10,360,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawRBox(0,10,380,195,30,colorLB)
			drawRBox(0,205,380,195,30,colorOB)
			drawRBox(0,400,380,190,30,colorLB)
			drawRBox(0,10,408,w-20,2,colorTB)
			drawTxt(lang["reporter"],"RAFont",15,393,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["reported"],"RAFont",210,393,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["claimed_by"],"RAFont",405,393,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawRBox(0,10,410,195,125,colorMBC)
			drawRBox(0,205,410,195,125,colorDB)
			drawRBox(0,400,410,190,125,colorMBC)
		end

	local RAFClose = vgui.Create("DButton", RAFSaxa)
		RAFClose:SetPos(555,8)
		RAFClose:SetSize(60,30)
		RAFClose:SetText("")
		RAFClose.Paint = function ()
			drawRBox(0,22.5,0,15,3, colorW)
			drawRBox(0,22.5,6,15,3, colorW)
			drawRBox(0,22.5,12,15,3, colorW)
		end
		RAFClose.DoClick = function()
			RAFSaxa:Remove()
		end

	local function playerAvatar(playerID, wPush, parent)
		local RAFAvarCon = vgui.Create("AvatarImage", parent)
			RAFAvarCon:SetSize(24,24)
			RAFAvarCon:SetPos(5+wPush,2)
			RAFAvarCon:SetPlayer(playerID,48)
	end

	local function deleteReport(rowid, reportSizeA, parent)
		if isSuperAdmin(LocalPlayer()) == true then -- there is also a serverside check, don't get happy skids
			local RAFSaveSyria = vgui.Create( "DButton", parent)
				RAFSaveSyria:SetSize(60,20)
				RAFSaveSyria:SetText("")
				RAFSaveSyria:SetPos(515-reportSizeA,4)
				RAFSaveSyria.Paint = function(s,w,h)
					drawRBox(0,0,0,w,h,colorFR)
					drawRBox(0,0,h-2,w,2,colorTB)
					drawTxt(lang["delete"],"RAFont",30,8,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end
				RAFSaveSyria.DoClick = function()
					nMsg.Start("reportDeleted")
						nMsg.WriteInt(rowid,32)
					nMsg.SendToServer()

					parent:Remove()
				end
		end	
	end

	local RAFReportList = vgui.Create("DScrollPanel", RAFSaxa)
		RAFReportList:SetSize(580,238)
		RAFReportList:SetPos(10,100)
				
	local RAFNato = RAFReportList:GetVBar()
		function RAFNato:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorTB )
		end
		function RAFNato.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function RAFNato.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
		end
		function RAFNato.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colorSG )
		end

	local RAFUSSR = vgui.Create("DListLayout", RAFReportList)
		RAFUSSR:SetPos(0,0)
		RAFUSSR:SetSize(580,3840)
		local reportSizeA = 0

		if #ActiveReports > 7 then
			reportSizeA = 20
		end

		for _, v in pairs(ActiveReports) do	
			local nameLength = string.len(v["reporter"])
			local nameLength2 = string.len(v["reported"])
			local reasonLength = string.len(v["reason"])
			local reporterName = v["reporter"]
			local reportedName = v["reported"]
			local reason = v["reason"]
			local reporterColor = colorW
			local reportedColor = colorW

			if v["reporterPly"] == nil then
				reporterColor = colorR
			end

			if nameLength > 16 then
				reporterName = (string.sub(v["reporter"],1,14).."...")
			end

			if v["reportedPly"] == nil then
				reportedColor = colorR
			end

			if nameLength > 16 then
				reportedName = (string.sub(v["reported"],1,14).."...")
			end

			if reasonLength > 16 then
				reason = (string.sub(v["reason"],1,14).."...")
			end	

			local RAFHeadaches = vgui.Create("DButton", RAFUSSR)
				RAFHeadaches:SetSize(580,30)
				RAFHeadaches:SetText("")
				RAFHeadaches.Paint = function(self)
					if repselected == self then
						drawRBox(0,0,0,580-reportSizeA,28,colorFG)
						drawRBox(0,0,26,580-reportSizeA,2,colorTB)
					else
						drawRBox(0,0,0,195,28,colorG)
						drawRBox(0,195,0,195,28,colorCONC)								
						drawRBox(0,390,0,190-reportSizeA,28,colorG)
						drawRBox(0,0,26,580-reportSizeA,2,colorTB)
					end
					drawTxt(reporterName,"RAFont",35,13,reporterColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					drawTxt(reportedName,"RAFont",230,13,reportedColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)								
					drawTxt(reason,"RAFont",395,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)															
				end
				RAFHeadaches.DoClick = function(self)
					repselected = self						
					RAFSaxa:SetSize(600,345)
					RAFSaxa:SetPos(ScrW()/2-610,ScrH()/2-300)
					net.Start("loadBaiscReportDetail")
						net.WriteInt(v["rowid"], 32)
						net.WriteBool(false)
					net.SendToServer()
				end

			playerAvatar(v["reporterPly"], 0, RAFHeadaches)
			playerAvatar(v["reportedPly"], 195, RAFHeadaches)
			deleteReport(v["rowid"], reportSizeA, RAFHeadaches)
		end

	local RAFReportProcessList = vgui.Create("DScrollPanel", RAFSaxa)
		RAFReportProcessList:SetSize(580,120)
		RAFReportProcessList:SetPos(10,415)
				
		local RAFSomalia = RAFReportProcessList:GetVBar()
			function RAFSomalia:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorTB )
			end
			function RAFSomalia.btnUp:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFSomalia.btnDown:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFSomalia.btnGrip:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSG )
			end

	local RAFChurchhill = vgui.Create("DListLayout", RAFReportProcessList)
		RAFChurchhill:SetPos(0,0)
		RAFChurchhill:SetSize(580,3840)
		local reportSizeG = 0

		if #ClaimedReports > 4 then
			reportSizeG = 20
		end

		for _, v in pairs(ClaimedReports) do
			local nameLength = string.len(v["reporter"])
			local nameLength2 = string.len(v["reported"])
			local nameLength3 = string.len(v["handler"])				
			local reporterName = v["reporter"]
			local reportedName = v["reported"]
			local handlerName = v["handler"]
			local reporterColor = colorW
			local reportedColor = colorW

			if v["reporterPly"] == nil then
				reporterColor = colorR
			end

			if nameLength > 16 then
				reporterName = string.sub(v["reporter"],1,14)
			end

			if v["reportedPly"] == nil then
				reportedColor = colorR
			end

			if nameLength > 16 then
				reportedName = (string.sub(v["reported"],1,14).."...")
			end

			if nameLength3 > 13 then
				handlerName = (string.sub(v["reported"],1,14).."...")
			end

			local RAFJihaddy = vgui.Create("DButton", RAFChurchhill)
				RAFJihaddy:SetSize(580,30)
				RAFJihaddy:SetText("")
				RAFJihaddy.Paint = function()
					drawRBox(0,0,0,195,28,colorG)
					drawRBox(0,195,0,195,28,colorCONC)
					drawRBox(0,390,0,190-reportSizeG,28,colorG)
					drawRBox(0,0,26,580-reportSizeG,2,colorTB)
					drawTxt(reporterName,"RAFont",35,13,reporterColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					drawTxt(reportedName,"RAFont",230,13,reportedColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)								
					drawTxt(handlerName,"RAFont",395,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end
				RAFJihaddy.DoClick = function(self)
					repselected = self
					RAFSaxa:SetSize(600,345)
					RAFSaxa:SetPos(ScrW()/2-610,ScrH()/2-300)

					net.Start("loadBaiscReportDetail")
						net.WriteInt(v["rowid"], 32)
						net.WriteBool(true)
					net.SendToServer()			
				end

			playerAvatar(v["reporterPly"], 0, RAFJihaddy)
			playerAvatar(v["reportedPly"], 195, RAFJihaddy)
			deleteReport(v["rowid"], reportSizeG, RAFJihaddy)
		end

	local RAFStats = vgui.Create("DButton", RAFSaxa)
		RAFStats:SetPos(10,540)
		RAFStats:SetSize(415,50)
		RAFStats:SetText("")
		RAFStats.Paint = function(_,w,h)
			drawRBox(0,0,0,w,h,colorFG)
			drawRBox(0,0,48,w,2,colorTB)
			drawTxt(lang["view_stats"],"RAFont",w/2,25,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)		
		end
		RAFStats.DoClick = function()
			nMsg.Start("loadStaffStats")
			nMsg.SendToServer()
			RAFSaxa:Remove()
		end

	if isSuperAdmin(LocalPlayer()) == true then -- also a serverside check dw bby
		local RAFdeleteAllReports = vgui.Create("DButton", RAFSaxa)
			RAFdeleteAllReports:SetPos(430,540)
			RAFdeleteAllReports:SetSize(160,50)
			RAFdeleteAllReports:SetText("")
			RAFdeleteAllReports.Paint = function(_,w,h)
				drawRBox(0,0,0,w,h,colorFR)
				drawRBox(0,0,48,w,2,colorTB)
				drawTxt(lang["delete_all_reports"],"RAFont",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)		
			end
			RAFdeleteAllReports.DoClick = function()
				nMsg.Start("deleteAllReports")
				nMsg.SendToServer()
				RAFSaxa:Remove()
			end
	end
end)

------------------------------------------------------------------------------------

net.Receive("reportDetails",function()
	local reportBasicDetails = net.ReadTable()
	local alreadyClaimed = net.ReadBool()

	if IsValid(RAReportDetails) then
		RAReportDetails:Remove()
	end

	local menuSize = 1

	local status1 = lang["offline"]
	local job1 = lang["offline"]
	local rank1 = lang["offline"]
	local status2 = lang["offline"]
	local job2 = lang["offline"]
	local rank2 = lang["offline"]
	local warnLooserBool = false

	if reportBasicDetails["reportedPly"] != nil then
		status1 = lang["online"]
		job1 = team.GetName(reportBasicDetails["reportedPly"]:Team())
		rank1 = reportBasicDetails["reportedPly"]:GetUserGroup()
	end

	if reportBasicDetails["reporterPly"] != nil then
		status2 = lang["online"]
		job2 = team.GetName(reportBasicDetails["reporterPly"]:Team())
		rank2 = reportBasicDetails["reporterPly"]:GetUserGroup()
	end

	if reportBasicDetails["handler"] == "NULL" or reportBasicDetails["handler"] == nil then -- if you staff is called NULL tell him to fuck off :)
		reportBasicDetails["handler"] = "Nobody"
	end

	RAReportDetails = vgui.Create("DFrame")
		RAReportDetails:SetSize(600, 345)
		RAReportDetails:SetPos(ScrW()/2+10,ScrH()/2-300)
		RAReportDetails:ShowCloseButton(false)
		RAReportDetails:SetTitle("")
		RAReportDetails.Paint = function(_, w, h)
			drawRBox(0, 0, 0, w, h, colorDDB)
			drawRBox(0, 0, 0, w, 58, colorHead)
			drawRBox(0, 0, 56, w, 2, colorTB)
			drawTxt("Жалобы", "RAFont", 300, 15, ColorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			drawTxt(lang["current_time"].." "..os.date("%H:%M:%S", os.time()), "RAFont", 12, 45, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["claimed_by"].." "..reportBasicDetails["handler"], "RAFont", w-10, 45, colorW, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

	local RAClose = vgui.Create("DButton", RAReportDetails)
		RAClose:SetPos(575,8)
		RAClose:SetSize(15,15)
		RAClose:SetText("")
		RAClose.Paint = function(_, w, h)
			drawRBox(0,0,0,15,3,colorW)
			drawRBox(0,0,6,15,3,colorW)
			drawRBox(0,0,12,15,3,colorW)
		end
		RAClose.DoClick = function()
			gui.EnableScreenClicker(false)

			RAReportDetails:Remove()
		end

	local RAFMaximise = vgui.Create("DButton", RAReportDetails)
		RAFMaximise:SetPos(10,10)
		RAFMaximise:SetSize(100,20)
		RAFMaximise:SetText("")
		RAFMaximise.Paint = function(_,w,h)
			drawRBoxEx(0,0,0,w,h,colorCONC,false,false,false,false)
			drawTxt(lang["return"],"RAFont",w/2,8,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawRBoxEx(0,0,18,w,2,colorTB,false,false,false,false) -- right shade
		end
		RAFMaximise.DoClick = function()
			RAReportDetails:Remove()
			RAFSaxa:MoveTo(ScrW()/2-300,ScrH()/2-300, 1, 0, -1, function() RAFSaxa:SetSize(600,600) end)
			RAFMaximise:Remove() 
		end

	local RAReportInfo = vgui.Create("DPanel", RAReportDetails)
		RAReportInfo:SetPos(10,65)
		RAReportInfo:SetSize(580,215)
		RAReportInfo:SetText("")
		RAReportInfo.Paint = function(_, w, h)
			drawRBox(0,0,0,w/2,30,colorLB)			
			drawRBox(0,w/2,0,w,30,colorOB)
			drawRBox(0,0,29,w,1,colorTB)	
			drawRBox(0,0,30,w/2,h,colorDB)
			drawRBox(0,w/2,30,w/2,h,colorMB)
			drawRBox(0,0,35,w/2,28,colorG)
			drawRBox(0,w/2,35,w/2,28,colorCONC)
			drawRBox(0,0,61,w,2,colorTB)
			drawRBox(0,0,65,w/2,28,colorG)
			drawRBox(0,w/2,65,w/2,28,colorCONC)
			drawRBox(0,0,91,w,2,colorTB)
			drawRBox(0,0,95,w/2,28,colorG)
			drawRBox(0,w/2,95,w/2,28,colorCONC)
			drawRBox(0,0,121,w,2,colorTB)
			drawRBox(0,0,125,w/2,28,colorG)
			drawRBox(0,w/2,125,w/2,28,colorCONC)
			drawRBox(0,0,151,w,2,colorTB)
			drawTxt(lang["reported"], "RAFont", (w/4), 15, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			drawTxt(lang["reporter"], "RAFont", ((w/4)*3), 15, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			drawTxt(lang["name2"].." "..reportBasicDetails["reported"], "RAFont", 5, 47.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["job2"].." "..job1, "RAFont", 5, 107.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["status"].." "..status1, "RAFont", 5, 137.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)			
			drawTxt(lang["name2"].." "..reportBasicDetails["reporter"], "RAFont", (w/2+5), 47.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["job2"].." "..job2, "RAFont", (w/2+5), 107.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["status"].." "..status2, "RAFont", (w/2+5), 137.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

	local RAReportInfoSub = vgui.Create("DPanel", RAReportInfo)
		RAReportInfoSub:SetPos(0,155)
		RAReportInfoSub:SetSize(580,60)
		RAReportInfoSub.Paint = function(_, w)
			drawRBox(0,0,0,w,28,colorPL)
			drawRBox(0,0,26,w,2,colorTB)
			drawRBox(0,0,30,w,28,colorPL)
			drawRBox(0,0,56,w,2,colorTB)
			drawTxt(lang["time_of_report"].." "..reportBasicDetails["time"], "RAFont", 5, 12.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			drawTxt(lang["reason"].." "..reportBasicDetails["reason"], "RAFont", 5, 42.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

	local function steamIDButton(wPush, SID)
		local steamIDCopy = vgui.Create("DButton",RAReportInfo)
			steamIDCopy:SetPos(5+wPush, 62.5)
			steamIDCopy:SetSize(285, 30)
			steamIDCopy:SetText("")
			steamIDCopy:SetFont("RAFont")
			steamIDCopy:SetTextColor(colorW)
			steamIDCopy.DoClick = function()
				SetClipboardText(SID)
			end
			steamIDCopy.Paint = function() 
				drawTxt(lang["steamid"].." "..SID, "RAFont", 0, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
	end

	steamIDButton(0, util.SteamIDFrom64(reportBasicDetails["reportedID"]))
	steamIDButton(290, util.SteamIDFrom64(reportBasicDetails["reporterID"]))

	local bottomPhase = vgui.Create("DPanel", RAReportDetails)
		bottomPhase:SetPos(10, 280)
		bottomPhase:SetSize(600, 58)
		bottomPhase.Paint = function() end

	local infoAndClaim = vgui.Create("DPanel", bottomPhase)
		infoAndClaim:SetPos(0, 0)
		infoAndClaim:SetSize(475, 58)
		infoAndClaim.Paint = function() end

	local infoText = lang["more_info"]
	local infoText2 = lang["click_me"]

	local moreInfo = vgui.Create("DButton", infoAndClaim)
		moreInfo:SetPos(0, 0)
		moreInfo:SetSize(475, 28)
		moreInfo:SetText("")
		moreInfo.Paint = function(_, w, h)
			drawRBox(0,0,0,w,h,colorG)
			drawRBox(0,0,26,w,2,colorTB)
			drawTxt(infoText, "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
			drawTxt(infoText2, "TinyRAFont", w-5, 24, colorW, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
		moreInfo.DoClick = function()
			infoText2 = ""

			net.Start("loadExtraReportDetail")
				net.WriteInt(reportBasicDetails["rowid"], 32)
			net.SendToServer()
		end

	local actionButtons = vgui.Create("DPanel", infoAndClaim)
		actionButtons:SetPos(0, 30)
		actionButtons:SetSize(475, 28)
		actionButtons.Paint = function() end

	local function claimedMode(rowid, reporterPly, reportedPly, button)
		if reportconfig.cursorShownOnNotification == true then
			gui.EnableScreenClicker(true)
		end


		if button == true then
			menuSize = menuSize + 2
		else
			menuSize = 3
		end

		RAReportDetails:AlignRight(50)
		RAReportDetails:AlignTop(50)

		if IsValid(RAFSaxa) then
			RAFSaxa:Remove()
		end

		if IsValid(RAFMaximise) then
			RAFMaximise:Remove()
		end

		if reportBasicDetails["handlerID"] == LocalPlayer():SteamID64() then 
			local reporterWon = vgui.Create("DButton", actionButtons)
				reporterWon:SetPos(0, 0)
				reporterWon:SetSize(133.3, 28)
				reporterWon:SetText("")
				reporterWon.Paint = function(_, w, h)
					drawRBox(0,0,0,w,h,colorFG)
					drawRBox(0,0,26,w,2,colorTB)
					drawTxt(lang["reporter_won"], "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)						
				end
				reporterWon.DoClick = function()
					if reportconfig.AWarn == true then
						warnLooserBool = false
						test = reportBasicDetails["reported"]
						LocalPlayer():ConCommand("say !warn "..test.." "..reportconfig.aWarnMessage )				
					end

					net.Start("reportCompleted")
						net.WriteInt(reportBasicDetails["rowid"], 32)
						net.WriteBool(warnLooserBool)
						net.WriteType(reportBasicDetails["reporter"])
						net.WriteType(reportBasicDetails["reporterID"])
						net.WriteType(reportBasicDetails["reported"])
						net.WriteType(reportBasicDetails["reportedID"])
						net.WriteType(reportBasicDetails["reporterPly"])
					net.SendToServer()

					gui.EnableScreenClicker(false)

					RAReportDetails:Remove()
				end

			local reportedWon = vgui.Create("DButton", actionButtons)
				reportedWon:SetPos(137.3, 0)
				reportedWon:SetSize(133.3, 28)
				reportedWon:SetText("")
				reportedWon.Paint = function(_, w, h)
					drawRBox(0,0,0,w,h,colorFG)
					drawRBox(0,0,26,w,2,colorTB)
					drawTxt(lang["reported_won"], "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)						
				end
				reportedWon.DoClick = function()
					net.Start("reportCompleted")
						net.WriteInt(reportBasicDetails["rowid"], 32)
						net.WriteBool(warnLooserBool)
						net.WriteType(reportBasicDetails["reported"])
						net.WriteType(reportBasicDetails["reportedID"])
						net.WriteType(reportBasicDetails["reporter"])
						net.WriteType(reportBasicDetails["reporterID"])
						net.WriteType(reportBasicDetails["reportedPly"])
					net.SendToServer()

					gui.EnableScreenClicker(false)

					RAReportDetails:Remove()
				end

			local nobodyWon = vgui.Create("DButton", actionButtons)
				nobodyWon:SetPos(274, 0)
				nobodyWon:SetSize(133.3, 28)
				nobodyWon:SetText("")
				nobodyWon.Paint = function(_, w, h)
					drawRBox(0,0,0,w,h,colorFG)
					drawRBox(0,0,26,w,2,colorTB)
					drawTxt(lang["nobody_won"], "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)						
				end
				nobodyWon.DoClick = function()
					net.Start("reportCompleted")
						net.WriteInt(reportBasicDetails["rowid"], 32)
						net.WriteBool(false)
						net.WriteType(false)
						net.WriteType(false)
						net.WriteType(false)
					net.SendToServer()

					gui.EnableScreenClicker(false)

					RAReportDetails:Remove()
				end

			local warnLooserText = vgui.Create("DPanel", actionButtons)
				warnLooserText:SetPos(405, 0)
				warnLooserText:SetSize(70, 30)
				warnLooserText.Paint = function(_, w)
					drawTxt(lang["warn_looser"], "TinyerRAFont", (w/2)+2, 5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)						
				end

			local warnLooser = vgui.Create("DCheckBox", actionButtons)
				warnLooser:SetPos(432, 12)
				warnLooser:SetSize(16, 16)
				function warnLooser:OnChange(val)
					if (val) then
						warnLooserBool = true
					else
						warnLooserBool = false
					end
				end
		end
	end

	if alreadyClaimed == false then
		local RAClaimReport = vgui.Create("DButton", actionButtons)
			RAClaimReport:SetPos(0, 0)
			RAClaimReport:SetSize(475, 28)
			RAClaimReport:SetText("")
			RAClaimReport.Paint = function(_, w, h)
				drawRBox(0,0,0,w,h,colorFG)
				drawRBox(0,0,26,w,2,colorTB)
				drawTxt(lang["claim_report"], "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
			end
			RAClaimReport.DoClick = function()
				nMsg.Start("reportClaimed")
					nMsg.WriteInt(reportBasicDetails["rowid"], 32)
				nMsg.SendToServer()

				RAClaimReport:Remove()

				nMsg.Receive("checkReportHandler",function()	
					reportBasicDetails["handlerID"] = nMsg.ReadString()
					reportBasicDetails["handler"] = nMsg.ReadString()

					claimedMode(reportBasicDetails["rowid"], reportBasicDetails["reporterPly"], reportBasicDetails["reportedPly"], true)
				end)
			end
	end

	local RAViewLogs = vgui.Create("DButton", bottomPhase)
		RAViewLogs:SetPos(477, 30)
		RAViewLogs:SetSize(103, 28)
		RAViewLogs:SetText("")
		RAViewLogs.Paint = function(_, w, h)
			drawRBox(0,0,0,w,h,colorG)
			drawRBox(0,0,26,w,2,colorTB)
			drawTxt(lang["view_logs"], "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		end
		RAViewLogs.DoClick = function()
			if reportconfig.blogsSupport == false then
				net.Start("reportLogs")
					net.WriteString(reportBasicDetails["reported"])
					net.WriteInt(menuSize, 4)
				net.SendToServer()

				RAReportDetails:SetVisible(false)
			else
				LocalPlayer():ConCommand("say !blogs")
			end
		end

	local buttonText = lang["show_buttons"]

	if reportBasicDetails["reporterPly"] != nil or reportBasicDetails["reportedPly"] != nil then
		local quickButtons = vgui.Create("DButton", bottomPhase)
			quickButtons:SetPos(477, 0)
			quickButtons:SetSize(103, 28)
			quickButtons:SetText("")
			quickButtons.Paint = function(_, w, h)
				drawRBox(0,0,0,w,h,colorG)
				drawRBox(0,0,26,w,2,colorTB)
				drawTxt(buttonText, "RAFont", w/2, 12.5, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
			end
			quickButtons.DoClick = function()
				if buttonText == lang["show_buttons"] then
					buttonText = lang["hide_buttons"]
					local activePlayer = ""
					if reportBasicDetails["reportedPly"] != nil then
						activePlayer = reportBasicDetails["reportedPly"]:Nick()
					else
						activePlayer = reportBasicDetails["reporterPly"]:Nick()
					end

					infoAndClaim:SetVisible(false)

					buttonBaseplate = vgui.Create("DPanel", bottomPhase)
						buttonBaseplate:SetPos(0, 0)
						buttonBaseplate:SetSize(475,58)
						buttonBaseplate.Paint = function() end
						
					local RAFBring = vgui.Create("DButton",buttonBaseplate)
						RAFBring:SetPos(0,0)
						RAFBring:SetSize(117,28)
						RAFBring:SetText("")
						RAFBring.Paint = function(s,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["bring"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFBring.DoClick = function()
							LocalPlayer():ConCommand("say !bring "..activePlayer)
						end

					local RAFGoto = vgui.Create("DButton",buttonBaseplate)
						RAFGoto:SetPos(0, 30)
						RAFGoto:SetSize(117,28)
						RAFGoto:SetText("")
						RAFGoto.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["goto"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFGoto.DoClick = function()
							LocalPlayer():ConCommand("say !goto "..activePlayer)
						end

					local RAFJail = vgui.Create("DButton",buttonBaseplate)
						RAFJail:SetPos(119.375,0)
						RAFJail:SetSize(117,28)
						RAFJail:SetText("")
						RAFJail.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["jail"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFJail.DoClick = function()
							LocalPlayer():ConCommand("say !jail "..activePlayer)
						end

					local RAFUnjail = vgui.Create("DButton",buttonBaseplate)
						RAFUnjail:SetPos(119.375,30)
						RAFUnjail:SetSize(117,28)
						RAFUnjail:SetText("")
						RAFUnjail.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["un_jail"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFUnjail.DoClick = function()
							LocalPlayer():ConCommand("say !unjail "..activePlayer)
						end

					local RAFFree = vgui.Create("DButton",buttonBaseplate)
						RAFFree:SetPos(238.5,0)
						RAFFree:SetSize(118,28)
						RAFFree:SetText("")
						RAFFree.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["freeze"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFFree.DoClick = function()
							LocalPlayer():ConCommand("say !freeze "..activePlayer)
						end

					local RAFUnFree = vgui.Create("DButton",buttonBaseplate)
						RAFUnFree:SetPos(238.5,30)
						RAFUnFree:SetSize(118,28)
						RAFUnFree:SetText("")
						RAFUnFree.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorG)
							drawRBox(0,0,26,w,2,colorTB)
							drawTxt(lang["un_freeze"],"RAFont",w/2,11,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						RAFUnFree.DoClick = function(s,w,h)
							LocalPlayer():ConCommand("say !unfreeze "..activePlayer)
						end

					local colorButReporter = Color(46,204,113,255)
					local colorButReported = Color(149, 165, 166, 255)

					if reportBasicDetails["reportedPly"] != nil then
						local chooseReporter = vgui.Create("DButton",buttonBaseplate)
							chooseReporter:SetPos(358.125,0)
							chooseReporter:SetSize(117,28)
							chooseReporter:SetText("")
							chooseReporter.Paint = function(_, w,h )
								drawRBox(0,0,0,w,h,colorButReporter)
								drawRBox(0,0,26,w,2,colorTB)
								drawTxt(lang["reported"],"RAFontLog",w/2,7,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
								drawTxt(lang["click_to_target_player"],"TinyerRAFont",w/2,19,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
							end
							chooseReporter.DoClick = function() 
								activePlayer = reportBasicDetails["reportedPly"]:Nick()
								
								colorButReporter = Color(46,204,113,255)
								colorButReported = Color(149, 165, 166, 255)
							end
					end

					if reportBasicDetails["reporterPly"] != nil then
						local chooseReporter = vgui.Create("DButton",buttonBaseplate)
							chooseReporter:SetPos(358.125,30)
							chooseReporter:SetSize(117,28)
							chooseReporter:SetText("")
							chooseReporter.Paint = function(_, w,h )
								drawRBox(0,0,0,w,h,colorButReported)
								drawRBox(0,0,26,w,2,colorTB)
								drawTxt(lang["reporter"],"RAFontLog",w/2,7,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
								drawTxt(lang["click_to_target_player"],"TinyerRAFont",w/2,19,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
							end
							chooseReporter.DoClick = function()
								activePlayer = reportBasicDetails["reporterPly"]:Nick()

								colorButReporter = Color(149, 165, 166, 255)
								colorButReported = Color(46,204,113,255) 
							end
					end
				else
					buttonText = lang["show_buttons"]

					infoAndClaim:SetVisible(true)

					buttonBaseplate:Remove()
				end
			end
	end

	if alreadyClaimed == true then
		claimedMode(reportBasicDetails["rowid"], reportBasicDetails["reporterPly"], reportBasicDetails["reportedPly"], false)
	end

	net.Receive("reportExtraDetails",function()
		local extraData1 = net.ReadTable()
		local extraData2 = net.ReadTable()
		local extraData3 = net.ReadInt(32)
		local extraData4 = net.ReadInt(32)
		local extraNotes = net.ReadString()

		if IsValid(RAReportInfoExtra) then
			menuSize = menuSize - 1
			infoText = lang["more_info"]
			RAReportInfoExtra:Remove()
			RAReportDetails:SetSize(600, 345)
			RAReportInfo:SetSize(580,215)
			bottomPhase:SetPos(10, 280)
			RAReportInfoSub:SetPos(0,155)
		else
			menuSize = menuSize + 1
			infoText = lang["less_info"]
			RAReportDetails:SetSize(600, 525)
			RAReportInfo:SetSize(580,395)
			bottomPhase:SetPos(10, 460)

			RAReportInfoExtra = vgui.Create("DPanel", RAReportInfo)
				RAReportInfoExtra:SetPos(0,155)
				RAReportInfoExtra:SetSize(580, 480)
				RAReportInfoExtra.Paint = function(_, w)
					drawRBox(0,0,0,w/2,28,colorG)
					drawRBox(0,w/2,0,w/2,28,colorCONC)
					drawRBox(0,0,26,w,2,colorTB)
					drawRBox(0,0,30,w/2,28,colorG)
					drawRBox(0,w/2,30,w/2,28,colorCONC)
					drawRBox(0,0,56,w,2,colorTB)
					drawRBox(0,0,60,w/2,28,colorG)
					drawRBox(0,w/2,60,w/2,28,colorCONC)
					drawRBox(0,0,86,w,2,colorTB)
					drawRBox(0,0,90,w/2,28,colorG)
					drawRBox(0,w/2,90,w/2,28,colorCONC)
					drawRBox(0,0,116,w,2,colorTB)
					--------------------
					drawRBox(0,0,180,w,58,colorPL)
					drawRBox(0,0,236,w,2,colorTB)
					---------
					drawTxt(lang["warns"].." "..extraData3, "RAFont", 5, 12.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["warns"].." "..extraData4, "RAFont", (w/2+5), 12.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["rank"].." "..rank1, "RAFont", 5, 42.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["rating"].." "..extraData1["rating"], "RAFont", 5, 72.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["reviews"].." "..extraData1["reviews"], "RAFont", 5, 102.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)		
					drawTxt(lang["rank"].." "..rank2, "RAFont", (w/2+5), 42.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["rating"].." "..extraData2["rating"], "RAFont", (w/2+5), 72.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					drawTxt(lang["reviews"].." "..extraData2["reviews"], "RAFont", (w/2+5), 102.5, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

			RAReportInfoSub:SetPos(0, 275)

			local function loadWarns(wPush, name)
				local RAWarnsInfo = vgui.Create("DButton", RAReportInfoExtra)
					RAWarnsInfo:SetPos(5+wPush, 5)
					RAWarnsInfo:SetSize(285,15)
					RAWarnsInfo:SetText("")
					RAWarnsInfo.DoClick = function()
						net.Start("warnPanelSearch")
							net.WriteString(name)
							net.WriteDouble(0)
							net.WriteDouble(49)
						net.SendToServer()
					end
					RAWarnsInfo.Paint = function() end
			end

			if reportconfig.AWarn == false then
				loadWarns(0, reportBasicDetails["reported"])
				loadWarns(295, reportBasicDetails["reporter"])
			end

			local RAReportNotesText = vgui.Create("RichText", RAReportInfoExtra)
				RAReportNotesText:SetPos(2, 180)
				RAReportNotesText:SetSize(580, 58)
				RAReportNotesText:AppendText(lang["extra_notes2"].." "..extraNotes)
				RAReportNotesText.PerformLayout = function( self )
					self:SetFontInternal("RAFont")
					self:SetFGColor(colorW)
				end
		end
	end)
end)
 
------------------------------------------------------------------------------------

local logNotifications = {}
local totalReports = 0

nMsg.Receive("newReportNoti",function() -- recieves message from server 
	local ReportInfo = nMsg.ReadTable()
	totalReports = #ReportInfo
	local reportcount = lang["there_are_currently"].." ".. #ReportInfo.." "..lang["active_reports"]

	if reportconfig.cursorShownOnNotification == true then
		gui.EnableScreenClicker(true)		
	end

	surface.PlaySound( "HL1/fvox/beep.wav" )

	local function bringGoto(ply, wpush, parent)
		local RAFBringNotiAlt = vgui.Create("DButton", parent)
			RAFBringNotiAlt:SetPos(210,2.5+wpush)
			RAFBringNotiAlt:SetSize(50,20)
			RAFBringNotiAlt:SetText("")
			RAFBringNotiAlt.Paint = function(s,w,h)
				drawRBoxEx(0, 0, 0, w, h, colorG, false, false, false, false) -- Draw box
				drawRBoxEx(0, 0, 19, w, 1, colorTB, false, false, false, false)					
				drawTxt(lang["bring"], "RAFontLog", 25, 10, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			RAFBringNotiAlt.DoClick = function(s,w,h)
				LocalPlayer():ConCommand("say !bring "..ply)
			end

		local RAFGotoNotiAlt = vgui.Create("DButton", parent)
			RAFGotoNotiAlt:SetPos(265,2.5+wpush)
			RAFGotoNotiAlt:SetSize(50,20)
			RAFGotoNotiAlt:SetText("")
			RAFGotoNotiAlt.Paint = function(s,w,h)
				drawRBoxEx(0, 0, 0, w, h, colorG, false, false, false, false) -- Draw box
				drawRBoxEx(0, 0, 19, w, 1, colorTB, false, false, false, false)		
				drawTxt(lang["goto"], "RAFontLog", 25, 10, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			RAFGotoNotiAlt.DoClick = function(s,w,h)
				LocalPlayer():ConCommand("say !goto "..ply)
			end
	end

	local function reportNotification(v) -- the v is lazy, ill ulazy one day
		local reporterName = v["reporter"]
		local reportedName = v["reported"]
		local reason = v["reason"]
		local reportID = v["rowid"]

		local nameLength = string.len(reporterName)
		local nameLength2 = string.len(reportedName)
		local reasonLength = string.len(reason)

		if nameLength > 10 then
			reporterName = (string.sub(v["reporter"],1,14).."...")
		end

		if nameLength2 > 10 then
			reportedName = (string.sub(v["reported"],1,14).."...")
		end

		if reasonLength > 10 then
			reason = (string.sub(v["reason"],1,14).."...")
		end

		local RAFNotiBambis = vgui.Create("DPanel", RAFNotiHub)
			RAFNotiBambis:Dock( TOP )
			RAFNotiBambis:DockMargin( 0, 10, 0, 0 ) -- shift to the right
			RAFNotiBambis:SetSize(320,75)
			RAFNotiBambis:SetText("")											
			RAFNotiBambis.Paint = function(self)
				drawRBox(0,0,0,320,75,colorDBT)
				drawTxt(lang["reporter3"].." "..reporterName,"RAFontLog",5,12.5,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["reported3"].." "..reportedName,"RAFontLog",5,37.5,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["reason"].." "..reason,"RAFontLog",5,62.5,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end

		logNotifications[reportID] = {RAFNotiBambis}

		bringGoto(reporterName, 0, RAFNotiBambis)
		bringGoto(reportedName, 25, RAFNotiBambis)

		local RAFQuickClaim = vgui.Create("DButton", RAFNotiBambis)
			RAFQuickClaim:SetPos(210,52.5)
			RAFQuickClaim:SetSize(105,20)
			RAFQuickClaim:SetText("")
			RAFQuickClaim.Paint = function(_, w, h)
				drawRBox(0, 0, 0, 105, h, colorLB)
				drawRBox(0, 0, 19, w, 1, colorTB)	
				drawTxt(lang["quick_claim"], "RAFontLog", 52.5, 10, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			RAFQuickClaim.DoClick = function()		
				nMsg.Start("reportClaimed")
					nMsg.WriteInt(reportID, 32)
				nMsg.SendToServer()

				nMsg.Start("loadBaiscReportDetail")
					nMsg.WriteInt(v["rowid"], 32)
					nMsg.WriteBool(true)
				nMsg.SendToServer()

				gui.EnableScreenClicker(false)

				RAFNoti:Remove()
			end
	end

	if IsValid(RAFNoti) then
		timer.Remove("NotiRemoveTimer")
		timer.Create("NotiRemoveTimer",reportconfig.notiActiveTime+1,1,function() RAFNoti:Remove() gui.EnableScreenClicker(false) end)

		reportNotification(ReportInfo[#ReportInfo])
	else
		if reportconfig.cursorShownOnNotification == true then
			gui.EnableScreenClicker(true)
		end
		
		RAFNoti = vgui.Create("DPanel")
			timer.Create("NotiRemoveTimer",reportconfig.notiActiveTime,1,function() RAFNoti:Remove() gui.EnableScreenClicker(false) end)
			RAFNoti:SetPos((ScrW()+330),ScrH()/8)
			RAFNoti:MoveTo(ScrW()-330,ScrH()/8, 1, 0, -1, function() end)
			RAFNoti:SetSize(320,315)
			RAFNoti.Paint = function(self,w,h)
				drawRBox(0,0,0,320,50,colorHeadT) -- Draw box
				drawRBox(0,0,45,w,5,colorTB)
				drawTxt(lang["new_report_recieved"],"RAFontLog",160,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt(lang["there_are_currently"].." "..totalReports.." "..lang["active_reports"],"RAFontLog",160,35,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end

		RAFNotiHub = vgui.Create( "DPanel", RAFNoti)
			RAFNotiHub:Dock( FILL )
			RAFNotiHub:SetSize(320,255)
			RAFNotiHub:DockMargin( 0, 50, 0, 0 )
			RAFNotiHub.Paint = function() end

		for _, v in pairs(ReportInfo) do
			reportNotification(v)
		end
	end
end)

nMsg.Receive("removeNoti",function() -- recieves message from server 
	local reportCompleted = nMsg.ReadString()

	if #logNotifications == 1 then -- if there is only 1 report active, it knows it needs to delete one so it closes the entire notifaction system
		if IsValid(RAFNoti) then
			RAFNoti:Remove()
			logNotifications = {} -- remove report from database *by resetting it
		end
	else
		totalReports = totalReports - 1
		if IsValid(RAFNoti) then
			logNotifications[reportCompleted][1]:Remove()
			logNotifications[reportCompleted] = nil -- removes report from database
		end
	end
end)

-----------------------------------------------------------------------------------

nMsg.Receive("viewStaffStats",function()
	local StaffStatsTable = nMsg.ReadTable()

	local lastVisit = lang["click_a_staff"]
	local staffData = lang["click_a_staff"]
	local wSmall = 0

	if #StaffStatsTable > 4 then
		wSmall = 20
	end

	local RAFAdminStats = vgui.Create("DFrame")
		RAFAdminStats:SetSize(600,598)
		RAFAdminStats:SetPos(ScrW()/2-300,ScrH()/2-300)
		RAFAdminStats:SetVisible(true)
		RAFAdminStats:SetDraggable(true)
		RAFAdminStats:ShowCloseButton(false)
		RAFAdminStats:MakePopup()
		RAFAdminStats:SetTitle("")
		RAFAdminStats.Paint = function(_,w)
			drawRBox(0,0,30, w, 570, colorDDB)
			drawRBox(0,0,0, w, 58, colorHead)
			drawRBox(0,0,56, w, 2, colorTB)
			drawRBox(0,10,95,60,124,colorMBC)
			drawRBox(0,70,95,170-wSmall,124,colorDB)
			drawRBox(0,240-wSmall,95,60,124,colorMBC)
			drawRBox(0,300-wSmall,95,60,124,colorDB)
			drawRBox(0,360-wSmall,95,60,124,colorMBC)
			drawRBox(0,420-wSmall,95,60,124,colorDB)
			drawRBox(0,480-wSmall,95,110,124,colorMBC)
			drawRBox(0,10,65,60,30,colorLB)
			drawRBox(0,70,65,170-wSmall,30,colorOB)		
			drawRBox(0,240-wSmall,65,60,30,colorLB)
			drawRBox(0,300-wSmall,65,60,30,colorOB)		
			drawRBox(0,360-wSmall,65,60,30,colorLB)
			drawRBox(0,420-wSmall,65,60,30,colorOB)	
			drawRBox(0,480-wSmall,65,110+wSmall,30,colorLB)
			drawRBox(0,10,93,580,2,colorTB)

			drawRBox(0,10,225,80,25,colorLB)
			drawRBox(0,90,225,250,25,colorG)
			drawRBox(0,340,225,250,25,colorCONC)
			drawRBox(0,10,248,580,2,colorTB)			

			drawRBox(0,10,255,580,280,colorMBC)	
			drawTxt("Жалобы","RAFont",300,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt("ID","RAFontLog",15,80,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["staff"],"RAFontLog",75,80,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["closed"],"RAFontLog",270-wSmall,80,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt(lang["score"],"RAFontLog",330-wSmall,80,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt(lang["reviews2"],"RAFontLog",390-wSmall,80,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt(lang["trends"],"RAFontLog",450-wSmall,80,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			drawTxt(lang["staff_info"].." ","RAFont",15,237,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["last_visit"].." "..lastVisit,"RAFont",95,237,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			drawTxt(lang["total_time"].." "..staffData,"RAFont",345,237,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end

	local RAFClose = vgui.Create("DButton", RAFAdminStats)
		RAFClose:SetPos(555,8)
		RAFClose:SetSize(60,30)
		RAFClose:SetText("")
		RAFClose.Paint = function ()
			drawRBox(0,22.5,0,15,3, colorW)
			drawRBox(0,22.5,6,15,3, colorW)
			drawRBox(0,22.5,12,15,3, colorW)
		end
		RAFClose.DoClick = function()
			RAFAdminStats:Remove()
		end

	local RAFSTATSSCROLLBAR = vgui.Create("DScrollPanel", RAFAdminStats)
		RAFSTATSSCROLLBAR:SetSize(580,120)
		RAFSTATSSCROLLBAR:SetPos(10,100)
					
		local RAFSTATSCOLORBAR = RAFSTATSSCROLLBAR:GetVBar()
			function RAFSTATSCOLORBAR:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorTB )
			end
			function RAFSTATSCOLORBAR.btnUp:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFSTATSCOLORBAR.btnDown:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFSTATSCOLORBAR.btnGrip:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSG )
			end

		local RAFSTATBAR = vgui.Create( "DHorizontalScroller", RAFSTATSSCROLLBAR )
			RAFSTATBAR:SetPos(0,0)
			RAFSTATBAR:SetSize( 50,50 )
			function RAFSTATBAR.btnLeft:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorNS )
			end
			function RAFSTATBAR.btnRight:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorMWC )
			end

		local RAFSTATLIST = vgui.Create("DListLayout", RAFSTATSSCROLLBAR)
			RAFSTATLIST:SetPos(0,0)
			RAFSTATLIST:SetSize(580,3840)
			for k, v in pairs(StaffStatsTable) do
				local RAFSTATBOX = vgui.Create("DButton", RAFSTATLIST)
					RAFSTATBOX:SetSize(580,30)
					RAFSTATBOX:SetText("")
					local nameLength = string.len(v["playerName"])
					local playerName = v["playerName"]
					local rating = math.Round(v["rating"],2)
					local previousScore = 0

					if nameLength > 14 then
						playerName = (string.sub(v["playerName"],1,12).."...")
					end

					if v["previousScore"] < v["reportsCompleted"] then
						previousScore = v["reportsCompleted"] - v["previousScore"]
					elseif v["previousScore"] > v["reportsCompleted"] then
						previousScore = v["reportsCompleted"] + -v["previousScore"]
					end

					RAFSTATBOX.Paint = function(self, w)
						if highlighted == self then
							drawRBoxEx(4,0,0,w-wSmall,28,colorFG,false,false,false,false)
							drawRBox(0,0,26,580-wSmall,2,colorTB)
						else
							drawRBox(0,0,0,60,28,colorG)
							drawRBox(0,60,0,170-wSmall,28,colorCONC)		
							drawRBox(0,230-wSmall,0,60,28,colorG)
							drawRBox(0,290-wSmall,0,60,28,colorCONC)		
							drawRBox(0,350-wSmall,0,60,28,colorG)
							drawRBox(0,410-wSmall,0,60,28,colorCONC)	
							drawRBox(0,470-wSmall,0,110,28,colorG)
							drawRBox(0,0,26,580-wSmall,2,colorTB)
						end
						drawTxt(k,"RAFont",5,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						drawTxt(playerName,"RAFont",65,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						drawTxt(v["reportsCompleted"],"RAFont",260-wSmall,13,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						drawTxt(rating,"RAFont",320-wSmall,13,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						drawTxt(v["reviews"],"RAFont",380-wSmall,13,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						drawTxt(previousScore,"RAFont",415-wSmall,13,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					end
					RAFSTATBOX.DoClick = function(self)
						highlighted = self

						lastVisit = tostring(v["lastvisit"])
						staffData = tostring(v["totaltime"])
					end

				local RAFCompairson = vgui.Create("DImage",RAFSTATBOX)
					RAFCompairson:SetPos(445-wSmall,4)
					RAFCompairson:SetSize(20,20)
					RAFCompairson:SetImage("straightarrow.png")
					if v["previousScore"] < v["reportsCompleted"] then
						RAFCompairson:SetImage("rauparrow.png")
					elseif v["previousScore"] > v["reportsCompleted"] then
						RAFCompairson:SetImage("radownarrow.png")
					else
						RAFCompairson:SetImage("straightarrow.png")
					end

				if isSuperAdmin(LocalPlayer()) == true then
					local DeleteStaff = vgui.Create("DButton", RAFSTATBOX)
						DeleteStaff:SetPos(475-wSmall,4)
						DeleteStaff:SetSize(100,20)
						DeleteStaff:SetText("")
						DeleteStaff.Paint = function(_,w,h)
							drawRBox(0,0,0,w,h,colorFR)
							drawRBox(0,0,h-2,w,2,colorTB)
							drawTxt(lang["remove_staff"],"RAFont",w/2,9,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
						DeleteStaff.DoClick = function()
							RAFAdminStats:SetVisible(false)

							local SafetyCheck = vgui.Create("DFrame")
								SafetyCheck:SetPos(ScrW()/2-80,ScrH()/2-32.5)
								SafetyCheck:SetSize(160,65)
								SafetyCheck:MakePopup(true)
								SafetyCheck:ShowCloseButton(false)
								SafetyCheck:SetTitle("")
								SafetyCheck.Paint = function(s,w,h)
									drawRBoxEx(4,0,0, 160, 30, colorG, true, true, false, false) -- Draw box
									drawRBoxEx(4,0,30, 160, 35, colorDB, false, false, true, true)	 -- Draw box
									drawTxt(lang["are_you_sure"],"RAFont",70,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)				
								end

							local SafetyCheckButton1 = vgui.Create("DButton", SafetyCheck)
								SafetyCheckButton1:SetPos(10,35)
								SafetyCheckButton1:SetSize(65,25)
								SafetyCheckButton1:SetText(lang["yes"])
								SafetyCheckButton1.DoClick = function()
									nMsg.Start("deleteStaffPlayer")
										nMsg.WriteString(v["player"])
									nMsg.SendToServer()

									RAFAdminStats:Remove()
									SafetyCheck:Remove()

									nMsg.Start("loadStaffStats")
									nMsg.SendToServer()
								end

							local SafetyCheckButton2 = vgui.Create("DButton", SafetyCheck)
								SafetyCheckButton2:SetPos(80,35)
								SafetyCheckButton2:SetSize(65,25)
								SafetyCheckButton2:SetText(lang["no"])
								SafetyCheckButton2.DoClick = function()
									RAFAdminStats:SetVisible(true)
									SafetyCheck:Remove()
								end

							local RAFCloseSafe = vgui.Create ("DButton", SafetyCheck)
								RAFCloseSafe:SetPos(110,8)
								RAFCloseSafe:SetSize(60,30)
								RAFCloseSafe:SetText("")
								RAFCloseSafe.Paint = function (s, w, h)
									drawRBoxEx(0,22.5,0,15,3,colorW,true,true,true,true)
									drawRBoxEx(0,22.5,0+6,15,3,colorW,true,true,true,true)
									drawRBoxEx(0,22.5,0+12,15,3,colorW,true,true,true,true)
								end
								RAFCloseSafe.DoClick = function()
									RAFAdminStats:SetVisible(true)
									SafetyCheck:Remove()
								end
						end
					end
			end

	if StaffStatsTable[1] != nil then
		dynchange = 250 / StaffStatsTable[1]["reportsCompleted"]
		dynwidth = (500 - ((#StaffStatsTable - 1) * 5)) / #StaffStatsTable

		local StaffBarChart = vgui.Create("DPanel", RAFAdminStats)
			StaffBarChart:SetPos(10,262)
			StaffBarChart:SetSize(580,275)
			StaffBarChart.Paint = function(s,w,h)
				drawTxt(StaffStatsTable[1]["reportsCompleted"],"RAFont",33,0,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
				drawTxt(StaffStatsTable[1]["reportsCompleted"]/2,"RAFont",33,125,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt(StaffStatsTable[1]["reportsCompleted"]/4,"RAFont",33,187.5,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt(StaffStatsTable[1]["reportsCompleted"]/2 + StaffStatsTable[1]["reportsCompleted"]/4,"RAFont",33,62.5,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt("0","RAFont",33,257,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
				xaxis = 70
				for k, v in pairs(StaffStatsTable) do
					drawRBoxEx(0,xaxis,250-v["reportsCompleted"]*dynchange,dynwidth,v["reportsCompleted"]*dynchange,colorG,false,false,false,false) -- Draw box
					drawTxt(k,"RAFont",xaxis + (dynwidth/2),270,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
					xaxis = xaxis + dynwidth + 5
				end
				surface.SetDrawColor( 255, 255, 255, 255 )
				drawLine(70, 248, 70, 0)
				drawLine(70, 249, 569, 249)
			end
	else
		local StaffBarChart = vgui.Create("DLabel", RAFAdminStats)
			StaffBarChart:SetPos(0,260)
			StaffBarChart:SetSize(600,280)
			StaffBarChart:SetText("")
			StaffBarChart.Paint = function(s,w,h)
				drawTxt(lang["you_need_staff_to_display_the_graph"],"RAFont",300,140,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end	
	end

	local RAFReturnAdminPanel = vgui.Create("DButton", RAFAdminStats)
		RAFReturnAdminPanel:SetPos(10,540)
		RAFReturnAdminPanel:SetSize(415,50)
		RAFReturnAdminPanel:SetText("")
		RAFReturnAdminPanel.Paint = function(s,w,h)
			drawRBox(0,0,0,w,h,colorFG)
			drawRBox(0,0,h-2,w,2,colorTB)
			drawTxt(lang["return"],"RAFont",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)		
		end
		RAFReturnAdminPanel.DoClick = function()
			nMsg.Start("reBootReportAdminMenu") -- Sends message to server
			nMsg.SendToServer()

			RAFAdminStats:Remove()
		end

	if isSuperAdmin(LocalPlayer()) == true then
		local RAFNextMeet = vgui.Create("DButton", RAFAdminStats)
			RAFNextMeet:SetPos(430,540)
			RAFNextMeet:SetSize(160,50)
			RAFNextMeet:SetText("")
			RAFNextMeet.Paint = function(_,w,h)
				drawRBox(0,0,0,w,h,colorFR)
				drawRBox(0,0,h-2,w,2,colorTB)
				drawTxt(lang["next_week"],"RAFont",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)		
			end
			RAFNextMeet.DoClick = function()
				RAFAdminStats:SetVisible(false)

				local SafetyCheck = vgui.Create("DFrame")
					SafetyCheck:SetPos(ScrW()/2-80,ScrH()/2-32.5)
					SafetyCheck:SetSize(160,65)
					SafetyCheck:MakePopup(true)
					SafetyCheck:ShowCloseButton(false)
					SafetyCheck:SetTitle("")
					SafetyCheck.Paint = function(s,w,h)
						drawRBoxEx(4,0,0, 160, 30, colorG, true, true, false, false) -- Draw box
						drawRBoxEx(4,0,30, 160, 35, colorDB, false, false, true, true)	 -- Draw box
						drawTxt(lang["are_you_sure"],"RAFont",70,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)				
					end

					local SafetyCheckButton1 = vgui.Create("DButton", SafetyCheck)
						SafetyCheckButton1:SetPos(10,35)
						SafetyCheckButton1:SetSize(65,25)
						SafetyCheckButton1:SetText(lang["yes"])
						SafetyCheckButton1.DoClick = function()
							nMsg.Start("nextWeekTime") -- Sends message to server
							nMsg.SendToServer()

							RAFAdminStats:Remove()
							SafetyCheck:Remove()

							nMsg.Start("loadStaffStats") -- Sends message to server
							nMsg.SendToServer()
						end

					local SafetyCheckButton2 = vgui.Create("DButton", SafetyCheck)
						SafetyCheckButton2:SetPos(80,35)
						SafetyCheckButton2:SetSize(65,25)
						SafetyCheckButton2:SetText(lang["no"])
						SafetyCheckButton2.DoClick = function()
							RAFAdminStats:SetVisible(true)
							SafetyCheck:Remove()
						end

					local RAFCloseSafe = vgui.Create ("DButton", SafetyCheck)
						RAFCloseSafe:SetPos(110,8)
						RAFCloseSafe:SetSize(60,30)
						RAFCloseSafe:SetText("")
						RAFCloseSafe.Paint = function (s, w, h)
							drawRBoxEx(0,22.5,0,15,3, colorW,true,true,true,true) -- Draw box
							drawRBoxEx(0,22.5,0+6,15,3, colorW,true,true,true,true) -- Draw box
							drawRBoxEx(0,22.5,0+12,15,3, colorW,true,true,true,true) -- Draw box
						end
						RAFCloseSafe.DoClick = function()
							RAFAdminStats:SetVisible(true)
							SafetyCheck:Remove()
						end
			end
	end
end)

------------------------------------------------------------------------------------------------------------

nMsg.Receive("sendLogs",function() -- recieves message from server 
	if IsValid(RAFRunway) then
		RAFRunway:Remove()
	end

	local reportText = net.ReadString() -- sends report default text
	local reportSizePos = net.ReadInt(4) -- sends size and position -- KEY: 1 = Small size, unclaimed    | 2 = Large size, unclaimed  |  3 = Small size, claimed   |  4 = Large size, claimed  | 5 = Standelone
	local reportMode = net.ReadInt(3) -- sends logger mode       -- KEY: 1 = Coming from report menu  | 2 = Standelone logger
	local activeLogger = "chat"

	RAFLOGDEBUG = vgui.Create( "DFrame")
		RAFLOGDEBUG:SetSize(600, 525)
		if reportSizePos == 1 then
			RAFLOGDEBUG:SetSize(600,345)
			RAFLOGDEBUG:SetPos(ScrW()/2+10,ScrH()/2-300)
		elseif reportSizePos == 2 then
			RAFLOGDEBUG:SetPos(ScrW()/2+10,ScrH()/2-300)
		elseif reportSizePos == 3 then
			RAFLOGDEBUG:SetSize(600,345)
			RAFLOGDEBUG:AlignRight(50)
			RAFLOGDEBUG:AlignTop(50)
		elseif reportSizePos == 4 then
			RAFLOGDEBUG:AlignRight(50)
			RAFLOGDEBUG:AlignTop(50)
		elseif reportSizePos == 5 then
			RAFLOGDEBUG:SetSize(600,490)
			RAFLOGDEBUG:Center()
		end

		RAFLOGDEBUG:SetVisible(true)
		RAFLOGDEBUG:SetDraggable(true)
		RAFLOGDEBUG:ShowCloseButton(false)
		RAFLOGDEBUG:MakePopup()
		RAFLOGDEBUG:SetTitle("")
		RAFLOGDEBUG.Paint = function(self, w, h)
			if reportconfig.blurTheme == true then 
				DrawBlur(self, 2) 
				surface.SetDrawColor(0,0,0,150)
				drawLine(0, 30, 0, 344)
				drawLine(599, 30, 599, 344)
				drawLine(0, 344, 600, 344)
			else 
				drawRBoxEx(4,0,30, w, h, colorDB, false, false, true, true) -- Draw box
			end 			
			drawRBoxEx(0,0,0, w, 30, colorHead, false, false, false, false)
			drawRBoxEx(0,0,28,w,2,colorTB,false,false,false,false)
			drawTxt("Жалобы","RAFont",300,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end

	local RAFCloseLogs = vgui.Create ("DButton", RAFLOGDEBUG)
		RAFCloseLogs:SetPos(550,8)
		RAFCloseLogs:SetSize(60,30)
		RAFCloseLogs:SetText("")
		RAFCloseLogs.Paint = function (s, w, h)
			drawRBoxEx(0,22.5,0,15,3, colorW,true,true,true,true) -- Draw box
			drawRBoxEx(0,22.5,0+6,15,3, colorW,true,true,true,true) -- Draw box
			drawRBoxEx(0,22.5,0+12,15,3, colorW,true,true,true,true) -- Draw box
		end
		RAFCloseLogs.DoClick = function()
			gui.EnableScreenClicker(false)

			if IsValid(RAReportDetails) then
				RAReportDetails:Remove()
			end

			RAFLOGDEBUG:Remove()
		end		

	if reportMode == 1 then
		local RAFRETURNINFO = vgui.Create( "DButton", RAFLOGDEBUG )
			RAFRETURNINFO:SetPos(5,315)
			RAFRETURNINFO:SetSize(105,25)
			if reportSizePos == 2 or reportSizePos == 4 then
				RAFRETURNINFO:SetPos(5,490)
				RAFRETURNINFO:SetSize(105,30)
			end
			RAFRETURNINFO:SetText("")
			RAFRETURNINFO.Paint = function(s,w,h)
				drawRBoxEx(0,0,0,w,h,colorG,false,false,false,false) -- Draw box
				drawTxt(lang["view_details"],"RAFontLog",w/2,h/2,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			RAFRETURNINFO.DoClick = function()
				RAReportDetails:SetVisible(true)

				RAFLOGDEBUG:Remove()
			end
	end

	local extraH = 0
	local extraW = 0
	local extraLH = 0

	if reportSizePos == 2 or reportSizePos == 4 or reportSizePos == 5 then
		extraH = 145
		extraLH = 180
		extraW = 20
	end

	local logNames = {[1] = {"chat", "Chat"}, [2] = {"conn", "Connection"}, [3] = {"disconn", "Disconnections"}, [4] = {"props", "Props"}, [5] = {"kill", "Kills"}, [6] = {"dama", "Damage"}, [7] = {"tool", "Tools"}}
	local darkrpLogNames = {[8] = {"teamChange", "Job change"}, [9] = {"warranted", "Waranted"}, [10] = {"wanted", "Wanted"}, [11] = {"wallet", "Money"}, [12] = {"arrested", "Arrested"}}

	local RAFLogsScrollBar = vgui.Create("DScrollPanel", RAFLOGDEBUG)
			RAFLogsScrollBar:SetSize(105,240+extraLH)
			RAFLogsScrollBar:SetPos(5,70)
			
		local RAFScrollBarColors = RAFLogsScrollBar:GetVBar()
			function RAFScrollBarColors:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorTB )
			end
			function RAFScrollBarColors.btnUp:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFScrollBarColors.btnDown:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
			end
			function RAFScrollBarColors.btnGrip:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, colorSG )
			end

	local RALogTypeHub = vgui.Create("DListLayout", RAFLogsScrollBar)
		RALogTypeHub:SetPos(0,0)
		RALogTypeHub:SetSize(85+extraW,500)

	local function newLogButton(v)
		local RAFLOGSOPTION = vgui.Create( "DButton", RALogTypeHub)
			RAFLOGSOPTION:SetSize(85+extraW,30)
			RAFLOGSOPTION:SetText("")
			RAFLOGSOPTION:DockMargin(0,0,0,5)
			RAFLOGSOPTION.Paint = function(_,w,h)
				drawRBoxEx(0,0,0,w,h,colorG,false,false,false,false)
				drawTxt(v[2],"TinyRAFont",w/2,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)				
			end
			RAFLOGSOPTION.DoClick = function()
				activeLogger = v[1]

				nMsg.Start("logLoader")
					nMsg.WriteString(RAFTextEntry:GetValue())
					nMsg.WriteString(v[1])
				nMsg.SendToServer()
			end
	end

	for _, v in pairs(logNames) do
		newLogButton(v)
	end

	if reportconfig.DarkRPLogs == true then
		for _, v in pairs(darkrpLogNames) do
			newLogButton(v)
		end
	end

	RAFTextEntry = vgui.Create( "DTextEntry", RAFLOGDEBUG )
		RAFTextEntry:SetPos( 5, 35 )
		RAFTextEntry:SetSize( 105,30 )
		RAFTextEntry:SetFont( "MiniRAFont" )
		RAFTextEntry:SetTextColor(colorB)
		if reportMode == 1 then
			RAFTextEntry:SetValue(reportText)
		else
			RAFTextEntry:SetValue("Поиск...")
		end
		RAFTextEntry.OnEnter = function()
			nMsg.Start("logLoader") -- Sends message to server
				nMsg.WriteString(RAFTextEntry:GetValue())
				nMsg.WriteString(activeLogger)
			nMsg.SendToServer()
		end

	nMsg.Receive("logStuff",function() -- Recieving message from server
		local logger = nMsg.ReadTable()
		local logType = nMsg.ReadString()
		local logSearch = nMsg.ReadString()

		if IsValid(RAFLOGBAR) then
			RAFLOGBAR:Remove() 
		end

		RAFLOGBAR = vgui.Create("DScrollPanel", RAFLOGDEBUG)
			RAFLOGBAR:SetSize(480,305+extraH)
			RAFLOGBAR:SetPos(115,35)
					
			local RAFLOGBARDES = RAFLOGBAR:GetVBar()
				function RAFLOGBARDES:Paint( w, h ) -- Colours scroll bar
					draw.RoundedBox( 0, 0, 0, w, h, colorTB )
				end
				function RAFLOGBARDES.btnUp:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
				end
				function RAFLOGBARDES.btnDown:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
				end
				function RAFLOGBARDES.btnGrip:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSG )
				end

				local lotsOfLogs = 0
			
				if #logger > 11 then
					lotsOfLogs = 20
				end

				local RAFLOGLIST = vgui.Create("DListLayout", RAFLOGBAR)
					RAFLOGLIST:SetPos(0,0)
					RAFLOGLIST:SetSize(485-lotsOfLogs,3840)
					for k, v in pairs(logger) do
						local logInfo = ""

						if logType == "chat" then
							logInfo = (v["time"] .. " | " ..v["playername"].." "..lang["said"].." "..v["datatwo"]..'"')
						elseif logType == "conn" then
							logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["connected"])
						elseif logType == "disconn" then
							logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["discon"])
						elseif logType == "props" then
							logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["spawned"].." ".. v["datatwo"])
						elseif logType == "kill" then
							if v["playername"] == v["datathree"] then
								logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["killed_himself"])
							else
								logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["killed_by"].." ".. v["datathree"].." " .. lang["with"].." ".. v["datatwo"])
							end
						elseif logType == "dama" then
							logInfo = (v["time"] .. " | " .. v["playername"].." "..lang["took"].." ".. v["datathree"] .." ".. lang["damage_from"].." "..v["datatwo"])
						elseif logType == "tool" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["used_the"].." " ..v["datathree"].." "..lang["tool"].." "..v["datatwo"])
						elseif logType == "teamChange" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["changed_from"] .." "..v["datatwo"].." "..lang["to"].." "..v["datathree"])
						elseif logType == "warranted" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["warranted"].." " ..v["datatwo"].." "..lang["for"].." "..v["datathree"])
						elseif logType == "wanted" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["wanted"] ..v["datathree"].." "..lang["for"].." "..v["datatwo"])
						elseif logType == "wallet" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["money_changed_by"].." " ..v["datatwo"])
						elseif logType == "arrested" then
							logInfo = (v["time"] .. " | " .. v["playername"].." ".. lang["arrested"].." " ..v["datatwo"])
						end

						local singleLog = vgui.Create("RichText", RAFLOGLIST)
							singleLog:SetSize(30, 40)
							singleLog:AppendText(logInfo)
							singleLog.PerformLayout = function( self )
								self:SetFontInternal("RAFontLog")
								self:SetFGColor(colorW)
							end
					end
	end)

	if reportMode == 1 then
		nMsg.Start("logLoader") -- Sends message to server
			nMsg.WriteString(reportText)
			nMsg.WriteString("chat")
		nMsg.SendToServer()
	else
		nMsg.Start("logLoader") -- Sends message to server
			nMsg.WriteString("")
			nMsg.WriteString("chat")
		nMsg.SendToServer()		
	end
end)

nMsg.Receive("reportHistory",function() -- recieves message from server 
	local reportHistory = nMsg.ReadTable()

	local function reportHistoryList()
		RARScrolley = vgui.Create("DScrollPanel", RARHistory)
				RARScrolley:SetSize(1180,440)
				RARScrolley:SetPos(10,110)
				
			local RAFHarrow = RARScrolley:GetVBar()
				function RAFHarrow:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorTB )
				end
				function RAFHarrow.btnUp:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
				end
				function RAFHarrow.btnDown:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSBB )
				end
				function RAFHarrow.btnGrip:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, colorSG )
				end

			local RARHistoryHub = vgui.Create("DListLayout", RARScrolley)
				RARHistoryHub:SetPos(0,0)
				RARHistoryHub:SetSize(1180,560) -- 3840 as that's the equivalent to 128 players
				for _, v in pairs(reportHistory) do
					local RAFHistoryReport = vgui.Create("DPanel", RARHistoryHub)
						RAFHistoryReport:SetSize(1180,40)
						RAFHistoryReport:SetText("")
						RAFHistoryReport.Paint = function()
							drawTxt(v["playerReported"],"RAFont",5,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
							drawTxt(v["playerReporter"],"RAFont",195,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
							drawTxt(v["reportWinner"],"RAFont",395,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
							drawTxt(v["reason"],"RAFont",595,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
							drawTxt(v["time"],"RAFontLog",995,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
							drawTxt(v["handler"],"RAFont",795,20,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
							surface.SetDrawColor(255,255,255,255)
							drawLine(0,39,1159,39)
							drawLine(190,0,190,39)
							drawLine(390,0,390,39)
							drawLine(590,0,590,39)
							drawLine(790,0,790,39)
							drawLine(990,0,990,39)
							drawLine(0,0,0,40)
							drawLine(1159,0,1159,39)
						end
				end
	end

	if IsValid(RARHistory) then 
		RARScrolley:Remove()

		reportHistoryList()
	else
		local resNum = 0
		local resNumVis = resNum + 1
		local largeResNum = 50

		RARHistory = vgui.Create( "DFrame" )
			RARHistory:SetSize(1200,600)
			RARHistory:Center()
			RARHistory:MakePopup()
			RARHistory:SetTitle("")
			RARHistory.Paint = function(_, w)
				drawRBoxEx(4,0,0, w, 30, colorG, true, true, false, false)
				drawRBoxEx(4,0,30, w, 570, colorDB, false, false, true, true)
				drawTxt(lang["report_history"],"RAFont",w/2,15,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				drawTxt(lang["reporter"],"RAFont",15,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["reported"],"RAFont",205,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["winner"],"RAFont",405,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["reason2"],"RAFont",605,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["date"],"RAFont",1005,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["handler"],"RAFont",805,90,colorW,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				drawTxt(lang["showing_results"].." "..resNumVis.." - "..largeResNum.."","RAFont",600,570,colorW,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				surface.SetDrawColor(255,255,255,255)
				drawLine(10,70,1169,70)
				drawLine(10,110,1169,110)
				drawLine(10,70,10,110)
				drawLine(1169,70,1169,110)
				drawLine(200,70,200,110)
				drawLine(400,70,400,110)
				drawLine(600,70,600,110)
				drawLine(800,70,800,110)
				drawLine(1000,70,1000,110)
			end

		local RAHistorySearch = vgui.Create( "DTextEntry", RARHistory )
			RAHistorySearch:SetPos( 10, 35 )
			RAHistorySearch:SetSize( 190, 30 )
			RAHistorySearch:SetFont( "RAFont" )
			RAHistorySearch:SetTextColor(colorB)
			RAHistorySearch:SetValue(lang["search_for_handler"])
			RAHistorySearch.OnEnter = function(self)
				nMsg.Start("reprotHistorySearcher") -- Sends message to server
					nMsg.WriteString(self:GetValue())
				nMsg.SendToServer()
			end

		local dLastPage = vgui.Create("DButton", RARHistory)
			dLastPage:SetPos(300,555)
			dLastPage:SetSize(200,35)
			dLastPage:SetText("<<")	
			dLastPage.DoClick = function()
				resNum = resNum - 50
				resNumVis = resNum + 1
				largeResNum = largeResNum - 50
				nMsg.Start("loadHistoryPage")
					nMsg.WriteDouble(resNum)
				nMsg.SendToServer()
			end		

		local dNextPage = vgui.Create("DButton", RARHistory)
			dNextPage:SetPos(700,555)
			dNextPage:SetSize(200,35)
			dNextPage:SetText(">>")
			dNextPage.DoClick = function()
				resNum = resNum + 50
				resNumVis = resNum + 1
				largeResNum = largeResNum + 50
				nMsg.Start("loadHistoryPage") -- Sends message to server
					nMsg.WriteDouble(resNum)
				nMsg.SendToServer()
			end

		reportHistoryList()
	end
end)

local firstLog = 0
local lastLog = 49

net.Receive("warnPanel",function()
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
		
			if string.len(warned) > 13 then -- maybe for loop?
				warned = (string.sub(warned, 1, 14).."...")
			end

			if string.len(warner) > 13 then -- maybe for loop?
				warner = (string.sub(warner, 1, 14).."...")
			end

			if string.len(warnReason) > 17-lenShrink then -- maybe for loop?
				warnReason = (string.sub(warnReason, 1, 18-lenShrink).."...")
			end

			RAWarn:SetSize(790-wShirnk,40)
			RAWarn:SetText("")
			RAWarn.Paint = function()
				drawRBox(0,0,0,150,35,colorG)
				drawRBox(0,150,0,150,35,colorCONC)
				drawRBox(0,300,0,150,35,colorG)
				drawRBox(0,450,0,190-wShirnk,35,colorCONC)					
				drawRBox(0,640-wShirnk,0,150,35,colorG)
				drawRBox(0,0,33,790,2,colorTB)					
				drawTxt(string.sub(warn["warnTime"],1,8), "RAFont", 75, 10, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				drawTxt(string.sub(warn["warnTime"],14,21), "RAFontLog", 75, 25, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				drawTxt(warned, "RAFont", 155, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				drawTxt(warner, "RAFont", 305, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				drawTxt(warnReason, "RAFont", 455, 15, colorW, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)			
			end
			RAWarn.DoClick = function()
				RAWarnListScrollBar:SetSize(790,275)

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
					RAWarnRichTextNote:SetPos(3,45)
					RAWarnRichTextNote:SetSize(790,30)
					RAWarnRichTextNote:SetFontInternal("RAFOverKill" )
					RAWarnRichTextNote:InsertColorChange(255,255,255,255)
					RAWarnRichTextNote:AppendText(lang["reason"].." "..warn["warnReason"])
			end

			local RAWarnDelete = vgui.Create("DButton", RAWarn)
				RAWarnDelete:SetPos(645-wShirnk,5)
				RAWarnDelete:SetSize(140, 25)
				RAWarnDelete:SetText("")
				RAWarnDelete.Paint = function(_, w, h)
					drawRBox(0,0,0,w,h,colorHead)
					drawRBox(0,0,23,w,2,colorTB)
					drawTxt(lang["delete_warn"], "RAFont", w/2, 12, colorW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
				end
				RAWarnDelete.DoClick = function()
					RAWarn:Remove()

					currentWarns = currentWarns - 1

					net.Start("RAdeleteWarn")
						net.WriteInt(warn["rowid"], 32)
					net.SendToServer()
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
		RAWarnMenu = vgui.Create( "DFrame" ) -- Makes admin interface
			RAWarnMenu:SetSize(800,500) -- Sets size of interface
			RAWarnMenu:SetPos(ScrW()/2-400,ScrH()/2-250) -- Set's position of interface
			RAWarnMenu:SetVisible(true) -- Makes sure it's visible
			RAWarnMenu:SetDraggable(true) -- Enables dragability
			RAWarnMenu:ShowCloseButton(false) -- Disables default close button (its ugly)
			RAWarnMenu:MakePopup() -- Makes popup
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
				drawRBox(0,455,65,190-wShirnk,35,colorOB)
				drawRBox(0,645-wShirnk,65,150+wShirnk,35,colorLB)
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

		local RASearchBar = vgui.Create("DTextEntry", RAWarnMenu)
			RASearchBar:SetPos(650-wShirnk,70)
			RASearchBar:SetSize(140+wShirnk,25)
			RASearchBar:SetValue("Search...")
			RASearchBar:SetFont("RAFont")
			RASearchBar.OnEnter = function(self)
				net.Start("warnPanelSearch")
					net.WriteString(self:GetValue())
					net.WriteDouble(firstLog)
					net.WriteDouble(lastLog)
				net.SendToServer()
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

				net.Start("warnPanelSearch")
					net.WriteString(RASearchBar:GetValue())
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

				net.Start("warnPanelSearch")
					net.WriteString(RASearchBar:GetValue())
					net.WriteDouble(firstLog)
					net.WriteDouble(lastLog)
				net.SendToServer()
			end
	end
end)


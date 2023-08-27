

local net = net
local netStart = net.Start
local netSend = net.Send
local netReceive = net.Receive
local netBroadcast = net.Broadcast
local netWriteTable = net.WriteTable
local netWriteInt = net.WriteInt
local netWriteString = net.WriteString
local netWriteBool = net.WriteBool
local netReadString = net.ReadString
local netReadInt = net.ReadInt
local netReadBool = net.ReadBool
local netReadType = net.ReadType
local netReadDouble = net.ReadDouble

local util = util
local utilAddNetworkString = util.AddNetworkString
local utilJSONToTable = util.JSONToTable

local os = os
local osdate = os.date

local sql = sql
local sqlSQLStr = sql.SQLStr
local sqlQuery = sql.Query
local sqlQueryValue = sql.QueryValue

local table = table
local tableinsert = table.insert
local tableremove = table.remove
local tableReverse = table.Reverse
local tableconcat = table.concat
local tableHasValue = table.HasValue

local player = player
local playerGetAll = player.GetAll

local hook = hook
local hookAdd = hook.Add

local string = string
local stringsub = string.sub
local stringlen = string.len
local stringlower = string.lower
local stringSplit = string.Split
local stringmatch = string.match

local file = file
local fileRead = file.Read
local fileDelete = file.Delete

local team = team
local teamGetName = team.GetName

local timer = timer
local timerCreate = timer.Create

local resource = resource
local resourceAddFile = resource.AddFile

local include = include
local tostring = tostring
local IsValid = IsValid
local Nick = Nick
local pairs = pairs
local SteamID64 = SteamID64
local tonumber = tonumber
local ChatPrint = ChatPrint
local GetUserGroup = GetUserGroup
local IsPlayer = IsPlayer
local GetActiveWeapon = GetActiveWeapon
local GetClass = GetClass
local GetAttacker = GetAttacker
local GetDamage = GetDamage

-------------------------------------------------------------------------------

include("autorun/ra_config.lua")
include("autorun/server/ra_sql.lua")

-------------------------------------------------------------------------------

local reportAddonFuncs = {}
local recentReporters = {}
local lang = BigLanguage
local checkTime = reportconfig.staffTotalTimeUpdator

-------------------------------------------------------------------------------

---------------ADMIN MENU-------------------
utilAddNetworkString("bootReportAdminMenu")
utilAddNetworkString("reBootReportAdminMenu")
---------------STAFF STATS---------
utilAddNetworkString("loadStaffStats")
utilAddNetworkString("viewStaffStats")
utilAddNetworkString("deleteStaffPlayer")
utilAddNetworkString("nextWeekTime")
---------------VIEWING REPORT DETAILS-----------------
utilAddNetworkString("reportDetails")
utilAddNetworkString("loadBaiscReportDetail")
utilAddNetworkString("loadExtraReportDetail")
utilAddNetworkString("reportExtraDetails")
---------------REPORT PROCESS-----------------
utilAddNetworkString("bootReportMenu")
utilAddNetworkString("newReport")
utilAddNetworkString("reportClaimed")
utilAddNetworkString("checkReportHandler")
utilAddNetworkString("reportCompleted")
utilAddNetworkString("playerRating")
utilAddNetworkString("playerRatingReview")
utilAddNetworkString("reportDeleted")
utilAddNetworkString("deleteAllReports")
--------------REPORT NOTIFICATIONS------------------
utilAddNetworkString("newReportNoti")
utilAddNetworkString("removeNoti")
----------------REPORT HISTORY----------------
utilAddNetworkString("reportHistory")
utilAddNetworkString("reprotHistorySearcher")
utilAddNetworkString("loadHistoryPage")
----------------LOGGER---------------
utilAddNetworkString("reportLogs")
utilAddNetworkString("sendLogs")
utilAddNetworkString("logLoader")
utilAddNetworkString("logStuff")
----------------WARNING SYSTEM------------------
utilAddNetworkString("warnPanel")
utilAddNetworkString("warnPanelSearch")
utilAddNetworkString("cleintWarnPanel")
utilAddNetworkString("newWarn")
utilAddNetworkString("RAdeleteWarn")
utilAddNetworkString("newWarnNoti")

------------------------------------------------------------------------------
if reportAddonSQLConfig.enableSQL == true then
	timer.Simple(1, function()
		local loadReportHistorySearch = radb:prepare("SELECT * FROM reportaddon_history WHERE handler = ?")
		local loadAllLogs = radb:prepare("SELECT * FROM reportaddon_logs WHERE logtype = ? AND playername LIKE ? LIMIT 200")
		local newStaffCheck = radb:prepare("SELECT * FROM reportaddon_staff WHERE `player` = ?")
		local newStaffQuery = radb:prepare("INSERT INTO reportaddon_staff (`player`, `totaltime`, `lastvisit`, `reportsCompleted`, `rating`, `reviews`, `previousScore`, `playerName`) VALUES (?, 0, ?, 1, 5, 0, 0, ?)") 
		local newReportHistory = radb:prepare("INSERT INTO reportaddon_history (`playerReporter`, `playerReported`, `reportWinner`, `reason`, `time`, `handler`) VALUES (?, ?, ?, ?, ?, ?)")
		local loadStaffStat = radb:prepare("SELECT totaltime, lastvisit FROM reportaddon_staff WHERE player = ?")
		local removeStaff = radb:prepare("DELETE FROM reportaddon_staff WHERE player = ?")
		local nextWeek = radb:prepare("UPDATE reportaddon_staff SET previousScore = reportsCompleted, totaltime = 0, rating = 5, reviews = 0, reportsCompleted = 0")
		local loadReportHistory = radb:prepare("SELECT * FROM reportaddon_history WHERE historyID > ? and historyID < ? ")
		local checkStaffTime = radb:prepare("SELECT totaltime FROM reportaddon_staff WHERE player = ?")
		local updateStaffTime = radb:prepare("UPDATE reportaddon_staff SET totaltime = ? WHERE player = ?") 
		local loadHistoryCom = radb:prepare("SELECT * FROM reportaddon_history WHERE historyID < 50")
		local updateStaffStat = radb:prepare("UPDATE reportaddon_staff SET reportsCompleted = reportsCompleted + 1 WHERE player = ?")
		local reviewScoreGetter = radb:prepare("SELECT rating FROM reportaddon_staff WHERE player = ?")
		local staffReviewed = radb:prepare("UPDATE reportaddon_staff SET reviews = reviews + 1, rating = ? WHERE player = ? ")
		local loadAllStaffData = radb:prepare("SELECT `player`, `reportsCompleted`, `rating`, `reviews`, `previousScore`, `playerName`, `lastvisit`, `totaltime` FROM reportaddon_staff ORDER BY reportsCompleted")
		local newReport = radb:prepare("INSERT INTO reportaddon_reports (`reporter`, `reported`, `reason`, `notes`, `time`, `reporterID`, `reportedID`, `server`) VALUES (?, ?, ?, ?, ?, ?, ?, "..reportAddonSQLConfig.serverNumber..") ")
		local loadAllReports = radb:prepare("SELECT `reporter`, `reported`, `handler`, `reason`, `rowid`, `reporterID`, `reportedID`, `notes`, `time`, 'handler' FROM reportaddon_reports WHERE handler is NULL LIMIT 150")
		local claimReport = radb:prepare("UPDATE reportaddon_reports SET handler = ?, handlerID = ? WHERE rowid = ? ")
		local deleteReport = radb:prepare("DELETE FROM reportaddon_reports WHERE rowid = ? AND handlerID = ? ")
		local findReport = radb:prepare("SELECT reporter, reported, handler, reason FROM reportaddon_reports WHERE rowid = ?")
		local deleteReportSa = radb:prepare("DELETE FROM reportaddon_reports WHERE rowid = ? ")
		local deleteAllReports = radb:prepare("TRUNCATE reportaddon_reports")
		local loadAllOpenReports = radb:prepare("SELECT rowid, reporter, reported, reason, reporterID, reportedID, handler, handlerID FROM reportaddon_reports LIMIT 150")
		local getReportDetails = radb:prepare("SELECT rowid, reporter, reported, reporterID, reportedID, reason, time, handler, handlerID FROM reportaddon_reports WHERE rowid = ?")
		local reportDetails = radb:prepare("SELECT reporterID, reportedID, notes FROM reportaddon_reports WHERE rowid = ?")
		local staffData = radb:prepare("SELECT rating, reviews FROM reportaddon_staff WHERE player = ?")
		local checkReport = radb:prepare("SELECT rowid from reportaddon_reports WHERE rowid = ? AND handlerID = ?")
		local reportClaimed = radb:prepare("UPDATE reportaddon_reports SET handler = ?, handlerID = ? WHERE rowid = ?")
		local checkClaimer = radb:prepare("SELECT handler, handlerID from reportaddon_reports WHERE rowid = ?")
		local newWarn = radb:prepare("INSERT INTO reportaddon_warns (warnedBySID, warnedBy, warnedSID, warned, warnReason, warnTime) VALUES (?, ?, ?, ?, ?, ?)")
		local loadAllWarns = radb:prepare("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime FROM reportaddon_warns WHERE rowid > ? and rowid < ?")
		local searchForWarns = radb:prepare("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime from reportaddon_warns WHERE warned = ? AND rowid > ? and rowid < ?")
		local deleteWarn = radb:prepare("DELETE FROM reportaddon_warns WHERE rowid = ?")
		local loadClientWarns = radb:prepare("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime FROM reportaddon_warns WHERE warnedSID = ? AND rowid > ? and rowid < ?")
		local warnData = radb:prepare("SELECT COUNT(warnedSID) FROM reportaddon_warns WHERE warnedSID = ?")
		if reportconfig.aWarn == true then
			warnData = radb:prepare("SELECT COUNT(awarn_warnings) FROM awarn_warnings WHERE uniqueID = ?")
		end
		----------------------------------------------------------------

		function reportAddonFuncs.loadAllHistorySQL(ply, handlerSearcher)			
			function loadReportHistorySearch:onSuccess()
				local reportHistory =  loadReportHistorySearch:getData()

				reportAddonFuncs.returnHistoryResults(ply, reportHistory)
			end

			loadReportHistorySearch:setString(1, handlerSearcher)
			loadReportHistorySearch:start()
		end

		function reportAddonFuncs.loadLogsSQL(ply, logSearch, logType)
			function loadAllLogs:onSuccess(data)
				reportAddonFuncs.sendLogs(ply, data, logSearch, logType)
			end

			loadAllLogs:setString(1, logType)
			loadAllLogs:setString(2, logSearch)		
			loadAllLogs:start()
		end

		function reportAddonFuncs.newStaffSQL(ply, reportID, reportWinner, staffID)
			function findReport:onSuccess(data)
				newReportHistory:setString(1, data[1]["reporter"])
				newReportHistory:setString(2, data[1]["reported"])
				newReportHistory:setString(3, reportWinner)
				newReportHistory:setString(4, data[1]["handler"])
				newReportHistory:setString(5, osdate())
				newReportHistory:setString(6, data[1]["reason"])
				newReportHistory:start()

				deleteReport:setNumber(1, reportID)
				deleteReport:setString(2, staffID)
				deleteReport:start()
			end

			function newStaffCheck:onSuccess(data)
				if data[1] == nil then
					newStaffQuery:setString(1, staffID)
					newStaffQuery:setString(2, osdate( "%d:%m:%Y" , Timestamp ))
					newStaffQuery:setString(3, ply:Nick())
					newStaffQuery:start() -- Makes query
				else
					updateStaffStat:setString(1, staffID)
					updateStaffStat:start()
				end

				findReport:setNumber(1, reportID)
				findReport:start()
			end

			newStaffCheck:setString(1, staffID)
			newStaffCheck:start() -- Makes query
		end

		function reportAddonFuncs.deleteStaffDataSQL(steamID)
			removeStaff:setString(1, steamID)
			removeStaff:start()
		end

		function reportAddonFuncs.nextWeekSQL(steamID)
			nextWeek:start()
		end

		function reportAddonFuncs.reportHistorySQL(ply, firstLog, lastLog)
			function loadReportHistory:onSuccess(data)
				reportAddonFuncs.reportHistorySendToClient(ply, data)
			end

			loadReportHistory:setNumber(1, firstLog)
			loadReportHistory:setNumber(2, lastLog)
			loadReportHistory:start()
		end

		function reportAddonFuncs.updateStaffTimeFSQL(steamID)
			function checkStaffTime:onSuccess(data)
				local totalTime = 0
				if data[1] == nil then
					totalTime = checkTime
				else
					totalTime = data[1] + checkTime
				end
				
				updateStaffTime:setNumber(1, totalTime)
				updateStaffTime:setString(2, steamID)
				updateStaffTime:start()
			end

			checkStaffTime:setString(1, steamID)
			checkStaffTime:start()
		end

		function reportAddonFuncs.reportHistoryConSQL(ply)
			function loadHistoryCom:onSuccess(data)
				reportAddonFuncs.reportHistorySendToClient(ply, data)
			end

			loadHistoryCom:start()
		end

		function reportAddonFuncs.staffReviewSQL(steamID, playerReview)
			function reviewScoreGetter:onSuccess(data)
				local reviewScore = data[1]["rating"]
				if reviewScore > playerReview then
					reviewScore = (reviewScore + playerReview) / 2
				else
					reviewScore = (playerReview + reviewScore) / 2
				end

				staffReviewed:setNumber(1, reviewScore)
				staffReviewed:setString(2, steamID)
				staffReviewed:start()
			end

			reviewScoreGetter:setString(1, steamID)
			reviewScoreGetter:start()
		end

		function reportAddonFuncs.loadStaffStatsSQL(ply)
			function loadAllStaffData:onSuccess(data)
				reportAddonFuncs.sendStaffStats(ply, data)
			end

			loadAllStaffData:start()
		end

		function reportAddonFuncs.newReportSQL(reporterName, reportedName, reason, notes, time, reporterSD, reportedSD)
			function newReport:onSuccess()
				loadAllReports:start()
			end

			function loadAllReports:onSuccess(data)
				reportAddonFuncs.staffNotification(reporterName, reportedName, reason, data)		
			end

			newReport:setString(1, reporterName)
			newReport:setString(2, reportedName)
			newReport:setString(3, reason)
			newReport:setString(4, notes)
			newReport:setString(5, time)
			newReport:setString(6, reporterSD)
			newReport:setString(7, reportedSD)
			newReport:start()
		end

		function reportAddonFuncs.claimReportSQL(ply, staffID, staffName, reportID)
			function reportClaimed:onSuccess()
				reportAddonFuncs.claimReportHandler(ply, staffID, staffName)
			end

			function checkClaimer:onSuccess(data)
				reportAddonFuncs.claimReportHandler(ply, data[1]["handlerID"], data[1]["handler"])
			end

			function checkReport:onSuccess(data)
				if data[1] == nil then
					reportClaimed:setString(1, staffName)
					reportClaimed:setString(2, staffID)
					reportClaimed:setNumber(3, reportID)
					reportClaimed:start()
				else
					checkClaimer:setNumber(1, reportID)
					checkClaimer:start()
				end
			end

			checkReport:setNumber(1, reportID)
			checkReport:setString(2, staffID)
			checkReport:start()
		end

		function reportAddonFuncs.removeReportSQL(reportID)
			deleteReportSa:setNumber(1, reportID)
			deleteReportSa:start()
		end

		function reportAddonFuncs.deleteAllReportSQL()
			deleteAllReports:start()
		end

		function reportAddonFuncs.loadAllOpenReportsSQL(ply, staffcount)
			function loadAllOpenReports:onSuccess(data)
				local calimedReports = {}
				for k, v in pairs(data) do -- maybe worth just doing 2 sql statements
					v["reporterPly"] = reportAddonFuncs.IDtoUID(v["reporterID"])
					v["reportedPly"] = reportAddonFuncs.IDtoUID(v["reportedID"])
				end

				for k, v in pairs(data) do -- don't ask me why im having to do this in 2 for loops
					if v["handler"] == nil then else
						v["handlerID"] = reportAddonFuncs.IDtoUID(v["handlerID"])
						tableinsert(calimedReports, v)
						tableremove(data, k)
					end	
				end

				reportAddonFuncs.sendAllOpenReports(ply, staffcount, data, calimedReports)
			end

			loadAllOpenReports:start()
		end

		function reportAddonFuncs.reportBasicDetailSQL(ply, reportID, alreadyClaimed)
			function getReportDetails:onSuccess(reportDetails)
				if reportDetails[1]["handler"] != nil then
					alreadyClaimed = true
				end

				reportDetails[1]["reporterPly"] = reportAddonFuncs.IDtoUID(reportDetails[1]["reporterID"])
				reportDetails[1]["reportedPly"] = reportAddonFuncs.IDtoUID(reportDetails[1]["reportedID"])

				reportAddonFuncs.sendReportDetails(ply, reportDetails[1], alreadyClaimed)
			end

			getReportDetails:setNumber(1, reportID)
			getReportDetails:start()
		end

		function reportAddonFuncs.extraReportDetailSQL(ply, reportID) -- please keep scrolling very fucking quickly
			function reportDetails:onSuccess(reportDetails)
				function staffData:onSuccess(staffData1)
					function staffData:onSuccess(staffData2)
						function warnData:onSuccess(warnData1)
							function warnData:onSuccess(warnData2)
								if staffData1[1] == nil then
									staffData1 = {{["rating"] = "N/A", ["reviews"] = "N/A"}}
								end

								if staffData2[1] == nil then
									staffData2 = {{["rating"] = "N/A", ["reviews"] = "N/A"}}
								end

								reportAddonFuncs.sendExtraDetail(ply, staffData1, staffData2, warnData1, warnData2, reportDetails)
							end

							warnData:setString(1, reportDetails[1]["reportedID"])
							warnData:start()
						end

						warnData:setString(1, reportDetails[1]["reporterID"])
						warnData:start()				
					end

					staffData:setString(1, reportDetails[1]["reporterID"])
					staffData:start()
				end

				staffData:setString(1, reportDetails[1]["reportedID"])
				staffData:start()
			end

			reportDetails:setNumber(1, reportID)
			reportDetails:start()
		end	

		function reportAddonFuncs.newWarnSQL(warnedBySID, warnedByName, warnedSID, warnedName, reason)
			newWarn:setString(1, warnedBySID)
			newWarn:setString(2, warnedByName)
			newWarn:setString(3, warnedSID)
			newWarn:setString(4, warnedName)
			newWarn:setString(5, reason)
			newWarn:setString(6, osdate("%d/%m/%Y - %H:%M:%S" , Timestamp ))
			newWarn:start()

			reportAddonFuncs.warnNotification(warnedByName, warnedName, reason)
		end

		function reportAddonFuncs.viewAllWarnsSQL(ply, firstLog, lastLog)
			function loadAllWarns:onSuccess(data)
				if data == nil then
					data = {}
				end

				reportAddonFuncs.returnWarns(ply, data)
			end

			loadAllWarns:setNumber(1, firstLog)
			loadAllWarns:setNumber(1, lastLog)
			loadAllWarns:start()
		end

		function reportAddonFuncs.searchForWarnsSQL(ply, warnName, firstLog, lastLog)
			function searchForWarns:onSuccess(warns)
				reportAddonFuncs.returnWarns(ply, warns)
			end

			searchForWarns:setString(1, warnName)
			searchForWarns:setNumber(2, firstLog)
			searchForWarns:setNumber(3, lastLog)
			searchForWarns:start()
		end

		function reportAddonFuncs.deleteWarnSQL(warnID)
			deleteWarn:setNumber(1, warnID)
			deleteWarn:start()
		end

		function reportAddonFuncs.loadClientWarnsPageSQL(ply, firstLog, lastLog)
			function loadClientWarns:onSuccess(warns)
				reportAddonFuncs.returnClientWarns(ply, warns)
			end

			loadClientWarns:setString(1, ply:SteamID64())
			loadClientWarns:setNumber(2, firstLog)
			loadClientWarns:setNumber(3, lastLog)
			loadClientWarns:start()
		end

		----------------------------------------------------------------

	    reportAddonFuncs.loadAllHistory = reportAddonFuncs.loadAllHistorySQL
	    reportAddonFuncs.loadLogs = reportAddonFuncs.loadLogsSQL
	    reportAddonFuncs.newStaff = reportAddonFuncs.newStaffSQL   
	    reportAddonFuncs.deleteStaffData = reportAddonFuncs.deleteStaffDataSQL
	    reportAddonFuncs.nextWeek = reportAddonFuncs.nextWeekSQL
	    reportAddonFuncs.reportHistory = reportAddonFuncs.reportHistorySQL
	    reportAddonFuncs.updateStaffTimeF = reportAddonFuncs.updateStaffTimeFSQL
	    reportAddonFuncs.reportHistoryCon = reportAddonFuncs.reportHistoryConSQL
	    reportAddonFuncs.staffReview = reportAddonFuncs.staffReviewSQL
	    reportAddonFuncs.loadStaffStats = reportAddonFuncs.loadStaffStatsSQL
	    reportAddonFuncs.newReport = reportAddonFuncs.newReportSQL
	    reportAddonFuncs.claimReport = reportAddonFuncs.claimReportSQL
	    reportAddonFuncs.removeReport = reportAddonFuncs.removeReportSQL
	    reportAddonFuncs.deleteAllReport = reportAddonFuncs.deleteAllReportSQL
	    reportAddonFuncs.loadAllOpenReports = reportAddonFuncs.loadAllOpenReportsSQL
	    reportAddonFuncs.reportBasicDetail = reportAddonFuncs.reportBasicDetailSQL
	    reportAddonFuncs.extraReportDetail = reportAddonFuncs.extraReportDetailSQL
		reportAddonFuncs.newWarn = reportAddonFuncs.newWarnSQL
		reportAddonFuncs.viewAllWarns = reportAddonFuncs.viewAllWarnsSQL
		reportAddonFuncs.searchForWarns = reportAddonFuncs.searchForWarnsSQL
		reportAddonFuncs.loadClientWarnsPage = reportAddonFuncs.loadClientWarnsPageSQL
	end)
else
	function reportAddonFuncs.loadAllHistorySQLITE(ply, handlerSearcher)
		local safehandlerSearcher = sqlSQLStr(handlerSearcher, true)
		local reportHistory = sqlQuery("SELECT * FROM report_addon_history WHERE handler = '"..safehandlerSearcher.."' ")

		if reportHistory == nil or reportHistory == false then
			reportHistory = {}
		end

		reportAddonFuncs.returnHistoryResults(ply, reportHistory)
	end

	function reportAddonFuncs.loadLogsSQLITE(ply, logSearch, logType)
		local safeLogType = sqlSQLStr(logType, true)
		local safeLogSearch = sqlSQLStr(logSearch, true)

		local logs = sqlQuery("SELECT * FROM report_addon_logs WHERE logtype = '"..safeLogType.."' AND playername LIKE '"..safeLogSearch.."%' LIMIT 200 ")

		if logs == nil then
			logs = {}
		end

		reportAddonFuncs.sendLogs(ply, logs, logSearch, logType)
	end

	function reportAddonFuncs.newStaffSQLITE(ply, reportID, reportWinner, staffID) -- Needs renaming
		local staffCheck = sqlQueryValue( "SELECT player FROM report_addon WHERE player = '"..staffID.."' " )
		if staffCheck == nil then
			sqlQuery( "INSERT INTO report_addon (player, totaltime, lastvisit, reportsCompleted, rating, reviews, previousScore, playerName) VALUES ('" ..staffID.. "', 0, '" .. osdate( "%d:%m:%Y" , Timestamp ) .. "', 1, 5, 0, 0, '"..ply:Nick().."') " )
		else
			sqlQuery("UPDATE report_addon SET reportsCompleted = reportsCompleted + 1 WHERE player = '"..staffID.."' ")
		end
	
		local findReport = sqlQuery("SELECT reporter, reported, handler, reason FROM report_addon_reports WHERE rowid = '"..reportID.."' ")

		local safeReporter = sqlSQLStr(findReport[1]["reporter"])
		local safeReported = sqlSQLStr(findReport[1]["reported"])
		local reportWinnerSafeName = sqlSQLStr(reportWinner)
		local reportReason = sqlSQLStr(findReport[1]["reason"])
		local reportHandlerSafeName = sqlSQLStr(findReport[1]["handler"])

		sqlQuery( "INSERT INTO report_addon_history (playerReporter, playerReported, reportWinner, reason, time, handler) VALUES ("..safeReporter..", "..safeReported..", "..reportWinnerSafeName..", "..reportHandlerSafeName..",'"..osdate().."', "..reportReason..") ")
		sqlQuery( "DELETE FROM report_addon_reports WHERE rowid = '"..reportID.."' AND handlerID = '"..staffID.."' ")
	end

	function reportAddonFuncs.deleteStaffDataSQLITE(steamID)
		sqlQuery( "DELETE FROM report_addon WHERE player = '".. steamID .."' " ) -- SQLITE query
	end

	function reportAddonFuncs.nextWeekSQLITE()
		sqlQuery("UPDATE report_addon SET previousScore = reportsCompleted, totaltime = 0, rating = 5, reviews = 0, reportsCompleted = 0")
	end

	function reportAddonFuncs.reportHistorySQLITE(ply, firstLog, lastLog) -- Verified
		local reportHistory = sqlQuery("SELECT * FROM report_addon_history WHERE rowid > "..firstLog.." and rowid < "..lastLog.." ") -- SQLITE query

		if reportHistory == nil then
			reportHistory = {}
		end

		reportAddonFuncs.reportHistorySendToClient(ply, reportHistory)
	end

	function reportAddonFuncs.updateStaffTimeFSQLITE(steamID)
		local totalTime = 0
		local time = sqlQueryValue("SELECT totaltime FROM report_addon WHERE player = '".. steamID .."'")

		if time != nil then -- may not be nil
			totalTime = time + checkTime
		else
			totalTime = checkTime
		end

		sqlQuery("UPDATE report_addon SET totaltime = '" .. totalTime .. "' WHERE player = '" .. steamID .. "'")
	end

	function reportAddonFuncs.reportHistoryConSQLITE(ply) -- Verified
		local reportHistory = sqlQuery("SELECT * FROM report_addon_history WHERE rowid < 50")

		if reportHistory == nil then
			reportHistory = {}
		end

		reportAddonFuncs.reportHistorySendToClient(ply, reportHistory)
	end

	function reportAddonFuncs.staffReviewSQLITE(steamID, playerReview)
		local reviewScore = sqlQueryValue("SELECT rating FROM report_addon WHERE player = '"..steamID.."' ")	

		if tonumber(reviewScore) > playerReview then
			reviewScore = (reviewScore + playerReview) / 2
		else
			reviewScore = (playerReview + reviewScore) / 2
		end

		sqlQuery("UPDATE report_addon SET reviews = reviews + 1, rating = '"..reviewScore.."' WHERE player = '"..steamID.."' ")
	end

	function reportAddonFuncs.loadStaffStatsSQLITE(ply)
		local staffStats = sqlQuery("SELECT player, reportsCompleted, rating, reviews, previousScore, playerName, lastvisit, totaltime FROM report_addon ORDER BY reportsCompleted DESC")

		if staffStats == nil then
			staffStats = {}
		end

		reportAddonFuncs.sendStaffStats(ply, staffStats)
	end

	function reportAddonFuncs.newReportSQLITE(reporterName, reportedName, reason, notes, time, reporterSD, reportedSD)
		local safeReporterName = sqlSQLStr(reporterName)
		local safeReportedName = sqlSQLStr(reportedName)
		local safeReason = sqlSQLStr(reason)
		local safeNotes = sqlSQLStr(notes)

		sqlQuery("INSERT INTO report_addon_reports (reporter, reported, reason, notes, time, reporterID, reportedID) VALUES ("..safeReporterName..", "..safeReportedName..", "..safeReason..", "..safeNotes..", '"..time.."', "..reporterSD..", "..reportedSD..") ")
		
		----------------------
		local reports = sqlQuery("SELECT rowid, reporter, reported, reason FROM report_addon_reports WHERE handler is NULL LIMIT 150")

		reportAddonFuncs.staffNotification(reporterName, reportedName, reason, reports)
	end

	function reportAddonFuncs.claimReportSQLITE(ply, staffID, staffName, reportID)
		local checkReport = sqlQueryValue("SELECT rowid from report_addon_reports WHERE rowid = '"..reportID.."' AND handlerID = '"..staffID.."'")

		if checkReport == nil then
			local staffName = sqlSQLStr(staffName)
			sqlQuery("UPDATE report_addon_reports SET handler = "..staffName..", handlerID = '"..staffID.."' WHERE rowid = '"..reportID.."' ")

			reportAddonFuncs.claimReportHandler(ply, staffID, ply:Nick())
		else
			local reportHandler = sqlQuery("SELECT handler, handlerID from report_addon_reports WHERE rowid = '"..reportID.."'")

			reportAddonFuncs.claimReportHandler(ply, reportHandler[1]["handlerID"], reportHandler[1]["handler"])
		end
	end

	function reportAddonFuncs.removeReportSQLITE(reportID)
		sqlQuery("DELETE FROM report_addon_reports WHERE rowid = '"..reportID.."' ")
	end

	function reportAddonFuncs.deleteAllReportSQLITE()
		sqlQuery("DELETE FROM report_addon_reports ")
	end

	function reportAddonFuncs.loadAllOpenReportsSQLITE(ply, staffcount)
		local unclaimedReports = sqlQuery( "SELECT rowid, reporter, reported, reason, reporterID, reportedID, handler, handlerID FROM report_addon_reports WHERE handler is NULL LIMIT 150" )
		local claimedReports = sqlQuery( "SELECT rowid, reporter, reported, reason, reporterID, reportedID, handler, handlerID FROM report_addon_reports WHERE handler is not NULL LIMIT 150" )

		if unclaimedReports == nil then
			unclaimedReports = {}
		end

		if claimedReports == nil then
			claimedReports = {}
		end

		for k, v in pairs(unclaimedReports) do
			v["reporterPly"] = reportAddonFuncs.IDtoUID(v["reporterID"])
			v["reportedPly"] = reportAddonFuncs.IDtoUID(v["reportedID"])
		end

		for k, v in pairs(claimedReports) do -- don't ask me why im having to do this in 2 for loops
			v["reporterPly"] = reportAddonFuncs.IDtoUID(v["reporterID"])
			v["reportedPly"] = reportAddonFuncs.IDtoUID(v["reportedID"])
			v["handlerID"] = reportAddonFuncs.IDtoUID(v["handlerID"])
		end

		reportAddonFuncs.sendAllOpenReports(ply, staffcount, unclaimedReports, claimedReports)
	end

	function reportAddonFuncs.newWarnSQLITE(warnedBySID, warnedByName, warnedSID, warnedName, reason)
		sqlQuery("INSERT INTO report_addon_warns (warnedBySID, warnedBy, warnedSID, warned, warnReason, warnTime) VALUES ("..warnedBySID..", "..warnedByName..", "..warnedSID..", "..warnedName..", "..reason..", '"..osdate("%d/%m/%Y - %H:%M:%S" , Timestamp ).."') ")

		reportAddonFuncs.warnNotification(warnedByName, warnedName, reason)
	end

	function reportAddonFuncs.viewAllWarnsSQLITE(ply, firstLog, lastLog)
		local warns = sqlQuery("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime FROM report_addon_warns WHERE rowid > "..firstLog.." and rowid < "..lastLog.."")

		if warns == nil then
			warns = {}
		end

		reportAddonFuncs.returnWarns(ply, warns)
	end

	function reportAddonFuncs.searchForWarnsSQLITE(ply, warnName, firstLog, lastLog)
		local warns = sqlQuery("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime from report_addon_warns WHERE warned = "..warnName.." AND rowid > "..firstLog.." and rowid < "..lastLog.." ")

		if warns == nil then
			warns = {}
		end

		reportAddonFuncs.returnWarns(ply, warns)
	end

	function reportAddonFuncs.deleteWarnSQLITE(warnID)
		sqlQuery("DELETE FROM report_addon_warns WHERE rowid = '"..warnID.."' ")
	end

	function reportAddonFuncs.loadClientWarnsPageSQLITE(ply, firstLog, lastLog)
		local warns = sqlQuery("SELECT rowid, warnedBy, warnedBySID, warned, warnedSID, warnReason, warnTime FROM report_addon_warns WHERE warnedSID = "..sqlSQLStr(ply:SteamID64()).." AND rowid > "..firstLog.." and rowid < "..lastLog.." ")

		if warns == nil then
			warns = {}
		end

		reportAddonFuncs.returnClientWarns(ply, warns)
	end

	function reportAddonFuncs.reportBasicDetailSQLITE(ply, reportID, preclaimed)
		local reportDetails = sqlQuery("SELECT rowid, reporter, reported, reporterID, reportedID, reason, time, handler, handlerID FROM report_addon_reports WHERE rowid = "..reportID.." ")

		if reportDetails[1]["handler"] != "NULL" then
			preclaimed = true
		end

		reportDetails[1]["reporterPly"] = reportAddonFuncs.IDtoUID(reportDetails[1]["reporterID"])
		reportDetails[1]["reportedPly"] = reportAddonFuncs.IDtoUID(reportDetails[1]["reportedID"])

		reportAddonFuncs.sendReportDetails(ply, reportDetails[1], preclaimed)
	end

	function reportAddonFuncs.extraReportDetailSQLITE(ply, reportID)
		local reportDetails = sqlQuery("SELECT reporterID, reportedID, notes FROM report_addon_reports WHERE rowid = "..reportID.." ") -- we don't want staff spoofing staff ID data
		local staffData1 = sqlQuery("SELECT rating, reviews FROM report_addon WHERE player = "..reportDetails[1]["reportedID"].." ")
		local staffData2 = sqlQuery("SELECT rating, reviews FROM report_addon WHERE player = "..reportDetails[1]["reporterID"].." ")
		local warnData1 = {}
		local warnData2 = {}

		if reportconfig.aWarn == true then
			warnData1 = sqlQuery("SELECT COUNT(awarn_warnings) FROM awarn_warnings WHERE uniqueID = "..reportDetails[1]["reportedID"].." ")
			warnData2 = sqlQuery("SELECT COUNT(awarn_warnings) FROM awarn_warnings WHERE uniqueID = "..reportDetails[1]["reporterID"].." ")
		else
			warnData1 = sqlQuery("SELECT COUNT(warnedSID) FROM report_addon_warns WHERE warnedSID = "..reportDetails[1]["reportedID"].." ")
			warnData2 = sqlQuery("SELECT COUNT(warnedSID) FROM report_addon_warns WHERE warnedSID = "..reportDetails[1]["reporterID"].." ")
		end

		if staffData1 == nil then
			staffData1 = {{["rating"] = "N/A", ["reviews"] = "N/A"}}
		end

		if staffData2 == nil then
			staffData2 = {{["rating"] = "N/A", ["reviews"] = "N/A"}}
		end

		reportAddonFuncs.sendExtraDetail(ply, staffData1, staffData2, warnData1, warnData2, reportDetails)
	end

    reportAddonFuncs.loadAllHistory = reportAddonFuncs.loadAllHistorySQLITE
	reportAddonFuncs.loadLogs = reportAddonFuncs.loadLogsSQLITE
    reportAddonFuncs.newStaff = reportAddonFuncs.newStaffSQLITE
    reportAddonFuncs.deleteStaffData = reportAddonFuncs.deleteStaffDataSQLITE
    reportAddonFuncs.nextWeek = reportAddonFuncs.nextWeekSQLITE
    reportAddonFuncs.reportHistory = reportAddonFuncs.reportHistorySQLITE
    reportAddonFuncs.updateStaffTimeF = reportAddonFuncs.updateStaffTimeFSQLITE
   	reportAddonFuncs.reportHistoryCon = reportAddonFuncs.reportHistoryConSQLITE
   	reportAddonFuncs.staffReview = reportAddonFuncs.staffReviewSQLITE
   	reportAddonFuncs.loadStaffStats = reportAddonFuncs.loadStaffStatsSQLITE
    reportAddonFuncs.newReport = reportAddonFuncs.newReportSQLITE
    reportAddonFuncs.claimReport = reportAddonFuncs.claimReportSQLITE
    reportAddonFuncs.removeReport = reportAddonFuncs.removeReportSQLITE
    reportAddonFuncs.deleteAllReport = reportAddonFuncs.deleteAllReportSQLITE
    reportAddonFuncs.loadAllOpenReports = reportAddonFuncs.loadAllOpenReportsSQLITE
    reportAddonFuncs.newWarn = reportAddonFuncs.newWarnSQLITE
    reportAddonFuncs.viewAllWarns = reportAddonFuncs.viewAllWarnsSQLITE
    reportAddonFuncs.searchForWarns = reportAddonFuncs.searchForWarnsSQLITE
    reportAddonFuncs.deleteWarn = reportAddonFuncs.deleteWarnSQLITE
    reportAddonFuncs.loadClientWarnsPage = reportAddonFuncs.loadClientWarnsPageSQLITE
    reportAddonFuncs.viewWarns = reportAddonFuncs.viewWarnsSQLITE
    reportAddonFuncs.reportBasicDetail = reportAddonFuncs.reportBasicDetailSQLITE
    reportAddonFuncs.extraReportDetail = reportAddonFuncs.extraReportDetailSQLITE

    ----------------------------------------------------

	if not sql.TableExists( "report_addon" ) then -- should be like report_addon_stats but too late now
		sqlQuery( "CREATE TABLE report_addon ( player INT, totaltime INT, lastvisit DATE, reportsCompleted INT, rating INT, reviews INT, previousScore INT, playerName STRING )" )
	end

	if not sql.TableExists( "report_addon_history" ) then
		sqlQuery( "CREATE TABLE report_addon_history ( playerReporter STRING, playerReported STRING, reportWinner STRING, reason STRING, time DATE, handler STRING )" )
	end

	if not sql.TableExists( "report_addon_logs" ) then
		sqlQuery( "CREATE TABLE report_addon_logs ( logtype STRING, time DATE, playername STRING, datatwo STRING, datathree STRING )" )
	else
		sqlQuery( "DELETE FROM report_addon_logs") -- temp
		sqlQuery( "CREATE TABLE report_addon_logs ( logtype STRING, time DATE, playername STRING, datatwo STRING, datathree STRING )" )
	end

	if not sql.TableExists( "report_addon_reports" ) then
		sqlQuery( "CREATE TABLE IF NOT EXISTS report_addon_reports (reporter STRING, reported STRING, reason STRING, notes STRING, time STRING, reporterID STRING, reportedID STRING, handler STRING, handlerID STRING) " )
	end

	if not sql.TableExists( "report_addon_warns" ) then
		sqlQuery( "CREATE TABLE report_addon_warns ( warnedBy STRING, warnedBySID INT, warned STRING, warnedSID INT, warnReason STRING, warnTime DATE)" )
	end
end

function reportAddonFuncs.reportHistorySendToClient(ply, reportHistory)
	netStart("reportHistory")
		netWriteTable(reportHistory)
	netSend(ply)
end

function reportAddonFuncs.sendExtraDetail(ply, staffData1, staffData2, warnData1, warnData2, reportDetails)
	if reportconfig.aWarn == true then
		warnData1 = warnData1[1]["COUNT(awarn_warnings)"]
		warnData2 = warnData2[1]["COUNT(awarn_warnings)"]
	else
		warnData1 = warnData1[1]["COUNT(warnedSID)"]
		warnData2 = warnData2[1]["COUNT(warnedSID)"]
	end

	netStart("reportExtraDetails")
		netWriteTable(staffData1[1])
		netWriteTable(staffData2[1])
		netWriteInt(warnData1, 32)
		netWriteInt(warnData2, 32)
		netWriteString(reportDetails[1]["notes"])
	netSend(ply)
end

function reportAddonFuncs.returnHistoryResults(ply, reportHistory)
	netStart("reportHistory")
		netWriteTable(reportHistory)
	netSend(ply)
end

function reportAddonFuncs.returnWarns(ply, warns)
	netStart("warnPanel")
		netWriteTable(warns)
	netSend(ply)
end

function reportAddonFuncs.returnClientWarns(ply, warns)
	netStart("cleintWarnPanel")
		netWriteTable(warns)
	netSend(ply)
end

function reportAddonFuncs.claimReportHandler(ply, staffID, staffName)
	netStart("checkReportHandler")
		netWriteString(staffID)
		netWriteString(staffName)
	netSend(ply)
end

function reportAddonFuncs.sendLogs(ply, logs, logSearch, logType)
	local logsReserver = tableReverse(logs)

	netStart("logStuff")
		netWriteTable(logsReserver)
		netWriteString(logType)
		netWriteString(logSearch)
	netSend(ply)
end

function reportAddonFuncs.sendStaffStats(ply, staffStats)
	netStart("viewStaffStats")
		netWriteTable(staffStats)
	netSend(ply)
end

function reportAddonFuncs.warnNotification(ply, warnedName, reason)
	if reportconfig.warnNotification == 0 then
		netStart("newWarnNoti")
			netWriteString(stringsub(warnedName, 2, stringlen(warnedName)-1))
			netWriteString(stringsub(ply, 2, stringlen(ply)-1))
			netWriteString(stringsub(reason, 2, stringlen(reason)-1))
		netBroadcast()			
	else
		for _, players in pairs(playerGetAll()) do
			if isAdmin(players) == true then
				netStart("newWarnNoti")
					netWriteString(warnedName)
					netWriteString(ply)
					netWriteString(reason)
				netSend(players)
			end
		end
	end
end

function reportAddonFuncs.staffNotification(reporterName, reportedName, reason, Reports)
	for k, v in pairs(Reports) do
		v["reporterPly"] = reportAddonFuncs.IDtoUID(v["reporterID"])
		v["reportedPly"] = reportAddonFuncs.IDtoUID(v["reportedID"])
	end

	for _, players in pairs(playerGetAll()) do
		if isAdmin(players) == true then
			players:ChatPrint(reporterName.." "..lang["has_reported"].." "..reportedName.." "..lang["for"]..reason)
				
			netStart("newReportNoti")
				netWriteTable(Reports)
			netSend(players)
		end
	end
end

function reportAddonFuncs.sendAllOpenReports(ply, staffcount, data, calimedReports)	
	netStart("bootReportAdminMenu")
		netWriteTable(data)
		netWriteTable(calimedReports)
		netWriteInt(staffcount,32)
	netSend(ply)
end

function reportAddonFuncs.sendReportDetails(ply, repoertDetails, preClaimed)
	netStart("reportDetails")
		netWriteTable(repoertDetails)
		netWriteBool(preClaimed)
	netSend(ply)
end

function reportAddonFuncs.IDtoUID(ID) -- I want a better system
	local playerOnline = false
	for _, v in pairs(playerGetAll()) do
		if v:SteamID64() == ID then
			playerOnline = v
		end
	end

	if not playerOnline == false then
		return playerOnline
	else
		return nil
	end
end

------------------------------------------------------------------------------

local chatcon = "PlayerSay"
hookAdd(chatcon,"reportAddonChatHook", function(ply, text)
	if stringlower(text) == "!"..reportconfig.ReportCommand or stringlower(text) == "/"..reportconfig.ReportCommand then
		local cooldown = false

		if recentReporters[ply] == true then
			cooldown = true
		end

		if cooldown == false then
			netStart("bootReportMenu")
				netWriteTable(reportconfig.ReportReasons)
			netSend(ply)

			tableinsert(recentReporters,ply:Nick())
		else
			ply:ChatPrint(lang["try_again"])
		end
	elseif stringlower(text) == "!"..reportconfig.warnCommand or stringlower(text) == "/"..reportconfig.warnCommand then
		if reportconfig.aWarn == false then
			if isAdmin(ply) == true then
				reportAddonFuncs.viewAllWarns(ply, 0, 49)
			else
				reportAddonFuncs.loadClientWarnsPage(ply, 0, 49)
			end
		end
	elseif stringsub(stringlower(text), 1, stringlen("!warnsid ")) == "!warnsid " or stringsub(stringlower(text), 1, stringlen("/warnsid ")) == "/warnsid " then
		if reportconfig.aWarn == false then
			if isAdmin(ply) == true then
				local foundPlayer = false
				local playerTextSID = stringSplit(text, " ")

			    for _, v in pairs(playerGetAll()) do
			        if v:SteamID64() == playerTextSID[2] then
			            foundPlayer = true
			            local preWarnedName = v:Nick()
						local warnedBySID = sqlSQLStr(ply:SteamID64())
						local warnedByName = sqlSQLStr(ply:Nick())
						local warnedSID = sqlSQLStr(v:SteamID64())
						local warnedName = sqlSQLStr(preWarnedName)
						local reason = lang["no_reason_provided"]

						if playerTextSID[3] != nil then
							if #playerTextSID > 4 then
								reason = tableconcat(playerTextSID, " ", 3,4)						
							else
								reason = tableconcat(playerTextSID, " ", 3)
							end
						end

						local reason = sqlSQLStr(reason)

						reportAddonFuncs.newWarn(warnedBySID, warnedByName, warnedSID, warnedName, reason)
			        end
			    end

				if foundPlayer == false then
					ply:ChatPrint(lang["player_not_found"])
				end
			end
		end		
	elseif stringsub(stringlower(text), 1, stringlen("!warn ")) == "!warn " or stringsub(stringlower(text), 1, stringlen("/warn ")) == "/warn " then
		if reportconfig.aWarn == false then
			if isAdmin(ply) == true then
				local foundPlayer = false
				local playerTextName = stringSplit(text, " ")

			    for _, v in pairs(playerGetAll()) do
			        if (stringmatch(stringlower(v:Nick()), stringlower(playerTextName[2]))) then
			            foundPlayer = true
			            local preWarnedName = v:Nick()
						local warnedBySID = sqlSQLStr(ply:SteamID64())
						local warnedByName = sqlSQLStr(ply:Nick())
						local warnedSID = sqlSQLStr(v:SteamID64())
						local warnedName = sqlSQLStr(preWarnedName)
						local reason = lang["no_reason_provided"]

						if playerTextName[3] != nil then
							if #playerTextName > 4 then
								reason = tableconcat(playerTextName, " ", 3,4)						
							else
								reason = tableconcat(playerTextName, " ", 3)
							end
						end

						local reason = sqlSQLStr(reason)

						reportAddonFuncs.newWarn(warnedBySID, warnedByName, warnedSID, warnedName, reason)
			        end
			    end

				if foundPlayer == false then
					ply:ChatPrint(lang["player_not_found"])
				end
			end
		end
	elseif stringlower(text) == "!sqlmigratereportaddon" or stringlower(text) == "/sqlmigratereportaddon" then
		if isSuperAdmin(ply) == true then
			local staffStatMigrationCount = 1
			local staffStats = {}
			local festusStaffStats = fileRead("reportaddon/adminstats.txt", "DATA")
			if festusStaffStats != "" then
				staffStats = utilJSONToTable( festusStaffStats, false )				
			else
				ply:ChatPrint(lang["no_stats"])
			end

			for _, v in pairs(staffStats) do -- need to do this but for sqlite
				ply:ChatPrint(lang["migrating_staff_stat"].." "..staffStatMigrationCount.."/"..#staffStats)
				sqlConvertData:setString(1, v[1])
				sqlConvertData:setNumber(2, v[2])
				sqlConvertData:setNumber(3, v[3])
				sqlConvertData:setNumber(4, v[4])
				sqlConvertData:setNumber(5, v[5])
				sqlConvertData:setString(6, v[6])
				sqlConvertData:start()
				staffStatMigrationCount = staffStatMigrationCount + 1
			end

			fileDelete( "reportaddon/adminstats.txt" )
			fileDelete( "reportaddon" )
		end
	elseif stringlower(text) == "!"..reportconfig.ReportHistoryCommand or stringlower(text) == "/"..reportconfig.ReportHistoryCommand then
		if isAdmin(ply) == true then
			reportAddonFuncs.reportHistoryCon(ply)
		end
	elseif stringsub(stringlower(text), 1, stringlen("!"..reportconfig.ReportCommand.." ")) == "!"..reportconfig.ReportCommand.." " or stringsub(stringlower(text), 1, stringlen("/"..reportconfig.ReportCommand.." ")) == "/"..reportconfig.ReportCommand.." " then
		local cooldown = false

		for _, v in pairs(recentReporters) do
			if v == ply:Nick() then
				cooldown = true
			end
		end

		if cooldown == false then
			tableinsert(recentReporters,ply:Nick())

			ply:ChatPrint(lang["report_sent"])

			local foundPlayer = false

			local PlayerEzyReport = stringSplit(text, " ")

		    for _, v in pairs(playerGetAll()) do
		        if (stringmatch(stringlower(v:Nick()), stringlower(PlayerEzyReport[2]))) then
		            chatReported = v
		            foundPlayer = true
		        end
		    end

		    if foundPlayer == true then
				local reportee = ply
				local reason = lang["no_reason"]
				local notes = lang["no_notes"]

				if PlayerEzyReport[3] != nil then
					if #PlayerEzyReport > 4 then
						reason = tableconcat(PlayerEzyReport, " ", 3,4)						
					else
						reason = tableconcat(PlayerEzyReport, " ", 3)
					end
					notes = tableconcat(PlayerEzyReport, " ", 3)
				end

				reportAddonFuncs.newReport(ply:Nick(), chatReported:Nick(), reason, notes, osdate( "%H:%M:%S" , Timestamp ), ply:SteamID64(), chatReported:SteamID64())
			else
				ply:ChatPrint(lang["player_not_found"])
			end
		else
			ply:ChatPrint(lang["try_again"])
		end
	elseif stringlower(text) == "!"..reportconfig.ReportAdminCommand or stringlower(text) == "/"..reportconfig.ReportAdminCommand then
		if isAdmin(ply) == true then
			local stafflist = {}
			for _,ply in pairs(playerGetAll()) do
				if tableHasValue(reportconfig.Admins,ply:GetUserGroup()) then
					tableinsert(stafflist,ply)
					staffcount = #stafflist
				end
			end
 
			reportAddonFuncs.loadAllOpenReports(ply, staffcount)
		end
	elseif stringlower(text) == "!"..reportconfig.ReportLoggerCommand or stringlower(text) == "/"..reportconfig.ReportLoggerCommand then
		if isAdmin(ply) == true then		
			netStart("sendLogs")
				netWriteString("")
				netWriteInt(5, 4)
				netWriteInt(2, 3)
			netSend(ply)
		end
	end
end)

if reportconfig.blogsSupport == false then
	if reportAddonSQLConfig.enableSQL == true then
		local newLog = radb:prepare("INSERT INTO reportaddon_logs (`logtype`, `time`, `playername`, `datatwo`, `datathree`) VALUES(?, ?, ?, ?, ?)")
		local checkLastVisit = radb:prepare("SELECT player FROM report_addon WHERE player = ?")
		local updateLastVisit = radb:prepare("UPDATE report_addon SET lastvisit = ? WHERE player = ?")

		hookAdd(chatcon,"chatLogHook", function(ply, text)
			newLog:setString(1, "chat")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, ply:Nick())
			newLog:setString(4, text)
			newLog:setNull(5)
			newLog:start()
		end)

		local hookconn = "PlayerAuthed"
		hookAdd(hookconn,"JoinHook", function(ply)
			newLog:setString(1, "conn")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, ply:Nick())
			newLog:setNull(4)
			newLog:setNull(5)
			newLog:start()

			function checkLastVisit:onSuccess(data)
				if data != false then -- probally wrong
					updateLastVisit:setString(1, date)
					updateLastVisit:setString(2, ply:SteamID64())
					updateLastVisit:start()
				end
			end

			checkLastVisit:setString(1, ply:SteamID64())
			checkLastVisit:start()
		end)

		local hookdiscon = "PlayerDisconnected"
		hookAdd(hookdiscon,"LeaveHook", function(ply)
			newLog:setString(1, "disconn")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, ply:Nick())
			newLog:setNull(4)
			newLog:setNull(5)
			newLog:start()
		end)

		local hookprop = "PlayerSpawnProp"
		hookAdd(hookprop,"PropSpawnHook", function(ply, model)
			newLog:setString(1, "props")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, ply:Nick())
			newLog:setString(4, model)
			newLog:setNull(5)
			newLog:start()
		end)

		local killcon = "PlayerDeath"
		hookAdd(killcon,"KillHook", function(ply, _, att)
			local attackername = lang["npc_other"]
			local weapon = lang["unkown"]
			local playername = lang["npc_other"]

			if att:IsPlayer() then
				attackername = att:Nick()
				weapon = IsValid(att:GetActiveWeapon()) and att:GetActiveWeapon():GetClass() or lang["unkown"]
			end

			if ply:IsPlayer() then
				playername = ply:Nick()
			end

			newLog:setString(1, "kill")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, playername)
			newLog:setString(4, weapon)
			newLog:setString(5, attackername)
			newLog:start()		
		end)

		local damaghook = "EntityTakeDamage"
		hookAdd(damaghook,"DamadgeHook", function(ply, inf)
			local attackerinfo = inf:GetAttacker()
			local attackernamedam = lang["npc_other"]
			local playernamedam = lang["npc_other"]

			if attackerinfo:IsPlayer() then
				attackernamedam = attackerinfo:Nick()
			end

			if ply:IsPlayer() then
				playernamedam = ply:Nick()
			end

			newLog:setString(1, "dama")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, playernamedam)
			newLog:setString(4, attackernamedam)
			newLog:setNumber(5, inf:GetDamage())
			newLog:start()	
		end)

		local toolHook = "CanTool"
		hookAdd(toolHook,"TollHookLogger", function(ply, _, tool)
			newLog:setString(1, "tool")
			newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
			newLog:setString(3, ply:Nick())
			newLog:setString(4, tool)
			newLog:setNull(5)
			newLog:start()	
		end)

		if reportconfig.DarkRPLogs == true then
			local darkrpJobChange = "OnPlayerChangedTeam"	
			hookAdd(darkrpJobChange,"darkRPJobChange", function(ply, old, new)
				newLog:setString(1, "teamChange")
				newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
				newLog:setString(3, ply:Nick())
				newLog:setString(4, teamGetName(old))
				newLog:setString(5, teamGetName(new))
				newLog:start()
			end)

			local darkrpWarrented = "playerWarranted"
			hookAdd(darkrpWarrented,"darkRPplyWarranted", function(crim, cop, reason)
				newLog:setString(1, "warranted")
				newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
				newLog:setString(3, cop:Nick())
				newLog:setString(4, crim:Nick())
				newLog:setString(5, reason)
				newLog:start()
			end)

			local darkrpWanted = "playerWanted"
			hookAdd(darkrpWanted,"darkRPplywanted", function(crim, cop, reason)
				local copName = lang["nobody"]

				if cop == nil then else
					copName = cop:Nick()
				end

				newLog:setString(1, "wanted")
				newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
				newLog:setString(3, copName)
				newLog:setString(4, crim:Nick())
				newLog:setString(5, reason)
				newLog:start()
			end)

			local darkrpWalletChange = "playerWalletChanged"
			hookAdd(darkrpWalletChange,"darkRPplywallet", function(ply, pickup)
				local pickupItem = tostring(pickup)
				newLog:setString(1, "wallet")
				newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
				newLog:setString(3, ply:Nick())
				newLog:setString(4, pickupItem)
				newLog:setNull(5)
				newLog:start()
			end)

			local darkrpRDAfucks = "playerArrested"
			hookAdd(darkrpRDAfucks,"darkRPplyarrests", function(crim, _, cop)
				local copName = lang["nobody"]

				if cop == nil then else
					copName = cop:Nick()
				end

				newLog:setString(1, "arrested")
				newLog:setString(2, osdate( "%H:%M:%S" , Timestamp ))
				newLog:setString(3, copName)
				newLog:setString(4, crim:Nick())
				newLog:setNull(5)
				newLog:start()
			end)
		end
	else
		hookAdd(chatcon,"chatLogHook", function(ply, text)
			local playerSafeName = sqlSQLStr(ply:Nick(), true)
			local safeText = sqlSQLStr(text)
			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo) VALUES ( 'chat', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "', " ..safeText.. ")" )
		end)

		local hookconn = "PlayerAuthed"
		hookAdd(hookconn,"JoinHook", function(ply)
			local playerSafeName = sqlSQLStr(ply:Nick(), true)
			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername) VALUES ( 'conn', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "' )" )

			local databasecheck = sqlQuery("SELECT player FROM report_addon WHERE player = '" ..ply:SteamID64().. "'")
			if databasecheck != false then
				sqlQuery( "UPDATE report_addon SET lastvisit = '" .. osdate( "%d:%m:%Y" , Timestamp ) .. "' WHERE player = '" .. ply:SteamID64() .. "'" )
			end
		end)

		local hookdiscon = "PlayerDisconnected"
		hookAdd(hookdiscon,"LeaveHook", function(ply)
			local playerSafeName = sqlSQLStr(ply:Nick(), true)
			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername) VALUES ( 'disconn', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "' )" )
		end)

		local hookprop = "PlayerSpawnProp"
		hookAdd(hookprop,"PropSpawnHook", function(ply, model)
			local playerSafeName = sqlSQLStr(ply:Nick(), true)
			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo) VALUES ( 'props', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "', '" ..model.. "' )" )
		end)

		local killcon = "PlayerDeath"
		hookAdd(killcon,"KillHook", function(ply, _, att)
			local attackername = lang["npc_other"]
			local weapon = lang["unkown"]
			local playername = lang["npc_other"]

			if att:IsPlayer() then
				attackername = sqlSQLStr(att:Nick(), true)
				weapon = IsValid(att:GetActiveWeapon()) and att:GetActiveWeapon():GetClass() or lang["unkown"]
			end

			if ply:IsPlayer() then
				playername = sqlSQLStr(ply:Nick(), true)
			end

			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo, datathree) VALUES ( 'kill', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playername.. "', '" ..weapon.. "', '" ..attackername.. "' )" )
		end)

		local damaghook = "EntityTakeDamage"
		hookAdd(damaghook,"DamadgeHook", function(ply, inf)
			local attackerinfo = inf:GetAttacker()
			local attackernamedam = lang["npc_other"]
			local playernamedam = lang["npc_other"]

			if attackerinfo:IsPlayer() then
				attackernamedam = sqlSQLStr(attackerinfo:Nick(), true)
			end

			if ply:IsPlayer() then
				playernamedam = sqlSQLStr(ply:Nick(), true)
			end

			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo, datathree) VALUES ( 'dama', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playernamedam.. "', '" ..attackernamedam.. "', '" ..inf:GetDamage().. "' )" )
		end)

		local toolHook = "CanTool"
		hookAdd(toolHook,"TollHookLogger", function(ply, _, tool)
			local playerSafeName = sqlSQLStr(ply:Nick(), true)	
			sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo) VALUES ( 'tool', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "', '" ..tool.. "' )" )	
		end)

		if reportconfig.DarkRPLogs == true then
			local darkrpJobChange = "OnPlayerChangedTeam"	
			hookAdd(darkrpJobChange,"darkRPJobChange", function(ply, old, new)
				local playerSafeName = sqlSQLStr(ply:Nick(), true)		
				sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo, datathree) VALUES ( 'teamChange', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "', '" .. teamGetName(old).. "', '" .. teamGetName(new).. "' )" )	
			end)

			local darkrpWarrented = "playerWarranted"
			hookAdd(darkrpWarrented,"darkRPplyWarranted", function(crim, cop, reason)
				local crimName = sqlSQLStr(crim:Nick(), true)	
				local copName = sqlSQLStr(cop:Nick(), true)
				sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo, datathree) VALUES ( 'warranted', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..copName.. "', '" ..crimName.. "', '" ..reason.. "' )" )	
			end)

			local darkrpWanted = "playerWanted"
			hookAdd(darkrpWanted,"darkRPplywanted", function(crim, cop, reason)
				local crimName = sqlSQLStr(crim:Nick(), true)	
				local copName = lang["nobody"]

				if cop == nil then else
					copName = sqlSQLStr(cop:Nick(), true)
				end

				sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo, datathree) VALUES ( 'wanted', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..copName.. "', '" ..crimName.. "', '" ..reason.. "' )" )	
			end)

			local darkrpWalletChange = "playerWalletChanged"
			hookAdd(darkrpWalletChange,"darkRPplywallet", function(ply, pickup)
				local playerSafeName = sqlSQLStr(ply:Nick(), true)	
				sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo) VALUES ( 'wallet', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..playerSafeName.. "', '" ..pickup.. "' )" )	
			end)

			local darkrpRDAfucks = "playerArrested"
			hookAdd(darkrpRDAfucks,"darkRPplyarrests", function(crim, _, cop)
				local crimName = sqlSQLStr(crim:Nick(), true)
				local copName = lang["nobody"]

				if cop == nil then else
					copName = sqlSQLStr(cop:Nick(), true)
				end

				sqlQuery( "INSERT INTO report_addon_logs (logtype, time, playername, datatwo) VALUES ( 'arrested', '" .. osdate( "%H:%M:%S" , Timestamp ) .. "', '" ..copName.. "', '" ..crimName.. "' )" )	
			end)
		end
	end
end

------------------------------------------------------------------------------

netReceive("reBootReportAdminMenu",function(_, ply)
	if isAdmin(ply) == true then
		local stafflist = {}
		for _,ply in pairs(playerGetAll()) do
			if tableHasValue(reportconfig.Admins,ply:GetUserGroup()) then
				tableinsert(stafflist,ply)
				staffcount = #stafflist
			end
		end
 
		reportAddonFuncs.loadAllOpenReports(ply, staffcount)
	end
end)

netReceive("newReport",function(_, ply)
	local cooldown = false

	for _, v in pairs(recentReporters) do
		if v == ply:Nick() then
			cooldown = true
		end
	end

	if cooldown == false then
		ply:ChatPrint(lang["report_sent"])

		tableinsert(recentReporters, ply:Nick())

		local reportedName = netReadString()
		local reportedSteamID = netReadString()
		local reason = netReadInt(5)
		local notes = netReadString()

		reportAddonFuncs.newReport(ply:Nick(), reportedName, reportconfig.ReportReasons[reason], notes, osdate( "%H:%M:%S" , Timestamp ), ply:SteamID64(), reportedSteamID)
	else
		ply:ChatPrint(lang["try_again"])
	end
end)

netReceive("reprotHistorySearcher",function(_, ply)
	if isAdmin(ply) == true then
		local handlerSearcher = netReadString()

		reportAddonFuncs.loadAllHistory(ply, handlerSearcher)
	end
end)

netReceive("reportClaimed",function(_, ply)
	if isAdmin(ply) == true then
		local reportID = netReadInt(32)
        ply:ChatPrint("При закрытии жалобы, обрати внимание:\n + закрыть жалобу в пользу обвиянемого | - закрыть жалобу в пользу подавшего")
		reportAddonFuncs.claimReport(ply, ply:SteamID64(), ply:Nick(), reportID)

		for _, players in pairs(playerGetAll()) do -- does this even work anymore? fuck knows
			if isAdmin(players) == true then
				netStart("removeNoti")
					netWriteString(tostring(reportID)) -- why I have to send it as a string is beyond autistic
				netSend(players)			
			end
		end
	end
end)

netReceive("logLoader",function(_, ply)
	if isAdmin(ply) == true then
		local logSearch = netReadString()
		local logType = netReadString()

		reportAddonFuncs.loadLogs(ply, logSearch, logType)
	end
end)

netReceive("reportCompleted",function(_, ply)
	if isAdmin(ply) == true then
		local reportID = netReadInt(32)
		local warnLooser = netReadBool()
		local reportWinnerName = netReadType()
		local reportWinner = netReadType()
		local reportLooserName = netReadType()
		local reportLooser = netReadType()
		local reportUID = netReadType()
		local reportHandler = ply:SteamID64()
		local reportHandlerName = ply:Nick()

		if warnLooser == true then
			reportAddonFuncs.newWarn(reportHandler, reportHandlerName, reportLooser, reportLooserName, lang["lost_report"])
		end

		reportAddonFuncs.newStaff(ply, reportID, reportWinnerName, reportHandler) -- really badly named, it checks if staff exists + updates staff data with report stuff + deletes report + updates report history

--		if reportWinner != reportLooser and reportWinner != reportHandler and reportLooser != reportHandler and reportUID != false then
			netStart("playerRating")
				netWriteString(reportHandlerName)
				netWriteString(reportHandler)
			netSend(reportUID)
--		end
	end
end)

netReceive("reportLogs",function(_, ply)
	if isAdmin(ply) == true then
		local reportText = netReadString()
		local reportSize = netReadInt(4)

		netStart("sendLogs")
			netWriteString(reportText) -- sends report default text
			netWriteInt(reportSize, 4) -- sends size and position -- KEY: 1 = Small size, unclaimed    | 2 = Large size, unclaimed  |  3 = Small size, claimed   |  4 = Large size, claimed
			netWriteInt(1, 3) -- sends logger mode       -- KEY: 1 = Coming from report menu  | 2 = Standelone logger
		netSend(ply)
	end
end)

netReceive("loadBaiscReportDetail",function(_, ply)
	if isAdmin(ply) == true then
		local reportID = netReadInt(32)
		local claimedMenu = netReadBool()

		reportAddonFuncs.reportBasicDetail(ply, reportID, claimedMenu)
	end
end)

netReceive("loadExtraReportDetail",function(_, ply)
	if isAdmin(ply) == true then
		local reportID = netReadInt(32)

		reportAddonFuncs.extraReportDetail(ply, reportID)
	end
end)

netReceive("playerRatingReview",function()
	local playerreview = netReadInt(3)
	local staffmember = netReadString()

	reportAddonFuncs.staffReview(staffmember, playerreview)
end)

netReceive("reportDeleted",function(_, ply)
	if isSuperAdmin(ply) == true then
		local reportID = netReadInt(32)

		reportAddonFuncs.removeReport(reportID)
	end
end)

netReceive("loadStaffStats",function(_, ply)
	if isAdmin(ply) == true then
		reportAddonFuncs.loadStaffStats(ply)
	end
end)

netReceive("deleteStaffPlayer",function(_, ply)
	if isSuperAdmin(ply) == true then
		local StaffSteamID = netReadString()

		reportAddonFuncs.deleteStaffData(StaffSteamID)
	end
end)

netReceive("nextWeekTime",function (_, ply)
	if isSuperAdmin(ply) == true then
		reportAddonFuncs.nextWeek()
	end
end)

netReceive("deleteAllReports",function(_, ply)
	if isSuperAdmin(ply) == true then
		reportAddonFuncs.deleteAllReport()
	end
end)

netReceive("newWarn",function(_, ply)
	if isAdmin(ply) == true then
		local warnedSID = sqlSQLStr(netReadString())
		local warnedName = sqlSQLStr(netReadString())
		local reason = sqlSQLStr(netReadString())
		local warnedBySID = sqlSQLStr(ply:SteamID64())
		local warnedByName = sqlSQLStr(ply:Nick())

		reportAddonFuncs.newWarn(warnedBySID, warnedByName, warnedSID, warnedName, reason)
	end
end)

netReceive("warnPanel",function(_, ply)
	if isAdmin(ply) == true then
		local firstLog = netReadDouble()
		local lastLog = netReadDouble()

		reportAddonFuncs.viewAllWarns(ply, firstLog, lastLog)
	end
end)

netReceive("warnPanelSearch",function(_, ply)
	if isAdmin(ply) == true then
		local warnName = sqlSQLStr(netReadString())
		local firstLog = netReadDouble()
		local lastLog = netReadDouble()

		if warnName == "''" or warnName == "'Search...'" then
			reportAddonFuncs.viewAllWarns(ply, firstLog, lastLog)		
		else
			reportAddonFuncs.searchForWarns(ply, warnName, firstLog, lastLog)		
		end
	end
end)

netReceive("RAdeleteWarn", function(_, ply)
	if isAdmin(ply) == true then
		local warnID = netReadInt(32)

		reportAddonFuncs.deleteWarn(warnID)
	end
end)

netReceive("cleintWarnPanel",function(_, ply)
	local userSID = sqlSQLStr(ply:SteamID64())
	local firstLog = netReadDouble()
	local lastLog = netReadDouble()

	reportAddonFuncs.loadClientWarnsPage(ply, firstLog, lastLog)
end)

netReceive("loadHistoryPage", function(_, ply)
	if isAdmin(ply) == true then
		local firstLog = netReadDouble()
		local lastLog = firstLog + 50

		reportAddonFuncs.reportHistory(ply, firstLog, lastLog)
	end
end)

------------------------------------------------------------------------------
 
timerCreate("StaffTimeUpdate",reportconfig.staffTotalTimeUpdator,0,function()
	for _, ply in pairs(playerGetAll()) do
		if isAdmin(ply) == true then
			reportAddonFuncs.updateStaffTimeF(ply:SteamID64())
 		end
	end
end)

timerCreate("recentReportsClearout",10,0,function()
	recentReporters = {}
end)

------------------------------------------------------------------------------

resourceAddFile("materials/1star.png")
resourceAddFile("materials/2stars.png")
resourceAddFile("materials/3stars.png")
resourceAddFile("materials/4stars.png")
resourceAddFile("materials/5stars.png")
resourceAddFile("materials/radownarrow.png")
resourceAddFile("materials/rauparrow.png")
resourceAddFile("materials/straightarrow.png")
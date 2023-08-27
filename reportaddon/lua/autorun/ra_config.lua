

reportconfig = {}

------------------------------------------------------------------------------
-------------------------------CONFIG-----------------------------------------

---------------------- // PERMISSIONS // ----------------------
reportconfig.PermissionType = "ULX" -- ULX / ServerGuard / SteamID
reportconfig.Admins = {"root", "superadmin", "curator", "admin", "moderator"} -- Your normal staff (if permission type is set to SteamID put your staff's StaemID's in here)
reportconfig.Superadmin = {"root", "superadmin"} -- Your higher ranking staff (these people can remove staff data, push the staff data to the next week and delete reports) (if permission type is set to SteamID put your staff's StaemID's in here)
reportconfig.adminList = true -- Should it show admins on the report list?

---------------------- // DEFEUALT REPORT REASONS // ----------------------
reportconfig.ReportReasons = { -- The reasons to report a player
	[1] = "RDM",
	[2] = "NonRP",
	[3] = "Неадекватность",
	[4] = "Другое",
}

reportconfig.showJobs = true -- Do you want players jobs to be listed in !report menu?
reportconfig.jobsToRoles = false -- Replace where it say's "Jobs" with "roles"

---------------------- // CHAT COMMANDS // ----------------------
reportconfig.ReportCommand = "s" -- open the report menu
reportconfig.ReportAdminCommand = "sc" -- opens the report admin menu
reportconfig.ReportHistoryCommand = "sh" -- open the report history menu
reportconfig.ReportLoggerCommand = "xxxddd" -- shows the logger
reportconfig.warnCommand = "warns" -- opens the warn menu

---------------------- // LOGGER // ----------------------
reportconfig.blogsSupport = false -- When you press "View Logs" it opens blogs instead of the built in logger?
reportconfig.DarkRPLogs = true -- Enable DarkRP logs?

---------------------- // WARN SySTEM // ----------------------
reportconfig.aWarn = false -- Do you have want to utilize awarn support instead of the built in warn system which comes with the report addon?
reportconfig.aWarnMessage = "Rule breaking" -- The defeault warn message
reportconfig.warnNotification = 0 -- 0 = Everyone | 1 = Admins only

---------------------- // MISC // ----------------------
reportconfig.staffTotalTimeUpdator = 600 --How often it will update how long your staff has been on the server
reportconfig.cursorShownOnNotification = false -- If you want the cursor to show when a notification comes in
reportconfig.notiActiveTime = 30 -- How long you want there to be a notifcation for

---------------------- // LANGUAGE // ----------------------
reportconfig.Language = "English" -- English / Français

reportconfig.enLang = {
	["has_reported"] = "подал жалобу",
	["for"] = "на",
	["try_again"] = "Попробуй снова через 10 секунд",
	["no_reason_provided"] = "Причина не указана",
	["player_not_found"] = "Игрок не найден",
	["no_stats"] = "У тебя нет статистики",
	["migrating_staff_stat"] = "Перенос статистики администрации",
	["report_sent"] = "Жалоба отправлена",
	["no_reason"] = "Причина не указана",
	["no_notes"] = "Без описания",
	["npc_other"] = "NPC/Остальное",
	["unkown"] = "?",
	["nobody"] = "?",
	["lost_report"] = "Ты упустил жалобу",
	["has_been_warned_by"] = "получил предупреждение от",
	["job"] = "Профессия",
	["role"] = "Роль",
	["name"] = "Имя",
	["rank"] = "Ранг",
	["nobody"] = "?",
	["classified"] = "Классифицированный",
	["enter_message"] = "Напиши что нибудь (Не обязательно)",
	["no_extra_notes"] = "Описание отсутствует",
	["cancel"] = "Отменить",
	["submit"] = "Отправить",
	["rate_the_staff"] = "Оценить работу администрации",
	["want_did_you_think_of"] = "Что ты думаешь о",
	["warned"] = "Предупреждения:",
	["warner"] = "Кто выдал:",
	["reason"] = "Причина:",
	["total_warns"] = "Всего предупреждений: ",
	["time"] = "Время",
	["warned2"] = "Предупрежден",
	["warner2"] = "Кто выдал",
	["reason2"] = "Причина",
	["prev_page"] = "Предыдущая страница",
	["next_page"] = "Следующая страница",
	["return"] = "Назад",
	["current_open_reports"] = "Текущие жалобы:",
	["current_claimed_reports"] = "Текущие принятые жалобы:",
	["staff_online"] = "Администрация онлайн:",
	["reporter"] = "Подавший",
	["reported"] = "Обвиняемый",
	["claimed_by"] = "Жалобу принял",
	["delete"] = "Удалить",
	["view_stats"] = "Посмотреть статистику",
	["delete_all_reports"] = "Удалить все жалобы",
	["offline"] = "Не в сети",
	["online"] = "В сети",
	["current_time"] = "Текущее время:",
	["claimed_by"] = "Жалобу принял:",
	["name2"] = "Имя:",
	["job2"] = "Профессия:",
	["status"] = "Статус:",
	["time_of_report"] = "Время жалобы:",
	["steamid"] = "SteamID:",
	["more_info"] = "Больше информации",
	["less_info"] = "Скрыть информацию",
	["click_me"] = "Нажми на меня!",
	["reporter_won"] = "-",
	["reported_won"] = "+",
	["nobody_won"] = "Закрыть жалобу",
	["warn_looser"] = "Выдать предупреждение обвиняемому",
	["claim_report"] = "Принять жалобу",
	["view_logs"] = "Логи",
	["show_buttons"] = "Команды",
	["hide_buttons"] = "Скрыть",
	["bring"] = "bring",
	["goto"] = "goto",
	["jail"] = "Посадить в тюрьму",
	["un_jail"] = "Выпустить из тюрьмы",
	["freeze"] = "Заморозить",
	["un_freeze"] = "Разморозить",
	["click_to_target_player"] = "Нажми что бы выделить игрока",
	["warns"] = "Предупреждения:",
	["rating"] = "Оценка:",
	["reviews"] = "Отзывы:",
	["extra_notes2"] = "Допольнительное описание:",
	["reporter3"] = "Подавший жалобу:",
	["reported3"] = "Обвиняемый:",
	["qucik_claim"] = "Принять",
	["new_report_recieved"] = "Получена новая жалоба",
	["there_are_currently"] = "В настоящее время",
	["active_reports"] = "активные жалобы",
	["click_a_staff"] = "1",
	["staff"] = "Администрация",
	["closed"] = "Закрыта",
	["score"] = "Оценка",
	["reviews2"] = "Отзывы",
	["trends"] = "Тенденции",
	["staff_info"] = "Информация",
	["last_visit"] = "Прошлая жб:",
	["total_time"] = "Общее время:",
	["remove_staff"] = "Удалить администратора",
	["are_you_sure"] = "Ты уверен?",
	["yes"] = "Да",
	["no"] = "Нет",
	["you_need_staff_to_display_the_graph"] = "Для отображения графика требуется администрация",
	["next_week"] = "Следующая неделя",
	["view_details"] = "Посмотреть детали",
	["report_history"] = "История жалоб",
	["winner"] = "Выигравший жалобу",
	["date"] = "Дата",
	["handler"] = "Обработка",
	["showing_results"] = "Показать результаты",
	["search_for_handler"] = "Показать обработчика",
	["delete_warn"] = "Снять предупреждение",
	["total_warns"] = "Всего предупреждений:",
	["said"] = 'сказал "',
	["connected"] = "подключился",
	["discon"] = "отключился",
	["spawned"] = "подключился",
	["killed_himself"] = "совершил самоубийство",
	["killed_by"] = "убит",
	["with"] = "с",
	["took"] = "взял",
	["damage_from"] = "урон от",
	["used_the"] = "использовал",
	["tool"] = "инструмент",
	["changed_from"] = "сменил с",
	["to"] = "на",
	["warranted"] = "warranted",
	["for"] = "по причине",
	["wanted"] = "wanred",
	["money_changed_by"] = "количество денег изменено на",
	["arrested"] = "арестован",
	["there_are_currently"] = "В настоящее время",
	["active_reports"] = "текущие жалобы",
	["quick_claim"] = "Принять"
}

reportconfig.frLang = {
	["has_reported"] = "a signalé",
	["for"] = "pour",
	["try_again"] = "Réessayez dans 10 secondes",
	["no_reason_provided"] = "Pas de raison donnée",
	["player_not_found"] = "Joueur introuvable, assurez-vous d’avoir entré le nom exact. Si vous voulez le menu faites !report (sans espace)",
	["no_stats"] = "Vous n’avez pas de statistiques à convertir!",
	["migrating_staff_stat"] = "Migration de statistiques d’administration",
	["report_sent"] = "Votre signalement a été envoyé",
	["no_reason"] = "Pas de raison",
	["no_notes"] = "Pas de notes",
	["npc_other"] = "PNJ/Autre",
	["unkown"] = "Inconnu",
	["nobody"] = "Personne",
	["lost_report"] = "Vous avez perdu le signalement",
	["has_been_warned_by"] = "a été signalé par",
	["job"] = "Emploi",
	["role"] = "Role",
	["name"] = "Nom",
	["rank"] = "Rang",
	["classified"] = "Classifié",
	["enter_message"] = "Entrez un message... (optionnel)",
	["no_extra_notes"] = "Pas de note supplémentaire fournie",
	["cancel"] = "Annuler",
	["submit"] = "Envoyer",
	["rate_the_staff"] = "Notez l’administrateur",
	["want_did_you_think_of"] = "Qu’avez-vous pensé de",
	["warned"] = "A signalé:",
	["warner"] = "Warner:",
	["reason"] = "Raison:",
	["total_warns"] = "Signalements totaux: ",
	["time"] = "Moment",
	["warned2"] = "A signalé",
	["warner2"] = "Warner",
	["reason2"] = "Raison",
	["prev_page"] = "Page précédente",
	["next_page"] = "Page suivante",
	["return"] = "Retour",
	["current_open_reports"] = "Signalements ouverts actuellement:",
	["current_claimed_reports"] = "Signalements acceptés actuellement:",
	["staff_online"] = "Administrateurs en ligne:",
	["reporter"] = "Signaleur",
	["reported"] = "Signalé",
	["claimed_by"] = "Accepté par",
	["delete"] = "Supprimer",
	["view_stats"] = "Voir les statistiques",
	["delete_all_reports"] = "Supprimer tous les rapports",
	["offline"] = "Hors-ligne",
	["online"] = "En ligne",
	["current_time"] = "Temps actuel:",
	["claimed_by"] = "Accepté par:",
	["name2"] = "Nom:",
	["job2"] = "Emploi:",
	["status"] = "Status:",
	["time_of_report"] = "Date de signalement:",
	["steamid"] = "SteamID:",
	["more_info"] = "Plus d’information",
	["less_info"] = "Moins d’information",
	["click_me"] = "Cliquez ici",
	["reporter_won"] = "Signaleur a gagné",
	["reported_won"] = "Signalé a gagné",
	["nobody_won"] = "Personne n’a gagné",
	["warn_looser"] = "Avertir le perdant?",
	["claim_report"] = "Accepter le signalement",
	["view_logs"] = "Voir les logs",
	["show_buttons"] = "Afficher les boutons",
	["hide_buttons"] = "Cacher le bouton",
	["bring"] = "Ramener",
	["goto"] = "Aller à",
	["jail"] = "Emprisonner",
	["un_jail"] = "Faire sortir de prison",
	["freeze"] = "Immobiliser",
	["un_freeze"] = "Désimmobiliser",
	["click_to_target_player"] = "Cliquer pour cibler le joueur",
	["warns"] = "Avertissements:",
	["rating"] = "Note:",
	["reviews"] = "Commentaires:",
	["extra_notes2"] = "Notes supplémentaires:",
	["reporter3"] = "Signaleur:",
	["reported3"] = "Signalé:",
	["qucik_claim"] = "Accepter (rapide)",
	["new_report_recieved"] = "Un nouveau signalement a été reçu",
	["there_are_currently"] = "Il y a actuellement",
	["active_reports"] = "signalements actifs",
	["click_a_staff"] = "Cliquer sur un administrateur",
	["staff"] = "Administrateur",
	["closed"] = "Fermé",
	["score"] = "Score",
	["reviews2"] = "Commentaires",
	["trends"] = "Tendances",
	["staff_info"] = "Information d’administrateur:",
	["last_visit"] = "Dernière visite:",
	["total_time"] = "Temps total:",
	["remove_staff"] = "Supprimer l’administrateur",
	["are_you_sure"] = "Êtes-vous sûr(e) ?",
	["yes"] = "Oui",
	["no"] = "Non",
	["you_need_staff_to_display_the_graph"] = "Vous devez être un administrateur pour voir les graphiques",
	["next_week"] = "Semaine suivante",
	["view_details"] = "Voir les détails",
	["report_history"] = "Historique de signalement",
	["winner"] = "Gagnant",
	["date"] = "Date",
	["handler"] = "En charge",
	["showing_results"] = "Affichage des résultats",
	["search_for_handler"] = "Recherche des administrateurs en charge",
	["delete_warn"] = "Supprimer les signalements",
	["total_warns"] = "Signalements totaux:",
	["said"] = 'a dit "',
	["connected"] = "s’est connecté",
	["discon"] = "s’est déconnecté",
	["spawned"] = "est apparu",
	["killed_himself"] = "s’est suicidé",
	["killed_by"] = "a été tué par",
	["with"] = "avec",
	["took"] = "a reçu",
	["damage_from"] = "dégâts de",
	["used_the"] = "a utillisé",
	["tool"] = "outil",
	["changed_from"] = "a changé de",
	["to"] = "à",
	["warranted"] = "a mis en place un mandat",
	["for"] = "pour",
	["wanted"] = "signalé",
	["money_changed_by"] = "argent changé par",
	["arrested"] = "arrêté",
	["there_are_currently"] = "Il y a actuellement",
	["active_reports"] = "signalements actifs",
	["quick_claim"] = "Accepter"
}

------------------------------END OF CONFIG-----------------------------------
------------------------------------------------------------------------------

if reportconfig.Language == "English" then
	BigLanguage = reportconfig.enLang
else
	BigLanguage = reportconfig.frLang
end

------------------------------------------------------------------------------

function isAdmin(ply)
	if reportconfig.PermissionType == "ULX" then
		for _, v in pairs(reportconfig.Admins) do
			if ply:IsUserGroup(v) then
				return true
			end
		end
	elseif reportconfig.PermissionType == "ServerGuard" then
		for _, v in pairs(reportconfig.Admins) do
			if serverguard.player:GetRank(ply) == v then
				return true
			end
		end
	else
		for _, v in pairs(reportconfig.Admins) do
			if ply:SteamID() == v then
				return true
			end
		end
	end
end

function isSuperAdmin(ply)
	if reportconfig.PermissionType == "ULX" then
		for _, v in pairs(reportconfig.Superadmin) do
			if ply:IsUserGroup(v) then
				return true
			end
		end
	elseif reportconfig.PermissionType == "ServerGuard" then
		for _, v in pairs(reportconfig.Superadmin) do
			if serverguard.player:GetRank(ply) == v then
				return true
			end
		end
	else
		for _, v in pairs(reportconfig.Superadmin) do
			if ply:SteamID() == v then
				return true
			end
		end
	end
end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/
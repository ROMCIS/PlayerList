-- https://discord.gg/tFvU4Gad
-- KinG " RoMcIs "
-- https://discord.gg/tFvU4Gad


local mysql = exports.mysql

myTable = { "avatars/free/1.png","avatars/free/2.png","avatars/free/3.png","avatars/free/4.png","avatars/free/5.png","avatars/free/6.png","avatars/free/7.png","avatars/free/8.png" }

local hostname = "localhost" -- الهوست
local username = "" -- اسم الحساب
local password = "" -- باسورد
local datebase = "" -- القاعدة
local port = 3306


timer = { }

function getTimeLeft( Timer )
	local Details = getTimerDetails( Timer ) 
    local DownDay, DownHours, DownMinutes, DownSeconds = math.floor( Details / 86400000 ), math.floor( Details / 3600000 ), math.floor( Details / 60000 ), math.floor( Details / 1000 ) 
	local Hours, Minutes, Seconds = math.floor( ( Details - DownDay * 86400000 ) / 3600000 ), math.floor( ( Details - DownHours * 3600000 ) / 60000 ), math.floor( ( Details - DownMinutes * 60000 ) / 1000 ) 
    return "x["..tostring(Hours)..":"..tostring(Minutes)..":"..tostring(Seconds).."]x"
end

function updateAvatar(thePlayer, MysqlID)
    local Mysqlconnect = dbConnect( "mysql", "dbname="..datebase..";host="..hostname..";port="..port..";", username, password )
    local Mysqlserial = getPlayerSerial(thePlayer)
    local MysqlQuery = dbQuery(Mysqlconnect, "SELECT * FROM accounts WHERE mtaserial='".. Mysqlserial .."'")
    local MysqlResult = dbPoll(MysqlQuery, -1)
    for k, row in ipairs(MysqlResult) do 
		if mysql:query_free("UPDATE `accounts` SET `avatar`='"..toSQL(MysqlID).."' WHERE `mtaserial`='"..toSQL(Mysqlserial).."'") then

			exports.anticheat:changeProtectedElementDataEx(thePlayer, "romcis:avatar", MysqlID)
		end
    end
end

addEvent ( "getfree:avatar" , true )
addEventHandler ( "getfree:avatar" , root , function ( ) 
if ( isTimer ( timer [ getPlayerSerial ( source ) ] ) ) then 
outputChatBox("#ffffff* #ffffff[ #0066CCArabNight #ffffff]#ffffff : لقد استلمت الافتار من قبل",source,255,255,255,true)
return
end
updateAvatar(source, myTable[ math.random( 1,#myTable ) ])
outputChatBox ( "#ffffff* #ffffff[ #0066CCArabNight #ffffff]#ffffff تم أستلام الافتار الخاص بك بنجاح ( خالد بو وليد ) " , source , 0,255,0,true)
timer [ getPlayerSerial ( source ) ] = setTimer ( function () end,9999000000000,1)
end ) ; 

function toSQL(stuff)
	return mysql:escape_string(stuff)
end
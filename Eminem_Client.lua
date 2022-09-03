local scoreboard = {};
local sx, sy = guiGetScreenSize();
local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

local localPlayer = getLocalPlayer()
local screenWidth, screenHeight = guiGetScreenSize()
scoreboard.page = "http://mta/local/html/index.html";
scoreboard.guiBrowser = guiCreateBrowser(0, 0, sx, sy, true, true, false);
scoreboard.theBrowser = guiGetBrowser(scoreboard.guiBrowser);

addEventHandler("onClientBrowserCreated", scoreboard.theBrowser, 
	function()
		loadBrowserURL(source, scoreboard.page)		
	end
)

guiSetVisible(scoreboard.guiBrowser, false)

local function getPlayerData(player, isStaff)
local playerTeam = getPlayerTeam ( player )

	local pdata = {};
	pdata.id = getElementData(player, "playerid")
	if ( not pdata.id ) then return false end;
	pdata.name 		= getPlayerName(player):gsub("#%x%x%x%x%x%x", "");
	pdata.isAFK 	= getElementData(player, "afk") or false;
	pdata.fps		= getElementData(player, "fps") or -1;
	pdata.ping		= getPlayerPing(player);
	pdata.discord		= getElementData(player, "fps") or -1;
	pdata.avatar		= getElementData(player, "romcis:avatar") or "avatars/user.png";
	--pdata.avatar		= "avatars/user.png"

	return pdata;
end

local function updatePlayers()
	local data = {};
	data.players = {};
	local players = getElementsByType("player");
	local isStaff = exports.integration:isPlayerStaff(localPlayer);
	
	data.playersCount = #players;
	for k,player in ipairs(players) do
		if (player ~= localPlayer) then
			local hasHidSco, hidScoState = exports.donators:hasPlayerPerk(localPlayer, 12);
			if (not hasHidSco or hasHidSco and hidScoState == 0) then
				local pdata = getPlayerData(player, isStaff);
				if (pdata) then
					table.insert(data.players, pdata);
				end
			end
		end
	end
	table.sort(data.players, function(a, b) return b.id > a.id end);
	
	-- insert local to be at the top
	local pdata = getPlayerData(localPlayer, isStaff);
	if (pdata) then
		table.insert(data.players, 1, pdata);
	end
	
	--outputChatBox(toJSON(data))
	executeBrowserJavascript(scoreboard.theBrowser, "refreshPlayers(`".. toJSON(data) .."`)");
	executeBrowserJavascript(scoreboard.theBrowser, 'document.getElementById("count").innerHTML = "' .. data.playersCount .. ' "')
end

function ToggleScoreboard(hkKey, hkKeyState)
    if (getElementData(localPlayer, "loggedin") ~= 1) then return end
    if (hkKeyState=="down") then
		guiSetVisible(scoreboard.guiBrowser, true )
		showCursor( true )
		updatePlayers()
		scoreboard.updateTimer = setTimer(updatePlayers, 1000, 0);
	else
		guiSetVisible(scoreboard.guiBrowser, false )
		showCursor( false )
		killTimer(scoreboard.updateTimer);
	end
end
bindKey("tab", "both", ToggleScoreboard)

local fps = 0
local fpsTick = getTickCount();
local function updateFPS(msSinceLastFrame)
    -- FPS are the frames per second, so count the frames rendered per milisecond using frame delta time and then convert that to frames per second.
    fps = (1 / msSinceLastFrame) * 1000
	if (getTickCount()-fpsTick >= 1000) then
		fpsTick = getTickCount();
		setElementData(localPlayer, "fps", math.ceil(fps));
	end
end
addEventHandler("onClientPreRender", root, updateFPS)
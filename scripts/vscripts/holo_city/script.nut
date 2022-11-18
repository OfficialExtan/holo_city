DoIncludeScript("holo_city/lib/vs_library.nut",null);

::hologramOrigin <- EntityGroup[0].GetCenter();
::TMaker <- EntityGroup[1];
::CTMaker <- EntityGroup[2];
::skullMaker <- EntityGroup[3];

::isOff <- false;
::weaponFire <- [];
::TPlayers <- [];
::CTPlayers <- [];
::Ts <- [];
::CTs <- [];
::TLights <- [];
::CTLights <- [];
::TBeams <- [];
::CTBeams <- [];
::TPlayernames <- [];
::CTPlayernames <- [];
::doneT <- false;
::doneCT <- false;
::updateTPlayernames <- false;
::updateCTPlayernames <- false;

const SCALE_FACTOR = 16;
const T_COLOR = "255 0 0";
const CT_COLOR = "0 0 255";
const SHOT_LIGHT_COLOR = "255 255 255";
const SHOT_LIGHT_DURATION = 0.1;
const SKULL_DURATION = 9;
const GROUND = -1952;

::TEAM_SPEC <- 1;
::TEAM_T <- 2;
::TEAM_CT <- 3;

function Think() {
	if(TPlayers.len() == 0 && CTPlayers.len() == 0 || isOff)
		return;
	
	if(TPlayers.len() > 0) {
		local n = 0;
		foreach(player in TPlayers) {
			local position = player.GetCenter();
			local angles = player.GetAngles();
			local height = player.GetBoundingMaxs().z / SCALE_FACTOR - 0.5;
			if(height < 4)
				height = 3.75;
			local posX = position.x / SCALE_FACTOR + hologramOrigin.x;
			local posY = position.y / SCALE_FACTOR + hologramOrigin.y;
			local posZ = position.z / SCALE_FACTOR + hologramOrigin.z - height * 2;
			
			if(!doneT) {
				TMaker.SpawnEntityAtLocation(Vector(posX, posY, posZ), Vector(0, 0, 0));
			}
			
			if(doneT && Ts.len() == TPlayers.len()) {
				Ts[n].SetOrigin(Vector(posX, posY, posZ));
				Ts[n].SetAngles(0, angles.y, 0);
				
				if(updateTPlayernames) {
					local tmpPlayer = ToExtendedPlayer(player);
					local name = player.GetScriptScope().name;
					if(tmpPlayer.IsBot()) {
						name = "Bot(" + name + ")";
					}
					TPlayernames[n].__KeyValueFromString("message", name);
				}
				
				if(weaponFire.len() > 0) {
					local index = 0;
					foreach(fire in weaponFire) {
						if(fire == player.GetScriptScope().userid) {
							Ts[n].__KeyValueFromString("rendercolor", SHOT_LIGHT_COLOR);
							TLights[n].__KeyValueFromString("_light", SHOT_LIGHT_COLOR + " 200");
							TBeams[n].__KeyValueFromString("rendercolor", SHOT_LIGHT_COLOR);
							VS.EventQueue.AddEvent(function(n) {
								if(Ts.len() > 0) {
									Ts[n].__KeyValueFromString("rendercolor", T_COLOR);
									TLights[n].__KeyValueFromString("_light", T_COLOR + " 200");
									TBeams[n].__KeyValueFromString("rendercolor", T_COLOR);
								}
							}, SHOT_LIGHT_DURATION, [this, n]);
							weaponFire.remove(index);
						}
						index++;
					}
				}
			}
			
			n++;
		}
		if(updateTPlayernames)
			updateTPlayernames = false;
	}
	
	if(CTPlayers.len() > 0) {
		local n = 0;
		foreach(player in CTPlayers) {
			local position = player.GetCenter();
			local angles = player.GetAngles();
			local height = player.GetBoundingMaxs().z / SCALE_FACTOR - 0.5;
			if(height < 4)
				height = 3.75;
			local posX = position.x / SCALE_FACTOR + hologramOrigin.x;
			local posY = position.y / SCALE_FACTOR + hologramOrigin.y;
			local posZ = position.z / SCALE_FACTOR + hologramOrigin.z - height * 2;
			
			if(!doneCT) {
				CTMaker.SpawnEntityAtLocation(Vector(posX, posY, posZ), Vector(0, 0, 0));
			}
			
			if(doneCT && CTs.len() == CTPlayers.len()) {
				CTs[n].SetOrigin(Vector(posX, posY, posZ));
				CTs[n].SetAngles(0, angles.y, 0);
				
				if(updateCTPlayernames) {
					local tmpPlayer = ToExtendedPlayer(player);
					local name = player.GetScriptScope().name;
					if(tmpPlayer.IsBot()) {
						name = "Bot(" + name + ")";
					}
					CTPlayernames[n].__KeyValueFromString("message", name);
				}
				
				if(weaponFire.len() > 0) {
					local index = 0;
					foreach(fire in weaponFire) {
						if(fire == player.GetScriptScope().userid) {
							CTs[n].__KeyValueFromString("rendercolor", SHOT_LIGHT_COLOR);
							CTLights[n].__KeyValueFromString("_light", SHOT_LIGHT_COLOR + " 200");
							CTBeams[n].__KeyValueFromString("rendercolor", SHOT_LIGHT_COLOR);
							VS.EventQueue.AddEvent(function(n) {
								if(CTs.len() > 0) {
									CTs[n].__KeyValueFromString("rendercolor", CT_COLOR);
									CTLights[n].__KeyValueFromString("_light", CT_COLOR + " 200");
									CTBeams[n].__KeyValueFromString("rendercolor", CT_COLOR);
								}
							}, SHOT_LIGHT_DURATION, [this, n]);
							weaponFire.remove(index);
						}
						index++;
					}
				}
			}
			
			n++;
		}
		if(updateCTPlayernames)
			updateCTPlayernames = false;
	}
	
	if(!doneT) {
		local ent = Entities.First();
		while (ent != null) {
			if(ent.GetClassname() == "func_physbox" && ent.tostring().find("Terrorist")) {
				ent.__KeyValueFromString("rendercolor", T_COLOR);
				Ts.push(ent);
			}
			if(ent.GetName() == "TBeam") {
				ent.__KeyValueFromString("rendercolor", T_COLOR);
				TBeams.push(ent);
			}
			if(ent.GetName() == "TPlayername") {
				TPlayernames.push(ent);
			}
			if(ent.GetName() == "TLight") {
				ent.__KeyValueFromString("_light", T_COLOR + " 200");
				TLights.push(ent);
			}
			
			ent = Entities.Next(ent);
		}
		
		doneT = true;
		updateTPlayernames = true;
	}
	
	if(!doneCT) {
		local ent = Entities.First();
		while (ent != null) {
			if(ent.GetClassname() == "func_physbox" && ent.tostring().find("Counterterrorist")) {
				ent.__KeyValueFromString("rendercolor", CT_COLOR);
				CTs.push(ent);
			}
			if(ent.GetName() == "CTBeam") {
				ent.__KeyValueFromString("rendercolor", CT_COLOR);
				CTBeams.push(ent);
			}
			if(ent.GetName() == "CTPlayername") {
				CTPlayernames.push(ent);
			}
			if(ent.GetName() == "CTLight") {
				ent.__KeyValueFromString("_light", CT_COLOR + " 200");
				CTLights.push(ent);
			}
		
			ent = Entities.Next(ent);
		}
		
		doneCT = true;
		updateCTPlayernames = true;
	}
	
	//if players join, disconnect, die or switch to spectator
	if(doneT && Ts.len() != TPlayers.len()) {
		local index = 0;
		foreach(T in Ts) {
			TBeams[index].Destroy();
			TLights[index].Destroy();
			TPlayernames[index].Destroy();
			T.Destroy();
			index++;
		}
		
		TBeams = [];
		TLights = [];
		TPlayernames = [];
		Ts = [];
		doneT = false;
	}
	
	if(doneCT && CTs.len() != CTPlayers.len()) {
		local index = 0;
		foreach(CT in CTs) {
			CTBeams[index].Destroy();
			CTLights[index].Destroy();
			CTPlayernames[index].Destroy();
			CT.Destroy();
			index++;
		}
		
		CTBeams = [];
		CTLights = [];
		CTPlayernames = [];
		CTs = [];
		doneCT = false;
	}
}

::Update <- function() {
	local tempPlayers = VS.GetAllPlayers();
	local arrT = [];
	local arrCT = [];
	foreach(player in tempPlayers) {
		if(player.GetTeam() == ::TEAM_T && player.GetHealth() > 0)
			arrT.push(player);
		else if(player.GetTeam() == ::TEAM_CT && player.GetHealth() > 0)
			arrCT.push(player);
	}
	TPlayers = arrT;
	CTPlayers = arrCT;
}

VS.ListenToGameEvent("weapon_fire", function(event) {
	if (isOff)
		return;

	local player = VS.GetPlayerByUserid(event.userid);
	
	weaponFire.push(player.GetScriptScope().userid);
}, "PlayerEvents");

VS.ListenToGameEvent("player_team", function(event) {
	Update();
}, "PlayerEvents");

VS.ListenToGameEvent("player_connect", function(event) {
	Update();
}, "PlayerEvents");

VS.ListenToGameEvent("player_disconnect", function(event) {
	Update();
}, "PlayerEvents");

VS.ListenToGameEvent("player_death", function(event) {
	Update();
	
	if(isOff)
		return;
	
	local player = ToExtendedPlayer(VS.GetPlayerByUserid(event.userid));
	
	if(player != null) {
		local position = player.GetCenter();
		local posX = position.x / SCALE_FACTOR + hologramOrigin.x;
		local posY = position.y / SCALE_FACTOR + hologramOrigin.y;
	
		skullMaker.SpawnEntityAtLocation(Vector(posX, posY, GROUND), Vector(0, rand() % 360, 0));
		
		local skull = null;
		local ent = Entities.First();
		while (ent != null) {
			if(ent.GetName() == "Skull") {
				skull = ent;
			}
			ent = Entities.Next(ent);
		}
		
		if(skull != null) {
			skull.SetOrigin(Vector(posX, posY, GROUND));
			VS.EventQueue.AddEvent(function(skull) {
				skull.Destroy();
			}, SKULL_DURATION, [this, skull]);
		}
	}
}, "PlayerEvents");

VS.ListenToGameEvent("player_spawn", function(event) {
	Update();
}, "PlayerEvents");

VS.ListenToGameEvent("round_start", function(event) {
	Update();
}, "PlayerEvents");

function SwitchOff() {
	local index = 0;
	foreach(T in Ts) {
		TBeams[index].Destroy();
		TLights[index].Destroy();
		TPlayernames[index].Destroy();
		T.Destroy();
		index++;
	}
	index = 0;
	foreach(CT in CTs) {
		CTBeams[index].Destroy();
		CTLights[index].Destroy();
		CTPlayernames[index].Destroy();
		CT.Destroy();
		index++;
	}
	TBeams = [];
	CTBeams = [];
	TLights = [];
	CTLights = [];
	TPlayernames = [];
	CTPlayernames = [];
	Ts = [];
	CTs = [];
	isOff = true;
}

function SwitchOn() {
	isOff = false;
}
_control = _this select 0;
_button = _this select 1;

switch (_button) do {
	case 0: { // Toggle AI BUTTON
		f_cam_playersOnly = !f_cam_playersOnly;
		f_cam_listUnits = [];
		lbClear 2100;
		if (f_cam_playersOnly) then {
			_control ctrlSetText "Players only";
		} else {
			_control ctrlSetText "All units";
		};
	};
	case 1: { // Side Filter
		// 0 = ALL, 1 = BLUFOR , 2 = OPFOR, 3 = INDFOR , 4 = Civ
		f_cam_sideButton = f_cam_sideButton +1;
		if (f_cam_sideButton > 4) then {f_cam_sideButton = 0};
		f_cam_side = switch (f_cam_sideButton) do {
			case 0: {nil};
			case 1: {west};
			case 2: {east};
			case 3: {independent};
			case 4: {civilian};
		};
		_control ctrlSetText (f_cam_sideNames select f_cam_sideButton);
		f_cam_listUnits = [];
		lbClear 2100;
	};
	case 2: { // Tags
		// 0 = "Off", 1 = "All Sides", 2 = "All Players", 3 = "BLUFOR", 4 = "OPFOR", 5 = "INDFOR", 6 = "CIV"
		f_cam_tagsButton = f_cam_tagsButton + 1;
		if (f_cam_tagsButton > 6) then {f_cam_tagsButton = 0};
		_control ctrlSetText (f_cam_tagsNames select f_cam_tagsButton);
		if (f_cam_tagsButton > 0) then {
			f_cam_toggleTags = true;
		} else {
			f_cam_toggleTags = false;
		};
	};
	case 3: { // Third/First Person Button
		[] call f_cam_ToggleFPCamera;
		if (f_cam_toggleCamera) then {
			_control ctrlSetText "Third Person";
		} else {
			_control ctrlSetText "First Person";
		}
	};
	case 4: { // Respawn Button
		_unit = player;
		createCenter west;
		_newGrp = createGroup west;
		_newUnit = _newGrp createUnit ["B_Soldier_F", [0,0,0], [], 0, "FORM"];
		_newUnit allowDamage true;
		_newUnit hideObjectGlobal false;
		_newUnit enableSimulationGlobal true;
		selectPlayer _newUnit;
		waitUntil {player == _newUnit};
		if (side _unit == sideLogic) then { deleteVehicle _unit; };
		
		_newUnit setPos ARC_cam_preCamPos;
		this = _newUnit;
		
		call compile ARC_cam_preCamLoadout;
		
		[] call f_fnc_ForceExit;
		[false] call acre_api_fnc_setSpectator;
	};
};
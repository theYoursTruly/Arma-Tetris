/*
 * Author: YoursTruly
 * Main preparation and run of a tetris logic. Make sure to call it on a single client.
 *
 * Arguments:
 * 0: Position of the top left corner of the board <ARRAY>
 * 1: (Optional) Starting level <NUMBER>
 * 2: (Optional) Music ON (1 - yes, 0 - no) <NUMBER>
 * 3: (Optional) Night mode (1 - yes, 0 - no) <NUMBER>
 *
 * Return Value:
 * -
 *
 * Example:
 * call yt_fnc_initTetris
 */
_this spawn {
    params [["_boardOffset", [0,0,0], [[]]], ["_level", yt_param_level, [0]], ["_musicON", yt_param_music, [0]], ["_nightMode", yt_param_night, [0]]];

    if(_nightMode == 1) then {
        setDate [2035,5,1,0,0];
    } else {
        setDate [2035,5,1,12,0];
    };
    if(_musicON == 1) then {
        yt_musicEH = addMusicEventHandler ["MusicStop", {playMusic (_this select 0);}];
        playMusic "tetrisTheme";
    };
    yt_level = _level;

    yt_lines = 0;
    yt_points = 0;
    yt_gameon = true;
    yt_pause = true;
    yt_semaphore = false;
    yt_p0 = _boardOffset;

    { if(_x != starter) then { deleteVehicle _x }; } forEach nearestObjects [yt_p0, ["Land_VR_Shape_01_cube_1m_F"], 35];

    yt_matrix = [];
    for "_x" from 0 to 23 do {
        yt_matrix pushBack [1,0,0,0,0,0,0,0,0,0,0,1];
    };
    yt_matrix pushBack [1,1,1,1,1,1,1,1,1,1,1,1];

    sleep 0.1;
    yt_nextBlock = floor random 7;
    yt_block = call yt_fnc_spawnBlock;

    waituntil {!isnull (finddisplay 46)};
    call yt_fnc_addKeybindings;

    while {yt_pause} do {
        hintSilent ("" +
            "ARMA TETRIS\n" +
            "-----------\n" +
            "SPACE - Pause/unpause\n" +
            "UP    - Rotate block\n" +
            "DOWN  - Drop block\n" +
            "LEFT  - Move block left\n" +
            "RIGHT - Move block right\n" +
            "C     - Switch to overhead view"
        );
        ["<t size='1.5'>GAME PAUSED</t>",-1,1,1,0,0] spawn BIS_fnc_dynamicText;
        sleep 1;
    };
    hint "GAME ON!";

    yt_pauseEH = addMissionEventHandler ["EachFrame", {
        if(!yt_gameon) then { removeMissionEventhandler ["EachFrame", _thisEventHandler]; };
        if(yt_pause) then {
            ["<t size='1.5'>GAME PAUSED</t>",-1,1,0.1,0,0] spawn BIS_fnc_dynamicText;
        } else {
            [format ["<t size='1' align='right'>%1 POINTS<br/>LEVEL %2</t>", yt_points, yt_level],0.6,1.1,0.1,0,0] spawn BIS_fnc_dynamicText;
        };
    }];

    // Debug printf of board's logical representation
    /*yt_blockEH = addMissionEventHandler ["EachFrame", {
        private _matrix = +yt_matrix;
        { _matrix select (_x select 0) set [_x select 1, 2] } forEach yt_block;
        private _str = "";
        for "_x" from 0 to 24 do {
            for "_y" from 0 to 11 do {
                _str = _str + (["_", "*", "$"] select (_matrix select _x select _y));
            };
            _str = _str + "\n";
        };
        hintSilent _str;
    }];*/

    while {yt_gameon} do {
        [1 - 0.218 * sqrt yt_level] call yt_fnc_pushBlockDown;
    };

    hint "GAME OVER";
    [format ["<t size='1.5' align='center'>GAME OVER<br/>%1 POINTS</t>", yt_points, yt_level],-1,1,3,0,0] spawn BIS_fnc_dynamicText;
    if(!isNil "yt_cam" && {!isNull yt_cam}) then { call yt_fnc_switchCamera; };
    (findDisplay 46) displayRemoveEventHandler ["KeyDown", yt_keyEH];
    if(_musicON == 1) then {
        removeMusicEventHandler ["MusicStop", yt_musicEH];
        playMusic "";
    };
};

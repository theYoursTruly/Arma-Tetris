/*
 * Author: YoursTruly
 * Find and remove full lines (both physically and from logical representation).
 *
 * Arguments:
 * -
 *
 * Return Value:
 * -
 *
 * Example:
 * call yt_fnc_checkLines
 */
private _newMatrix = [];
private _removedLines = [];

//remove full lines
for "_i" from 2 to 23 do {
    if( {_x == 0} count (yt_matrix select _i) == 0 ) then { //line full
        _removedLines pushBack _i;
        for "_y" from 1 to 10 do {
            { deleteVehicle _x } forEach (nearestObjects [[(yt_p0 select 0) + _i, (yt_p0 select 1) + _y], ["Land_VR_Shape_01_cube_1m_F"], 0.5]);
        };
    } else {
        _newMatrix pushBack (yt_matrix select _i);
    };
};
_newMatrix pushBack [1,1,1,1,1,1,1,1,1,1,1,1];

private _removedLinesCount = count _removedLines;
if(_removedLinesCount == 0) exitWith {};

//add new empty lines on top
for "_i" from 1 to _removedLinesCount+2 do {
 _newMatrix = [[1,0,0,0,0,0,0,0,0,0,0,1]] + _newMatrix;
};

//move physical blocks
for "_i" from 23 to 2 step -1 do {
    private _offset = {_i < _x} count _removedLines;
    if(_offset > 0) then {
        for "_y" from 1 to 10 do {
            private _blocks = nearestObjects [[(yt_p0 select 0) + _i, (yt_p0 select 1) + _y], ["Land_VR_Shape_01_cube_1m_F"], 0.5];
            if(count _blocks != 0) then {
                (_blocks select 0) setPosATL ((getPosATL (_blocks select 0)) vectorAdd [_offset,0,0]);
            };
        };
    };
};

//add points
private _points = switch (_removedLinesCount) do {
    case 4: { 1200 };
    case 3: { 300 };
    case 2: { 100 };
    case 1: { 40 };
    default { 0 };
};
yt_points = yt_points + (yt_level + 1) * _points;

//determine current level
yt_lines = yt_lines + _removedLinesCount;
if(yt_lines >= 10) then {
    yt_level = yt_level + 1;
    yt_lines = yt_lines - 10;
};

yt_matrix = _newMatrix;

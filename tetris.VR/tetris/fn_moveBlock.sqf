/*
 * Author: YoursTruly
 * Move block horizontally within the given limit.
 *
 * Arguments:
 * 0: Movement offset <NUMBER>
 *
 * Return Value:
 * True if block move successfull, false otherwise
 *
 * Example:
 * [-1] call yt_fnc_moveBlock
 */
params ["_offset"];

if(yt_pause || yt_semaphore) exitWith {};

private _newBlock = [];
private _break = false;

{
    if(yt_matrix select (_x select 0) select ((_x select 1) + _offset) == 1) exitWith { _break = true };
    _newBlock pushBack [_x select 0, (_x select 1) + _offset];
} forEach yt_block;

if(!_break) then {
    yt_block = _newBlock;
    {
        _x setPos (yt_p0 vectorAdd ((yt_block select _forEachIndex) + [0]));
    } forEach yt_objects;
};

!_break

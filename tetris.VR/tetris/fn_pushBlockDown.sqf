/*
 * Author: YoursTruly
 * Move a block down 1 line, checking for all possible events (end of board, full board etc.).
 *
 * Arguments:
 * Time to sleep after successfull drop.
 *
 * Return Value:
 * -
 *
 * Example:
 * call yt_fnc_pushBlockDown
 */
if(yt_pause) then {
    sleep 1;
} else {
    if(yt_semaphore) exitWith {};
    yt_semaphore = true;
    private _blocking = false;
    {
        if(yt_matrix select ((_x select 0)+1) select (_x select 1) == 1) then {
            _blocking = true;
            if(_x select 0 == 0) exitWith {
                yt_gameon = false;
            };
        };
    } forEach yt_block;
    
    if(_blocking) then {
        { yt_matrix select (_x select 0) set [_x select 1, 1] } forEach yt_block;
        call yt_fnc_checkLines;
        yt_block = call yt_fnc_spawnBlock;
    } else {
        for "_block" from 0 to 3 do {
            yt_block select _block set [0, (yt_block select _block select 0)+1];
            {
                _x setPos (yt_p0 vectorAdd ((yt_block select _forEachIndex) + [0]));
            } forEach yt_objects;
        };
    };
    yt_semaphore = false;
    sleep (_this select 0);
};

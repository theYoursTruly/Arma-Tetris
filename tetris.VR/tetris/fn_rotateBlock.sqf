/*
 * Author: YoursTruly
 * Physically rotate a block.
 *
 * Arguments:
 * -
 *
 * Return Value:
 * -
 *
 * Example:
 * call yt_fnc_rotateBlock
 */
if(yt_blockType == 1) exitWith {}; //O-block doesn't rotate

// select rotation coef
private _rotation = [
    [[-1,2], [0,1],  [1,0], [2,-1]],  //I-block
    [],   //O-block
    [[1,1],  [1,-1], [0,0], [-1,1]],  //T-block
    [[2,0],  [1,1],  [0,0], [-1,1]],  //S-block
    [[0,2],  [1,1],  [0,0], [1,-1]],  //Z-block
    [[0,2],  [-1,1], [0,0], [1,-1]],  //J-block
    [[2,0],  [1,-1], [0,0], [-1,1]]   //L-block
] select yt_blockType;

// modify rotation coef depending on current rotation
_rotation = _rotation apply ([
    {_x},
    {[_x select 1, -(_x select 0)]},
    {[-(_x select 0), -(_x select 1)]},
    {[-(_x select 1), _x select 0]}
] select yt_rotation);

private _newBlock = [];
private _canRotate = {
    _newBlock = [];
    private _break = false;
    { // try rotation against existing blocks and walls
        private _newXY = [(_x select 0) + (_rotation select _forEachIndex select 0),
                          (_x select 1) + (_rotation select _forEachIndex select 1)];
        if(yt_matrix select (_newXY select 0) select (_newXY select 1) == 1) exitWith { _break = true };
        _newBlock pushBack _newXY;
    } forEach yt_block;
    !_break
};

private _success = call _canRotate;
if(!_success) then {
    if([-1] call yt_fnc_moveBlock) then {
        _success = call _canRotate;
    };
    if(!_success) then {
        if([1] call yt_fnc_moveBlock) then {
            _success = call _canRotate;
        };
    }
};

if(_success) then {
    yt_block = _newBlock;
    {
        _x setPos (yt_p0 vectorAdd ((yt_block select _forEachIndex) + [0]));
    } forEach yt_objects;
    yt_rotation = (yt_rotation + 1) % 4;
};

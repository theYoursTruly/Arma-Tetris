/*
 * Author: YoursTruly
 * Create new tetris block (both physical and logical presentation).
 *
 * Arguments:
 * -
 *
 * Return Value:
 * Spawned block.
 *
 * Example:
 * call yt_fnc_spawnBlock
 */
private _types = [
    [[0,4], [0,5], [0,6], [0,7]],   //I-block
    [[0,5], [0,6], [1,5], [1,6]],   //O-block
    [[0,5], [1,6], [1,5], [1,4]],   //T-block
    [[0,6], [0,5], [1,5], [1,4]],   //S-block
    [[0,4], [0,5], [1,5], [1,6]],   //Z-block
    [[0,4], [1,4], [1,5], [1,6]],   //J-block
    [[0,6], [1,6], [1,5], [1,4]]    //L-block
];

//spawn logical block
yt_rotation = 0;
yt_blockType = yt_nextBlock;
private _block = _types select yt_blockType;

//spawn physical block
yt_objects = [];
{
    private _object = "Land_VR_Shape_01_cube_1m_F" createVehicle [0,0,0];
    _object setPos (yt_p0 vectorAdd (_x + [0]));
    yt_objects pushBack _object;
} forEach _block;

//refresh next block
private _p0_next = yt_p0 vectorAdd [5,7.5,0.5];
{ deleteVehicle _x } forEach (nearestObjects [_p0_next vectorAdd [0.5,5.5,0], ["Land_VR_Shape_01_cube_1m_F"], 2]);

yt_nextBlock = floor random 7;
{
    private _object = "Land_VR_Shape_01_cube_1m_F" createVehicle [0,0,0];
    _object setPos (_p0_next vectorAdd (_x + [0.5]));
} forEach (_types select yt_nextBlock);

_block

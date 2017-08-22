/*
 * Author: YoursTruly
 * Add keybinds to operate tetris:
 * SPACE - Pause/unpause
 * UP    - Rotate block
 * DOWN  - Drop block
 * LEFT  - Move block left
 * RIGHT - Move block right
 *
 * Arguments:
 * -
 *
 * Return Value:
 * Keybinds event handler.
 *
 * Example:
 * call yt_fnc_addKeybindings
 */
yt_keyEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
    switch (_this select 1) do {
        case 57: { //space
            yt_pause = !yt_pause;
            true
        };
        case 46: { //C
            call yt_fnc_switchCamera;
            true
        };
        case 200: { //up
            if(yt_pause || yt_semaphore) exitWith { true };
            call yt_fnc_rotateBlock;
            true
        };
        case 208: { //down
            [(0.6/(yt_level+1)) max 0.025] spawn yt_fnc_pushBlockDown;
            true
        };
        case 203: { //left
            [-1] call yt_fnc_moveBlock;
            true
        };
        case 205: { //right
            [1] call yt_fnc_moveBlock;
            true
        };
        default { false };
    };
}];

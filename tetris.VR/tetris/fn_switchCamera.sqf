/*
 * Author: YoursTruly
 * Switch between normal and overhead view.
 *
 * Arguments:
 * -
 *
 * Return Value:
 * -
 *
 * Example:
 * call yt_fnc_switchCamera
 */
if (isNil "yt_cam" || {isNull yt_cam}) then {
    yt_cam = "camera" camCreate [(yt_p0 select 0) + 13, (yt_p0 select 1) + 5.5, 20];
    yt_cam setVectorDirAndUp [[0,0,-1],[-1,0,0]];
    yt_cam switchCamera "INTERNAL";
    hint "Press C to leave this view.";
} else {
    player switchCamera "INTERNAL";
    deleteVehicle yt_cam;
    hintSilent "";
};

showTension = false;
showRail = false;
include <gradle.scad>
$fn = 128;
gradle(170, printTension = showTension, printInsert = false, printRail = showRail);
// testRig();
// rail();
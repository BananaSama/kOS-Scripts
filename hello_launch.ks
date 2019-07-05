//hellolaunch - just fiddling around and learning some syntax stuff

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

// Get a vessel by it's name.
// The name is Case Sensitive.
// set vesselName to "Guidance_Test_1.2.1".
// set currentVehicle to vessel (vesselName).

// Save the current vessel in a variable,
// in case the current vessel changes.
set currentVehicle to ship.

print currentVehicle.








//Copied from https://ksp-kos.github.io/KOS/structures/vessels/sensor.html?highlight=sensor
PRINT "Full Sensor Part Dump:".
list sensors in sensorList.

// Print list of sensors and set barometric sensor to variable pressureSensor
FOR s IN sensorList {
  print s + "  SENSOR Type: " + s:type.
  if s:type = "PRES" {
      set pressureSensor to s.
      print "Selected pressure sensor: " + pressureSensor.
  }
}

//Turn on pressureSensor
if not pressureSensor:active {
    pressureSensor:toggle().
    print "Turned on pressureSensor.".
  }
else{
    print "pressureSensor already active.".
}

//Print out current value of pressureSensor
print " ".
print "Current Barometric Pressure = " + pressureSensor:display.










//Store list (array) of engine components in engList
print " ".
PRINT "Full Engine Part Dump:".
list Engines in engList.
set engFirstStage to engList[0].
set engSecondStage to engList[1].

//Print engine list
FOR Engine IN engList {
    print Engine + " " + Engine:stage.
}.

print "First stage engine:" + engFirstStage.
print "Second stage engine:" + engSecondStage.







//Lock throttle to 100%
lock throttle to 1.0.

//This is our countdown loop, which cycles from 10 to 0
print " ".
PRINT "Counting down:".
FROM {local countdown is 5.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

// Engine Start
PRINT "Cmd Eng Start".
STAGE.



print "Eng Ramp".
// Wait for engine ramp-up, then release hold-downs
when engFirstStage:thrust > (engFirstStage:maxThrust - 1) then{
stage.
print "Lift-off".
}




//Setup log file and set log timestamp to start when this runs
log "Time (sec)" + "," + "Current Pressure (kPa)" to flightDataFile.
set t0 to floor(time:seconds).
lock logStep to round((time:seconds - t0),1) + "," + round(ship:altitude) + "," + pressureSensor:display.

set t_last to round((time:seconds - t0)).
UNTIL false {
    //log altitude vs pressure until 200000
    if round((time:seconds - t0)) > t_last{
        if ship:altitude < 200000{
        log logStep to flightDataFile.
        print logStep.
        }
        set t_last to round((time:seconds - t0)).
    }
    //check for meco and stage
    PRINT "=====Waiting for thrust to drop=====".
    when (engFirstStage:thrust < 10  and ship:altitude > 1000) then {
    //print "MECO".
    stage.

    until engSecondStage:ignition = true{
        //PRINT "Staging".
        STAGE.
        wait 2.
    }

    lock throttle to 1.
    }
    //Hold steering attitude to fly straight up
    PRINT "=====STEERING====".
    SET steerCmd TO heading(90,90).
    LOCK steering TO steerCmd.

}

//Log pressure data until vehicle altitude is > 10km
// until ship:altitude > 200000{
//     log logStep to flightDataFile.
//     print logStep.
//     wait 1.
// }



// Check for MECO and stage
// when (engFirstStage:thrust < 10  and ship:altitude > 1000) then {
//     print "MECO".
//     stage.

//     until engSecondStage:ignition = true{
//         PRINT "Staging".
//         STAGE.
//         wait 2.
//     }

//     lock throttle to 1.
// }










//Copy flight log file to Flight_Logs folder and add a unique real-world timestamp
copyPath("0:/flightDataFile", "0:/Flight_Logs/flightDataFile_" + currentVehicle:name + "_" + kuniverse:realworldtime + ".txt").
deletePath("0:/flightDataFile").

// this be a comment
#include <Stepper.h>

const int stepsPerRevolution = 24;

const int limit_cw = 2;
const int limit_ccw = 3;

int dir = -1;

Stepper myStepper(stepsPerRevolution, 4, 5, 6, 7);

void setup() {
  // set the speed at 60 rpm:
  myStepper.setSpeed(700);

  // initialize the serial port:
  Serial.begin(9600);
  pinMode(limit_cw, INPUT);
  pinMode(limit_ccw, INPUT);
}

void loop() {
  Serial.println("STEP");
  if(digitalRead(limit_cw) == LOW) {
    Serial.println("CW limit");
    dir = 1;
  }
  if(digitalRead(limit_ccw) == LOW) {
    Serial.println("CCW limit");
    dir = -1;
  }
  myStepper.step(stepsPerRevolution * dir);
  /*
  // step one revolution  in one direction:
  Serial.println("clockwise");
  myStepper.step(stepsPerRevolution);
  delay(500);

  // step one revolution in the other direction:
  Serial.println("counterclockwise");
  myStepper.step(-stepsPerRevolution);
  delay(500);
  */
}


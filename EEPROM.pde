/*
  MikroQuad v3.0 - March 2009
  www.MikroQuad.com
  Copyright (c) 2009 Ted Carancho.  All rights reserved.
  An Arduino based quadrocopter using the Sparkfun 5DOF IMU and IDG300 Dual Axis Gyro
  This version will be able to use gyros for stability (acrobatic mode) or accelerometers (experimental stable mode).
 
  This program is free software: you can redistribute it and/or modify 
  it under the terms of the GNU General Public License as published by 
  the Free Software Foundation, either version 3 of the License, or 
  (at your option) any later version. 

  This program is distributed in the hope that it will be useful, 
  but WITHOUT ANY WARRANTY; without even the implied warranty of 
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
  GNU General Public License for more details. 

  You should have received a copy of the GNU General Public License 
  along with this program. If not, see <http://www.gnu.org/licenses/>. 
*/

// Utilities for writing and reading from the EEPROM
float readFloat(int address) {
  union floatStore {
    byte floatByte[4];
    float floatVal;
  } floatOut;
  
  for (int i = 0; i < 4; i++) 
    floatOut.floatByte[i] = EEPROM.read(address + i);
  return floatOut.floatVal;
}

void writeFloat(float value, int address) {
  union floatStore {
    byte floatByte[4];
    float floatVal;
  } floatIn;
  
  floatIn.floatVal = value;
  for (int i = 0; i < 4; i++) 
    EEPROM.write(address + i, floatIn.floatByte[i]);
}

void readEEPROM() {
  for (axis = ROLL; axis < YAW; axis++) {
    PID[axis].P = readFloat(PGAIN_ADR);
    PID[axis].I = readFloat(IGAIN_ADR);
    PID[axis].D = readFloat(DGAIN_ADR);
    PID[axis].lastPosition = 0;
    PID[axis].integratedError = 0;
  }
  
  PID[YAW].P = readFloat(YAW_PGAIN_ADR);
  PID[YAW].I = readFloat(YAW_IGAIN_ADR);
  PID[YAW].D = readFloat(YAW_DGAIN_ADR);
  PID[YAW].lastPosition = 0;
  PID[YAW].integratedError = 0;
  
  for (axis = LEVELROLL; axis < (LASTLEVELAXIS); axis++) {
    PID[axis].P = readFloat(LEVEL_PGAIN_ADR);
    PID[axis].I = readFloat(LEVEL_IGAIN_ADR);
    PID[axis].D = readFloat(LEVEL_DGAIN_ADR);
    PID[axis].lastPosition = 0;
    PID[axis].integratedError = 0;
  }  
  
  windupGuard = readFloat(WINDUPGUARD_ADR);
  levelLimit = readFloat(LEVELLIMIT_ADR);
  levelInterval = readFloat(LEVELINTERVAL_ADR);
  xmitFactor = readFloat(XMITFACTOR_ADR);
  smoothFactor[GYRO] = readFloat(GYROSMOOTH_ADR);
  smoothFactor[ACCEL] = readFloat(ACCSMOOTH_ADR);
  accelZero[ROLL] = readFloat(LEVELROLLCAL_ADR);
  accelZero[PITCH] = readFloat(LEVELPITCHCAL_ADR);
  accelZero[ZAXIS] = readFloat(LEVELZCAL_ADR);
  timeConstant = readFloat(FILTERTERM_ADR);
}
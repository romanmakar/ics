#include <SPI.h>
#include <Ethernet.h>
#include <ArduinoRS485.h>
#include <ArduinoModbus.h>
#include "Led.h"
#include "Motor.h"

// Enter a MAC address for your controller below.
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
// The IP address will be dependent on your local network:
IPAddress ip(192, 168, 9, 99);
EthernetServer ethServer(502);
ModbusTCPServer modbusTCPServer;

Led led_2(2);
Led led_3(3);
Led led_4(4);
Led led_5(5);
Led led_6(6);
Led led_7(7);

Motor pump;
Motor agitator;

int procVal;
int setVal;
unsigned long myTime;
bool tick;


void setup() {
  // start the Ethernet connection && the server:
  Ethernet.begin(mac, ip);
  // start the server
  ethServer.begin();
  modbusTCPServer.begin();
  // configure a holding register at address 100
  modbusTCPServer.configureHoldingRegisters(0x64, 10);
  modbusTCPServer.configureCoils(0x64, 5);

  //  Serial.begin(9600);
  myTime = millis();
}


void loop() {
  // listen for incoming clients
  EthernetClient client = ethServer.available();

  if (client) {
    // let the Modbus TCP accept the connection 
    modbusTCPServer.accept(client);

    if (client.connected()) {
      // poll for Modbus TCP requests, while client connected
      modbusTCPServer.poll();
    } else {
      modbusTCPServer.end();
    }
  }

  //  Serial.println(pump.manAuto);

  // Discrete level (LEDs) processing
  if ((procVal > 0) && (procVal <= 200))
  {
    led_2.on();
    led_3.off();
    led_4.off();
    led_5.off();
    led_6.off();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 1);
  } else if ((procVal > 200) && (procVal <= 400))
  {
    led_2.on();
    led_3.on();
    led_4.off();
    led_5.off();
    led_6.off();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 3);
  } else if ((procVal > 400) && (procVal <= 600))
  {
    led_2.on();
    led_3.on();
    led_4.on();
    led_5.off();
    led_6.off();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 7);
  } else if ((procVal > 600) && (procVal <= 800))
  {
    led_2.on();
    led_3.on();
    led_4.on();
    led_5.on();
    led_6.off();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 15);
  } else if ((procVal > 800) && (procVal <= 1000))
  {
    led_2.on();
    led_3.on();
    led_4.on();
    led_5.on();
    led_6.on();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 31);
  } else if (procVal > 1000)
  {
    led_2.on();
    led_3.on();
    led_4.on();
    led_5.on();
    led_6.on();
    led_7.on();
    modbusTCPServer.holdingRegisterWrite(0x66, 63);
  } else {
    led_2.off();
    led_3.off();
    led_4.off();
    led_5.off();
    led_6.off();
    led_7.off();
    modbusTCPServer.holdingRegisterWrite(0x66, 0);
  }

  // Pump motor operating
  // Read pump control word
  pump.operate(modbusTCPServer.holdingRegisterRead(0x67));
  // Write pump status word
  modbusTCPServer.holdingRegisterWrite(0x69, pump.status);
  // Write pump status to coils (optional)
  modbusTCPServer.coilWrite(0x64, pump.manAuto);
  modbusTCPServer.coilWrite(0x65, pump.running);

  // Agitator motor operating
  // Read agitator control word
  agitator.operate(modbusTCPServer.holdingRegisterRead(0x68));
  // Write agitator status word
  modbusTCPServer.holdingRegisterWrite(0x6A, agitator.status);
  // Write agitator status to coils (optional)
  modbusTCPServer.coilWrite(0x66, agitator.manAuto);
  modbusTCPServer.coilWrite(0x67, agitator.running);

  // Reset motor command words
  if (modbusTCPServer.holdingRegisterRead(0x67) != 0)
  {
    modbusTCPServer.holdingRegisterWrite(0x67, 0);
  } else if (modbusTCPServer.holdingRegisterRead(0x68) != 0)
  {
    modbusTCPServer.holdingRegisterWrite(0x68, 0);
  }

  // Pump auto cycle
  if (pump.manAuto && (procVal <= 13))
  {
    pump.start();
  } else if (pump.manAuto && (procVal > setVal))
  {
    pump.stop();
  }

  // Agitator auto cycle
  if (agitator.manAuto)
  {
    agitator.start();
  }

  // 1 second timer
  if (millis() >= (myTime + 1000))
  {
    myTime = millis();
    tick = true;
  } else if (myTime > millis())
  {
     myTime = millis();
  }

  // Level auto simulation
  if (pump.manAuto && pump.running)
  {
    if (tick)
    {
      procVal += 13;
      tick = false;
    }
  } else if (pump.manAuto && !pump.running )
  {
    if (tick)
    {
      procVal -= 7;
      tick = false;
    }
  } else {
    procVal = analogRead(A0);
  }

  // Write Process Value to modbus
  modbusTCPServer.holdingRegisterWrite(0x64, procVal);
  // Read Set Point from modbus
  setVal = modbusTCPServer.holdingRegisterRead(0x65);
}
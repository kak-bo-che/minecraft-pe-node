from __future__ import print_function
import re
import os
import json
import logging
from asyncore import file_dispatcher, loop
from traceback import print_exc
from evdev import InputDevice, list_devices, categorize, ecodes, events

class ButtonDispatcher(file_dispatcher):
  def __init__(self, device, ButtonPressMethod, connectionLostMethod):
    self.device = device
    self.ButtonPressMethod = ButtonPressMethod
    self.connectionLostMethod = connectionLostMethod
    file_dispatcher.__init__(self, device)

  def recv(self, ign=None):
    return self.device.read()

  def translate_dpad(self, cat_event):
    if 'ABS_HAT0X' == events.ABS[cat_event.event.code]:
      if cat_event.event.value > 0:
        button = 'KEY_RIGHT'
      else:
        button = 'KEY_LEFT'
    else:
      if cat_event.event.value > 0:
        button = 'KEY_DOWN'
      else:
        button = 'KEY_UP'
    return button


  def handle_read(self):
    for event in self.recv():
      cat_event = categorize(event)

      if (event.type == ecodes.EV_ABS and
          re.match('ABS_HAT', str(events.ABS[cat_event.event.code])) and
          cat_event.event.value != 0):
        self.ButtonPressMethod(self.translate_dpad(cat_event))

      if event.type == ecodes.EV_KEY:
        if cat_event.keystate == events.KeyEvent.key_down:
          if isinstance(cat_event.keycode,(list)):
            btn_name = next(btn for btn in cat_event.keycode if re.match('BTN_.$', btn))
            self.ButtonPressMethod(btn_name)
          else:
            self.ButtonPressMethod(cat_event.keycode)
        else:
          pass

  def handle_error(self):
    print_exc()
    self.del_channel(self._map) # why isn't this done by the library?
    self.connectionLostMethod()

class KeyboardControl(object):
  device = None
  inputDevice = None

  def __init__(self, buttonPressMethod):
    self.connected = False
    self.dispatcher = None
    self.buttonPressMethod = buttonPressMethod
    self.connectToEzKey()

  def connectToEzKey(self):
    print("connecting keyboard")
    logging.info("Looking for BT devices")
    self.device = self.findEzKey()
    if self.device:
      self.inputDevice = InputDevice(self.device)
      self.dispatcher = ButtonDispatcher(self.inputDevice, self.buttonPressMethod, self.connectionLost)
      self.connected = True

  def connectionLost(self):
    self.connected = False

  def findEzKey(self):
    device = None
    devices = [InputDevice(fn) for fn in list_devices()]
    for dev in devices:
      if re.match('Adafruit EZ-Key|Zeemote: SteelSeries FREE', dev.name):
        print(dev.fn)
        device = dev.fn
        break
    return device

  def read_keys(self):
    if self.inputDevice and self.connected:
      loop(timeout=1, count=1)
    else:
      self.connectToEzKey()

def main():
  debug = lambda k: print(k)
  keyboard = KeyboardControl(debug)
  while(True):
    keyboard.read_keys()

if __name__ == '__main__':
  main()

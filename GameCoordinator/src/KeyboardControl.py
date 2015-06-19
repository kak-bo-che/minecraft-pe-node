import re
import json
import logging
from evdev import InputDevice, list_devices, categorize, ecodes


#  ('/dev/input/event0', 'Adafruit EZ-Key 57f1', '00:1a:7d:da:71:13')

class KeyboardControl(object):
  device = None
  inputDevice = None

  def __init__(self):
    self.device = self.findEzKey()
    logging.info("Looking for BT devices")
    if not self.device:
      raise IOError("EZ-Key device was not found")
    self.inputDevice = InputDevice(self.device)

  def findEzKey(self):
    device = None
    devices = [InputDevice(fn) for fn in list_devices()]
    for dev in devices:
      if re.match('Adafruit EZ-Key', dev.name):
        device = dev.fn
        break
    return device

  def read_keys(self):

    if self.inputDevice:
      try:
        # for event in self.inputDevice.read_loop():
        event = self.inputDevice.read_one()
        if event and event.type == ecodes.EV_KEY:
          cat_event = categorize(event)
          if cat_event.keystate == 1:
            return cat_event.keycode
        elif event:
          pass
        else:
          return None
      except IOError:
        print "Lost HID Device exiting"
        exit(1)

import re
from evdev import InputDevice, list_devices, categorize, ecodes


#  ('/dev/input/event0', 'Adafruit EZ-Key 57f1', '00:1a:7d:da:71:13')

class GameCoordinator(object):
  self.device = None
  self.inputDevice = None

  def __init__(self):
    self.device = self.findEzKey()
    if not self.device:
      print "EZ-Key device was not found"
      exit(1)
    self.inputDevice = InputDevice(self.device)
    self.read_keys()

  def findEzKey(self):
    device = None
    devices = [InputDevice(fn) for fn in list_devices()]
    for dev in devices:
      if re.match('Adafruit EZ-Key', dev[1]):
        device = dev[0]
        break
    return device

  def read_keys(self):
    if self.inputDevice:
      for event in self.inputDevice.read_loop():
        if event.type == ecodes.EV_KEY:
        print(categorize(event))
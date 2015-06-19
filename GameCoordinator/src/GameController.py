from KeyboardControl import KeyboardControl
from transitions import Machine
import requests
import sched, time
import json

class GameController(object):
  headers = {'content-type': 'application/json'}
  url = "http://localhost:8080/"
  states = ['stopped', 'forward', 'back']

  def __init__(self):
    self.weapons = self.get_weapons()
    self.current_weapon = 0
    self.direction = 0
    self.machine = Machine(model=self, states=GameController.states, initial='stopped')
    self.machine.add_transition('stop', '*', 'stopped', before='stop_direction')
    self.machine.add_transition('play', 'stopped', 'forward', before= 'forward_direction')
    self.machine.add_transition('reverse', 'stopped', 'back', before= 'reverse_direction')
    self.keboard_control = KeyboardControl()
    self.events = {
      "KEY_ENTER":self.stop,
      "KEY_LEFT":self.reverse,
      "KEY_RIGHT": self.play,
      "KEY_UP": self.play,
      "KEY_DOWN": self.reverse
    }

  def stop_direction(self):
    self.direction=0

  def forward_direction(self):
    self.direction = 1

  def reverse_direction(self):
    self.direction = -1

  def display(self):
    if self.direction == 0:
      pass
    elif self.direction == 1:
      if self.current_weapon == len(self.weapons) - 1:
        self.current_weapon = 0
      else:
        self.current_weapon = self.current_weapon + 1
    else:
      if self.current_weapon == 0:
        self.current_weapon = len(self.weapons) - 1
      else:
        self.current_weapon = self.current_weapon - 1
    self.show_weapon(self.weapons[self.current_weapon])

  def run(self):
    while(True):
      key = self.keboard_control.read_keys()
      if key:
        self.events[key]()
      time.sleep(1)
      self.display()

  def get_weapons(self):
    req = requests.get(self.url + 'blocks')
    return req.json()['blocks']

  def show_weapon(self, weapon):
    payload = {"block":weapon}
    r = requests.post(self.url + "block", data=json.dumps(payload), headers=self.headers)
    print r

def main():
  game_controller = GameController()
  game_controller.run()

main()

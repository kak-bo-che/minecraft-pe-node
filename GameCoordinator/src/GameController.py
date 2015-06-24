from KeyboardControl import KeyboardControl
from RemoteConsole import RemoteConsole
from transitions import Machine
from Minecraft import Constants
import requests
import random
import sched, time
import json

class GameController(object):
  headers = {'content-type': 'application/json'}
  url = "http://localhost:8080/"
  states = ['stopped', 'forward', 'back']

  def __init__(self, password):
    self.setupPocketmineConnection(password)
    self.setupStateMachine()
    self.setupKeyboardControl()
    self.current_item = 0
    self.direction = 0
    self.setupStateMachine()

  def setupPocketmineConnection(self, password):
    self.pocketmine_password = password
    self.pocketmine = RemoteConsole(password)
    self.users = self.pocketmine.getUsers()
    self.items = self.get_items()

  def setupKeyboardControl(self):
    self.events = {
      "KEY_ENTER":self.stop,
      "KEY_LEFT":self.reverse,
      "KEY_RIGHT": self.play,
      "KEY_UP": self.play,
      "KEY_DOWN": self.reverse
    }
    self.keboard_control = KeyboardControl(self.direction_control)

  def setupStateMachine(self):
    self.machine = Machine(model=self, states=GameController.states, initial='stopped', ignore_invalid_triggers=True)
    self.machine.add_transition('stop', '*', 'stopped', before='stop_direction')
    self.machine.add_transition('play', 'stopped', 'forward', before= 'forward_direction')
    self.machine.add_transition('reverse', 'stopped', 'back', before= 'reverse_direction')

  def direction_control(self, key):
    self.debug(key)
    self.events[key]()

  def debug(self, key):
    print "Key received: %s" % key

  def stop_direction(self):
    self.direction=0
    if self.users:
      user = self.users[random.randrange(len(self.users))]
      item = self.items[self.current_item]
      self.pocketmine.giveItem(user, item)

  def forward_direction(self):
    self.direction = 1

  def reverse_direction(self):
    self.direction = -1

  def display(self):
    if self.direction == 0:
      pass
    elif self.direction == 1:
      if self.current_item == len(self.items) - 1:
        self.current_item = 0
      else:
        self.current_item = self.current_item + 1
    else:
      if self.current_item == 0:
        self.current_item = len(self.items) - 1
      else:
        self.current_item = self.current_item - 1
    self.show_item(self.items[self.current_item])

  def run(self):
    while(True):
      self.keboard_control.read_keys()
      self.display()
      time.sleep(0.25)

  def get_items(self):
    req = requests.get(self.url + 'items')
    return req.json()['items']

  def show_item(self, item):
    payload = {"item":item}
    if self.direction:
      r = requests.post(self.url + "item", data=json.dumps(payload), headers=self.headers)
      print r

def main():
  password="hTbVnCj50G"
  game_controller = GameController(password)
  game_controller.run()

if __name__ == '__main__':
  main()

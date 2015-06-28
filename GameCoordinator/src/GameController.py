from KeyboardControl import KeyboardControl
from RemoteConsole import RemoteConsole
from ScreenControl import ScreenControl
from transitions import Machine
from Minecraft import Constants
from random import randrange
import sched, time
import json

class GameController(object):

  def __init__(self, password, uri):
    self.setupPocketmineConnection(password)
    self.setupStateMachine()
    self.setupKeyboardControl()

    self.display = ScreenControl(uri)
    self.items = self.display.get_items()

    self.current_item = 0
    self.direction = 0
    self.timeout_event = None
    self.target_player = None
    self.scheduler = sched.scheduler(time.time, time.sleep)

  def setupPocketmineConnection(self, password):
    self.pocketmine_password = password
    self.pocketmine = RemoteConsole(password)

  def setupKeyboardControl(self):
    self.events = {
      "KEY_ENTER":self.key_enter,
      "KEY_LEFT":self.key_left,
      "KEY_RIGHT": self.key_right,
      "KEY_UP": self.key_up,
      "KEY_DOWN": self.key_down
    }
    self.keboard_control = KeyboardControl(self.direction_control)

  def setupStateMachine(self):
    self.states = [
    'start', 'stopped',
    'random_get', 'random_teleport', 'random_steal', 'random_build',
    'send_current_item', 'transport_to_player', 'take_from_player', 'build_current_building']

    self.transitions = [
        { 'trigger': 'key_enter', 'source': 'stopped', 'dest': 'start', 'after': 'waitForButtonPress'},
        { 'trigger': 'key_up',    'source': 'start', 'dest': 'random_get', 'after': 'waitForButtonPress' },
        { 'trigger': 'key_down',  'source': 'start', 'dest': 'random_teleport', 'after': 'waitForButtonPress' },
        { 'trigger': 'key_right', 'source': 'start', 'dest': 'random_steal', 'after': 'waitForButtonPress' },
        { 'trigger': 'key_left',  'source': 'start', 'dest': 'random_build', 'after': 'waitForButtonPress' },

        { 'trigger': 'key_enter', 'source': 'random_get',      'dest': 'send_current_item', 'before': 'sendItem','after': 'scheduleStop' },
        { 'trigger': 'key_enter', 'source': 'random_teleport', 'dest': 'transport_to_player', 'before': 'teleportPlayer', 'after': 'scheduleStop' },
        { 'trigger': 'key_enter', 'source': 'random_steal',    'dest': 'take_from_player', 'after': 'scheduleStop' },
        { 'trigger': 'key_enter', 'source': 'random_build',    'dest': 'build_current_building', 'after': 'scheduleStop' },
        { 'trigger': 'go_idle', 'source': '*', 'dest': 'stopped', 'after': 'clearDisplay'}
    ]
    self.machine = Machine(model=self, states=self.states, transitions=self.transitions, initial='stopped', ignore_invalid_triggers=True)

  def sendItem(self):
    self.pocketmine.giveItem(self.player, self.current_item)

  def teleportPlayer(self):
    self.pocketmine.teleport(self.player, self.target_player)

  def direction_control(self, key):
    self.debug(key)
    self.events[key]()

  def scheduleStop(self):
    self.scheduler.enter(5, 1, self.go_idle, ())

  def debug(self, key):
    print "Key received: %s" % key

  def printState(self):
    print self.state

  # def stop_direction(self):
  #   if self.users:
  #     user = self.users[randrange(len(self.users))]
  #     item = self.items[self.current_item]
  #     self.pocketmine.giveItem(user, item)

  def displayItem(self):
    if self.state == 'random_get':
      self.current_item = self.items[randrange(len(self.items))]
      self.display.show_item(self.current_item)
    if self.state == 'random_teleport':
      players = self.pocketmine.getPlayers()
      self.target_player = players[randrange(len(players))]
      self.display.show_player(self.target_player)


  def clearDisplay(self):
    self.display.power_off()

  def timeout(self):
    print "Timeout"
    self.timeout_event = None
    self.go_idle()

  def checkButtonState(self, current_state):
    self.printState()
    self.keboard_control.read_keys()
    self.displayItem()

    if self.state == current_state:
      self.scheduler.enter(0.25, 1, self.checkButtonState, (current_state,))
    else:
      self.clearTimeoutEvent()

  def clearTimeoutEvent(self):
    if self.timeout_event:
      self.scheduler.cancel(self.timeout_event)
      self.timeout_event = None

  def waitForButtonPress(self):
    self.clearTimeoutEvent()
    current_state = self.state
    # Timeout for button press
    self.timeout_event = self.scheduler.enter(5, 1, self.timeout, ())
    self.checkButtonState(current_state)
    self.scheduler.run()

  def luckyUser(self):
    players = self.pocketmine.getPlayers()
    if players:
      self.player = players[randrange(len(players))]
      self.pocketmine.tellPlayer(self.player, "Time to Choose!")
      self.key_enter()
      sleepTime = randrange(120)
      print "Sleeping for: %d seconds" %sleepTime
      time.sleep(sleepTime)
    else:
      print "Waiting for Players to connect"
      time.sleep(5)


  def run(self):
    while(True):
      self.luckyUser()

def main():
  password="hTbVnCj50G"
  uri="http://localhost:8080/"
  game_controller = GameController(password, uri)
  game_controller.run()

if __name__ == '__main__':
  main()
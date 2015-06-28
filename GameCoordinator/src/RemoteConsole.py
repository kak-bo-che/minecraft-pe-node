import subprocess
from Minecraft import Constants
from subprocess import check_output
import os

class RemoteConsole(object):
  def __init__(self, password, host="127.0.0.1", port=19132):
    self.cmd = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../mcrcon/mcrcon'))
    self.host = host
    self.port = port
    self.password = password
    self.default_command = [self.cmd, "-c", "-p", self.password, "-H", self.host, "-P", str(self.port)]
    self.users = []

  def getPlayers(self):
    # ./mcrcon -p hTbVnCj50G -H 127.0.0.1 -P 19132 'list'
    self.users = []
    parameters = ['list']
    output = self._executeCommand(parameters)
    raw_users = output.split(':')[1].strip()
    if raw_users:
      self.users = [user.strip() for user in raw_users.split(',')]
    return self.users

  def teleport(self, player1, player2):
    parameters = ['tp', player1, player2]
    self._executeCommand(parameters)

  def giveItem(self, player, item, damage=0, amount=1):
    item_id = Constants.ITEMS[item][0]
    parameters = ['give', player, str(item_id), str(amount)]
    print parameters
    self._executeCommand(parameters)

  def tellPlayer(self, player, message):
    print "tell %s: %s" %(player, message)
    parameters = ['tell', player, message]
    self._executeCommand(parameters)

  def _executeCommand(self, parameters):
    command = list(self.default_command)
    command.append(' '.join(parameters))
    print command
    try:
      check_output(command, stderr=subprocess.STDOUT)
      return ""
       # always returns non zero exit code ...
    except subprocess.CalledProcessError as e:
      print e.output
      return e.output

def main():
  remoteConsole = RemoteConsole(host="127.0.0.1", port=19132, password="hTbVnCj50G")
  users =  remoteConsole.getPlayers()
  if users:
    remoteConsole.giveItem(users[0], 'Gunpowder')

if __name__ == '__main__':
  main()
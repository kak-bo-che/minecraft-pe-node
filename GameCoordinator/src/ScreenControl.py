import json
import requests

class ScreenControl(object):
  def __init__(self, uri="http://localhost:8080/"):
    self.headers = {'content-type': 'application/json'}
    self.uri = uri

  def show_item(self, item):
    payload = {"item":item}
    r = requests.post(self.uri + "item", data=json.dumps(payload), headers=self.headers)

  def show_player(self, player):
    payload = {"player":player}
    r = requests.post(self.uri + "player", data=json.dumps(payload), headers=self.headers)

  def get_items(self):
    req = requests.get(self.uri + 'items')
    return req.json()['items']

  def power_off(self):
    r = requests.post(self.uri + "off")

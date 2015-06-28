
from bottle import route, run, template, request, abort, Bottle
from PIL import Image, ImageDraw, ImageFont
from rpi_rgb_led_matrix.rgbmatrix import Adafruit_RGBmatrix
from bibliopixel.drivers.driver_base import *
from os import listdir
import os
from Minecraft import Constants
from os.path import isfile, join
import glob
# Rows and chain length are both required parameters:

# curl -XPOST -H "Content-Type: application/json" localhost:8080/item -d '{"item":"100"}'

# blocks = [ f.split('.png')[0] for f in listdir('./minecraft') if isfile(join('./minecraft',f)) ]
# current_block = 'Grass.png'

class ScreenServer(Bottle):
  def __init__(self):
    super(ScreenServer, self).__init__()
    self.matrix = Adafruit_RGBmatrix(32, 1)
    self.matrix.Clear()
    self.displayState = True;
    self.brightness = 1.0;
    self.items = Constants.ITEMS
    self.image = Image.open('/home/minecraft/minecraft-screen-server/Items.png')
    self.route('/off' , method='POST', callback=self.off)
    self.route('/items', method='GET', callback=self.get_items)
    self.route('/item', method='POST', callback=self.set_item)
    self.route('/item_id', method='POST', callback=self.set_item_id)
    self.route('/player', method='POST', callback=self.set_player)

  def load_item_id(self, id):
    x = (id%16)*32
    y = (id/16)*32
    self.matrix.Clear()
    item_image = self.image.crop((x,y,x+32,y+32))
    item_image.load()
    self.matrix.SetImage(item_image.im.id,0,0)

  def off(self):
    self.matrix.Clear()

  def get_items(self):
      return {'items' :self.items.keys()}

  def set_item(self):
    item_name = request.json.get('item')
    id = self.items[item_name][1]
    self.load_item_id(id)

  def set_item_id(self):
    id = request.json.get('item')
    id = int(id)
    if id < 256:
      self.load_item_id(id)

  def set_player(self):
    self.matrix.Clear()
    player_name = request.json.get('player')
    if player_name:
      image_path = join(os.path.dirname(os.path.abspath(__file__)), '4x6.pil')
      font = ImageFont.load(image_path)
      image = Image.new("1", (32, 32))
      draw  = ImageDraw.Draw(image)
      draw.text((0,13), player_name, font=font, fill='red')
      self.matrix.SetImage(image.im.id, 0, 0)

if __name__ == '__main__':
  server = ScreenServer()
  server.run(host='0.0.0.0', port=8080)

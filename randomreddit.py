import urllib.request as r
from tkinter import Tk, Label
from random import choice
from os import system
from json import load
from PIL import Image, ImageTk

subreddits = [f'https://reddit.com/r/{i}.json'
              for i in ['pics', 'memes', 'funny']]

j = load(r.urlopen(choice(subreddits)))

def get_url():
    url = choice(j['data']['children'])['data']['url']
    if 'i.redd.it' in url:
        return url
    else:
        return get_url()
    
def mf():
    url = get_url()
    print(url)

    img = r.urlopen(r.Request(url, None, {'User-agent' : 'Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5'}))
    root = Tk()
    img2 = Image.open(img)
    newsize = (img2.size[0], 740)
    img2.thumbnail(newsize, Image.ANTIALIAS)
    a = ImageTk.PhotoImage(img2)

    labela = Label(root, image=a)
    labela.pack()
    root.mainloop()

mf()

__author__ = 'Edward'

import os

def clear():
    os.system('cls' if os.name=='nt' else 'clear')

def game_cover():
    print("""
      ___                _      _             _                   
     |   \ ___  __ _    /_\  __| |_ _____ _ _| |_ _  _ _ _ ___ ___
     | |) / _ \/ _` |  / _ \/ _` \ V / -_) ' \  _| || | '_/ -_|_-<
     |___/\___/\__, | /_/ \_\__,_|\_/\___|_||_\__|\_,_|_| \___/__/
               |___/
               
               ____,'`-, 
          _,--'   ,/::.; 
       ,-'       ,/::,' `---.___        ___,_ 
       |       ,:';:/        ;'"`;"`--./ ,-^.;--. 
       |:     ,:';,'         '         `.   ;`   `-. 
        \:.,:::/;/ -:.                   `  | `     `-. 
         \:::,'//__.;  ,;  ,  ,  :.`-.   :. |  ;       :. 
          \,',';/O)^. :'  ;  :   '__` `  :::`.       .:' ) 
         |,'  |\__,: ;      ;  '/O)`.   :::`;       ' ,' 
               |`--''            \__,' , ::::(       ,' 
               `    ,            `--' ,: :::,'\   ,-' 
                | ,;         ,    ,::'  ,:::   |,' 
                |,:        .(          ,:::|   ` 
                ::'_   _   ::         ,::/:| 
               ,',' `-' \   `.      ,:::/,:| 
              | : _  _   |   '     ,::,' ::: 
              | \ O`'O  ,',   ,    :,'   ;:: 
               \ `-'`--',:' ,' , ,,'      :: 
                ``:.:.__   ',-','        ::' 
        -hrr-      `--.__, ,::.         ::' 
                       |:  ::::.       ::' 
                       |:  ::::::    ,::'
                       
    """)

def setup():
    global name
    global HP
    global hunger
    global npcnamechoice
    global npcresponses
    global npcanimal
    name = raw_input("What is your name little dog? ")
    HP = randint(10,20)
    hunger = randint(0,50)
    npcnamechoice = ["Bob", "Frank", "Sarah", "Sally"]
    npcresponses = ["I am a lost animal.", "Are you a hero?", "Are you from this part of town?", "There are many dangers lurking for stray animals."]
    npcanimal = ["dog", "cat", "hamster", "rabbit"]

class npc(object):

    def __init__(self):
        self.name = random.choice(npcnamechoice)
        self.response = random.choice(npcresponses)
        self.animal = random.choice(npcanimal)

    def talk(self):
        print("\n=== You encounter a stray animal. ===\n")
        print("\n["+self.name+":] Hello, my name is "+self.name+", I am a stray "+self.animal+". Would you like to talk to me?\n")
        print("Press y to talk.")
        if raw_input() == "y" or "Y":
            print("["+self.name+":] "+self.response)
        else:
            print("["+self.name+":] Goodbye")

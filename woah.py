import win32console as console
import os, sys
try:
    buffer = console.CreateConsoleScreenBuffer()
except:
    print('Run in CMD!')
    exit()
buffer.SetConsoleTextAttribute(console.FOREGROUND_BLUE)
buffer.SetConsoleActiveScreenBuffer()
buffer.WriteConsole('lol\n')
sys.stdout.flush()
os.system('pause')
buffer.Close()

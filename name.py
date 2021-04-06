import os

with os.scandir('C:\\Users\\') as it:
    for entry in it:
        if not entry.name.startswith('.') and entry.is_file():
            print(entry.path)
            file = open(entry.path)
            print(file.read())
            file.close()

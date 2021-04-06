from pathlib import Path
from os import remove

# remove texture checksums

for path in Path('stu').rglob('*.png'):
    with open(path, 'rb') as f:
        f.seek(12)
        rest = f.read()
    with open(path, 'wb') as f:
        f.write(rest)

print("done png")

for path in Path('stu').rglob('*.jpg'):
    with open(path, 'rb') as f:
        f.seek(12)
        rest = f.read()
    with open(path, 'wb') as f:
        f.write(rest)

print("done jpg")

# remove compiled code

for path in Path('stu').rglob('*.luac'):
    remove(path)

import os, sys

def removeEmptyFolders(path, removeRoot=True):
  'Function to remove empty folders'
  if not os.path.isdir(path):
    return

  # remove empty subfolders
  files = os.listdir(path)
  if len(files):
    for f in files:
      fullpath = os.path.join(path, f)
      if os.path.isdir(fullpath):
        removeEmptyFolders(fullpath)

  # if folder empty, delete it
  files = os.listdir(path)
  if len(files) == 0 and removeRoot:
    print("Removing empty folder:", path)
    os.rmdir(path)

removeEmptyFolders('stu')

print("done")

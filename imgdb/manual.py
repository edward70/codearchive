import requests
import mimetypes
import hashlib
import sys
import sqlite3

url = sys.argv[1]
headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
r = requests.get(url, headers=headers) # fetch image

# file extension from content-type header
extension = mimetypes.guess_extension(r.headers['content-type'])
if r.headers['content-type'] == 'image/webp':
    extension = '.webp'

content = r.content # image bytes
content_hash = hashlib.sha256(content).hexdigest() # image hash
filename = content_hash + extension # filename

# connect to database
conn = sqlite3.connect('database.db')
c = conn.cursor()

contains_hash = c.execute('SELECT * FROM files WHERE hash=?', (content_hash,)).fetchone()

# see if database already has identical file
if not contains_hash:
    open('img/' + filename, 'wb').write(content) # write file to filesystem
    c.execute('INSERT INTO files VALUES (?,?)', (content_hash, filename))
else:
    print("File already in database.")

already_matched = c.execute('SELECT * FROM urls WHERE url=? AND hash=?', (url, content_hash)).fetchone()

# see if database already matched
if not already_matched:
    c.execute('INSERT INTO urls VALUES (?,?)', (url, content_hash))
else:
    print("Url already matched in database.")

manually_added = c.execute('SELECT * FROM manual WHERE url=?', (url,)).fetchone()

# see if it was manually added before            
if not manually_added:
    c.execute('INSERT INTO manual VALUES (?)', (url,))
else:
    print("Url already manually added.")

conn.commit() # save changes
conn.close() # close database

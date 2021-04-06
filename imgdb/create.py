import sqlite3

def create_tables():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()

    c.execute("CREATE TABLE files (hash CHAR(64) UNIQUE, filename VARCHAR(80) UNIQUE)")
    c.execute("CREATE TABLE urls (url TEXT, hash CHAR(64))")
    c.execute("CREATE TABLE manual (url TEXT)")

    conn.commit()
    conn.close()

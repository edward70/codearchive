import requests, os, time
from hashlib import sha256

# bearer token to authorise requests
token = open("token.txt").read()

# headers for requesting feed
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer {}".format(token),
    "[REDACTED]-PLATFORM": "ANDROID",
    "[REDACTED]-DEVICE-MODEL": "HUAWEI",
    "[REDACTED]-DEVICE-APP-VERSION": "1.9381.0001",
    "[REDACTED]-ACCEPT-LANGUAGE": "en",
    "[REDACTED]-SUB-PLATFORM": "[REDACTED]",
    "Connection": "Keep-Alive",
    "Accept-encoding": "gzip",
    "User-Agent": "okhttp/3.10.0",
}

# headers for downloading images
download_headers = {
    "Accept-encoding": "gzip",
    "User-Agent": "Dalvik/2.1.0 (Linux; U; Android 5.1; HUAWEI)",
    "Connection": "Keep-Alive",
}

# endpoint url
url = "http://[REDACTED].com/feed/v1/forums/{}/posts?offset={}&limit=3"

class Scraper:
    def __init__(self, forum, dest):
        self.forum = forum
        self.current_index = 0
        self.dest = dest
        if not os.path.exists(self.dest):
            os.mkdir(self.dest) # create destination directory

    def get_feed(self):
        feedurl = url.format(self.forum, self.current_index)
        self.current_index += 3 # increment index for next request
        print(self.current_index)
        r = requests.get(feedurl, allow_redirects=True, headers=headers)
        return r.json()

    def downloadimg(self, url):
        # request image data
        data = requests.get(url, allow_redirects=True, headers=download_headers).content
        # determine file type
        if '.JPEG' in url or '.jpeg' in url or '.jpg' in url or '.JPG' in url:
            basename = "{}\\{}.jpeg"
        elif '.GIF' in url or '.gif' in url:
            basename = "{}\\{}.gif"
        elif '.WEBP' in url or '.webp' in url or '.WebP' in url:
            basename = "{}\\{}.webp"
        else:
            basename = "{}\\{}.png"
        # base64 encode url and urlencode for filename and put in folder
        filename = basename.format(self.dest, sha256(data).hexdigest())
        # write out file
        if os.path.exists(filename):
            print("{} already exists".format(filename))
        else:
            with open(filename, 'wb') as f:
                f.write(data)
                f.close()

    def downloadvid(self, url):
        # base64 encode url and urlencode for filename and put in folder
        filename = "{}\\{}.mp4".format(self.dest, "VID-" + sha256(str.encode(url)).hexdigest())
        # cheat with ffmpeg :D
        if os.path.exists(filename):
            print("{} already exists".format(filename))
        else:
            print("downloading {}".format(url))
            os.system("ffmpeg -i {} -c copy -bsf:a aac_adtstoasc {}".format(url, filename))
            print("done")

    def scrape(self):
        # go through all of feed
        while True:
            # don't ddos the endpoint lol
            time.sleep(1)
            # fetch chunk
            feed = self.get_feed()["data"]
            # break if done
            if len(feed) == 0:
                print("all done bois")
                break
            # iterate chunk
            for post in feed:
                # determine media type
                if post["postType"] == "IMAGE":
                    self.downloadimg(post['multimedia']['mediaUrl'])
                elif post["postType"] == "VIDEO" or post["postType"] == "LIVE":
                    self.downloadvid(post['multimedia']['mediaUrl'])
                else:
                    pass # we don't care about text posts
      

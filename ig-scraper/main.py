from profile import Profile
from data import TagData
from bs4 import BeautifulSoup
from post import Post
import requests
import json
  
def get_profile(user):
    headers = {
        "accept": "/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "en-US,en;q=0.9",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
    }
    req = requests.get('https://instagram.com/' + user, headers=headers)
    soup = BeautifulSoup(req.text, 'html.parser')
    meta = json.loads(soup.find_all(type="application/ld+json")[0].get_text().strip())
    shared = json.loads(soup.select("body > script")[0].get_text()[21:-1])
    return Profile(meta, shared)

def get_tag(tag):
    headers = {
        "accept": "/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "en-US,en;q=0.9",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
    }
    req = requests.get('https://instagram.com/tags/' + tag, headers=headers)
    soup = BeautifulSoup(req.text, 'html.parser')
    shared = json.loads(soup.select("body > script")[0].get_text()[21:-1])
    return TagData(shared)

def get_page(shortcode):
    headers = {
        "accept": "/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "en-US,en;q=0.9",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
    }
    req = requests.get('https://instagram.com/p/' + shortcode, headers=headers)
    soup = BeautifulSoup(req.text, 'html.parser')
    meta = json.loads(soup.find_all(type="application/ld+json")[0].get_text().strip())
    shared = json.loads(soup.select("body > script")[0].get_text()[21:-1])
    return Post(meta, shared)

def get_story():
    headers = {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.5",
        "Connection": "keep-alive",
        "Host": "www.instagram.com",
        "Referer": "https://www.instagram.com/story/highlights/18026551780049605/",
        "TE": "Trailers",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36",
        "X-IG-App-ID": "1217981644879628",
        "X-Instagram-GIS": "f5cd5815d777f572756d779be47e808b",
        "X-Requested-With": "XMLHttpRequest"
    }
    req = requests.get('https://www.instagram.com/graphql/query/?query_hash=20cb92f1c3997aa6547733c1da67f640&variables={"reel_ids":[],"tag_names":[],"location_ids":[],"highlight_reel_ids":["18026551780049605"],"precomposed_overlay":true,"show_story_viewer_list":true,"story_viewer_fetch_count":50,"story_viewer_cursor":""}', headers=headers)
    print(req.text)

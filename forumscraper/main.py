import argparse
from scraper import Scraper

parser = argparse.ArgumentParser(description='Scraper')
parser.add_argument('forum', type=str, help='forum code to scrape')
parser.add_argument('folder', type=str, help='Destination folder')

args = parser.parse_args()

my_scraper = Scraper(args.forum, args.folder)
my_scraper.scrape()

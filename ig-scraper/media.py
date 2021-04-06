from user import User, BaseUserProfile, MinimalUserProfile, PostUser
from comment import PostComment

class BaseMedia:
    def __init__(self, node):
        self.obj = node

    def get_id(self):
        return self.obj["id"]

class Media(BaseMedia):
    def __init__(self, node):
        self.obj = node
        self.owner = User(self.obj["owner"])
        
    def is_video(self):
        return self.obj["is_video"]

    def get_accessibility_caption(self):
        return self.obj["accessibility_caption"]

    def get_shortcode(self):
        return self.obj["shortcode"]

    def get_time(self):
        return self.obj["taken_at_timestamp"]

    def get_caption(self):
        return self.obj["edge_media_to_caption"]["edges"][0]["node"]["text"]

    def get_comment_count(self):
        return self.obj["edge_media_to_comment"]["count"]

    def get_dimensions(self):
        return (self.obj["dimensions"]["height"], self.obj["dimensions"]["width"])
        
    def get_display(self):
        return self.obj["display_url"]

    def get_thumbnail(self):
        return self.obj["thumbnail_src"]

class TagMedia(Media):
    def __init__(self, node):
        self.obj = node
        self.owner = MinimalUserProfile(self.obj["owner"])  
    
class FullMedia(Media):
    def get_location_obj(self):
        return self.obj["location"]

class PostMedia(FullMedia):
    def __init__(self, node):
        self.obj = node
        self.owner = PostUser(self.obj["owner"])

    def has_ranked_comments(self):
        return self.obj["has_ranked_comments"]

    def is_comments_disabled(self):
        return self.obj["comments_disabled"]

    def is_caption_edited(self):
        return self.obj["caption_is_edited"]

    def is_ad(self):
        return self.obj["is_ad"]

    def get_likes(self):
        return self.obj["edge_media_preview_like"]["count"]

    def get_comment_count(self):
        return self.obj["edge_media_to_comment"]["count"]

    def get_comment(self, n):
        return PostComment(self.obj["edge_media_to_comment"]["edges"][n]["node"])

    def get_comment_page_info(self):
        return self.obj["edge_media_to_comment"]["page_info"]

class HighlightMedia(BaseMedia):
    def __init__(self, node):
        self.obj = node
        self.owner = BaseUserProfile(self.obj["owner"])

    def get_title(self):
        return self.obj["title"]

    def get_display(self):
        return self.obj["cover_media"]["thumbnail_src"]

    def get_cropped_thumbnail(self):
        return self.obj["cover_media_cropped_thumbnail"]["url"]

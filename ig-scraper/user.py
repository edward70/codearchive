import json

class User:
    def __init__(self, user):
        self.obj = user

    def get_id(self):
        return self.obj["id"]

class MinimalUserProfile(User):
    def get_username(self):
        return self.obj["username"]

class BaseUserProfile(MinimalUserProfile):
    def get_profile_pic(self):
        return self.obj["profile_pic_url"]

class AltBaseUserProfile(MinimalUserProfile):
    def is_verified(self):
        return self.obj["is_verified"]

class PostUser(BaseUserProfile):
    def is_private(self):
        return self.obj["is_private"]

    def is_verified(self):
        return self.obj["is_verified"]

    def get_full_name(self):
        return self.obj["full_name"]

    def is_unpublished(self):
        return self.obj["is_unpublished"]

class UserProfile(BaseUserProfile):
    def is_private(self):
        return self.obj["is_private"]

    def is_verified(self):
        return self.obj["is_verified"]

    def is_business_account(self):
        return self.obj["is_business_account"]

    def has_joined_recently(self):
        return self.obj["is_joined_recently"]
        
    def get_bio(self):
        return self.obj["biography"]

    def get_full_name(self):
        return self.obj["full_name"]

    def get_business_category(self):
        return self.obj["business_category_name"]

    def get_business_email(self):
        return self.obj["business_email"]

    def get_business_phone_number(self):
        return self.obj["business_phone_number"]

    def get_business_address_obj(self):
        return json.loads(self.obj["business_address_json"])

    def get_connected_fb_page(self):
        return self.obj["connected_fb_page"]

    def get_hd_profile_pic(self):
        return self.obj["profile_pic_url_hd"]

    def get_follower_count(self):
        return self.obj["edge_followed_by"]["count"]

    def get_following_count(self):
        return self.obj["edge_follow"]["count"]

    def get_mutual_following_obj(self):
        return self.obj["edge_mutual_followed_by"]

    def is_country_blocked(self):
        return self.obj["country_block"]

    # todo: "edge_felix_video_timeline", "edge_saved_media", "edge_media_collections"

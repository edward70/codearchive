from user import UserProfile
from media import TagMedia, FullMedia

class BaseData:
    def __init__(self, shared):
        self.obj = shared

    def get_csrf_token(self):
        return self.obj["config"]["csrf_token"]

class TagData(BaseData):
    def __init__(self, shared):
        self.obj = shared
        self.page1 = self.obj["entry_data"]["TagPage"][0]["graphql"]["hashtag"]
        
    def get_media(self, n):
        return TagMedia(self.page1["edge_hashtag_to_media"]["edges"][n]["node"])

    def get_top_post(self, n):
        return TagMedia(self.page1["edge_hashtag_to_top_posts"]["edges"][n]["node"])

    def get_media_count(self):
        return self.page1["edge_hashtag_to_media"]["count"]

    def get_page_info_obj(self):
        return self.page1["edge_hashtag_to_media"]["page_info"]

    def get_id(self):
        return self.page1["id"]

    def get_name(self):
        return self.page1["name"]

    def allows_following(self):
        return self.page1["allow_following"]

    def is_top_media_only(self):
        return self.page1["is_top_media_only"]

    def get_profile_pic(self):
        return self.page1["profile_pic_url"]

    # find out about "edge_hashtag_to_content_advisory" property

class ProfileData(BaseData):
    def __init__(self, shared):
        self.obj = shared
        self.page1 = shared["entry_data"]["ProfilePage"][0]
        self.user = UserProfile(self.page1["graphql"]["user"])

    def get_media(self, n):
        return FullMedia(self.page1["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"][n]["node"])

    def get_media_count(self):
        return self.page1["graphql"]["user"]["edge_owner_to_timeline_media"]["count"]

    def get_page_info_obj(self):
        return self.page1["graphql"]["user"]["edge_owner_to_timeline_media"]["page_info"]
        
    def get_onboarding_video(self):
        return self.page1["felix_onboarding_video_resources"]["mp4"]

    def get_onboarding_poster(self):
        return self.page1["felix_onboarding_video_resources"]["poster"]

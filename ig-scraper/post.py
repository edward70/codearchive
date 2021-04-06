from meta import PostMeta
from media import PostMedia

class Post:
    def __init__(self, meta, shared):
        self.meta = PostMeta(meta)
        self.shared = shared
        self.data = PostMedia(shared["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"])

    def get_csrf_token(self):
        return self["config"]["csrf_token"]

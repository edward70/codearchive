from comment import Comment

class BaseMeta:
    def __init__(self, meta):
        self.obj = meta

    def get_type(self):
        return self.obj["@type"]

    def get_page(self):
        return self.obj["mainEntityofPage"]["@id"]

    def get_name(self):
        return self.obj["name"]

    def get_description(self):
        return self.obj["description"]

class Meta(BaseMeta):
    def get_followers(self):
        return self.obj["mainEntityofPage"]["interactionStatistic"]["userInteractionCount"]

    def get_handle(self):
        return self.obj["alternateName"]

    def get_url(self):
        return self.obj["url"]

    def get_address_obj(self):
        return self.obj["address"]

class PostMeta(BaseMeta):
    def get_likes(self):
        return self.obj["interactionStatistic"]["userInteractionCount"]

    def get_caption(self):
        return self.obj["caption"]

    def get_upload_date(self):
        return self.obj["uploadDate"]

    def get_author_type(self):
        return self.obj["author"]["@type"]

    def get_handle(self):
        return self.obj["author"]["mainEntityofPage"]["@id"]

    def get_comment(self, n):
        return Comment(self.obj["comment"])

    def get_comment_count(self):
        return self.obj["commentCount"]

from user import AltBaseUserProfile

class Comment:
    def __init__(self, comment):
        self.obj = comment

    def get_text(self):
        return self.obj["text"]

    def get_author_type(self):
        return self.obj["author"]["@type"]

    def get_handle(self):
        return self.obj["author"]["alternateName"]

    def get_author_page(self):
        return self.obj["author"]["mainEntityofPage"]["@id"]

class PostComment:
    def __init__(self, comment):
        self.obj = comment
        self.owner = AltBaseUserProfile(self.obj["owner"])

    def get_text(self):
        return self.obj["text"]

    def get_time(self):
        return self.obj["created_at"]

    def get_id(self):
        return self.obj["id"]

    def get_likes(self):
        return self.obj["edge_liked_by"]["count"]

    def did_report_as_spam(self):
        return self.obj["did_report_as_spam"]

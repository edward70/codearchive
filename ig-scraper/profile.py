from meta import Meta
from data import ProfileData
    
class Profile:
    def __init__(self, meta, shared):
        self.meta = Meta(meta)
        self.data = ProfileData(shared)

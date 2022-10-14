from django.db import models
from user.models import User

class Buyer(models.Model):
    name = models.CharField(max_length=100)
    
    user = models.ForeignKey(User, null=True, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"{self.name}"


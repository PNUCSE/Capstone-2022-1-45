from django.db import models
from user.models import User
from bank.models import BankAccount

class PowerPlant(models.Model):
    name = models.CharField(max_length=100)
    registration_number = models.CharField(max_length=100, unique=True)
    post_num = models.IntegerField()
    address = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=10)
    
    owner = models.ForeignKey(User, null=True, on_delete=models.CASCADE)
    bank_account = models.ForeignKey(BankAccount, null=True, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"{self.name} | {self.bank_account.bank} | {self.bank_account.number}"
    
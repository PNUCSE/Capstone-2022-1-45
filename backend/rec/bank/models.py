from django.db import models

class Bank(models.Model):
    BANK_CHOICE = (
        ('IBK', 'IBK 산업은행'),
        ('KEB', 'KEB 하나은행'),
    )
    name = models.CharField(max_length=100, unique=True, choices=BANK_CHOICE)
    
    def __str__(self):
        return self.name

class BankAccount(models.Model):
    bank = models.ForeignKey(Bank, on_delete=models.PROTECT)
    number = models.CharField(max_length=100, unique=True)
    
    def __str__(self):
        return f"{self.bank} | {self.number}"

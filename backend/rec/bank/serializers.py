from dataclasses import field
from re import search
from rest_framework import serializers
from .models import Bank, BankAccount

class BankSerializer(serializers.ModelSerializer):
    class Meta: 
        model = Bank
        fields = '__all__'

class BankAccountSerializer(serializers.ModelSerializer):
    bank = BankSerializer(read_only=False)
    
    class Meta:
        model = BankAccount
        fields = '__all__'
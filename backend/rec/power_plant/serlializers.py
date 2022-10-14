from dataclasses import field
from rest_framework import serializers
from .models import PowerPlant
from bank.serializers import BankSerializer, BankAccountSerializer

class PowerPlantSerializer(serializers.ModelSerializer):
    bank_account = BankAccountSerializer(read_only=True)
    class Meta:
        model = PowerPlant
        fields = '__all__'
# Default import
from django.shortcuts import render
from django.http import Http404

# DRF import
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view

# Model, Serializer import
from .models import Buyer
from .serializers import BuyerSerializer

class BuyerAPI(APIView):
    def get(self, request, id):
        query = Buyer.objects.get(user=id)
        serializer = BuyerSerializer(query)
        return Response(serializer.data)
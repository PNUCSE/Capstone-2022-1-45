# Default import
from django.shortcuts import render
from django.http import Http404

# DRF import
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

# Model, Serializer import
from .models import User
from .serializers import UserSerializer

class UserAPI(APIView):
    @permission_classes([IsAuthenticated])
    def get(self, request):
        user = request.user
        serializer = UserSerializer(user)
        return Response(serializer.data)
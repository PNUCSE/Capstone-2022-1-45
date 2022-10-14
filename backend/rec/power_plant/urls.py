from django.urls import path
from . import views

urlpatterns = [
    path('<int:supplier>/', views.PowerPlantAPI.as_view()),
]

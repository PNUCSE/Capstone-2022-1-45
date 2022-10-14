from django.contrib import admin
from django.urls import path, include, re_path
from django.conf import settings

from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
    openapi.Info(
        title="TAY's api documents",
        default_version='v0',
        description="안녕하세요",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="rubinstory@naver.com"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
    permission_classes=[permissions.AllowAny],
)

urlpatterns = [
    path('admin/', admin.site.urls),
    
    #PowerPlant
    path('powerplant/', include('power_plant.urls')),
    
    #Auth
    path('account/', include('dj_rest_auth.urls')),
    
    #User
    path('', include('user.urls')),
    
    #Buyer
    path('buyer/', include('buyer.urls')),
]

if settings.DEBUG:
    urlpatterns += [
        re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
        re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
        re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc')
    ]
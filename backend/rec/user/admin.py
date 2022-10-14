from dataclasses import field
from django.contrib import admin
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from .forms import UserChangeForm, UserCreationForm
from .models import User

class UserAdmin(BaseUserAdmin):
    form = UserChangeForm
    add_form = UserCreationForm
    
    list_display = ('email', 'id', 'is_supplier')
    list_filter = ('is_supplier',)
    
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('User Type', {'fields': ('is_supplier',)}),
        ('Permissions', {'fields': ('is_admin',)}),
    )
    
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2')}),
    )
    
    search_fields = ('email', )    
    ordering = ('email', )
    filter_horizontal = ()

admin.site.register(User, UserAdmin)
admin.site.unregister(Group)

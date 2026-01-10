from django.contrib import admin
from .models import Firma, Urun, MenuItem

# Register your models here.
@admin.register(Firma)
class FirmaAdmin(admin.ModelAdmin):
    list_display = ('sira_no', 'ad', 'aktif')
    ordering = ('sira_no',)

@admin.register(Urun)
class UrunAdmin(admin.ModelAdmin):
    list_display = ('sira_no', 'ad', 'aktif')
    ordering = ('sira_no',)

@admin.register(MenuItem)
class MenuItemAdmin(admin.ModelAdmin):
    list_display = ('sira_no', 'baslik', 'name', 'icon', 'aktif')
    ordering = ('sira_no',)

"""
Tanker menü öğesini ekle
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem

# Tanker menü öğesini ekle
menu, created = MenuItem.objects.get_or_create(
    sira_no=4,
    defaults={
        'name': 'tanker',
        'baslik': 'Tanker',
        'tab_baslik': 'Tanker',
        'icon': '🚛',
        'page_url': '/tanker/',
        'aktif': True
    }
)

if created:
    print("✅ Tanker menü öğesi eklendi!")
else:
    print("✅ Tanker menü öğesi zaten var, güncellendi!")
    menu.name = 'tanker'
    menu.baslik = 'Tanker'
    menu.tab_baslik = 'Tanker'
    menu.icon = '🚛'
    menu.page_url = '/tanker/'
    menu.aktif = True
    menu.save()
    print("✅ Tanker menü öğesi güncellendi!")

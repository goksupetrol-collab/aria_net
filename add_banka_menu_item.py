"""
Banka menü öğesini veritabanına ekle
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem
from django.db.models import Max

# Mevcut en yüksek sira_no'yu bul
max_sira = MenuItem.objects.aggregate(max_sira=Max('sira_no'))['max_sira'] or 0
new_sira = max_sira + 1

# Banka menü öğesini oluştur
banka_menu, created = MenuItem.objects.get_or_create(
    name='banka',
    defaults={
        'sira_no': new_sira,
        'baslik': 'Banka',
        'tab_baslik': 'Banka',
        'icon': '🏦',
        'page_url': '/banka/',
        'aktif': True
    }
)

if created:
    print(f"OK Banka menu ogesi eklendi! Sira No: {new_sira}")
else:
    print(f"INFO Banka menu ogesi zaten var, guncellendi.")
    banka_menu.sira_no = new_sira
    banka_menu.baslik = 'Banka'
    banka_menu.tab_baslik = 'Banka'
    banka_menu.icon = '🏦'
    banka_menu.page_url = '/banka/'
    banka_menu.aktif = True
    banka_menu.save()
    print(f"OK Banka menu ogesi guncellendi! Sira No: {new_sira}")

"""
Tanker MenuItem'ı direkt ekle
"""
import os
import sys
import django

# Proje dizinine git
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Django ayarlarını yükle
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem

print("Tanker MenuItem ekleniyor...")

# Önce mevcut kayıtları kontrol et
existing = MenuItem.objects.filter(sira_no=3).first()
if existing:
    print(f"Sira No 3 zaten var: {existing.baslik}")
    # Sira No 4'ü kontrol et
    existing4 = MenuItem.objects.filter(sira_no=4).first()
    if existing4 and existing4.name == 'banka':
        # Tanker için sira_no 5 kullan
        menu, created = MenuItem.objects.get_or_create(
            name='tanker',
            defaults={
                'sira_no': 5,
                'baslik': 'Tanker',
                'tab_baslik': 'Tanker',
                'icon': '🚛',
                'page_url': '/tanker/',
                'aktif': True
            }
        )
    else:
        # Sira No 3'e ekle
        menu, created = MenuItem.objects.get_or_create(
            name='tanker',
            defaults={
                'sira_no': 3,
                'baslik': 'Tanker',
                'tab_baslik': 'Tanker',
                'icon': '🚛',
                'page_url': '/tanker/',
                'aktif': True
            }
        )
else:
    # Sira No 3 boş, ekle
    menu, created = MenuItem.objects.get_or_create(
        name='tanker',
        defaults={
            'sira_no': 3,
            'baslik': 'Tanker',
            'tab_baslik': 'Tanker',
            'icon': '🚛',
            'page_url': '/tanker/',
            'aktif': True
        }
    )

if created:
    print(f"✅ Tanker eklendi! Sira No: {menu.sira_no}")
else:
    print(f"✅ Tanker zaten var! Sira No: {menu.sira_no}")
    # Güncelle
    menu.sira_no = 3
    menu.baslik = 'Tanker'
    menu.tab_baslik = 'Tanker'
    menu.icon = '🚛'
    menu.page_url = '/tanker/'
    menu.aktif = True
    menu.save()
    print(f"✅ Tanker güncellendi! Sira No: {menu.sira_no}")

print("\nTüm MenuItem kayıtları:")
for item in MenuItem.objects.filter(aktif=True).order_by('sira_no'):
    print(f"  {item.sira_no}. {item.baslik} ({item.name}) - Aktif: {item.aktif}")

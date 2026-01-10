"""
Menü öğelerini veritabanına yükle
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem

menu_ogeleri = [
    (1, 'operasyon_sayfasi', 'Operasyon Sayfası', 'Operasyon Sayfası', '⛽', '/', True),
]

print("Menü öğeleri kaydediliyor...")
for sira_no, name, baslik, tab_baslik, icon, page_url, aktif in menu_ogeleri:
    menu, created = MenuItem.objects.get_or_create(
        sira_no=sira_no,
        defaults={
            'name': name,
            'baslik': baslik,
            'tab_baslik': tab_baslik,
            'icon': icon,
            'page_url': page_url,
            'aktif': aktif
        }
    )
    if created:
        print(f"OK {sira_no} - {baslik} kaydedildi")
    else:
        print(f"GUNCELLENDI {sira_no} - {baslik} zaten var, guncellendi")
        menu.name = name
        menu.baslik = baslik
        menu.tab_baslik = tab_baslik
        menu.icon = icon
        menu.page_url = page_url
        menu.aktif = aktif
        menu.save()

print(f"\nToplam {len(menu_ogeleri)} menü öğesi kaydedildi!\n")

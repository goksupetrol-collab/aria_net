"""
Ürünleri veritabanına yükleme scripti
MOTORİN ve BENZİN
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import Urun

# Ürünleri kaydet
urunler = [
    (1, 'MOTORİN'),
    (2, 'BENZİN'),
]

print("Urunler kaydediliyor...")

for sira_no, ad in urunler:
    urun, created = Urun.objects.get_or_create(
        sira_no=sira_no,
        defaults={'ad': ad}
    )
    if created:
        print(f"OK {sira_no} - {ad} kaydedildi")
    else:
        print(f"GUNCELLENDI {sira_no} - {ad} zaten var, guncellendi")
        urun.ad = ad
        urun.save()

print(f"\nToplam {len(urunler)} urun kaydedildi!")

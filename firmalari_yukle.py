"""
Firmaları veritabanına yükleme scripti
PetroNet'ten alınan firma listesi
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import Firma

# Firmaları kaydet
firmalar = [
    (1, 'MERKEZ'),
    (2, 'YAĞCILAR'),
    (3, 'TEPEKUM'),
    (4, 'NAMDAR'),
    (5, 'AKOVA'),
    (6, 'KOOP.'),
    (7, 'NAZİLLİ'),
]

print("Firmalar kaydediliyor...")

for sira_no, ad in firmalar:
    firma, created = Firma.objects.get_or_create(
        sira_no=sira_no,
        defaults={'ad': ad}
    )
    if created:
        print(f"✓ {sira_no} - {ad} kaydedildi")
    else:
        print(f"→ {sira_no} - {ad} zaten var, güncellendi")
        firma.ad = ad
        firma.save()

print(f"\nToplam {len(firmalar)} firma kaydedildi!")

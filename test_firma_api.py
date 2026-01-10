"""
Firma API'sini test et
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import Firma

print("=" * 50)
print("FIRMA VERİTABANI KONTROLÜ")
print("=" * 50)

firmalar = Firma.objects.all().order_by('sira_no')
print(f"\nToplam firma sayısı: {firmalar.count()}\n")

if firmalar.count() > 0:
    print("Firmalar:")
    for f in firmalar:
        print(f"  {f.sira_no} - {f.ad} (ID: {f.id}, Aktif: {f.aktif})")
else:
    print("VERİTABANINDA HİÇ FİRMA YOK!")
    print("\nFirmaları yüklemek için: python firmalari_yukle.py")

print("\n" + "=" * 50)

# -*- coding: utf-8 -*-
"""
Tanker ikonunu degistir - daha yaygin desteklenen emoji
"""
import os
import sys
import django
import io

# Encoding sorununu coz
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

os.chdir(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem

print("Tanker ikonu degistiriliyor...")

t = MenuItem.objects.get(name='tanker')
print("Mevcut ikon uzunlugu:", len(t.icon))

# En basit ve yaygin desteklenen emoji: araba
t.icon = '🚗'
t.save()

print("OK Tanker ikonu degistirildi: araba emoji")
print("\nTum menu ogeleri:")
for item in MenuItem.objects.filter(aktif=True).order_by('sira_no'):
    print(f"  {item.sira_no}. {item.baslik} - Ikon uzunlugu: {len(item.icon)}")

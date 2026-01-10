import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem
from django.db.models import Max

# En yüksek sıra numarasını bul
max_sira = MenuItem.objects.aggregate(max_sira=Max('sira_no'))['max_sira'] or 0

# Yeni MenuItem oluştur
MenuItem.objects.create(
    sira_no=max_sira + 1,
    name='kredi_karti',
    baslik='K.Kartı-Kredi',
    tab_baslik='K.Kartı-Kredi',
    icon='💳',
    page_url='/kredi-karti/',
    aktif=True
)

print('K.Kartı-Kredi menü öğesi eklendi!')

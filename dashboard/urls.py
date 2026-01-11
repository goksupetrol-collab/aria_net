from django.urls import path
from .views import (
    motorin_telerik_test,
    telerik_yeni_proje,
    kredi_karti,
    banka,
    api_motorin_satis,
    api_benzin_satis,
    api_tahsilat,
    api_odeme,
    api_entry,
    api_alis_fiyati,
    api_tanker,
    api_upload_excel,
    api_arac_bilgi,
    api_firmalar,
    api_urunler,
)

urlpatterns = [
    path('', telerik_yeni_proje, name='home'),  # Varsayılan: Telerik sayfası
    path('motorin-telerik-test/', motorin_telerik_test, name='motorin_telerik_test'),
    path('telerik-yeni-proje/', telerik_yeni_proje, name='telerik_yeni_proje'),
    path('kredi-karti/', kredi_karti, name='kredi_karti'),
    path('banka/', banka, name='banka'),
    # API endpoints
    path('api/motorin-satis/', api_motorin_satis, name='api_motorin_satis'),
    path('api/benzin-satis/', api_benzin_satis, name='api_benzin_satis'),
    path('api/tahsilat/', api_tahsilat, name='api_tahsilat'),
    path('api/odeme/', api_odeme, name='api_odeme'),
    path('api/entry/', api_entry, name='api_entry'),
    path('api/alis-fiyati/', api_alis_fiyati, name='api_alis_fiyati'),
    path('api/tanker/', api_tanker, name='api_tanker'),
    path('api/upload-excel/', api_upload_excel, name='api_upload_excel'),
    path('api/arac-bilgi/', api_arac_bilgi, name='api_arac_bilgi'),
    path('api/arac-bilgi/<int:sira_no>/', api_arac_bilgi, name='api_arac_bilgi_detail'),
    path('api/firmalar/', api_firmalar, name='api_firmalar'),
    path('api/firmalar/<int:firma_id>/', api_firmalar, name='api_firmalar_detail'),
    path('api/urunler/', api_urunler, name='api_urunler'),
    path('api/urunler/<int:urun_id>/', api_urunler, name='api_urunler_detail'),
]

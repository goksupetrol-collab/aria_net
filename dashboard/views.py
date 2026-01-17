from pathlib import Path
from django.shortcuts import render
from django.http import JsonResponse, FileResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.views.decorators.clickjacking import xframe_options_sameorigin
from django.utils.dateparse import parse_date
from datetime import date
import json
import os
import xml.etree.ElementTree as ET
import mimetypes
from django.db.models import Max
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
import re
try:
    import openpyxl
    OPENPYXL_AVAILABLE = True
except ImportError:
    OPENPYXL_AVAILABLE = False

from .models import MotorinSatis, BenzinSatis, Tahsilat, Odeme, Entry, AlisFiyati, Tanker, AracBilgi, Hypco, Aygaz, Firma, Urun, MenuItem, EvrakTuru, FirmaEvrak

# BASE_DIR tanımı (Django settings'den alınabilir ama burada da tanımlıyoruz)
BASE_DIR = Path(__file__).resolve().parent.parent

LICENSE_PATH = Path(r"C:\Users\{}\AppData\Roaming\Telerik\telerik-license.txt".format(os.environ.get('USERNAME', 'arial')))

# Geçici Excel dosyaları için klasör
TEMP_EXCEL_DIR = BASE_DIR / 'temp_excel'
TEMP_EXCEL_DIR.mkdir(exist_ok=True)


def _load_license():
    try:
        return LICENSE_PATH.read_text(encoding="utf-8").strip()
    except OSError:
        return None


def _turkish_title(value):
    if value is None:
        return ""
    value = " ".join(str(value).strip().split())
    if not value:
        return ""

    lower_map = str.maketrans({"I": "ı", "İ": "i"})
    upper_map = str.maketrans({"i": "İ", "ı": "I"})

    def tr_lower(text):
        return text.translate(lower_map).lower()

    def tr_upper(text):
        return text.translate(upper_map).upper()

    def title_word(word):
        if not word:
            return word
        parts = re.split(r"([-'])", word)
        fixed_parts = []
        for part in parts:
            if part in ("-", "'"):
                fixed_parts.append(part)
                continue
            if not part:
                fixed_parts.append(part)
                continue
            lowered = tr_lower(part)
            fixed_parts.append(tr_upper(lowered[0]) + lowered[1:])
        return "".join(fixed_parts)

    return " ".join(title_word(word) for word in value.split(" "))


def _normalize_firma_text(value):
    return _turkish_title(value)


def motorin_telerik_test(request):
    """MOTORİN tablosu için Telerik test sayfası"""
    context = {
        "kendo_license": _load_license(),
    }
    return render(request, "dashboard/motorin_telerik.html", context)


def telerik_yeni_proje(request):
    """Yeni Telerik projesi sayfası"""
    # Menü öğelerini veritabanından çek
    menu_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
    menu_items_json = json.dumps([{
        'sira_no': item.sira_no,
        'name': item.name,
        'baslik': item.baslik,
        'tab_baslik': item.get_tab_baslik(),
        'icon': item.icon,
        'page_url': item.page_url or '',
        'aktif': item.aktif
    } for item in menu_items], ensure_ascii=False)
    
    context = {
        "kendo_license": _load_license(),
        "menu_items": menu_items_json,
    }
    return render(request, "dashboard/telerik_yeni_proje.html", context)


def kredi_karti(request):
    """K.Kartı-Kredi sayfası"""
    # Menü öğelerini veritabanından çek
    menu_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
    menu_items_json = json.dumps([{
        'sira_no': item.sira_no,
        'name': item.name,
        'baslik': item.baslik,
        'tab_baslik': item.get_tab_baslik(),
        'icon': item.icon,
        'page_url': item.page_url or '',
        'aktif': item.aktif
    } for item in menu_items], ensure_ascii=False)
    
    context = {
        "kendo_license": _load_license(),
        "menu_items": menu_items_json,
    }
    return render(request, "dashboard/kredi_karti.html", context)


def banka(request):
    """Banka sayfası"""
    # Menü öğelerini veritabanından çek
    menu_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
    menu_items_json = json.dumps([{
        'sira_no': item.sira_no,
        'name': item.name,
        'baslik': item.baslik,
        'tab_baslik': item.get_tab_baslik(),
        'icon': item.icon,
        'page_url': item.page_url or '',
        'aktif': item.aktif
    } for item in menu_items], ensure_ascii=False)
    
    context = {
        "kendo_license": _load_license(),
        "menu_items": menu_items_json,
    }
    return render(request, "dashboard/banka.html", context)


def tanker(request):
    """Tanker sayfası"""
    # Menü öğelerini veritabanından çek
    menu_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
    menu_items_json = json.dumps([{
        'sira_no': item.sira_no,
        'name': item.name,
        'baslik': item.baslik,
        'tab_baslik': item.get_tab_baslik(),
        'icon': item.icon,
        'page_url': item.page_url or '',
        'aktif': item.aktif
    } for item in menu_items], ensure_ascii=False)
    
    context = {
        "kendo_license": _load_license(),
        "menu_items": menu_items_json,
    }
    return render(request, "dashboard/tanker.html", context)


def fiyat_degisimi(request):
    """Fiyat Değişimi sayfası"""
    # Menü öğelerini veritabanından çek
    menu_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
    menu_items_json = json.dumps([{
        'sira_no': item.sira_no,
        'name': item.name,
        'baslik': item.baslik,
        'tab_baslik': item.get_tab_baslik(),
        'icon': item.icon,
        'page_url': item.page_url or '',
        'aktif': item.aktif
    } for item in menu_items], ensure_ascii=False)
    
    context = {
        "kendo_license": _load_license(),
        "menu_items": menu_items_json,
    }
    return render(request, "dashboard/fiyat_degisimi.html", context)


# API ENDPOINTS

@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_motorin_satis(request):
    """MOTORİN satış değerlerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            tarih_str = data.get('tarih')
            sube = data.get('sube')
            deger = data.get('deger', 0)
            
            if not tarih_str or not sube:
                return JsonResponse({'error': 'Tarih ve şube gerekli'}, status=400)
            
            tarih = parse_date(tarih_str) if isinstance(tarih_str, str) else date.today()
            
            satis, created = MotorinSatis.objects.update_or_create(
                tarih=tarih,
                sube=sube,
                defaults={'deger': deger}
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Bugünün satış değerlerini getir
    bugun = date.today()
    satislar = MotorinSatis.objects.filter(tarih=bugun)
    data = {s.sube: float(s.deger) for s in satislar}
    return JsonResponse(data)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_benzin_satis(request):
    """BENZİN satış değerlerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            tarih_str = data.get('tarih')
            sube = data.get('sube')
            deger = data.get('deger', 0)
            
            if not tarih_str or not sube:
                return JsonResponse({'error': 'Tarih ve şube gerekli'}, status=400)
            
            tarih = parse_date(tarih_str) if isinstance(tarih_str, str) else date.today()
            
            satis, created = BenzinSatis.objects.update_or_create(
                tarih=tarih,
                sube=sube,
                defaults={'deger': deger}
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Bugünün satış değerlerini getir
    bugun = date.today()
    satislar = BenzinSatis.objects.filter(tarih=bugun)
    data = {s.sube: float(s.deger) for s in satislar}
    return JsonResponse(data)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_tahsilat(request):
    """TAHSİLAT işlemlerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            kime = data.get('kime', '')
            ne_kadar = data.get('ne_kadar', 0)
            onay = data.get('onay', False)
            
            if sira_no is None:
                return JsonResponse({'error': 'Sıra no gerekli'}, status=400)
            
            tahsilat, created = Tahsilat.objects.update_or_create(
                sira_no=sira_no,
                defaults={
                    'kime': kime,
                    'ne_kadar': ne_kadar,
                    'onay': onay
                }
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Tüm tahsilatları getir
    tahsilatlar = Tahsilat.objects.all().order_by('sira_no')
    data = [
        {
            'sira_no': t.sira_no,
            'kime': t.kime or '',
            'ne_kadar': float(t.ne_kadar),
            'onay': t.onay
        }
        for t in tahsilatlar
    ]
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_odeme(request):
    """ÖDEME işlemlerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            kime = data.get('kime', '')
            ne_kadar = data.get('ne_kadar', 0)
            onay = data.get('onay', False)
            
            if sira_no is None:
                return JsonResponse({'error': 'Sıra no gerekli'}, status=400)
            
            odeme, created = Odeme.objects.update_or_create(
                sira_no=sira_no,
                defaults={
                    'kime': kime,
                    'ne_kadar': ne_kadar,
                    'onay': onay
                }
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Tüm ödemeleri getir
    odemeler = Odeme.objects.all().order_by('sira_no')
    data = [
        {
            'sira_no': o.sira_no,
            'kime': o.kime or '',
            'ne_kadar': float(o.ne_kadar),
            'onay': o.onay
        }
        for o in odemeler
    ]
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_entry(request):
    """ENTRY/Sipariş işlemlerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            firma = data.get('firma')
            urun = data.get('urun')
            litre = data.get('litre', 0)
            tl = data.get('tl', 0)
            odeme_turu = data.get('odeme_turu', '')
            bos_alan = data.get('bos_alan', '')
            onay = data.get('onay', False)
            
            if sira_no is None:
                return JsonResponse({'error': 'Sıra no gerekli'}, status=400)
            
            entry, created = Entry.objects.update_or_create(
                sira_no=sira_no,
                defaults={
                    'firma': firma,
                    'urun': urun,
                    'litre': litre,
                    'tl': tl,
                    'odeme_turu': odeme_turu,
                    'bos_alan': bos_alan,
                    'onay': onay
                }
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Tüm siparişleri getir
    entries = Entry.objects.all().order_by('sira_no')
    data = [
        {
            'sira_no': e.sira_no,
            'firma': e.firma,
            'urun': e.urun,
            'litre': float(e.litre),
            'tl': float(e.tl),
            'odeme_turu': e.odeme_turu or '',
            'bos_alan': e.bos_alan or '',
            'onay': e.onay
        }
        for e in entries
    ]
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_alis_fiyati(request):
    """Alış fiyatlarını kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            sube = data.get('sube')
            urun = data.get('urun')
            fiyat = data.get('fiyat', 0)
            
            if not sube or not urun:
                return JsonResponse({'error': 'Şube ve ürün gerekli'}, status=400)
            
            alis_fiyati, created = AlisFiyati.objects.update_or_create(
                sube=sube,
                urun=urun,
                defaults={'fiyat': fiyat}
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Tüm alış fiyatlarını getir
    fiyatlar = AlisFiyati.objects.all()
    data = {}
    for f in fiyatlar:
        key = f"{f.sube}_{f.urun}"
        data[key] = float(f.fiyat)
    return JsonResponse(data)


def _read_excel_xlsx(file_path):
    """Excel .xlsx dosyasını openpyxl ile oku ve verileri döndür"""
    if not OPENPYXL_AVAILABLE:
        return []
    
    try:
        workbook = openpyxl.load_workbook(file_path, data_only=True)
        worksheet = workbook.active
        
        # Başlık satırını bul (satır 4, index 4)
        headers = []
        for cell in worksheet[4]:
            headers.append(str(cell.value).strip() if cell.value else '')
        
        # İstasyon Kodu, Ürün, Yakıt (Net Lt) sütun indekslerini bul
        ist_kod_idx = None
        urun_idx = None
        net_lt_idx = None
        
        for i, header in enumerate(headers):
            if 'İst. Kod' in header or 'İstasyon Kodu' in header:
                ist_kod_idx = i + 1  # openpyxl 1-based index kullanır
            elif 'Ürün' in header:
                urun_idx = i + 1
            elif 'Yakıt (Net Lt)' in header or 'Net Lt' in header:
                net_lt_idx = i + 1
        
        if ist_kod_idx is None or urun_idx is None or net_lt_idx is None:
            return []
        
        # Veri satırlarını oku (satır 5'ten itibaren)
        data_rows = []
        for row in worksheet.iter_rows(min_row=5, values_only=False):
            ist_kod_cell = row[ist_kod_idx - 1] if ist_kod_idx <= len(row) else None
            urun_cell = row[urun_idx - 1] if urun_idx <= len(row) else None
            net_lt_cell = row[net_lt_idx - 1] if net_lt_idx <= len(row) else None
            
            ist_kod = str(ist_kod_cell.value).strip() if ist_kod_cell and ist_kod_cell.value else None
            urun = str(urun_cell.value).strip() if urun_cell and urun_cell.value else None
            
            net_lt = None
            if net_lt_cell and net_lt_cell.value is not None:
                try:
                    net_lt = float(net_lt_cell.value)
                except (ValueError, TypeError):
                    net_lt = None
            
            if ist_kod and urun and net_lt is not None:
                data_rows.append({
                    'istasyon_kodu': ist_kod,
                    'urun': urun,
                    'net_lt': net_lt
                })
        
        return data_rows
    except Exception as e:
        print(f"Excel .xlsx okuma hatası: {e}")
        return []


def _read_excel_xml(file_path):
    """Excel XML dosyasını (.xls) oku ve verileri döndür"""
    try:
        tree = ET.parse(file_path)
        root = tree.getroot()
        ns = {'ss': 'urn:schemas-microsoft-com:office:spreadsheet'}
        
        worksheet = root.find('.//ss:Worksheet', ns)
        if worksheet is None:
            return []
        
        table = worksheet.find('.//ss:Table', ns)
        if table is None:
            return []
        
        rows = table.findall('.//ss:Row', ns)
        if len(rows) < 4:
            return []
        
        # Başlık satırını bul (satır 4, index 3)
        header_row = rows[3]
        header_cells = header_row.findall('.//ss:Cell', ns)
        headers = []
        for cell in header_cells:
            data = cell.find('.//ss:Data', ns)
            if data is not None:
                headers.append(data.text.strip() if data.text else '')
            else:
                headers.append('')
        
        # İstasyon Kodu, Ürün, Yakıt (Net Lt) sütun indekslerini bul
        ist_kod_idx = None
        urun_idx = None
        net_lt_idx = None
        
        for i, header in enumerate(headers):
            if 'İst. Kod' in header or 'İstasyon Kodu' in header:
                ist_kod_idx = i
            elif 'Ürün' in header:
                urun_idx = i
            elif 'Yakıt (Net Lt)' in header or 'Net Lt' in header:
                net_lt_idx = i
        
        if ist_kod_idx is None or urun_idx is None or net_lt_idx is None:
            return []
        
        # Veri satırlarını oku (satır 5'ten itibaren, index 4+)
        data_rows = []
        for row in rows[4:]:
            cells = row.findall('.//ss:Cell', ns)
            if len(cells) > max(ist_kod_idx, urun_idx, net_lt_idx):
                ist_kod = None
                urun = None
                net_lt = None
                
                for i, cell in enumerate(cells):
                    data = cell.find('.//ss:Data', ns)
                    if data is not None and data.text:
                        if i == ist_kod_idx:
                            ist_kod = data.text.strip()
                        elif i == urun_idx:
                            urun = data.text.strip()
                        elif i == net_lt_idx:
                            try:
                                net_lt = float(data.text.strip().replace(',', '.'))
                            except:
                                net_lt = None
                
                if ist_kod and urun and net_lt is not None:
                    data_rows.append({
                        'istasyon_kodu': ist_kod,
                        'urun': urun,
                        'net_lt': net_lt
                    })
        
        return data_rows
    except Exception as e:
        print(f"Excel XML okuma hatası: {e}")
        return []


def _calculate_stock(data_rows):
    """Excel verilerinden stok hesapla"""
    # İstasyon kodları -> Firma eşleştirmesi
    istasyon_map = {
        '750203': 'YAGCILAR',
        '751042': 'SEKER',
        '751043': 'AKOVA',
        '751044': 'KOOP',
        '751045': 'NAZILLI',
        '751046': 'TEPEKUM',
        '751047': 'NAMDAR',
        # '750209': 'OZGUR',  # Kullanılmayacak
    }
    
    # Ürün kodları -> Tablo eşleştirmesi
    urun_map = {
        'Mtrn': 'motorin',
        'K95': 'benzin'
    }
    
    # Sonuçları topla: {tablo: {firma: toplam}}
    results = {
        'motorin': {},
        'benzin': {}
    }
    
    for row in data_rows:
        ist_kod = row['istasyon_kodu']
        urun = row['urun']
        net_lt = row['net_lt']
        
        # İstasyon kodunu kontrol et
        if ist_kod not in istasyon_map:
            continue  # ÖZGÜR veya bilinmeyen kod, atla
        
        # Ürün tipini kontrol et
        if urun not in urun_map:
            continue  # Bilinmeyen ürün, atla
        
        firma = istasyon_map[ist_kod]
        tablo = urun_map[urun]
        
        # Topla
        if firma not in results[tablo]:
            results[tablo][firma] = 0
        results[tablo][firma] += net_lt
    
    return results


@csrf_exempt
@require_http_methods(["POST"])
def api_upload_excel(request):
    """Excel dosyasını geçici olarak kaydet ve hesapla"""
    if request.method != 'POST':
        return JsonResponse({"success": False, "error": "Sadece POST istekleri kabul edilir"}, status=405)
    
    if 'file' not in request.FILES:
        return JsonResponse({"success": False, "error": "Dosya bulunamadı"}, status=400)
    
    file = request.FILES['file']
    
    # Dosya adını kontrol et
    if not file.name.endswith(('.xlsx', '.xls')):
        return JsonResponse({"success": False, "error": "Sadece Excel dosyaları (.xlsx, .xls) kabul edilir"}, status=400)
    
    try:
        # Geçici klasöre kaydet
        file_path = TEMP_EXCEL_DIR / file.name
        
        # Eğer aynı isimde dosya varsa, üzerine yaz
        with open(file_path, 'wb+') as destination:
            for chunk in file.chunks():
                destination.write(chunk)
        
        # Excel dosyasını oku ve hesapla
        try:
            # Dosya uzantısına göre uygun okuma fonksiyonunu seç
            if file.name.endswith('.xlsx'):
                data_rows = _read_excel_xlsx(file_path)
            else:
                data_rows = _read_excel_xml(file_path)
            
            if not data_rows:
                return JsonResponse({
                    "success": False,
                    "error": "Excel dosyası okunamadı veya veri bulunamadı.\n\n" +
                            "Lütfen kontrol edin:\n" +
                            "1. Dosya formatı doğru mu? (.xlsx veya .xls)\n" +
                            "2. Dosyada 'İstasyon Kodu', 'Ürün' ve 'Yakıt (Net Lt)' sütunları var mı?\n" +
                            "3. Başlık satırı 4. satırda mı?\n" +
                            "4. Veriler 5. satırdan itibaren mi başlıyor?"
                }, status=400)
            
            # Stok hesapla
            stock_results = _calculate_stock(data_rows)
            
            return JsonResponse({
                "success": True,
                "message": "Dosya başarıyla kaydedildi ve hesaplandı",
                "filename": file.name,
                "filepath": str(file_path),
                "data": stock_results,
                "debug": {
                    "data_rows_count": len(data_rows),
                    "motorin_count": len(stock_results.get('motorin', {})),
                    "benzin_count": len(stock_results.get('benzin', {}))
                }
            })
        except Exception as e:
            import traceback
            error_detail = traceback.format_exc()
            print(f"Excel işleme hatası: {error_detail}")
            return JsonResponse({
                "success": False,
                "error": f"Excel dosyası işlenirken hata oluştu: {str(e)}"
            }, status=500)
    except Exception as e:
        return JsonResponse({"success": False, "error": f"Hata: {str(e)}"}, status=500)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_tanker(request):
    """Tanker bilgilerini kaydet/oku"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            
            if sira_no is None:
                return JsonResponse({'error': 'Sıra no gerekli'}, status=400)
            
            tanker, created = Tanker.objects.update_or_create(
                sira_no=sira_no,
                defaults={
                    'tanker_adi': data.get('tanker_adi', ''),
                    'cekici_plaka': data.get('cekici_plaka', ''),
                    'dorse_plaka': data.get('dorse_plaka', ''),
                    'goz_1': data.get('goz_1', 0),
                    'goz_2': data.get('goz_2', 0),
                    'goz_3': data.get('goz_3', 0),
                    'goz_4': data.get('goz_4', 0),
                    'goz_5': data.get('goz_5', 0),
                    'toplam_goz_kapasitesi': data.get('toplam_goz_kapasitesi', 0),
                    'toplam_tasima_kapasitesi': data.get('toplam_tasima_kapasitesi', 0),
                    'aktif': data.get('aktif', False)
                }
            )
            
            return JsonResponse({'success': True, 'created': created})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    # GET: Tüm tankerleri getir
    tankerler = Tanker.objects.all().order_by('sira_no')
    data = [
        {
            'sira_no': t.sira_no,
            'tanker_adi': t.tanker_adi,
            'cekici_plaka': t.cekici_plaka or '',
            'dorse_plaka': t.dorse_plaka or '',
            'goz_1': float(t.goz_1),
            'goz_2': float(t.goz_2),
            'goz_3': float(t.goz_3),
            'goz_4': float(t.goz_4),
            'goz_5': float(t.goz_5),
            'toplam_goz_kapasitesi': float(t.toplam_goz_kapasitesi),
            'toplam_tasima_kapasitesi': float(t.toplam_tasima_kapasitesi),
            'aktif': t.aktif
        }
        for t in tankerler
    ]
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_arac_bilgi(request, sira_no=None):
    """Araç Bilgi API - GET: Tüm araçları veya tek araç getir, POST: Kaydet/Güncelle"""
    if request.method == 'GET':
        if sira_no:
            # Tek araç getir
            try:
                arac = AracBilgi.objects.get(sira_no=sira_no)
                data = {
                    'sira_no': arac.sira_no,
                    'firma': arac.firma or '',
                    'sofor': arac.sofor or '',
                    'tc': arac.tc or '',
                    'dorse': arac.dorse or '',
                    'cekici': arac.cekici or '',
                    'goz_1': arac.goz_1 or '',
                    'goz_2': arac.goz_2 or '',
                    'goz_3': arac.goz_3 or '',
                    'goz_4': arac.goz_4 or '',
                    'goz_5': arac.goz_5 or '',
                    'goz_6': arac.goz_6 or '',
                    'toplam_litre': arac.toplam_litre or '',
                    'tasima_siniri_lt': arac.tasima_siniri_lt or '',
                    'aktif': arac.aktif,
                }
                return JsonResponse(data)
            except AracBilgi.DoesNotExist:
                return JsonResponse({'error': 'Araç bulunamadı'}, status=404)
        else:
            # Tüm araçları getir
            araclar = AracBilgi.objects.all().order_by('sira_no')
            data = [
                {
                    'sira_no': a.sira_no,
                    'firma': a.firma or '',
                    'sofor': a.sofor or '',
                    'tc': a.tc or '',
                    'dorse': a.dorse or '',
                    'cekici': a.cekici or '',
                    'goz_1': a.goz_1 or '',
                    'goz_2': a.goz_2 or '',
                    'goz_3': a.goz_3 or '',
                    'goz_4': a.goz_4 or '',
                    'goz_5': a.goz_5 or '',
                    'goz_6': a.goz_6 or '',
                    'toplam_litre': a.toplam_litre or '',
                    'tasima_siniri_lt': a.tasima_siniri_lt or '',
                    'aktif': a.aktif,
                }
                for a in araclar
            ]
            return JsonResponse(data, safe=False)
    
    elif request.method == 'POST':
        # Kaydet/Güncelle
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            if not sira_no:
                return JsonResponse({'error': 'Sıra no gerekli'}, status=400)
            
            arac, created = AracBilgi.objects.update_or_create(
                sira_no=sira_no,
                defaults={
                    'firma': data.get('firma', ''),
                    'sofor': data.get('sofor', ''),
                    'tc': data.get('tc', ''),
                    'dorse': data.get('dorse', ''),
                    'cekici': data.get('cekici', ''),
                    'goz_1': data.get('goz_1', ''),
                    'goz_2': data.get('goz_2', ''),
                    'goz_3': data.get('goz_3', ''),
                    'goz_4': data.get('goz_4', ''),
                    'goz_5': data.get('goz_5', ''),
                    'goz_6': data.get('goz_6', ''),
                    'toplam_litre': data.get('toplam_litre', ''),
                    'tasima_siniri_lt': data.get('tasima_siniri_lt', ''),
                    'aktif': data.get('aktif', False),
                }
            )
            return JsonResponse({
                'success': True,
                'message': 'Araç bilgisi kaydedildi',
                'created': created
            })
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["GET", "POST", "PUT", "DELETE"])
def api_firmalar(request, firma_id=None):
    """Firmaları yönet - GET: Listele, POST: Ekle, PUT: Güncelle, DELETE: Sil"""
    if request.method == 'GET':
        # Tüm firmaları listele (yönetim için aktif olmayanlar da görünsün)
        firmalar = Firma.objects.all().order_by('sira_no')
        for firma in firmalar:
            normalized_ad = _normalize_firma_text(firma.ad)
            normalized_sube = _normalize_firma_text(firma.sube)
            normalized_vergi_dairesi = _normalize_firma_text(firma.vergi_dairesi)
            normalized_yetkili = _normalize_firma_text(firma.yetkili_kisi)
            updates = {}
            if firma.ad != normalized_ad:
                updates["ad"] = normalized_ad
            if firma.sube != normalized_sube:
                updates["sube"] = normalized_sube
            if firma.vergi_dairesi != normalized_vergi_dairesi:
                updates["vergi_dairesi"] = normalized_vergi_dairesi
            if firma.yetkili_kisi != normalized_yetkili:
                updates["yetkili_kisi"] = normalized_yetkili
            if updates:
                for field, value in updates.items():
                    setattr(firma, field, value)
                firma.save(update_fields=list(updates.keys()))
        data = [
            {
                'id': f.id,
                'sira_no': f.sira_no,
                'ad': f.ad,
                'sube': f.sube,
                'vergi_no': f.vergi_no,
                'vergi_dairesi': f.vergi_dairesi,
                'adres': f.adres,
                'telefon': f.telefon,
                'eposta': f.eposta,
                'yetkili_kisi': f.yetkili_kisi,
                'aktif': f.aktif
            }
            for f in firmalar
        ]
        return JsonResponse(data, safe=False)
    
    elif request.method == 'POST':
        # Yeni firma ekle
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            ad = _normalize_firma_text(data.get('ad', '').strip())
            sube = _normalize_firma_text(data.get('sube', '').strip())
            vergi_no = data.get('vergi_no', '').strip()
            vergi_dairesi = _normalize_firma_text(data.get('vergi_dairesi', '').strip())
            adres = data.get('adres', '').strip()
            telefon = data.get('telefon', '').strip()
            eposta = data.get('eposta', '').strip()
            yetkili_kisi = _normalize_firma_text(data.get('yetkili_kisi', '').strip())
            
            if not ad:
                return JsonResponse({'error': 'Firma adı gerekli'}, status=400)

            if not sira_no:
                max_sira = Firma.objects.aggregate(Max('sira_no'))['sira_no__max'] or 0
                sira_no = max_sira + 1
            
            # Aynı sıra no var mı kontrol et
            if Firma.objects.filter(sira_no=sira_no).exists():
                return JsonResponse({'error': 'Bu sıra numarası zaten kullanılıyor'}, status=400)
            
            firma = Firma.objects.create(
                sira_no=sira_no,
                ad=ad,
                sube=sube,
                vergi_no=vergi_no,
                vergi_dairesi=vergi_dairesi,
                adres=adres,
                telefon=telefon,
                eposta=eposta,
                yetkili_kisi=yetkili_kisi,
                aktif=True
            )
            return JsonResponse({
                'success': True,
                'id': firma.id,
                'sira_no': firma.sira_no,
                'ad': firma.ad,
                'sube': firma.sube,
                'vergi_no': firma.vergi_no,
                'vergi_dairesi': firma.vergi_dairesi,
                'adres': firma.adres,
                'telefon': firma.telefon,
                'eposta': firma.eposta,
                'yetkili_kisi': firma.yetkili_kisi
            })
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    elif request.method == 'PUT':
        # Firma güncelle
        try:
            data = json.loads(request.body)
            firma_id = data.get('id')
            sira_no = data.get('sira_no')
            ad = _normalize_firma_text(data.get('ad', '').strip())
            sube = _normalize_firma_text(data.get('sube', '').strip())
            vergi_no = data.get('vergi_no', '').strip()
            vergi_dairesi = _normalize_firma_text(data.get('vergi_dairesi', '').strip())
            adres = data.get('adres', '').strip()
            telefon = data.get('telefon', '').strip()
            eposta = data.get('eposta', '').strip()
            yetkili_kisi = _normalize_firma_text(data.get('yetkili_kisi', '').strip())
            aktif = data.get('aktif', True)
            
            if not firma_id:
                return JsonResponse({'error': 'Firma ID gerekli'}, status=400)
            
            try:
                firma = Firma.objects.get(id=firma_id)
            except Firma.DoesNotExist:
                return JsonResponse({'error': 'Firma bulunamadı'}, status=404)
            
            # Sıra no değişiyorsa kontrol et
            if sira_no and sira_no != firma.sira_no:
                if Firma.objects.filter(sira_no=sira_no).exclude(id=firma_id).exists():
                    return JsonResponse({'error': 'Bu sıra numarası zaten kullanılıyor'}, status=400)
                firma.sira_no = sira_no
            
            if ad:
                firma.ad = ad
            if 'sube' in data:
                firma.sube = sube
            if 'vergi_no' in data:
                firma.vergi_no = vergi_no
            if 'vergi_dairesi' in data:
                firma.vergi_dairesi = vergi_dairesi
            if 'adres' in data:
                firma.adres = adres
            if 'telefon' in data:
                firma.telefon = telefon
            if 'eposta' in data:
                firma.eposta = eposta
            if 'yetkili_kisi' in data:
                firma.yetkili_kisi = yetkili_kisi
            firma.aktif = aktif
            firma.save()
            
            return JsonResponse({
                'success': True,
                'id': firma.id,
                'sira_no': firma.sira_no,
                'ad': firma.ad,
                'sube': firma.sube,
                'aktif': firma.aktif
            })
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    
    elif request.method == 'DELETE':
        # Firma sil (aktif=False yap)
        try:
            # URL'den firma_id al
            if not firma_id:
                # Body'den de deneyelim
                try:
                    data = json.loads(request.body)
                    firma_id = data.get('id')
                except:
                    pass
            
            if not firma_id:
                return JsonResponse({'error': 'Firma ID gerekli'}, status=400)
            
            try:
                firma = Firma.objects.get(id=firma_id)
                firma.aktif = False
                firma.save()
                return JsonResponse({'success': True})
            except Firma.DoesNotExist:
                return JsonResponse({'error': 'Firma bulunamadı'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["GET", "POST", "PUT", "DELETE"])
def api_urunler(request, urun_id=None):
    """Ürünleri yönet - GET: Listele, POST: Ekle, PUT: Güncelle, DELETE: Sil"""
    if request.method == 'GET':
        # Tüm ürünleri listele
        urunler = Urun.objects.all().order_by('sira_no')
        data = [
            {
                'id': u.id,
                'sira_no': u.sira_no,
                'ad': u.ad,
                'aktif': u.aktif
            }
            for u in urunler
        ]
        return JsonResponse(data, safe=False)
    
    elif request.method == 'POST':
        # Yeni ürün ekle
        try:
            data = json.loads(request.body)
            sira_no = data.get('sira_no')
            ad = data.get('ad', '').strip()
            
            if not sira_no or not ad:
                return JsonResponse({'error': 'Sıra no ve ad gerekli'}, status=400)
            
            if Urun.objects.filter(sira_no=sira_no).exists():
                return JsonResponse({'error': 'Bu sıra numarası zaten kullanılıyor'}, status=400)
            
            urun = Urun.objects.create(sira_no=sira_no, ad=ad, aktif=True)
            return JsonResponse({
                'success': True,
                'id': urun.id,
                'sira_no': urun.sira_no,
                'ad': urun.ad
            })
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

    elif request.method == 'PUT':
        # Ürün güncelle
        try:
            data = json.loads(request.body)
            urun_id_param = data.get('id')
            sira_no = data.get('sira_no')
            ad = data.get('ad', '').strip()
            aktif = data.get('aktif', True)

            if not urun_id_param:
                urun_id_param = urun_id

            if not urun_id_param:
                return JsonResponse({'error': 'Ürün ID gerekli'}, status=400)

            try:
                urun = Urun.objects.get(id=urun_id_param)
            except Urun.DoesNotExist:
                return JsonResponse({'error': 'Ürün bulunamadı'}, status=404)

            if sira_no and sira_no != urun.sira_no:
                if Urun.objects.filter(sira_no=sira_no).exclude(id=urun_id_param).exists():
                    return JsonResponse({'error': 'Bu sıra numarası zaten kullanılıyor'}, status=400)
                urun.sira_no = sira_no

            if ad:
                urun.ad = ad
            urun.aktif = aktif
            urun.save()

            return JsonResponse({
                'success': True,
                'id': urun.id,
                'sira_no': urun.sira_no,
                'ad': urun.ad,
                'aktif': urun.aktif
            })
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

    elif request.method == 'DELETE':
        # Ürün sil (aktif=False yap)
        try:
            if not urun_id:
                try:
                    data = json.loads(request.body)
                    urun_id = data.get('id')
                except:
                    pass

            if not urun_id:
                return JsonResponse({'error': 'Ürün ID gerekli'}, status=400)

            try:
                urun = Urun.objects.get(id=urun_id)
                urun.aktif = False
                urun.save()
                return JsonResponse({'success': True})
            except Urun.DoesNotExist:
                return JsonResponse({'error': 'Ürün bulunamadı'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_evrak_turleri(request):
    """Evrak türlerini listele / ekle"""
    if request.method == 'GET':
        turler = EvrakTuru.objects.filter(aktif=True).order_by('ad')
        data = [
            {
                'id': t.id,
                'ad': t.ad
            }
            for t in turler
        ]
        return JsonResponse(data, safe=False)

    # POST
    try:
        data = json.loads(request.body)
        ad = data.get('ad', '').strip()
        if not ad:
            return JsonResponse({'error': 'Evrak türü gerekli'}, status=400)

        tur, _ = EvrakTuru.objects.get_or_create(ad=ad, defaults={'aktif': True})
        return JsonResponse({'success': True, 'id': tur.id, 'ad': tur.ad})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["GET", "POST"])
def api_firma_evraklari(request, firma_id=None):
    """Firma evrakları - GET: liste, POST: yükle"""
    if request.method == 'GET':
        if not firma_id:
            return JsonResponse({'error': 'Firma ID gerekli'}, status=400)

        evraklar = FirmaEvrak.objects.filter(firma_id=firma_id).order_by('-olusturma_tarihi')
        data = [
            {
                'id': e.id,
                'firma_id': e.firma_id,
                'evrak_turu': e.evrak_turu.ad,
                'evrak_turu_id': e.evrak_turu_id,
                'aciklama': e.aciklama,
                'bitis_tarihi': e.bitis_tarihi.isoformat() if e.bitis_tarihi else None,
                'uyari_gunu': e.uyari_gunu,
                'dosya_url': e.dosya.url if e.dosya else '',
                'dosya_adi': e.dosya.name.split('/')[-1] if e.dosya else '',
                'olusturma_tarihi': e.olusturma_tarihi.isoformat()
            }
            for e in evraklar
        ]
        return JsonResponse(data, safe=False)

    # POST (multipart/form-data)
    if not firma_id:
        return JsonResponse({'error': 'Firma ID gerekli'}, status=400)

    try:
        evrak_turu_id = request.POST.get('evrak_turu_id')
        aciklama = (request.POST.get('aciklama') or '').strip()
        bitis_tarihi_str = (request.POST.get('bitis_tarihi') or '').strip()
        uyari_gunu = int(request.POST.get('uyari_gunu') or 7)
        dosya = request.FILES.get('dosya')

        if not evrak_turu_id or not dosya:
            return JsonResponse({'error': 'Evrak türü ve dosya gerekli'}, status=400)

        try:
            evrak_turu = EvrakTuru.objects.get(id=evrak_turu_id, aktif=True)
        except EvrakTuru.DoesNotExist:
            return JsonResponse({'error': 'Evrak türü bulunamadı'}, status=404)

        bitis_tarihi = parse_date(bitis_tarihi_str) if bitis_tarihi_str else None
        evrak = FirmaEvrak.objects.create(
            firma_id=firma_id,
            evrak_turu=evrak_turu,
            dosya=dosya,
            aciklama=aciklama,
            bitis_tarihi=bitis_tarihi,
            uyari_gunu=uyari_gunu
        )

        return JsonResponse({
            'success': True,
            'id': evrak.id,
            'dosya_url': evrak.dosya.url if evrak.dosya else ''
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)


@require_http_methods(["GET"])
@xframe_options_sameorigin
def firma_evrak_onizle(request, evrak_id):
    """Evrak dosyasını iframe içinde açmak için inline döner."""
    try:
        evrak = FirmaEvrak.objects.get(id=evrak_id)
    except FirmaEvrak.DoesNotExist:
        raise Http404("Evrak bulunamadı.")

    if not evrak.dosya:
        raise Http404("Dosya bulunamadı.")

    file_path = evrak.dosya.path
    if not os.path.exists(file_path):
        raise Http404("Dosya bulunamadı.")

    content_type, _ = mimetypes.guess_type(file_path)
    response = FileResponse(open(file_path, "rb"), content_type=content_type or "application/octet-stream")
    filename = os.path.basename(file_path)
    response["Content-Disposition"] = f'inline; filename="{filename}"'
    return response

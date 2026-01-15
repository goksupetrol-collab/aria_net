"""
Django Güvenlik Kontrol Komutu
SQL Server'daki güvenlik kontrollerine benzer şekilde Django projesini kontrol eder
"""
from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connections
import os
import sys
from pathlib import Path


class Command(BaseCommand):
    help = 'Django projesinin güvenlik durumunu kontrol eder (SQL Server kontrolüne benzer)'

    def handle(self, *args, **options):
        self.stdout.write("=" * 70)
        self.stdout.write("DJANGO PROJESI GUVENLIK KONTROLU")
        self.stdout.write("=" * 70)
        
        # 1. Logging kontrolü
        self.check_logging()
        
        # 2. Middleware kontrolü
        self.check_middleware()
        
        # 3. Veritabanı bağlantıları
        self.check_database_connections()
        
        # 4. Dış bağlantılar (API, servisler)
        self.check_external_connections()
        
        # 5. Otomatik görevler (Celery, cron)
        self.check_scheduled_tasks()
        
        # 6. Güvenlik ayarları
        self.check_security_settings()
        
        self.stdout.write("\n" + "=" * 70)
        self.stdout.write("KONTROL TAMAMLANDI")
        self.stdout.write("=" * 70)
    
    def check_logging(self):
        """Logging ayarlarını kontrol et"""
        self.stdout.write("\n1. LOGGING AYARLARI:")
        if hasattr(settings, 'LOGGING') and settings.LOGGING:
            self.stdout.write(self.style.SUCCESS("  [OK] Logging aktif"))
            handlers = settings.LOGGING.get('handlers', {})
            if 'file' in handlers or 'security' in handlers:
                self.stdout.write(self.style.SUCCESS("  [OK] Dosyaya loglama aktif"))
            else:
                self.stdout.write(self.style.WARNING("  [UYARI] Dosyaya loglama yok"))
        else:
            self.stdout.write(self.style.WARNING("  [UYARI] Logging ayarlari yok"))
    
    def check_middleware(self):
        """Middleware ayarlarını kontrol et"""
        self.stdout.write("\n2. MIDDLEWARE KONTROLU:")
        middleware_list = settings.MIDDLEWARE
        
        # Güvenlik middleware'leri
        security_middlewares = [
            'SecurityMiddleware',
            'CsrfViewMiddleware',
            'XFrameOptionsMiddleware',
        ]
        
        for mw in security_middlewares:
            found = any(mw in m for m in middleware_list)
            if found:
                self.stdout.write(self.style.SUCCESS(f"  [OK] {mw} aktif"))
            else:
                self.stdout.write(self.style.WARNING(f"  [UYARI] {mw} yok"))
        
        # Özel güvenlik middleware'i
        if 'dashboard.middleware.SecurityAuditMiddleware' in middleware_list:
            self.stdout.write(self.style.SUCCESS("  [OK] SecurityAuditMiddleware aktif"))
        else:
            self.stdout.write(self.style.WARNING("  [UYARI] SecurityAuditMiddleware yok"))
    
    def check_database_connections(self):
        """Veritabanı bağlantılarını kontrol et"""
        self.stdout.write("\n3. VERITABANI BAGLANTILARI:")
        for db_name, db_config in settings.DATABASES.items():
            engine = db_config.get('ENGINE', '')
            name = db_config.get('NAME', '')
            host = db_config.get('HOST', 'localhost')
            
            self.stdout.write(f"  Veritabani: {db_name}")
            self.stdout.write(f"    Engine: {engine}")
            self.stdout.write(f"    Name: {name}")
            self.stdout.write(f"    Host: {host}")
            
            # Bağlantıyı test et
            try:
                conn = connections[db_name]
                conn.ensure_connection()
                self.stdout.write(self.style.SUCCESS("    [OK] Baglanti basarili"))
            except Exception as e:
                self.stdout.write(self.style.ERROR(f"    [HATA] Baglanti hatasi: {e}"))
    
    def check_external_connections(self):
        """Dış bağlantıları kontrol et (API'ler, servisler)"""
        self.stdout.write("\n4. DIS BAGLANTILAR:")
        
        # settings.py'de dış servis ayarları var mı?
        external_keys = ['API_URL', 'EXTERNAL_SERVICE', 'WEBHOOK_URL']
        found_external = False
        
        for key in external_keys:
            if hasattr(settings, key):
                value = getattr(settings, key)
                self.stdout.write(f"  [BULUNDU] {key}: {value}")
                found_external = True
        
        if not found_external:
            self.stdout.write(self.style.SUCCESS("  [OK] Dis baglanti bulunamadi"))
    
    def check_scheduled_tasks(self):
        """Zamanlanmış görevleri kontrol et"""
        self.stdout.write("\n5. ZAMANLANMIS GOREVLER:")
        
        # Celery kontrolü
        if hasattr(settings, 'CELERY_BROKER_URL'):
            self.stdout.write(self.style.WARNING("  [UYARI] Celery aktif - zamanlanmis gorevler var"))
            self.stdout.write(f"    Broker: {settings.CELERY_BROKER_URL}")
        else:
            self.stdout.write(self.style.SUCCESS("  [OK] Celery yok"))
        
        # Cron jobs kontrolü (django-crontab)
        if 'django_crontab' in settings.INSTALLED_APPS:
            self.stdout.write(self.style.WARNING("  [UYARI] Django-crontab aktif - zamanlanmis gorevler var"))
        else:
            self.stdout.write(self.style.SUCCESS("  [OK] Django-crontab yok"))
    
    def check_security_settings(self):
        """Güvenlik ayarlarını kontrol et"""
        self.stdout.write("\n6. GUVENLIK AYARLARI:")
        
        # DEBUG modu
        if settings.DEBUG:
            self.stdout.write(self.style.ERROR("  [UYARI] DEBUG=True - Production'da kapali olmali!"))
        else:
            self.stdout.write(self.style.SUCCESS("  [OK] DEBUG=False"))
        
        # ALLOWED_HOSTS
        if settings.ALLOWED_HOSTS:
            self.stdout.write(self.style.SUCCESS(f"  [OK] ALLOWED_HOSTS tanimli: {settings.ALLOWED_HOSTS}"))
        else:
            self.stdout.write(self.style.WARNING("  [UYARI] ALLOWED_HOSTS bos - Production'da tanimlanmali!"))
        
        # SECRET_KEY
        if settings.SECRET_KEY and 'insecure' not in settings.SECRET_KEY.lower():
            self.stdout.write(self.style.SUCCESS("  [OK] SECRET_KEY guvenli"))
        else:
            self.stdout.write(self.style.ERROR("  [UYARI] SECRET_KEY guvensiz veya varsayilan!"))
        
        # CSRF
        if 'django.middleware.csrf.CsrfViewMiddleware' in settings.MIDDLEWARE:
            self.stdout.write(self.style.SUCCESS("  [OK] CSRF korumasi aktif"))
        else:
            self.stdout.write(self.style.ERROR("  [UYARI] CSRF korumasi kapali!"))

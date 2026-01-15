"""
Güvenlik ve İzleme Middleware'i
SQL Server'daki güvenlik kontrollerine benzer şekilde Django'da izleme yapar
"""
import logging
import json
from django.utils import timezone
from django.http import JsonResponse

logger = logging.getLogger('security')


class SecurityAuditMiddleware:
    """
    Tüm istekleri loglar ve güvenlik kontrolleri yapar
    SQL Server Audit'e benzer şekilde çalışır
    """
    
    def __init__(self, get_response):
        self.get_response = get_response
        
    def __call__(self, request):
        # İstek bilgilerini logla
        self.log_request(request)
        
        # İsteği işle
        response = self.get_response(request)
        
        # Yanıt bilgilerini logla
        self.log_response(request, response)
        
        return response
    
    def log_request(self, request):
        """İstek bilgilerini logla"""
        log_data = {
            'timestamp': timezone.now().isoformat(),
            'method': request.method,
            'path': request.path,
            'user': str(request.user) if hasattr(request, 'user') and request.user.is_authenticated else 'Anonymous',
            'ip_address': self.get_client_ip(request),
            'user_agent': request.META.get('HTTP_USER_AGENT', ''),
            'referer': request.META.get('HTTP_REFERER', ''),
        }
        
        logger.info(f"REQUEST: {json.dumps(log_data, ensure_ascii=False)}")
    
    def log_response(self, request, response):
        """Yanıt bilgilerini logla"""
        log_data = {
            'timestamp': timezone.now().isoformat(),
            'path': request.path,
            'status_code': response.status_code,
            'user': str(request.user) if hasattr(request, 'user') and request.user.is_authenticated else 'Anonymous',
        }
        
        # Sadece hataları detaylı logla
        if response.status_code >= 400:
            logger.warning(f"ERROR RESPONSE: {json.dumps(log_data, ensure_ascii=False)}")
        else:
            logger.debug(f"RESPONSE: {json.dumps(log_data, ensure_ascii=False)}")
    
    def get_client_ip(self, request):
        """Kullanıcının IP adresini al"""
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip


class DatabaseQueryLogger:
    """
    Veritabanı sorgularını loglar
    SQL Server'daki sorgu izlemeye benzer
    """
    
    @staticmethod
    def log_query(query, params=None, duration=None):
        """Veritabanı sorgusunu logla"""
        log_data = {
            'timestamp': timezone.now().isoformat(),
            'query': str(query),
            'params': str(params) if params else None,
            'duration': duration,
        }
        
        logger.debug(f"DB QUERY: {json.dumps(log_data, ensure_ascii=False)}")

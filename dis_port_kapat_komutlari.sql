-- ============================================================
-- DIŞ PORT KAPATMA KOMUTLARI
-- ============================================================

-- ADIM 1: Mevcut durumu kontrol edin
EXEC sp_configure 'remote access'
GO

EXEC sp_configure 'remote login timeout'
GO

SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled
GO

-- ============================================================
-- ADIM 2: Uzak girişi kapatın
-- ============================================================

EXEC sp_configure 'remote access', 0
GO

RECONFIGURE
GO

-- ============================================================
-- ADIM 3: Remote login timeout'u kapatın
-- ============================================================

EXEC sp_configure 'remote login timeout', 0
GO

RECONFIGURE
GO

-- ============================================================
-- ADIM 4: Kontrol edin (sonuç 0 olmalı)
-- ============================================================

SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled
-- Sonuç: 0 olmalı (kapalı)
GO

EXEC sp_configure 'remote access'
GO

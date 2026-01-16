from django.db import migrations


def seed_menu_items(apps, schema_editor):
    MenuItem = apps.get_model("dashboard", "MenuItem")
    if MenuItem.objects.exists():
        return

    items = [
        {
            "sira_no": 1,
            "name": "operasyon_sayfasi",
            "baslik": "Operasyon",
            "tab_baslik": "Operasyon",
            "icon": "⛽",
            "aktif": True,
        },
        {
            "sira_no": 2,
            "name": "kredi_karti",
            "baslik": "Kredi Kartı",
            "tab_baslik": "Kredi Kartı",
            "icon": "💳",
            "aktif": True,
        },
        {
            "sira_no": 3,
            "name": "cari_kart",
            "baslik": "Cari Kart",
            "tab_baslik": "Cari Kart",
            "icon": "📒",
            "aktif": True,
        },
        {
            "sira_no": 4,
            "name": "banka",
            "baslik": "Banka",
            "tab_baslik": "Banka",
            "icon": "🏦",
            "aktif": True,
        },
        {
            "sira_no": 5,
            "name": "tanker",
            "baslik": "Tanker",
            "tab_baslik": "Tanker",
            "icon": "🛢️",
            "aktif": True,
        },
        {
            "sira_no": 6,
            "name": "fiyat_degisimi",
            "baslik": "Fiyat Değişimi",
            "tab_baslik": "Fiyat Değişimi",
            "icon": "💹",
            "aktif": True,
        },
    ]

    MenuItem.objects.bulk_create(MenuItem(**item) for item in items)


def unseed_menu_items(apps, schema_editor):
    MenuItem = apps.get_model("dashboard", "MenuItem")
    names = [
        "operasyon_sayfasi",
        "kredi_karti",
        "cari_kart",
        "banka",
        "tanker",
        "fiyat_degisimi",
    ]
    MenuItem.objects.filter(name__in=names).delete()


class Migration(migrations.Migration):
    dependencies = [
        ("dashboard", "0010_menuitem_tab_baslik"),
    ]

    operations = [
        migrations.RunPython(seed_menu_items, unseed_menu_items),
    ]

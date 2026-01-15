"""
ASGI config for aria_net project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/6.0/howto/deployment/asgi/
"""

import os
import sys

try:
    import sqlite3  # noqa: F401
except ModuleNotFoundError:
    import pysqlite3 as sqlite3  # type: ignore

    sys.modules["sqlite3"] = sqlite3

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')

application = get_asgi_application()

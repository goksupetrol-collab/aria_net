try:
    import sqlite3  # noqa: F401
except ModuleNotFoundError:
    import pysqlite3 as sqlite3  # type: ignore
    import sys

    sys.modules["sqlite3"] = sqlite3

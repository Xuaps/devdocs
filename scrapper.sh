#!/bin/bash
export DYLD_FALLBACK_LIBRARY _PATH=/Library/PostgreSQL/9.4/lib/
cd lib/docs/db_storage/
python import_docset.py -aall -mall -cs$2
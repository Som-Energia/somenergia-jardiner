# Manually download a solargis reading

To download a specific day you just need to call

```bash
python -m scripts.solargis <dbapi> <apikey> 2023-05-13 2023-05-13 1 2 3 4
 5 6 7 9 13 14 15 16 17 22 40
```

See `python -m scripts.solargis --help` for info on each parameter (essentially time range and plant id list) and the wiki or the pyxis server for credentials.

Note that to download one day you have to put the same from and to date. The from is start day and to date is end day. The script DOES NOT check for duplicates. You'll have to clean up yourself using the query time if you made a mistake.
# TTS Manager
This program is designed to allow you to manage mods in TTS using ttsbackup and also search through a mod backup database and extract and install those mods to TTS too.

## Updating the Database
This program uses [TTSModsArchive](https://drive.google.com/drive/folders/1iAuPj1tmKSwg55m6ubM-CboegOzz9G_N) on Google Drive to find and download mods.

To update your local backup mods database run:
```
yarn mod_update
```
This will pull a new index file into `./mod_index.html` which is used to search for mods.

## (Optional) Download full mods archive
You can download a complete archive of all the mods listed in `./mod_index.html` from the [TTSModsArchive](https://drive.google.com/drive/folders/1iAuPj1tmKSwg55m6ubM-CboegOzz9G_N) google drive by opening the `Monthly` folder and downloading the large archive. This will avoid issues of downloading too many mods later and hitting googles rate limit.

Once you have downloaded the archive, you should extract it into this folder. You should now have a `./TTS_All_Workshop_Mods` folder and inside it, lots of 7z mod archives.

## Search mods
You can find mods by using:

```
yarn mod_search "STRING_TO_SEARCH_FOR"
```

e.g. to find Chess mods:
```
yarn mod_search "Chess"
```

And this will return:
```
====================================================
Found the following matching mods:
====================================================
0: 10 Dimensional Chess (465549865).7z
1: 2 Chess Boards (1948136513).7z
2: 2 Player Circular Chess (Modern & Byzantine) (767321684).7z
3: 2 Player team_mirror chess (1628840958).7z
4: 2 Set of Chess (1609841039).7z
5: 2v2 chess (351833559).7z
6: 3 Person Chess (1236100964).7z
7: 3 person chess (402991375).7z
8: 3 Player Chess (280046262).7z
9: 3 Player Chess (Setup) (726327723).7z
...
```

If you want number 3 then extract the id from the brackets at the end of the name: `767321684` and use it in the next section

# Download mods
You can download (and optionally import into TTS) mods by using:

```
yarn mod_download "MOD_ID"
```

e.g. to download "2 Player Circular Chess (Modern & Byzantine)":

```
yarn mod_download "767321684"
```

# ttsbackup
You can also use ttsbackup from this repo

```
yarn ttsbackup -h
```

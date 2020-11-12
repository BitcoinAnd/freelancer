#!/usr/bin/env python3
import os,sys
from io import BytesIO
from mutagen.mp3 import MP3 # pip3 install mutagen
from mutagen.id3 import ID3
from PIL import Image, ImageFile # pip3 install pillow

song_path = os.path.join(sys.argv[1])
track = MP3(song_path)
tags = ID3(song_path)
print("ID3 tags included in this song ------------------")
print(tags.pprint())
print("-------------------------------------------------")
tcon = tags.get("TCON")
apic = tags.get("APIC")
tit2 = tags.get("TIT2")
tpe1 = tags.get("TPE1")
print(tcon)
print(apic)
print(sys.getsizeof(apic))
print(tit2)
print(tpe1)
try:
    im = Image.open(BytesIO(apic))
    print('Picture size : ' + str(im.size))

except:
    pass

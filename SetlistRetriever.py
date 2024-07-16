import requests
from requests.auth import HTTPDigestAuth
import json
import os
from PIL import Image
from io import BytesIO

key = "b866417bd1dbe7afdd2e38d765848f8d"
mainurl = "https://rebrickable.com/api/v3/lego/"
kitID = '76424-1'

def getPartsList(url):
    # It is a good practice not to hardcode the credentials. So ask the user to enter credentials at runtime
    myResponse = requests.get(url,params={"key": key, 'inc part_details' : '1'})
    if(myResponse.ok):
        # Loading the response data Into a dict Variable
        # json.loads takes in only binary or string variables so using content to fetch binary content
        # loads (Load String) takes a Json file and converts into python data structure (dict or list, depending on JSON)
        jData = json.loads(myResponse.content)
        return jData
    else:
        # If response code is not ok (200), print the resulting http error code with description
        myResponse.raise_for_status()

def partsImportLDRAW():
    url = mainurl + "sets/" + kitID + "-1/parts/"
    parts = []
    partsList = getPartsList(url)
    for piece in partsList['results']:
        parts.append(piece["part"]["part_num"])
    return parts

def makeLDRAWfile():
    LDRAW_file = open("LDRAW_file.ldr", "w")
    parts = partsImportLDRAW()
    for piece in parts:
        line = '1 4 0 0 0 1 0 0 0 1 0 0 0 1 ' + str(piece) + '.dat'
        LDRAW_file.write(line)
        LDRAW_file.write("\n")
    LDRAW_file.close()

makeLDRAWfile()

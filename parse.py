import gzip
import xmltodict, json
import xml
import os
import re

output = open("input.txt","w")
jsoncatalog = open("jsoncatalog.txt","w")

def parseSubject(subject):
    """
    Parses the keyword field, and returns a dictionary of between one and three items
    (depending on whether there's a second field in parentheses, or a third field in
    after the parentheses.
    """
    try:
        values = re.findall("(.*) \((.*)\) ?(.*)",subject)
    except TypeError:
        return dict()
    keys = ['subject1','subject2','subject3']
    output = dict()
    if len(values)==0:
        return dict()
    vals = dict(zip(keys,values[0]))
    for key in vals:
        if vals[key] != "":
            output[key] = vals[key]
    return output
    

def handle(line):
    try:
        f = dict()
        try:
            o = xmltodict.parse(line)['IndexCatalogueRecord']
        except xml.parsers.expat.ExpatError:
            return
        f['filename'] = o['IndexCatalogueID']
        for key in ['Title','TypeOfResource','Language',"Size"]:
            try:
                f[key] = o[key]
            except KeyError:
                f[key] = ""
        for key in ['JournalTA','PubDate',"Place"]:
            try:
                f[key] = o['PublicationInfo'][key]
            except KeyError:
                pass
            except TypeError:
                pass
        for key in ['LastName','FirstName']:
            try:
                f[key] = o['Author'][key]
            except KeyError:
                pass
            except TypeError:
                pass
        try:
            keywords = o["Keyword"]
            values = parseSubject(keywords)
            for key in values:
                f[key] = values[key]
        except KeyError:
            f["subject1"] = "None"
        
        jsoncatalog.write(json.dumps(f)+"\n")
        try:
            aline = f['filename'] + "\t" + f['Title'] + "\n"
            aline = aline.encode("utf-8")
            output.write(aline)
        except:
            import warnings
            warnings.warn("Error on " + line)
    except:
        raise

i = 0
limit = float("inf")
limit = 10000;
for filename in [file for file in os.listdir(".") if re.search("xml.gz",file)]:
    file = gzip.open(filename)

    for line in file:
        handle(line)
        i+= 1
        if i > limit:
            break



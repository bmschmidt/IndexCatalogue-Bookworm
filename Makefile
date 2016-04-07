targets = ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries1/IndexCatalogueSeries1.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries2/IndexCatalogueSeries2.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries3/IndexCatalogueSeries3.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries4/IndexCatalogueSeries4.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries5/IndexCatalogueSeries5.xml.gz



all: input.txt jsoncatalog.txt
	bookworm build all

downloads:
	wget -nc $(targets)

.bookworm:
	bookworm init

input.txt: downloads
	python parse.py

jsoncatalog.txt: downloads
	python parse.py


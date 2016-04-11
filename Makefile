targets = ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries1/IndexCatalogueSeries1.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries2/IndexCatalogueSeries2.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries3/IndexCatalogueSeries3.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries4/IndexCatalogueSeries4.xml.gz ftp://public.nlm.nih.gov/nlmdata/IndexCatalogue/IndexCatalogueSeries5/IndexCatalogueSeries5.xml.gz


all: input.txt jsoncatalog.txt .bookworm
	bookworm build all

.bookworm/extensions/bookworm-geolocator:
	mkdir -p .bookworm/extensions
	git clone https://github.com/bmschmidt/bookworm-geolocator.git $@

.bookworm/extensions/bookworm-geolocator/geolocation.cnf:
	echo "geonamesID=nobody" > $@
	echo "bookwormName=indexcatalog" >> $@
	echo "fieldName=Place" >> $@
	echo "outputFile=geocoded.txt" >> $@
	echo "nToAdd=0" >> $@

geocoding: .bookworm/extensions/bookworm-geolocator .bookworm/extensions/bookworm-geolocator/geolocation.cnf
	make -C $<

downloads:
	wget -nc $(targets)

.bookworm:
	bookworm init

input.txt: downloads
	python parse.py

jsoncatalog.txt: downloads
	python parse.py


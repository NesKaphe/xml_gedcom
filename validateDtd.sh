#!/bin/bash

clear

if [ ! -f data/begood.xml ]
then
    echo "begood.xml non trouvé. Parse : begood.ged"
    sbt "run-main parse data/begood.ged"
fi
result=`xmllint --noout --dtdvalid src/gedcom.dtd data/begood.xml 2>&1 >/dev/null`

if [ -n "$result" ]
then
    echo "$result"
    exit 0
else
    echo "[SUCCESS] begood.xml avec la dtd gedcom.dtd"
fi


if [ ! -f data/doe.xml ]
then
    echo "doe.xml non trouvé. Parse : doe.ged"
    sbt "run-main parse data/doe.ged"
fi
result=`xmllint --noout --dtdvalid src/gedcom.dtd data/doe.xml 2>&1 >/dev/null`

if [ -n "$result" ]
then
    echo "$result"
    exit 0
else
    echo "[SUCCESS] doe.xml avec la dtd gedcom.dtd"
fi


if [ ! -f data/complet.xml ]
then
    echo "complet.xml non trouvé. Parse : complet.ged"
    sbt "run-main parse data/complet.ged"
fi

result=`xmllint --noout --dtdvalid src/gedcom.dtd data/complet.xml 2>&1 >/dev/null`

if [ -n "$result" ]
then
    echo "$result"
    exit 0
else
    echo "[SUCCESS] complet.xml avec la dtd gedcom.dtd"
fi

if [ ! -f data/french.xml ]
then
    echo "french.xml non trouvé. Parse : french.ged"
    sbt "run-main parse data/french.ged"
fi

result=`xmllint --noout --dtdvalid src/gedcom.dtd data/french.xml 2>&1 >/dev/null`

if [ -n "$result" ]
then
    echo "$result"
    exit 0
else
    echo "[SUCCESS] french.xml avec la dtd gedcom.dtd"
fi

if [ ! -f data/royal.xml ]
then
    echo "royal.xml non trouvé. Parse : royal.ged"
    sbt "run-main parse data/royal.ged"
fi

result=`xmllint --noout --dtdvalid src/gedcom.dtd data/royal.xml 2>&1 >/dev/null`

if [ -n "$result" ]
then
    echo "$result"
    exit 0
else
    echo "[SUCCESS] royal.xml avec la dtd gedcom.dtd"
fi

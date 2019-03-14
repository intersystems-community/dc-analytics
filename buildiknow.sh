#!/bin/sh

/bin/echo -e '' \
        ' do $system.DeepSee.BuildCube("POST", 1, 1)' \
        ' halt' \
| iris session $ISC_PACKAGE_INSTANCENAME -UDCANALYTICS
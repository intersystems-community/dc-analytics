ARG IMAGE=store/intersystems/iris:2019.1.0.511.0-community
ARG IMAGE=store/intersystems/iris:2019.2.0.107.0-community
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.204.0-zpm
FROM $IMAGE

USER root
WORKDIR /opt/dcanalytics
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/dcanalytics

RUN mkdir -p /tmp/deps \
 && cd /tmp/deps \
 # Download globals data
&& wget -q -O - https://api.github.com/repos/intersystems-community/dc-analytics/releases/latest \
  | egrep 'http.*DCAnalytics_globals.*gz' \
  | cut -d : -f 2,3 \
  | tr -d '"' \
  | wget -O - -i - \
  | gunzip > /opt/dcanalytics/globals.xml 


USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .
COPY  post_start_hook .
COPY  src src
COPY iris.script iris.script

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly


COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /dsw/dcanalytics.json /usr/irissys/csp/dsw/configs/
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /dsw/config.json /usr/irissys/csp/dsw/



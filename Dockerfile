ARG IMAGE=store/intersystems/iris:2019.1.0.511.0-community
ARG IMAGE=store/intersystems/iris:2019.2.0.107.0-community
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.204.0-zpm
FROM $IMAGE

USER root
WORKDIR /opt/dcanalytics
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/dcanalytics
COPY irissession.sh /
RUN chmod +x /irissession.sh 

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
COPY  src src
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).setup() \
  zn "DCANALYTICS" \
  zpm "install dsw" \
  zpm "install isc-dev" \
  zpm "install webterminal" \
  do ##class(dev.code).workdir("/irisdev/app/src") \
  do EnableDeepSee^%SYS.cspServer("/csp/dcanalytics/") \
  do ##class(Community.Utils).setup("/opt/dcanalytics/globals.xml",10000000) \
  zn "%SYS" \
  write "Modify MDX2JSON application security...",! \
  set webName = "/mdx2json" \
  set webProperties("AutheEnabled") = 64 \
  set webProperties("MatchRoles")=":%DB_DCANALYTICS" \
  set sc = ##class(Security.Applications).Modify(webName, .webProperties) 

SHELL ["/bin/bash", "-c"]

COPY /dsw/dcanalytics.json /usr/irissys/csp/dsw/configs/


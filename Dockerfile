FROM intersystems/iris:2019.1.0S.111.0

# version DeepSeeWeb
ARG DSW_VERSION=2.1.32


WORKDIR /opt/app

COPY ./src/ ./src/
COPY dswinstaller.cls ./


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl

RUN mkdir -p /tmp/deps \

 && cd /tmp/deps \

 # Download MDX2JSON, just master branch from github as archive
 && curl -L -q https://github.com/eduard93/Cache-MDX2JSON/archive/master.tar.gz | tar xvfzC - . \

 # Download DeepSeeWeb from releases
 && curl -L -q https://github.com/intersystems-ru/DeepSeeWeb/releases/download/${DSW_VERSION}/DSW.Installer.${DSW_VERSION}.xml -o deepseeweb.xml \

 # Download globals data
&& curl -s https://api.github.com/repos/intersystems-community/dc-analytics/releases/latest \
  | egrep 'http.*DCAnalytics_globals.*gz' \
  | cut -d : -f 2,3 \
  | tr -d '"' \
  | wget -O - -i - \
  | gunzip > /opt/app/globals.xml 

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    /bin/echo -e "sys\nsys\n" \
            " Do ##class(Security.Users).UnExpireUserPasswords(\"*\")\n" \
            " Do ##class(Security.Users).AddRoles(\"admin\", \"%ALL\")\n" \
            " do \$system.OBJ.Load(\"/opt/app/dswinstaller.cls\",\"ck\")\n" \
            " Do ##class(Security.System).Get(,.p)\n" \
            " Set p(\"AutheEnabled\")=\$zb(p(\"AutheEnabled\"),16,7)\n" \
            " Do ##class(Security.System).Modify(,.p)\n" \
            " set ^%SYS(\"CSP\",\"DefaultFileCharset\")=\"utf-8\"\n" \
            # " do \$system.OBJ.Load(\"/tmp/deps/Cache-MDX2JSON-master/MDX2JSON/Installer.cls.xml\",\"ck\")\n" \
            # " do \$system.OBJ.Load(\"/tmp/deps/deepseeweb.xml\",\"ck\")\n" \
            " s sc=##class(DSWMDX2JSON.Installer).setup()\n" \
            " If 'sc do \$zu(4, \$JOB, 1)\n" \
            # "do CreateDatabase^%SYS.SQLSEC(\"DCANALYTICS\",\"\",,0)\n" \
            " zn \"DCANALYTICS\"\n" \
            " do \$system.OBJ.ImportDir(\"/opt/app/src\",,\"ck\",,1)\n" \
            " do ##class(Community.Utils).setup(\"/opt/app/globals.xml\")" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e "sys\nsys\n" \
    | iris stop $ISC_PACKAGE_INSTANCENAME quietly

COPY ./other/dcanalytics.json /usr/irissys/csp/dsw/configs/

COPY ./buildiknow.sh ./

CMD [ "-l", "/usr/irissys/mgr/messages.log", "-a", "/opt/app/buildiknow.sh" ]
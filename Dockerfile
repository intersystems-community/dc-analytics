FROM store/intersystems/iris:2019.1.0.511.0-community

WORKDIR /opt/app

COPY ./src/ ./src/

RUN mkdir -p /tmp/deps \

 && cd /tmp/deps \

 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml \

 # Download globals data
&& wget -q -O - https://api.github.com/repos/intersystems-community/dc-analytics/releases/latest \
  | egrep 'http.*DCAnalytics_globals.*gz' \
  | cut -d : -f 2,3 \
  | tr -d '"' \
  | wget -O - -i - \
  | gunzip > /opt/app/globals.xml 

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    /bin/echo -e "sys\nsys\n" \
            " do ##class(Security.Users).UnExpireUserPasswords(\"*\")\n" \
            " do ##class(Security.Users).AddRoles(\"admin\", \"%ALL\")\n" \
            " do \$system.OBJ.Load(\"/opt/app/dswinstaller.cls\",\"ck\")\n" \
            " do ##class(Security.System).Get(,.p)\n" \
            " set p(\"AutheEnabled\")=\$zb(p(\"AutheEnabled\"),16,7)\n" \
            " do ##class(Security.System).Modify(,.p)\n" \
            " Do \$system.OBJ.Load(\"/tmp/deps/zpm.xml\", \"ck\")" \
            " do CreateDatabase^%SYS.SQLSEC(\"DCANALYTICS\",\"\",,0)\n" \
            " zn \"DCANALYTICS\"" \
            " zpm \"install dsw\"" \
            " do \$system.OBJ.ImportDir(\"/opt/app/src\",,\"ck\",,1)\n" \
            " do ##class(Community.Utils).setup(\"/opt/app/globals.xml\")" \
            " zn \"%sys\"" \
            " write \"Create web application ...\",!" \
            " set webName = \"/csp/dcanalytics\"" \
            " set webProperties(\"NameSpace\") = \"DCANALYTICS\"" \
            " set webProperties(\"Enabled\") = 1" \
            " set webProperties(\"IsNameSpaceDefault\") = 1" \
            " set webProperties(\"CSPZENEnabled\") = 1" \
            " set webProperties(\"AutheEnabled\") = 32" \
            " set webProperties(\"iKnowEnabled\") = 1" \
            " set webProperties(\"DeepSeeEnabled\") = 1" \
            " set status = ##class(Security.Applications).Create(webName, .webProperties)" \
            " write:'status \$system.Status.DisplayError(status)" \
            " write \"Web application \"\"\"_webName_\"\"\" was created!\",!" \
            " zn \"DCANALYTICS\"" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e "sys\nsys\n" \
    | iris stop $ISC_PACKAGE_INSTANCENAME quietly

RUN apt update && apt install -y git && git clone https://github.com/intersystems-community/dsw-reports.git && cp -r dsw-reports/src/web/reports /usr/irissys/csp/dsw/ && cp -r src/reports /usr/irissys/csp/dsw/ && rm -rf dsw-reports

COPY ./other/dcanalytics.json /usr/irissys/csp/dsw/configs/

COPY ./fixoverlay.sh ./

CMD [ "-b", "/opt/app/fixoverlay.sh" ]
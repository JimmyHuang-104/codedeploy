#!/bin/sh

#刪除 war
if [ -f /var/lib/tomcat8/webapps/ROOT.war ]; then
  rm /var/lib/tomcat8/webapps/ROOT.war
fi

#刪除 war 自動解開後的 webapp 部署目錄
if [ -d /var/lib/tomcat8/webapps/ROOT ]; then
  rm -rf /var/lib/tomcat8/webapps/ROOT
fi

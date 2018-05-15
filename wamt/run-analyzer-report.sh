#!/bin/bash
# using https://developer.ibm.com/wasdev/downloads/#asset/tools-Migration_Toolkit_for_Application_Binaries
EAR_FILE=$1
java -jar binaryAppScanner.jar $EAR_FILE --analyze --sourceJava=oracle6 --targetJava=oracle8 --sourceAppServer=jboss --targetCloud=thirdParty
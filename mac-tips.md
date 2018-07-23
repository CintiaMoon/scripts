# Mac Tips

How to kill a process that's hogging port 8080...

````bash
netstat -vanp tcp | grep 8080
kill -9 <PID>
````

Logging in to remote servers (public key)
ssh user@IP-ADDRESS

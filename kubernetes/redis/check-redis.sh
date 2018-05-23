#!/bin/bash
kubectl get all -o wide
kubectl exec redis-2 -c redis -- redis-cli -p 26379 sentinel get-master-addr-by-name redis # Should show IP of redis-0 and 6379
kubectl exec redis-2 -c redis -- redis-cli -p 6379 get foo # Should show no data
kubectl exec redis-2 -c redis -- redis-cli -p 6379 set foo 10 # Should give error - can't write against a slave
kubectl exec redis-0 -c redis -- redis-cli -p 6379 set foo 10 # Should be OK
kubectl exec redis-2 -c redis -- redis-cli -p 6379 get foo # Should now show 10 where before there was no data
kubectl exec redis-0 -c redis -- redis-cli -p 6379 del foo # Should remove the key 'foo'
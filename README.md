### stack:
  * CNI: cilium
  * Service Mash: istio
  * CD: argo-cd
  * Secret engine: vault hcl
  * Monitoring: grafana/prometheus/loki
  * Message broker: RabbitMQ
 
## Start 

### Download providers 
```bash
terraform init
```
### First need init cluster 
```bash
terraform apply -target=kind_cluster.workshop
```
### Apply all resources 
```bash 
terraform apply 
```
### Clear 
```
terraform destroy 
```
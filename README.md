### stack:
  * CNI: cilium
  * Load Balancer: metallb
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
### Apply all resources 
```bash 
terraform apply 
```
### Clear 
```
terraform destroy 
```
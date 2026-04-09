# get the Ingress IP
INGRESS_IP=$(kubectl get ingress foo-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# should output "foo-app"
printf "curl -i ${INGRESS_IP}/foo\n\n"
curl -i ${INGRESS_IP}/foo
printf "\n\n---\n"

# get the Ingress IP
INGRESS_IP=$(kubectl get ingress bar-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# should output "bar-app"
printf "curl -i ${INGRESS_IP}/bar\n\n"
curl -i ${INGRESS_IP}/bar
printf "\n"
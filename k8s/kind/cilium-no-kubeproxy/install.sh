helm upgrade --install --namespace kube-system --repo https://helm.cilium.io/ cilium cilium --values values.yaml --set k8sServiceHost=$(k get endpoints kubernetes -o=jsonpath='{.subsets[0].addresses[0].ip}')
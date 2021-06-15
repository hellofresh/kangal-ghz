#!/usr/bin/env bash
set -e

# Run dummy grpc server to test ghz
kubectl run greeter-server --port=50051 --image=greeter_server:local -- --enable-reflection
kubectl expose pod greeter-server
kubectl wait --for=condition=ready pod greeter-server

helm repo add kangal https://hellofresh.github.io/kangal
helm install \
  --set configMap.GHZ_IMAGE_TAG=local \
  --set proxy.replicaCount=1 \
  kangal kangal/kangal --wait --timeout 60s 

PROXY_POD_NAME=$(kubectl  get po | grep proxy | awk '{print $1}')
kubectl expose pod "$PROXY_POD_NAME" --type=NodePort && sleep 2

PROXY_IP=$(kubectl describe pod "${PROXY_POD_NAME}" | grep "Node:" | cut -d '/' -f 2)
PROXY_PORT=$(kubectl get service "${PROXY_POD_NAME}" | grep kangal-proxy | cut -d ':' -f 2 | cut -d '/' -f 1)

KANGAL_PROXY_ADDRESS="${PROXY_IP}:${PROXY_PORT}"

curl -f -X POST "http://${KANGAL_PROXY_ADDRESS}/load-test" \
  -H 'Content-Type: multipart/form-data' \
  -F type=Ghz \
  -F distributedPods=1 \
  -F testFile=@testdata/config.json
  
sleep 5
# Verify that greeter-server received something
REQUEST_COUNT=$(kubectl logs greeter-server --tail=100 | grep -c "Received")
if [ "$REQUEST_COUNT" -eq "0" ]; then
  echo "Expected dummy grpc server to receive >0 request, but found 0. Test failed."
  exit 1
fi

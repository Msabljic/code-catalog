# PLEX-SERVER

This helm chart lets you spin up a plex server with SMB file sources and loadbalanced. There are some pre work you will need to do. 

This is directly sourced from [JimsGarage](https://github.com/JamesTurland/JimsGarage/tree/main/Kubernetes/SMB)

## Install CSI
``` 
curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/v1.18.0/deploy/install-driver.sh | bash -s v1.18.0 --
```

## Create CSI Storage Class
```
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/deploy/example/storageclass-smb.yaml
```

## Create SMB Authentication secret
```
kubectl create secret generic YOURCREDNAME --from-literal username=USERNAME --from-literal password='PASSWORD'
```

Note: You will want to use ' ' as passwords with special characters can be an issue in terminal

## Create a value.yaml 
```yaml
appName: value
namespace: value
plexClaim: claim-value # This comes from plex to claim a server
configmap:
  csi:
    volumeAttributes:
      source: "//value/subvalue" #server IP and relative path if needed
    nodeStageSecretRef:
      name: value # The name of the credential you created
      namespace: value # The namespace you created it in
resource: #If you have a nvidia gpu 
  limits:
    nvidia.com/gpu: 1
```

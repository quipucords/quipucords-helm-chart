# Quipucords Helm Chart

Helm Chart for the Discovery product.

Install and Uninstall the Discovery product to OpenShift and Kubernetes via the `helm` command-line tool which must be installed as a prerequisite.

The Helm chart lives in the `discovery` subdirectory and can be installed as follows to use the default `discovery` name:

First login to OpenShift and set your working Namespace/Project for `discovery`:


```
$ oc login https://api.<your_cluster>:6443 -u kubeadmin -p <kubeadmin_password>
$ oc project discovery-helm
```

Then, install discovery:

```
$ helm install discovery ./discovery --set server.password="EXAMPLE-superadmin1"
NAME: discovery
LAST DEPLOYED: Sun Dec  3 16:09:56 2023
NAMESPACE: discovery-helm
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES: ...
```


To uninstall the above release of discovery:

```
$ helm uninstall discovery
release "discovery" uninstalled
```

If there is a need to install multiple `discovery` instances to the same namespace, install `discovery` with a unique instance name as follows:

```
$ helm install --generate-name ./discovery --set server.password="EXAMPLE-superadmin2"
NAME: discovery-1612624192
LAST DEPLOYED: Sun Dec  3 16:09:56 2023
NAMESPACE: discovery-helm
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES: ...
```


To uninstall the above release of discovery, specify the instance name:

```
$ helm uninstall discovery-1612624192
release "discovery-1612624192" uninstalled
```

Note that `helm list` will show the installed Charts in the namespace:

```
$ helm list
NAME                	NAMESPACE     	REVISION	UPDATED                             	STATUS  	CHART          	APP VERSION
discovery-1702314666	discovery-helm	1       	2023-12-11 12:11:07.898808 -0500 EST	deployed	discovery-0.9.1	1.4.5
discovery-1702314671	discovery-helm	1       	2023-12-11 12:11:11.442539 -0500 EST	deployed	discovery-0.9.1	1.4.5
```

Note, by default the Discovery Django secret key used is `development`, for production, an alternate secret key should be used. The Django secret key gets stored with the `discovery-secrets` and should be specified at initial deployment as follows:

```
$ helm install --generate-name ./discovery \
  --set server.password="EXAMPLE-superadmin1" \
  --set server.djangoSecretKey="production1"
```


By default, the Discovery product uses the `discovery-pull-secret` if defined.  If a different pull secret is needed specify the alternate name as follows:

```
$ helm install discovery ./discovery \
    --set server.password="EXAMPLE-superadmin1" \
    --set global.imagePullSecrets[0].name=alternate-discovery-pull-secret
```

Other than the generated names by Helm, custom Discovery release names can be used as follows:

```
$ helm install discovery-dev ./discovery \
    --set server.password="EXAMPLE-superadmin1"
...
$ helm install discovery-qe ./discovery \
    --set server.password="EXAMPLE-testadmin1"
...
```

And can be uninstalled by their given names:

```
$ helm uninstall discovery-dev discovery-qe
```

For development use cases a simple `Makefile` is provided as a wrapper to helm.

```
$ make
Makefile for the Discovery Helm Chart.

Make targets:
  help                       Shows this output.
  dry-run                    Does a dry-run Installation and sends generated object to standard output.
  install <params>           Installs Discovery onto the current namespace.
     <params> = NAME=... SERVER_PASSWORD=...

  install-unique <params>    Installs Discovery with a unique generated name onto the current namespace.
     <params> = SERVER_PASSWORD=...

  lint                       Run Lint against the Discovery Chart
  ls                         Show the installed Discovery helm charts.
  uninstall <params>         Uninstalls Discovery from the current namespace.
     <params> = NAME=...
```

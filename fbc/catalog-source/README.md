
**setup**

* This sequence assumes the use of an index image located at **quay.io/scoheb/fbc-index-testing:latest**
* It should contain a FBC fragment added by IIB
* Modify **catalogsource.yaml** to specify your index image to use

**login as kubeadmin**

```
oc login ...
```

**create new namespace**
```
oc new-project my-namespace
```

**disable other catalog sources**

```
sh ./patch.sh
```

**create catalog source**

```
oc apply -f catalogsource.yaml
```

**create operator group**

```
oc apply -f operatorgroup.yaml
```

**create subscription**

```
oc apply -f subscription.yaml
```

**install operator via console**

* login to console
* goto Operators/OperatorHub
* search for 'virtualization'
* select the one for 'My Operator Catalog'

**verify**
* At this point, the operator will attempt to install



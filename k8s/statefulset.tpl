apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: dc-analytics
  namespace: iris
spec:
  serviceName: dc-analytics
  replicas: 1
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: dc-analytics
  template:
    metadata:
      labels:
        app: dc-analytics
    spec:

      initContainers:
      - name: dc-volume-change-owner-hack
        image: busybox
        command:
        - sh
        - -c
        - |
          chown -R 51773:52773 /opt/dcanalytics/DCANALYTICS-DATA
          chmod g+w /opt/dcanalytics/DCANALYTICS-DATA
          echo -e "zn \"%sys\"\nif (##class(SYS.Database).%ExistsId(\"/opt/dcanalytics/DCANALYTICS-DATA\")) { halt }\nset db=##class(SYS.Database).%New()\nset db.Directory=\"/opt/dcanalytics/DCANALYTICS-DATA\"\nset db.ResourceName=\"%DB_DCANALYTICS\"\nwrite db.%Save()\nhalt" > /mount-helper/mount_dcanalytics_data
        volumeMounts:
        - mountPath: /opt/dcanalytics/DCANALYTICS-DATA
          name: dc-volume
        - mountPath: /mount-helper
          name: mount-helper
      volumes:
      - emptyDir: {}
        name: mount-helper
      containers:
      - image: DOCKER_REPO_NAME:DOCKER_IMAGE_TAG
        name: dc-analytics
        lifecycle:
          postStart:
            exec:
              command:
              - /bin/bash
              - -c
              - |
                sleep 30
                iris session iris < /mount-helper/mount_dcanalytics_data
        ports:
        - containerPort: 52773
          name: web
        readinessProbe:
          httpGet:
            path: /csp/sys/UtilHome.csp
            port: 52773
          initialDelaySeconds: 10
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /csp/sys/UtilHome.csp
            port: 52773
          periodSeconds: 10
        volumeMounts:
        - mountPath: /opt/dcanalytics/DCANALYTICS-DATA
          name: dc-volume
        - mountPath: /mount-helper
          name: mount-helper
  volumeClaimTemplates:
  - metadata:
      name: dc-volume
      namespace: iris
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10Gi

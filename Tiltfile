SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='tap-harbor.vm-metaage.lab/tap-tkgm/apps/validation-v1-default')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')
APP_NAME = 'validation-v1'

k8s_custom_deploy(
   APP_NAME,
   apply_cmd="tanzu apps workload apply -f config/workload.yaml --debug --live-update" +
       " --local-path " + LOCAL_PATH +
       " --source-image " + SOURCE_IMAGE +
       " --namespace " + NAMESPACE +
       " --yes >/dev/null" +
       " && kubectl get workload APP-NAME --namespace " + NAMESPACE + " -o yaml",
   delete_cmd="tanzu apps workload delete -f config/workload.yaml --namespace " + NAMESPACE + " --yes" ,
   deps=['pom.xml', './target/classes'],
   container_selector='workload',
   live_update=[
       sync('./target/classes', '/workspace/BOOT-INF/classes')
   ]
)

k8s_resource(APP_NAME, port_forwards=["80:80"],
   extra_pod_selectors=[{'carto.run/workload-name': APP_NAME, 'app.kubernetes.io/component': 'run'}])

SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='dy-harbor.sysage.com.tw/tap-tkgm/apps/validation-v1-source')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='tap-dev')
USER_NAME = os.getenv("USER_NAME", default='admin')
USER_PASS = os.getenv("USER_PASS", default='')
OUTPUT_TO_NULL_COMMAND = os.getenv("OUTPUT_TO_NULL_COMMAND", default='> /dev/null')

allow_k8s_contexts(k8s_context())

k8s_custom_deploy(
    'validation-v1',
    apply_cmd="tanzu apps workload apply -f config/workload.yaml --debug --live-update" +
              " --local-path " + LOCAL_PATH +
              " --source-image " + SOURCE_IMAGE +
              " --namespace " + NAMESPACE +
              " --registry-username " + USER_NAME +
              " --registry-password " + USER_PASS +
              " --yes " +
              OUTPUT_TO_NULL_COMMAND +
              " && kubectl get workload validation-v1 --namespace " + NAMESPACE + " -o yaml",
    delete_cmd="tanzu apps workload delete -f config/workload.yaml --namespace " + NAMESPACE + " --yes",
    deps=['pom.xml', 'src'],
    container_selector='workload',
    live_update=[
      sync('./target/classes', '/workspace/BOOT-INF/classes')
    ]
)

k8s_resource('validation-v1', port_forwards=["80:80"],
            extra_pod_selectors=[{'serving.knative.dev/service': 'validation-v1'}])

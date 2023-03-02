# Tanzu Application Platform 環境準備

## 工具

* 安裝 Kubernetes 命令行工具`kubectl`。

> 有關安裝`kubectl`的信息，請參閱Kubernetes 文檔中的[安裝工具](https://kubernetes.io/docs/tasks/tools/)。

* 將您的`kubeconfig`上下文設置為準備好的集群以及命名空間。

```shell
export CONTEXT_NAME="CONTEXT_NAME"
kubectl config use-context $CONTEXT_NAME
kubectl config set-context $CONTEXT_NAME --namespace "NAMESPACE"
```

* 安裝 Tanzu CLI。

>
請參閱 [安裝或更新 Tanzu CLI 和插件](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-install-tanzu-cli.html#cli-and-plugin)。

* 安裝插件必須包含 App 插件。

>
請參閱[安裝 App 插件](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-cli-plugins-apps-install-apps-cli.html)。

* 設置開發人員命名空間：
    1. Add Registry Credentials and assign to `ServiceAccount`。如果不只一個 Registry
       要驗證，則必須設置在同一個`secret/registry-credentials`。
    ```shell
      tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
      kubectl patch serviceaccount default --type=json -p '[{"op":"add","path":"/imagePullSecrets/-","value":{"name": "registry-credentials"}}]' --namespace YOUR-NAMESPACE
    ```

    2. Add Git Credentials and assign to `ServiceAccount`。
    ```shell
      cat <<EOF | kubectl apply -f -
        apiVersion: v1
        kind: Secret
        metadata:
          name: git-credential
          namespace: {YOUR-NAMESPACE}
          annotations:
            tekton.dev/git-0: {GIT_HOST_URL}
        type: kubernetes.io/basic-auth
        stringData:
          username: {GIT_ACCOUNT}
          password: {GIT_PASS}
      EOF                                                           
      kubectl patch serviceaccount default --type=json -p '[{"op":"add","path":"/secrets/-","value":{"name": "git-credential"}}]' --namespace YOUR-NAMESPACE
    ```
    > 如果要設定自簽憑證請設定`caFile`，詳請請參考[Git Repositories | Flux | HTTPS Certificate Authority](https://fluxcd.io/flux/components/source/gitrepositories/#https-certificate-authority)

## 部屬配置

### Workload

* 於專案下建一目錄 **config**，並新增 **workload.yaml**

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: { SERVICE-NAME }
  namespace: { NAMESPACE }
  labels:
    app.kubernetes.io/part-of: { SERVICE-NAME }
    apps.tanzu.vmware.com/workload-type: web
    apps.tanzu.vmware.com/has-tests: "true"
    apis.apps.tanzu.vmware.com/register-api: "true"
    tanzu.app.live.view: "true"
    tanzu.app.live.view.application.name: { SERVICE-NAME }
    tanzu.app.live.view.application.flavours: spring-boot
spec:
  params:
    - name: annotations
      value:
        autoscaling.knative.dev/minScale: "1"
    - name: gitops_ssh_secret
      value: gitlab-auth
    - name: dockerfile
      value: ./Dockerfile
    - name: debug
      value: "false"
    - name: api_descriptor
      value:
        type: openapi
        location:
          path: "/v3/api-docs"
          baseURL: http://{SERVICE-NAME}.{NAMESPACE}.svc.cluster.local
        system: default-system
        owner: default-team
        description: demo
  source:
    git:
      ref:
        branch: master
      url: https://www.gitlab.com/training/sample/validation.git
```

* 新增一 **secret** 為 **gitlab** 的 **credentials**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-auth
  namespace: { NAMESPACE }
  annotations:
    tekton.dev/git-0: https://www.gitlab.com
type: kubernetes.io/basic-auth
stringData:
  username: { USER_NAME }
  password: { PERSONAL_ACCESS_TOKEN }
```

### Catalog

* 於專案下建一目錄 **catalog**，並新增 **catalog-info.yaml**

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: { SERVICE-NAME }
  namespace: { NAMESPACE }
  annotations:
    'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of={SERVICE-NAME}'
spec:
  type: web
  lifecycle: experimental
  owner: default-team
```

*

# 問題排除

* **Multi-cluster** 環境下， `TAP v1.3`仍需要手動分配`Deliverable` **resource**
  ，請參閱[Get started with multicluster Tanzu Application Platform](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-multicluster-getting-started.html)
*

# 參考

* [Multicluster Tanzu Application Platform overview](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-multicluster-about.html)
* [Getting Started With Tilt](https://docs.tilt.dev/)
* [Create a workload](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-cli-plugins-apps-create-workload.html)
* [Set up developer namespaces to use installed packages](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-set-up-namespaces.html)
* [Application Live view](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-app-live-view-about-app-live-view.html)

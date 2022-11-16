$NAMESPACE = "test"
$API_VERSION = "v1"
$APPNAME = "validation"
$NAME = "$APPNAME-$API_VERSION"
$PORT = 80

$IMAGE_SERVER = "harbor.metaage.tech/test/validation"
$VERSION = "1.0"
$IMAGE = "$IMAGE_SERVER`:$VERSION"

mvn clean package spring-boot:repackage

docker rmi $IMAGE
docker build -t $IMAGE .
docker push $IMAGE

$template = Get-Content 'template.yaml' -Raw
Invoke-Expression "@`"`r`n$template`r`n`"@" | Out-File -FilePath deploy.yaml

kubectl apply -f deploy.yaml

Remove-Item deploy.yaml
#!/bin/bash
# Sai imediatamente se um comando sai com um status não-zero.
set -e

# Importação da função utilitária isNotNull.
source util/is-not-null.sh

# Validação dos dados obrigatórios.
isNotNull dominio
isNotNull subdominio

# Definição do diretório compartilhado, caso não definido previamente.
if test -z "$diretotioCompartilhado"
then
  diretorioCompartilhado="$HOME/.local/share/k3d"
fi

mkdir --parents "$diretorioCompartilhado"

chavePrivadaACRaiz="$diretorioCertificados/ac.$dominio.key"
certificadoACRaiz="$diretorioCertificados/ac.$dominio.crt"
if [ ! -f "$certificadoACRaiz" ]
then
  isNotNull organizacao
  echo "Emissão do certificado SSL da AC Raiz $organizacao."
  if [ -z "$nomeComumOrganizacao" ]
  then
    nomeComumOrganizacao="AC Raiz $organizacao"
  fi
  openssl genrsa -out "$chavePrivadaACRaiz" 2048
  openssl req -new -x509 -days 365 -key "$chavePrivadaACRaiz" -subj "/C=BR/ST=RJ/L=Rio de Janeiro/O=$organizacao/CN=$nomeComumOrganizacao" -out "$certificadoACRaiz"
  sudo mkdir --parents /usr/local/share/ca-certificates/$dominio
  sudo cp "$certificadoACRaiz" /usr/local/share/ca-certificates/$dominio/
  sudo update-ca-certificates
  echo "O certificado da $nomeComumOrganizacao foi emitido com sucesso."
fi

subdominioComHifenSemPonto=$(echo -n $subdominio | sed --expression 's/\./\-/g')
chavePrivadaSubdominio="$diretorioCertificados/$subdominio.$dominio.key"
requisicaoAssinaturaCertificadoSubdominio="$diretorioCertificados/$subdominio.$dominio.csr"
certificadoSubdominio="$diretorioCertificados/$subdominio.$dominio.crt"
if [ ! -f "$certificadoSubdominio" ]
then
  isNotNull organizacao
  isNotNull unidadeOrganizacional

  if [ -z "$nomeComumUnidadeOrganizacional" ]
  then
    nomeComumUnidadeOrganizacional="AC $unidadeOrganizacional"
  fi
  echo "Criação da chave privada e emissão do certificado SSL da unidade organizacional."
  openssl req -newkey rsa:2048 -nodes -keyout "$chavePrivadaSubdominio" -subj "/C=BR/ST=RJ/L=Rio de Janeiro/O=$organizacao/OU=$unidadeOrganizacional/CN=$nomeComumUnidadeOrganizacional" -out "$requisicaoAssinaturaCertificadoSubdominio"
  openssl x509 -req -extfile <(printf "subjectKeyIdentifier = hash\nauthorityKeyIdentifier = keyid:always,issuer\nbasicConstraints = critical, CA:true, pathlen:0\nkeyUsage = critical, digitalSignature, cRLSign, keyCertSign\nsubjectAltName=DNS:$subdominio.$dominio,DNS:*.$subdominio.$dominio") -days 365 -CA "$certificadoACRaiz" -CAkey "$chavePrivadaACRaiz" -CAcreateserial -in "$requisicaoAssinaturaCertificadoSubdominio" -out "$certificadoSubdominio"
  echo "A chave privada e o certificado SSL da unidade organizacional, $nomeComumUnidadeOrganizacional, foi emitido com sucesso."
fi
echo "Criação do cluster Kubernetes intitulado $subdominioComHifenSemPonto."
k3d cluster create $subdominioComHifenSemPonto \
  --servers=3 \
  --port=80:80@loadbalancer \
  --port=443:443@loadbalancer \
  --image=rancher/k3s:v1.28.14-k3s1 \
  --k3s-arg="--disable=traefik@all:*" \
  --volume="$certificadoACRaiz:/etc/ssl/certs/ac.$dominio.pem@server:*;agent:*" \
  --volume="$diretorioCompartilhado:/hostPath@server:*;agent:*"
echo "O cluster $subdominio foi criado com sucesso."
echo "Instalação do controlador de entrada HTTP e HTTPS (Nginx Ingress Controller)."
cat << EOF > /tmp/ingress-nginx.yaml
controller:
  config:
    allow-snippet-annotations: true
  ingressClassResource:
    default: true
EOF
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --version=4.9.0 --namespace=ingress-nginx --create-namespace --values=/tmp/ingress-nginx.yaml
rm /tmp/ingress-nginx.yaml
echo "O Nginx Ingress Controller foi implantado com sucesso."
# Definição do cluster como cliente do serviço DNS.
isNotNull ipServidorNomes

echo "Configuração do cluster como cliente do serviço DNS."
cat << EOF | kubectl apply --namespace=kube-system --filename -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
data:
  $dominio.server: |
    $dominio:53 {
      errors
      cache 30
      forward . $ipServidorNomes
    }
EOF
echo "Configuração bem-sucedida do cliente do serviço DNS."
echo "Implantação do serviço de emissão de certificados SSL (CertManager)."
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace=cert-manager --create-namespace --set=crds.enabled=true
kubectl create secret tls chaves-ac-$subdominioComHifenSemPonto --namespace=cert-manager --cert="$certificadoSubdominio" --key="$chavePrivadaSubdominio"
cat << EOF | kubectl apply --namespace=cert-manager --filename -
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: emissor-ac-$subdominioComHifenSemPonto
  namespace: cert-manager
spec:
  ca:
    secretName: chaves-ac-$subdominioComHifenSemPonto
EOF
echo "O CertManager foi implantado com sucesso."
# Ajustar a implantação do MailHog.
echo "Implantação do serviço SMTP (MailHog)."
cat << EOF | kubectl apply --namespace=mailhog --filename -
---
apiVersion: v1
kind: Namespace
metadata:
  name: mailhog
spec:
  finalizers:
  - kubernetes
---
apiVersion: v1
kind: Secret
metadata:
  name: mailhog
type: Opaque
stringData:
  auth-file: |
    admin:\$2a\$04\$jJCi8GlkvkBIQCDXDzcuCuHOMrbtsX0JwVF3Gj6ItvR9tM0gVw04.
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mailhog
  name: mailhog
spec:
  selector:
    matchLabels:
      app: mailhog
  template:
    metadata:
      labels:
        app: mailhog
    spec:
      containers:
      - name: mailhog
        image: mailhog/mailhog:v1.0.1
        command:
        - MailHog
        args:
        - -auth-file=/mnt/mailhog/auth-file
        resources:
          limits:
            cpu: 10m
            memory: 16Mi
        volumeMounts:
        - name: mailhog
          mountPath: /mnt/mailhog
          readOnly: false
      volumes:
      - name: mailhog
        secret:
          secretName: mailhog
          items:
          - key: auth-file
            path: auth-file
          defaultMode: 0444
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: mailhog
  name: mailhog
spec:
  ports:
  - name: smtp
    port: 25
    protocol: TCP
    targetPort: 1025
  - name: http
    port: 80
    protocol: TCP
    targetPort: 8025
  selector:
    app: mailhog
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: emissor-ac-$subdominioComHifenSemPonto
  name: mailhog
spec:
  ingressClassName: nginx
  rules:
  - host: mailhog.$subdominio.$dominio
    http:
      paths:
      - backend:
          service:
            name: mailhog
            port:
              name: http
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - mailhog.$subdominio.$dominio
    secretName: mailhog-tls
---
EOF
echo "O MailHog foi implantado com sucesso."
echo "Implantação dos serviços de monitoramento do cluster."
cat << EOF > /tmp/loki-stack.yaml
grafana:
  ingress:
    annotations:
      cert-manager.io/cluster-issuer: emissor-ac-$subdominioComHifenSemPonto
    enabled: true
    hosts:
    - grafana.${subdominio}.${dominio}
    path: /
    pathType: Prefix
    tls:
    - hosts:
      - grafana.$subdominio.$dominio
      secretName: grafana-tls-secret
prometheus:
  enabled: true
EOF
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki-stack grafana/loki-stack --namespace=monitoring --create-namespace --values=/tmp/loki-stack.yaml
rm /tmp/loki-stack.yaml
# TODO: Importar os painéis para o Grafana.
# https://grafana.com/grafana/dashboards/12019-loki-dashboard-quick-search/
# https://grafana.com/grafana/dashboards/1860-node-exporter-full/
# https://grafana.com/grafana/dashboards/13639-logs-app/
# Implantação do Harbor.
# https://artifacthub.io/packages/helm/harbor/harbor
# https://docs.docker.com/engine/security/certificates/
cat << EOF > /tmp/harbor-values.yaml
expose:
  # Set how to expose the service. Set the type as "ingress", "clusterIP", "nodePort" or "loadBalancer"
  # and fill the information in the corresponding section
  type: ingress
  tls:
    # Enable TLS or not.
    # Delete the "ssl-redirect" annotations in "expose.ingress.annotations" when TLS is disabled and "expose.type" is "ingress"
    # Note: if the "expose.type" is "ingress" and TLS is disabled,
    # the port must be included in the command when pulling/pushing images.
    # Refer to https://github.com/goharbor/harbor/issues/5291 for details.
    enabled: true
    # The source of the tls certificate. Set as "auto", "secret"
    # or "none" and fill the information in the corresponding section
    # 1) auto: generate the tls certificate automatically
    # 2) secret: read the tls certificate from the specified secret.
    # The tls certificate can be generated manually or by cert manager
    # 3) none: configure no tls certificate for the ingress. If the default
    # tls certificate is configured in the ingress controller, choose this option
    certSource: secret
    secret:
      secretName: harbor-tls
  ingress:
    hosts:
      core: harbor.${subdominio}.${dominio}
    className: nginx
    annotations:
      # note different ingress controllers may require a different ssl-redirect annotation
      # for Envoy, use ingress.kubernetes.io/force-ssl-redirect: "true" and remove the nginx lines below
      ingress.kubernetes.io/ssl-redirect: "true"
      ingress.kubernetes.io/proxy-body-size: "0"
      nginx.ingress.kubernetes.io/ssl-redirect: "true"
      nginx.ingress.kubernetes.io/proxy-body-size: "0"
      cert-manager.io/cluster-issuer: emissor-ac-$subdominioComHifenSemPonto
externalURL: https://harbor.${subdominio}.${dominio}
harborAdminPassword: password
EOF
helm repo add harbor https://helm.goharbor.io
helm install harbor harbor/harbor --namespace=harbor --create-namespace --version=1.14.0 --values=/tmp/harbor-values.yaml
rm /tmp/harbor-values.yaml

echo "Os serviços de monitoramento do cluster foram implantados com sucesso."
echo "Implantação do serviço controlador de Sealed Secrets."
helm repo add bitnami-labs https://bitnami-labs.github.io/sealed-secrets/
helm install sealed-secrets bitnami-labs/sealed-secrets --namespace=security --create-namespace --version 2.15.0
echo "O serviço controlador de Sealed Secrets foi implantado com sucesso."
# DISPONIBILIZAR STORAGE CLASS VIA NFS V4 NO LXC. Ref. RNP2021-108032.
# https://help.ubuntu.com/community/NFSv4Howto#NFSv4_Server
# https://gitlab.rnp.br/fsen/documentacao/-/blob/main/instalacao-do-nfs-v4.md
# CONSIDERAR DOMÍNIOS NIP.IO (https://nip.io/)
# https://keda.sh/
# https://kyverno.io/
# https://www.fairwinds.com/
# https://trivy.dev/
# https://medium.com/@petr.ruzicka/trivy-operator-dashboard-in-grafana-3d9cc733e6ab
# https://sentry.io/welcome/
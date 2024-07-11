# Calo
A configuração do ambiente local de desenvolvimento, por vezes, é um "calo no pé". Então, este repositório tem o propósito de facilitar essa configuração, instalando os softwares utilizados nesse ambiente.

## O que é que o Calo tem?
O ambiente local de desenvolvimento configurado pelo Calo possui os seguintes softwares:
- Bind9, o servidor de nomes (DNS), que resolve os nomes de domínio locais e repassa as consultas dos demais nomes ao Cloudflare, ao Google Public DNS ou ao Quad9;
- Discord;
- Draw.io;
- Mozilla Firefox;
- Git;
- SDKMAN;
- OpenJDK;
- NVM;
- NodeJS;
- PWgen.io (Password Generator);
- Trivy, o escâner de segurança;
- CLI processador de:
  - JSON;
  - YAML.
- IDE:
  - Android Studio;
  - IntelliJ;
  - VS Code.
- Utilitários de provedores de nuvem:
  - AWS CLI;
  - CLI do Goocle Cloud e o plugin de autenticação do GKE.
- Utilitários de bancos de dados:
  - DBeaver;
  - Clientes do PostgreSQL (psql, pg_dump, pg_restore etc.);
  - PostgreSQL Database Modeler (pgModeler).
- Utilitários de redes:
  - FortiClient, o agente de VNP;
  - Net Tools.
- Utilitários do Kubernetes:
  - Helm;
  - Lens Desktop;
  - K3D;
  - Kubectl;
  - Kubeseal.
- Utilitários do PHP:
  - CLI;
  - PEAR.
- Virtualizadores:
  - Docker;
  - LXD;
  - Virtual Machine Manager (QEMU, KVM etc).
- Cluster Kubernetes com as seguintes características:
  - Baseado no Docker, executado em contêineres;
  - Cliente do Bind9 (servidor de nomes);
  - Aplicações implantações:
    - Nginx Ingress Controller, o controlador de entrada HTTP e HTTPS;
    - CertManager, o emissor de certificados SSL;
    - MailHog, o serviço SMTP;
    - Prometheus, o kit de ferramentas de monitoramento e alerta;
    - Loki-Stack (Loki, Grafana e Promtail), a solução de centralização de logs e métricas e de construção e visualização de painéis gráficos;
    - Harbor, o repositório de imagens Docker.

## Requisitos
Os atuais requisitos para a execução do Calo são:
- sistema operacional: Linux;
- distribuição: Ubuntu;
- versão: 24.04 LTS (Noble Numbat).

## Como usar?
O arquivo executável `setup.sh` é o ponto de entrada da configuração do ambiente local de desenvolvimento. A execução desse arquivo é demonstrada abaixo:
```bash
dominio=exemplo subdominio=nuvem ./setup.sh
```
A execução do `setup.sh` pode ser feita a partir do diretório de checkout do Calo ou, preferencialmente, do diretório específico para manter os arquivos dos certificados SSL, criados durante a configuração.
As definições dos valores das variáveis dominio e subdominio são obrigatórias. Esses valores são necessários para a configuração do servidor de nomes, a criação dos certificados SSL etc.

# Helm Charts

A collection of Helm charts I wrote because I could not find reliable, production-ready versions on Artifacthub or elsewhere. Each chart is built from scratch, tested on real Kubernetes clusters, and maintained with the same standards I apply to production workloads.

If you are looking for charts that just work without heavy customization, these might save you time.

## Charts

| Chart | Description | App Version |
|-------|-------------|-------------|
| [itop](./charts/itop) | IT service management platform (ITSM) by Combodo | 3.2 |
| [request-tracker](./charts/request-tracker) | Issue tracking system with workflow automation and email integration | 5.0.8 |
| [postal](./charts/postal) | Open-source mail server with SMTP/HTTP APIs | 3.3.4 |
| [novu](./charts/novu) | Notification infrastructure for multi-channel notifications | 2.3.0 |

## Usage
```bash
helm repo add sowabdoul https://sowabdoul.github.io/helm-charts
helm repo update
helm install my-release sowabdoul/<chart-name> -f my-values.yaml
```

## Local install
```bash
git clone https://github.com/sowabdoul/helm-charts.git
cd helm-charts
helm dependency build charts/<chart-name>
helm install my-release ./charts/<chart-name> -f my-values.yaml
```

## Maintainer

[Abdoulaye Sow](https://github.com/sowabdoul)


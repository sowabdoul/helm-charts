{{/*
Expand the name of the chart.
*/}}
{{- define "itop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "itop.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "itop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "itop.labels" -}}
helm.sh/chart: {{ include "itop.chart" . }}
{{ include "itop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "itop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "itop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "itop.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "itop.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the docker image registry to use
*/}}
{{- define "itop.imageRegistry" -}}
{{- if .Values.global.image.registry }}
{{- .Values.global.image.registry }}
{{- else }}
{{- .Values.image.registry }}
{{- end }}
{{- end -}}

{{/*
Return the data storage class name to use
*/}}
{{- define "itop.data.storageClass" -}}
{{- default .Values.global.storageClass .Values.persistence.data.storageClass }}
{{- end -}}

{{/*
Create the docker config secret to use
*/}}
{{- define "itop.dockerConfigSecret" -}}
{{- with .Values.image.auth.enabled | ternary .Values.image .Values.global.image }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .auth.username .auth.password (printf "%s:%s" .auth.username .auth.password | b64enc) | b64enc }}
{{- end }}
{{- end }}

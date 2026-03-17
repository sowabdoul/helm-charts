{{/*
Expand the name of the chart.
*/}}
{{- define "request-tracker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "request-tracker.fullname" -}}
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
{{- define "request-tracker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "request-tracker.labels" -}}
helm.sh/chart: {{ include "request-tracker.chart" . }}
{{ include "request-tracker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "request-tracker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "request-tracker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "request-tracker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "request-tracker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "request-tracker.secretName" -}}
{{- printf "%s-secret" (include "request-tracker.fullname" .) }}
{{- end }}

{{/*
Get the database host
*/}}
{{- define "request-tracker.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
  {{- if .Values.postgresql.fullnameOverride }}
    {{- .Values.postgresql.fullnameOverride }}
  {{- else }}
    {{- include "request-tracker.fullname" . }}
  {{- end }}
{{- else }}
  {{- .Values.rt.database.host }}
{{- end }}
{{- end }}

{{/*
Get database password
*/}}
{{- define "request-tracker.databasePassword" -}}
{{- if .Values.rt.database.password }}
{{- .Values.rt.database.password }}
{{- else if .Values.postgresql.enabled }}
{{- .Values.postgresql.auth.password }}
{{- else }}
{{- required "Database password is required when using external database" .Values.rt.database.password }}
{{- end }}
{{- end }}

{{/*
Get SMTP from address
*/}}
{{- define "request-tracker.smtpFrom" -}}
{{- if .Values.rt.smtp.from }}
{{- .Values.rt.smtp.from }}
{{- else }}
{{- printf "rt@%s" .Values.rt.domain }}
{{- end }}
{{- end }}

{{/*
Get SMTP user
*/}}
{{- define "request-tracker.smtpUser" -}}
{{- if .Values.rt.smtp.user }}
{{- .Values.rt.smtp.user }}
{{- else }}
{{- include "request-tracker.smtpFrom" . }}
{{- end }}
{{- end }}

{{/*
Get GetMail username
*/}}
{{- define "request-tracker.getmailUsername" -}}
{{- if .Values.rt.getmail.username }}
{{- .Values.rt.getmail.username }}
{{- else }}
{{- include "request-tracker.smtpFrom" . }}
{{- end }}
{{- end }}

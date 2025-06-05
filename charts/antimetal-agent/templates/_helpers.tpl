{{/*
Expand the name of the chart.
*/}}
{{- define "antimetal-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "antimetal-agent.fullname" -}}
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
{{- define "antimetal-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "antimetal-agent.labels" -}}
helm.sh/chart: {{ include "antimetal-agent.chart" . }}
{{ include "antimetal-agent.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "antimetal-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "antimetal-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "antimetal-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "antimetal-agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret name containing API key
*/}}
{{- define "antimetal-agent.apiKeySecretName" -}}
{{- if .Values.apiKey }}
{{- printf "%s-api-key" (include "antimetal-agent.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- required "Must set either apiKey or apiKeySecretRef" .Values.apiKeySecretRef | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Metrics server port
*/}}
{{- define "antimetal-agent.metricsServerPort" -}}
{{- default false .Values.metrics.secure | ternary "8443" "8080" }}
{{- end }}

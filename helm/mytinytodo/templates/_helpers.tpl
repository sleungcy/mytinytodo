{{/*
Expand the name of the chart.
*/}}
{{- define "mytinytodo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mytinytodo.fullname" -}}
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
{{- define "mytinytodo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mytinytodo.labels" -}}
helm.sh/chart: {{ include "mytinytodo.chart" . }}
{{ include "mytinytodo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mytinytodo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mytinytodo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mytinytodo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mytinytodo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create PostgreSQL host
*/}}
{{- define "mytinytodo.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" (include "mytinytodo.fullname" .) -}}
{{- else -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL port
*/}}
{{- define "mytinytodo.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
5432
{{- else -}}
{{- .Values.externalDatabase.port -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL database name
*/}}
{{- define "mytinytodo.postgresql.database" -}}
{{- if .Values.postgresql.enabled -}}
{{- .Values.postgresql.auth.database -}}
{{- else -}}
{{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL username
*/}}
{{- define "mytinytodo.postgresql.username" -}}
{{- if .Values.postgresql.enabled -}}
{{- .Values.postgresql.auth.username -}}
{{- else -}}
{{- .Values.externalDatabase.username -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL secret name
*/}}
{{- define "mytinytodo.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" (include "mytinytodo.fullname" .) -}}
{{- else -}}
{{- if .Values.externalDatabase.existingSecret -}}
{{- .Values.externalDatabase.existingSecret -}}
{{- else -}}
{{- printf "%s-postgresql" (include "mytinytodo.fullname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL secret key
*/}}
{{- define "mytinytodo.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
postgres-password
{{- else -}}
{{- if .Values.externalDatabase.existingSecret -}}
{{- .Values.externalDatabase.existingSecretPasswordKey -}}
{{- else -}}
postgresql-password
{{- end -}}
{{- end -}}
{{- end -}}
{{/* 
Generate a name for the resource based on the release name and chart name 
*/}}
{{- define "taskmanager.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* 
Generate a name for the resource based on the release name, chart name and the application name 
*/}}
{{- define "taskmanager.fullnameApp" -}}
{{- $appName := index . 0 -}}
{{- $root := index . 1 -}}
{{- if $root.Values.fullnameOverride -}}
{{- $root.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default $root.Chart.Name $root.Values.nameOverride -}}
{{- if contains $name $root.Release.Name -}}
{{- printf "%s-%s" $root.Release.Name $appName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" $root.Release.Name $name $appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* 
Generate standard labels for the resource
*/}}
{{- define "taskmanager.labels" -}}
helm.sh/chart: {{ include "taskmanager.chart" . }}
{{ include "taskmanager.selectorLabels" . }}
{{- end -}}

{{/* 
Generate selector labels for the resource
*/}}
{{- define "taskmanager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "taskmanager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* 
Generate the chart name with version 
*/}}
{{- define "taskmanager.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/* 
Generate the application name 
*/}}
{{- define "taskmanager.name" -}}
{{- if .Values.nameOverride -}}
{{- .Values.nameOverride -}}
{{- else -}}
{{- .Chart.Name -}}
{{- end -}}
{{- end -}}

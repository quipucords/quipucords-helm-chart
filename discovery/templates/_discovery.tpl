{{/*
Define the global Service Account name to use for Discovery and its subcharts.
*/}}
{{- define "discovery.globalServiceAccountName" -}}
{{- printf "%s-sa" .Release.Name }}
{{- end }}

{{/*
Define the full name of the discovery server
*/}}
{{- define "discovery.serverFullname" -}}
{{- printf "%s-server" .Release.Name }}
{{- end }}

{{/*
Define the cluster local fully qualified host for the database
*/}}
{{- define "discovery.db-host" -}}
{{ printf "%s-db.%s.svc.cluster.local" (.Release.Name) (.Release.Namespace) }}
{{- end }}

{{/*
Define the cluster local fully qualified host for redis
*/}}
{{- define "discovery.redis-host" -}}
{{ printf "%s-redis.%s.svc.cluster.local" (.Release.Name) (.Release.Namespace) }}
{{- end }}

{{/*
Define the boolean to tell us if we're targetting OpenShift
*/}}
{{- define "discovery.isOpenShift" -}}
{{- if .Capabilities.APIVersions.Has "route.openshift.io/v1" -}}
{{ printf "true" }}
{{- else -}}
{{ printf "false" }}
{{- end }}
{{- end }}

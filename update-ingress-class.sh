#!/bin/bash

# Script to update ingress class from legacy to modern format using yq
# Updates kubernetes.io/ingress.class: nginx to ingressClassName: nginx

set -e

echo "Updating ingress class annotations from legacy to modern format using yq..."

# List of ingress files to update
INGRESS_FILES=(
    "autobrr/ingress.yaml"
    "bazarr/ingress.yaml"
    "channels/ingress.yaml"
    "changedetection/ingress.yaml"
    "cross-seed/ingress.yaml"
    "grafana/ingress.yaml"
    "hass/ingress.yaml"
    "meshcentral/ingress.yaml"
    "netatmo-exporter/ingress.yaml"
    "pihole/ingress.yaml"
    "plexmediaserver/ingress.yaml"
    "prometheus/ingress.yaml"
    "prowlarr/ingress.yaml"
    "pushgateway/ingress.yaml"
    "qbittorrent/ingress.yaml"
    "radarr/ingress.yaml"
    "sabnzbd/ingress.yaml"
    "smokeping/ingress.yaml"
    "sonarr/ingress.yaml"
    "tautulli/ingress.yaml"
    "transmission/ingress.yaml"
)

# Update each file
for file in "${INGRESS_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Updating $file..."

        # Use yq to:
        # 1. Remove the legacy annotation
        # 2. Add the modern ingressClassName to spec
        yq eval '
            del(.metadata.annotations."kubernetes.io/ingress.class") |
            .spec.ingressClassName = "nginx"
        ' -i "$file"

        echo "✅ Updated $file"
    else
        echo "⚠️  File not found: $file"
    fi
done

echo ""
echo "✅ All ingress files updated!"
echo ""
echo "Changes made:"
echo "- Removed: kubernetes.io/ingress.class: nginx"
echo "- Added: ingressClassName: nginx (in spec section)"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff"
echo "2. Test the changes: kubectl apply --dry-run=client -f ."
echo "3. Commit the changes: git add . && git commit -m 'Update ingress class to modern format'"

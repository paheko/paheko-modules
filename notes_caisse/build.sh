#!/bin/bash
# Build script for notes_caisse module deployment

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$MODULE_DIR")"
BUILD_DIR="$PROJECT_ROOT/_pkg"
OUTPUT_ZIP="$PROJECT_ROOT/notes_caisse-paheko-cloud.zip"

# Clean and prepare build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/modules"

# Copy module (exclude build.sh from deployment)
cp -R "$MODULE_DIR" "$BUILD_DIR/modules/"
rm -f "$BUILD_DIR/modules/notes_caisse/build.sh"

# Create ZIP
cd "$BUILD_DIR"
rm -f "$OUTPUT_ZIP"
zip -r "$OUTPUT_ZIP" modules > /dev/null 2>&1

# Show result
if [ -f "$OUTPUT_ZIP" ]; then
	SIZE=$(ls -lh "$OUTPUT_ZIP" | awk '{print $5}')
	echo "✅ Archive créée: $OUTPUT_ZIP ($SIZE)"
else
	echo "❌ Erreur lors de la création de l'archive"
	exit 1
fi

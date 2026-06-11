#!/usr/bin/env bash
# SAOS Plymouth Theme — Logo Generator
# Creates a simple text-based SAOS logo as PNG

# This is a template — in a real build, use ImageMagick or similar:
# convert -background '#000000' -fill '#00ff41' \
#   -pointsize 48 -font "JetBrains-Mono-Bold" \
#   label:"S A O S" \
#   -border 4 -bordercolor '#003311' \
#   logo.png

echo "Plymouth logo asset needed at: splash/saos-plymouth/assets/logo.png"
echo "Create a 200x100px PNG with:"
echo "  Background: #000000"
echo "  Text: 'S A O S' in JetBrains Mono Bold, #00ff41"
echo "  Border: 1px #00ff41"

#!/bin/bash

MY_DIR="/usr/share/neural-style/"
SCRIPT="${MY_DIR}/neural_style.lua"

function printUsage() {
	local STYLE="${MY_DIR}/examples/inputs/picasso_selfport1907.jpg"
	local CONTENT="${MY_DIR}/examples/inputs/brad_pitt.jpg"
	local OUTPUT="~/profile.png"
	echo "Usage: neural-style.cpu.sh <style-image> <content-image> <output-image>"
	echo ""
	echo "e.g., neural-style.cpu.sh '${STYLE}' '${CONTENT}' '${OUTPUT}'"
}



#echo ""
#/usr/bin/th "${SCRIPT}" -gpu -1 -print_iter 1
#local STYLE="${MY_DIR}/examples/inputs/picasso_selfport1907.jpg"
#local CONTENT="${MY_DIR}/examples/inputs/brad_pitt.jpg"
#local OUTPUT="~/profile.png"

/usr/bin/th "${SCRIPT}" -gpu -1 -style_image "${STYLE}" -content_image "${CONTENT}" -output_image profile.png -model_file models/nin_imagenet_conv.caffemodel -proto_file models/train_val.prototxt -gpu 0 -backend clnn -num_iterations 1000 -seed 123 -content_layers relu0,relu3,relu7,relu12 -style_layers relu0,relu3,relu7,relu12 -content_weight 10 -style_weight 1000 -image_size 512 -optimizer adam

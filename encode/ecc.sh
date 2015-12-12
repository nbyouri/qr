# Récupère l'error correction code depuis thonky.com
#!/bin/sh

first=`echo $1|fgrep -v '\['`;
last=`echo $9|fgrep -v '\]'`;
html=`curl -s "http://www.thonky.com/qr-code-tutorial/show-division-steps?msg_coeff=$first%2C$2%2C$3%2C$4%2C$5%2C$6%2C$7%2C$8%2C$last&num_ecc_blocks=9"| fgrep "correction codewords to use for the original message polynomial:"`;

echo $html | awk -F'\<p\>' '{ gsub(/\&nbsp\;/, ""); print $9 }' | grep -o '[0-9]\+';

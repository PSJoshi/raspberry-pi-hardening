#!/bin/sh

# Ref - https://tldp.org/LDP/abs/html/here-docs.html#FTN.AEN17822
# Google shell guide - https://google.github.io/styleguide/shellguide.html

greeting="What's up there?"

# Notice that `EOF` is not quoted
cat << EOF
    No quotes means there is var substitution: 
        $greeting
EOF

cat << "EOF"
    
    ------
    "EOF" means no var subtitution
    
        $greeting
EOF


cat << 'EOF'
    
    ------
    'EOF' means no var subtitution
    
        $greeting
EOF

#!/bin/bash
read -d '' content <<EOF
$(date)
README:
https://raw.githubusercontent.com/yxing-xyz/data/main/README.md

userdata:
https://raw.githubusercontent.com/yxing-xyz/data/main/userdata.7z
EOF
echo "$content" >./url.txt
echo >>./url.txt
tee >>./url.txt <<EOF
docker run -dit --name dev --hostname dev --restart always --privileged --pull always \\
    --platform linux/amd64 -p 2222:22 \\
    -v /data:/data \\
    ccr.ccs.tencentyun.com/yxing-xyz/linux:ubuntu-devel
EOF
echo >>./url.txt

RepoLatestRelease() {
    owner=$1
    repo=$2
    list=$(curl -s https://api.github.com/repos/${owner}/${repo}/releases/latest | grep browser_download_url)
    array=($(echo "$list" | grep -Eo "\"https://.+\""))
    echo "$repo:" >>./url.txt
    for element in ${array[@]}; do
        element=${element:1}
        element=${element%?}
        echo "https://gh-proxy.com/$element" >>./url.txt
    done
    echo >>./url.txt
    echo >>./url.txt
}

RepoLatestRelease trzsz trzsz-go
RepoLatestRelease derailed k9s
RepoLatestRelease jesseduffield lazygit
RepoLatestRelease jesseduffield lazydocker
RepoLatestRelease tsenart vegeta
RepoLatestRelease FiloSottile mkcert
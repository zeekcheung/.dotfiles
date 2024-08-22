function proxy-on
    set -gx http_proxy "http://127.0.0.1:20171"
    set -gx https_proxy "http://127.0.0.1:20171"
    set -gx all_proxy "socks5://127.0.0.1:20170"
    set -gx no_proxy "127.0.0.1"

    git config --global http.proxy "http://127.0.0.1:20171"
    git config --global https.proxy "http://127.0.0.1:20171"
end

function proxy-off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy

    git config --global --unset http.proxy
    git config --global --unset https.proxy
end

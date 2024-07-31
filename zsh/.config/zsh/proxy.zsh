function proxy-on() {
  export http_proxy="http://127.0.0.1:20171"
  export https_proxy="http://127.0.0.1:20171"
  export all_proxy="socks5://127.0.0.1:20170"
  export no_proxy="127.0.0.1"
}

function proxy-off() {
  unset http_proxy
  unset https_proxy
  unset all_proxy
}

# proxy-on

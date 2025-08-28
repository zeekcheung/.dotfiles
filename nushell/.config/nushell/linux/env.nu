$env.XDG_CONFIG_HOME = $"($env.HOMEPATH)/.config"
$env.XDG_CACHE_HOME = $"(env.HOMEPATH)/.cache"
$env.XDG_DATA_HOME = $"(env.HOMEPATH)/.local/share"
$env.XDG_STATE_HOME = $"(env.HOMEPATH)/.local/state"

$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.MANPAGER = "nvim +Man!"
$env.MANROFFOPT = "-c"

$env.GOPATH = $"($env.HOMEPATH)/go"
$env.CARGO_HOME =  $"($env.HOMEPATH)/.cargo"
$env.RUSTUP_HOME = $"($env.HOMEPATH)/.rustup"
$env.RUSTUP_HOME = $"($env.HOMEPATH)/.rustup"
$env.PNPM_HOME =  $"($env.HOMEPATH)/.pnpm"
$env.DENO_INSTALL_ROOT = $"($env.HOMEPATH)/.deno/bin"
$env.PIPX_BIN_DIR = $"($env.HOMEPATH)/.pipx/bin"
$env.FNM_PATH = $"($env.XDG_DATA_HOME)/fnm"

$env.PATH = [ ($env.PIPX_BIN_DIR) ] ++ $env.PATH
$env.PATH = [ ($env.DENO_INSTALL_ROOT) ] ++ $env.PATH
$env.PATH = [ ($env.PNPM_HOME) ] ++ $env.PATH
$env.PATH = [ $"($env.CARGO_HOME)/bin" ] ++ $env.PATH
$env.PATH = [ $"($env.GOPATH)/bin" ] ++ $env.PATH
$env.PATH = [ $"($env.HOMEPATH)/.local/bin" ] ++ $env.PATH

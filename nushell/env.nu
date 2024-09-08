# Nushell Environment Config File


def create_left_prompt [] {
    let home =  $nu.home-path

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}
# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

$env.OPAM_SWITCH_PREFIX = "/home/jakob/.opam/default"
# $env.OPAM_SWITCH_PREFIX = "/home/jakob/.opam/4.14.1-jst"
# $env.OPAM_SWITCH_PREFIX = "/home/jakob/.opam/4.11.2+flambda/"

$env.CAML_LD_LIBRARY_PATH = $env.OPAM_SWITCH_PREFIX ++ "/lib/stublibs:/usr/lib64/ocaml/stublibs:/usr/lib64/ocaml"
$env.OCAML_TOPLEVEL_PATH = $env.OPAM_SWITCH_PREFIX ++ "/lib/toplevel"
$env.PKG_CONFIG_PATH = $env.OPAM_SWITCH_PREFIX ++ "/lib/pkgconfig"
$env.MANPATH = $env.OPAM_SWITCH_PREFIX ++ "/man"

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
$env.PATH = ($env.PATH | split row (char esep)
    | prepend "/home/linuxbrew/.linuxbrew/bin"
    | prepend "/home/jakob/.local/bin"
    | prepend "/home/jakob/.cargo/bin"
    | prepend ($env.OPAM_SWITCH_PREFIX ++ "/bin")
    | prepend "/home/jakob/go/bin"
    | prepend "/home/jakob/.modular/pkg/packages.modular.com_mojo/bin"
)

$env.NODE_ENV = development
$env.EDITOR = nvim


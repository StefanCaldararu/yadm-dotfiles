# Tempus Future theme for the shell: prompt, ls and git colors.
# Works in bash and zsh. Source it from ~/.bashrc or ~/.zshrc:
#   . ~/.config/tempus/shell.sh

. "$HOME/.config/tempus/colors"

# ── Terminal palette ──────────────────────────────────────────────
# Load the tempus hex colors into the terminal's palette with OSC escape
# codes, so everything below (which only names palette slots) looks the
# same on every machine. Works in GNOME Terminal/VTE (Ubuntu), Windows
# Terminal (WSL), iTerm2, kitty, alacritty, WezTerm, xterm, ...
# Terminal.app ignores these: import "Tempus Future.terminal" there instead.
# Skipped inside tmux, as the outer terminal already has the palette.
if [ -t 1 ] && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != Apple_Terminal ]; then
	for _i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
		eval "_hex=\$TEMPUS_HEX_$_i"
		printf '\033]4;%s;%s\033\\' "$_i" "$_hex"
	done
	# Default foreground, background and cursor
	printf '\033]10;%s\033\\' "$TEMPUS_HEX_FG"
	printf '\033]11;%s\033\\' "$TEMPUS_HEX_BG"
	printf '\033]12;%s\033\\' "$TEMPUS_HEX_FG"
	unset _i _hex
fi

# ── Prompt: user@host:dir ─────────────────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
	PROMPT="%B%F{$TEMPUS_GREEN}%n@%m%f:%F{$TEMPUS_BLUE}%~%f%b "
elif [ -n "$BASH_VERSION" ]; then
	PS1="${debian_chroot:+($debian_chroot)}\[\e[1;38;5;${TEMPUS_GREEN}m\]\u@\h\[\e[0m\]:\[\e[1;38;5;${TEMPUS_BLUE}m\]\w\[\e[0m\]\$ "
fi

# ── ls ────────────────────────────────────────────────────────────
# GNU ls (Linux, or gls on macOS)
LS_COLORS="di=1;38;5;${TEMPUS_BLUE}:ln=38;5;${TEMPUS_CYAN}:ex=1;38;5;${TEMPUS_GREEN}"
LS_COLORS="${LS_COLORS}:so=38;5;${TEMPUS_MAGENTA}:pi=38;5;${TEMPUS_YELLOW}"
LS_COLORS="${LS_COLORS}:bd=1;38;5;${TEMPUS_YELLOW}:cd=1;38;5;${TEMPUS_YELLOW}"
LS_COLORS="${LS_COLORS}:or=38;5;${TEMPUS_RED}:mi=38;5;${TEMPUS_RED}"
LS_COLORS="${LS_COLORS}:su=1;38;5;${TEMPUS_RED}:sg=1;38;5;${TEMPUS_RED}"
LS_COLORS="${LS_COLORS}:tw=1;38;5;${TEMPUS_BLUE}:ow=1;38;5;${TEMPUS_BLUE}"
export LS_COLORS

# BSD ls (macOS) only knows the first 8 palette slots, as letters a-h
# (uppercase = bold), in the fixed order: di ln so pi ex bd cd su sg tw ow
_tempus_bsd() {
	_c=$(printf '%s' abcdefgh | cut -c$(($1 + 1)))
	[ "$2" = bold ] && _c=$(printf '%s' "$_c" | tr a-h A-H)
	printf '%sx' "$_c"
}
LSCOLORS=$(_tempus_bsd $TEMPUS_BLUE bold)$(_tempus_bsd $TEMPUS_CYAN)
LSCOLORS=${LSCOLORS}$(_tempus_bsd $TEMPUS_MAGENTA)$(_tempus_bsd $TEMPUS_YELLOW)
LSCOLORS=${LSCOLORS}$(_tempus_bsd $TEMPUS_GREEN bold)
LSCOLORS=${LSCOLORS}$(_tempus_bsd $TEMPUS_YELLOW bold)$(_tempus_bsd $TEMPUS_YELLOW bold)
LSCOLORS=${LSCOLORS}$(_tempus_bsd $TEMPUS_RED bold)$(_tempus_bsd $TEMPUS_RED bold)
LSCOLORS=${LSCOLORS}$(_tempus_bsd $TEMPUS_BLUE bold)$(_tempus_bsd $TEMPUS_BLUE bold)
export LSCOLORS
unset -f _tempus_bsd
unset _c

# Prefer GNU ls everywhere so listings look the same on Linux and macOS
# (brew install coreutils provides gls); fall back to BSD ls with CLICOLOR
export CLICOLOR=1
if command -v gls >/dev/null 2>&1; then
	alias ls='gls --color=auto'
elif ls --color=auto -d . >/dev/null 2>&1; then
	alias ls='ls --color=auto'
fi

# ── git ───────────────────────────────────────────────────────────
# Passed through git's GIT_CONFIG_* environment variables, so git can use
# the colors above without a copy of them in a gitconfig file.
# TEMPUS_GIT_BASE remembers where our entries start, so sourcing this again
# (nested shells, tmux panes) overwrites them instead of piling up.
_tempus_git_n=${TEMPUS_GIT_BASE:-${GIT_CONFIG_COUNT:-0}}
export TEMPUS_GIT_BASE=$_tempus_git_n
_tempus_git() {
	export "GIT_CONFIG_KEY_$_tempus_git_n=$1" "GIT_CONFIG_VALUE_$_tempus_git_n=$2"
	_tempus_git_n=$((_tempus_git_n + 1))
}
_tempus_git color.ui auto
_tempus_git color.diff.meta "$TEMPUS_BLUE bold"
_tempus_git color.diff.frag "$TEMPUS_MAGENTA"
_tempus_git color.diff.func "$TEMPUS_ALT_FG"
_tempus_git color.diff.old "$TEMPUS_RED"
_tempus_git color.diff.new "$TEMPUS_GREEN"
_tempus_git color.diff.commit "$TEMPUS_YELLOW"
_tempus_git color.diff.whitespace "$TEMPUS_RED reverse"
_tempus_git color.status.header "$TEMPUS_ALT_FG"
_tempus_git color.status.branch "$TEMPUS_BLUE bold"
_tempus_git color.status.added "$TEMPUS_GREEN"
_tempus_git color.status.changed "$TEMPUS_RED"
_tempus_git color.status.untracked "$TEMPUS_YELLOW"
_tempus_git color.status.unmerged "$TEMPUS_ORANGE bold"
_tempus_git color.branch.current "$TEMPUS_GREEN bold"
_tempus_git color.branch.local "$TEMPUS_FG"
_tempus_git color.branch.remote "$TEMPUS_CYAN"
_tempus_git color.branch.upstream "$TEMPUS_BLUE"
_tempus_git color.decorate.HEAD "$TEMPUS_CYAN bold"
_tempus_git color.decorate.branch "$TEMPUS_GREEN bold"
_tempus_git color.decorate.remoteBranch "$TEMPUS_RED bold"
_tempus_git color.decorate.tag "$TEMPUS_YELLOW bold"
_tempus_git color.grep.match "$TEMPUS_YELLOW bold"
_tempus_git color.grep.filename "$TEMPUS_MAGENTA"
_tempus_git color.grep.linenumber "$TEMPUS_GREEN"
export GIT_CONFIG_COUNT=$_tempus_git_n
unset -f _tempus_git
unset _tempus_git_n

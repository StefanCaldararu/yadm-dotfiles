# ~/.bash_profile: executed by bash(1) for login shells.
# macOS terminals (and tmux panes on macOS) start login shells, which read
# only this file, so it sets up the environment and then loads ~/.bashrc,
# where all the interactive setup lives. Every block checks that its tool
# exists, so this file is safe on macOS, Ubuntu and WSL alike.

# ── Environment (PATH etc.), before ~/.bashrc needs it ───────────
# Homebrew (macOS)
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Silence macOS /bin/bash's "default shell is now zsh" notice
export BASH_SILENCE_DEPRECATION_WARNING=1

# Java (macOS): pinned to 25; change the -v to switch versions
if [ -x /usr/libexec/java_home ] && JAVA_HOME=$(/usr/libexec/java_home -v 25 2>/dev/null); then
	export JAVA_HOME
	export PATH="$JAVA_HOME/bin:$PATH"
fi

# OpenMP runtime from Homebrew (macOS)
if [ -d /opt/homebrew/opt/libomp/lib ]; then
	export DYLD_LIBRARY_PATH="/opt/homebrew/opt/libomp/lib${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
fi

# ── Interactive setup (prompt, aliases, theme) ────────────────────
[ -r ~/.bashrc ] && . ~/.bashrc

# ── Tool hooks ────────────────────────────────────────────────────
# conda / mamba (miniforge)
if [ -x "$HOME/miniforge3/bin/conda" ]; then
	__conda_setup="$("$HOME/miniforge3/bin/conda" shell.bash hook 2>/dev/null)" && eval "$__conda_setup"
	unset __conda_setup
fi
if [ -x "$HOME/miniforge3/bin/mamba" ]; then
	export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
	export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
	if __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"; then
		eval "$__mamba_setup"
	else
		alias mamba="$MAMBA_EXE"
	fi
	unset __mamba_setup
fi

# SDKMAN: must stay at the end of the file
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"

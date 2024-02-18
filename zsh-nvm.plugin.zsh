#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://z-shell.github.io/zsh-plugin-assessor/Zsh-Plugin-Standard
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ $PMSPEC != *b* ]] {
  PATH=$PATH:"${0:h}/bin"
}

if [[ $PMSPEC != *f* ]] {
  fpath+=( "${0:h}/functions" )
}

ZSH_NVM_DIR=${0:a:h}

[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

autoload -U add-zsh-hook
autoload -Uz \
  @zsh_nvm_auto_use @zsh_nvm_completion          \
  @zsh_nvm_global_binaries @zsh_nvm_has          \
  @zsh_nvm_install @zsh_nvm_install_wrapper      \
  @zsh_nvm_latest_release_tag @zsh_nvm_lazy_load \
  @zsh_nvm_load @zsh_nvm_previous_version        \
  @zsh_nvm_rename_function @zsh_nvm_revert       \
  @zsh_nvm_upgrade

# Don't init anything if this is true (debug/testing only)
if [[ "$ZSH_NVM_NO_LOAD" != true ]]; then

  # Install nvm if it isn't already installed
  [[ ! -f "$NVM_DIR/nvm.sh" ]] && @zsh_nvm_install

  # If nvm is installed
  if [[ -f "$NVM_DIR/nvm.sh" ]]; then

    # Load it
    [[ "$NVM_LAZY_LOAD" == true ]] && @zsh_nvm_lazy_load || @zsh_nvm_load

    # Enable completion
    [[ "$NVM_COMPLETION" == true ]] && @zsh_nvm_completion

    # Auto use nvm on chpwd
    [[ "$NVM_AUTO_USE" == true ]] && add-zsh-hook chpwd @zsh_nvm_auto_use && @zsh_nvm_auto_use
  fi

fi

# Make sure we always return good exit code
# We can't `return 0` because that breaks antigen
true

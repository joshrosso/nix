# All host-specific modification go here
{
  # set terminal background to yellow for hermes
  programs.bash.promptInit = ''
    if [[ -n "$SSH_CONNECTION" ]]; then
      printf '\e]11;rgb:ca/ca/78\a'
    fi
  '';
}

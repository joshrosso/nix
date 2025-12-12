# All host-specific modification go here
{
  # set terminal background to yellow for hermes
  programs.bash.promptInit = ''
    if [[ -n "$SSH_CONNECTION" ]]; then
      printf '\e]11;rgb:ca/ca/78\a'
    fi

    printf '\033]11;rgb:40/35/00\007'
    # Prompt: literal "name @ hermes$ "
    PS1="$(whoami) @ hermes$ "
  '';
}

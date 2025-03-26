#!/bin/bash

curl -sL https://talos.dev/install | sh  > /dev/null

print_INFO "Adding talosctl completion"

print_DEBUG "talosctl completion bash > ~/.bash_completion.d/talosctl"
talosctl completion fish > ~/.config/fish/completions/talosctl.fish

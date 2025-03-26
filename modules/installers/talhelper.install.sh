#!/bin/bash

print_INFO "Installing talhelper"
curl https://i.jpillora.com/budimanjojo/talhelper! | sudo bash | indent


print_INFO "Adding talosctl completion"

print_DEBUG "talosctl completion bash > ~/.bash_completion.d/talosctl"
talhelper completion fish > ~/.config/fish/completions/talhelper.fish

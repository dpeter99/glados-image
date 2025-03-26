#!/bin/bash
# process_modules.sh - Process and execute modules defined in the profile

section "Processing modules"
MODULES=$(yq -r '.modules.enabled[]' "$PROFILE_FILE" 2>/dev/null || echo "")

if [ -n "$MODULES" ]; then
  for module in $MODULES; do
    MODULE_PATH="${CONF_DIR}/modules.d/$module.sh"
    
    # Check if module has a .install.sh extension
    if [[ ! -f "$MODULE_PATH" && "$module" == *".install" ]]; then
      MODULE_PATH="${CONF_DIR}/modules.d/$module.sh"
    fi
    
    info "Installing module: $module"

    if [ -f "$MODULE_PATH" ]; then
      module_header "$module"

      if bash "$MODULE_PATH"; then
        task "Successfully installed module: $module"
      else
        warning "Module installation may have issues: $module"
      fi

      # Draw a separator line
      separator
    else
      error "Module installation script not found: $MODULE_PATH"
    fi
  done
else
  info "No modules specified"
fi

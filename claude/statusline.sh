#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Build status line parts
status_parts=()

# Add current directory
status_parts+=("$cwd")

# Add model
status_parts+=("[$model]")

# Add output style if not default
if [ "$output_style" != "default" ] && [ -n "$output_style" ] && [ "$output_style" != "null" ]; then
    status_parts+=("{$output_style}")
fi

# Add context usage as a progress bar
if [ -z "$used" ]; then
    used=0
fi

used_int=$(printf "%.0f" "$used")

# 10 character bar (each char = 10%)
bar_length=20
filled=$((used_int * 2 / 10))
empty=$((bar_length - filled))

bar=""
for ((i=0; i<filled; i++)); do
    bar+="█"
done
for ((i=0; i<empty; i++)); do
    bar+="░"
done

status_parts+=("[${bar}] ${used_int}%")

# Add cost
if [ -n "$cost" ] && [ "$cost" != "null" ]; then
    status_parts+=("\$$(printf '%.2f' "$cost")")
fi

# Join parts with spaces and print
printf "%s" "${status_parts[0]}"
for i in "${status_parts[@]:1}"; do
    printf " %s" "$i"
done
printf "\n"

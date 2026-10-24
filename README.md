Use it as a command:

Add to your `~/.zshrc`

```
claude-box() {
  docker run -it --rm \
    -v claude-config:/home/node/.claude \
    -v "$PWD":/workspace \
    --cap-drop ALL --security-opt no-new-privileges \
    --memory 16g --pids-limit 512 \
    claude-box claude --dangerously-skip-permissions "$@"
}

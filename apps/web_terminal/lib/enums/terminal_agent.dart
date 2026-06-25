/// What the shell is running. [terminal] is a plain shell; the others launch a
/// coding-agent CLI (command strings in `ValueConst`). [claude] is the default.
enum TerminalAgent { terminal, claude, codex }

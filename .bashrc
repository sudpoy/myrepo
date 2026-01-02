# Shortcut: Type 'journal' to unlock and start writing
alias journal='git-crypt unlock && code entries/$(date +%Y-%m-%d).md'

# Shortcut: Type 'save' to encrypt and push everything
alias save='git add . && git commit -m "Auto-save" && git push && echo "Vault Locked and Synced."'

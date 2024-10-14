#!/bin/bash

# Define the directory containing your dotfiles
DOTFILES_DIR=~/dotfiles

# List of files to symlink 
FILES=(
    ".bashrc"
    ".gitconfig"
    ".gitconfig-private"
    ".git-credentials"
)

# Symlink each file
for file in "${FILES[@]}"; do
    ln -sf "$DOTFILES_DIR/$file" ~/"$file"
    echo "Symlinked $DOTFILES_DIR/$file to ~/$file"
done

echo "All specified files symlinked successfully!"


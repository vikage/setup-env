#!/bin/bash

set -e
GREEN='\033[0;32m'
RED='\033[0;32m'
NC='\033[0m'

print_green(){
	echo -e "${GREEN}$1${NC}"
}

print_red(){
	echo -e "${GREEN}$1${NC}"
}

# Check zsh installed
CURRENT_SHELL=$(echo $SHELL)
if [ "${CURRENT_SHELL}" != "/bin/zsh" ]; then
	print_green "* Installing zsh..."	

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
	print_green "* Zsh installed"
fi

# Check powerlevel9k installed
POWERLEVEL_9K_INSTALLED_CMD=$(git -C ~/powerlevel9k status > /dev/null 2>&1)
POWERLEVEL_9K_INSTALLED=$?
if [[ $POWERLEVEL_9K_INSTALLED -ne 0 ]]; then
	print_green "* Installing powerlevel9k..."	
else
	print_green "* Powerlevel9k installed"
fi

# Check codesnipet
SNIPET_INSTALLED_CMD=$(git -C ~/Library/Developer/Xcode/UserData/CodeSnippets status > /dev/null 2>&1)
SNIPET_INSTALLED=$?

if [[ $SNIPET_INSTALLED -ne 0 ]]; then
	print_green "* Installing xcode CodeSnippets..."
	git clone https://bitbucket.org/thanhdev2703/codesnippets ~/Library/Developer/Xcode/UserData/CodeSnippets
	if [[ $? -eq 0 ]]; then
		print_green "* CodeSnippets installed"
	fi
else
	print_green "* CodeSnippets installed"
fi

# Check install homebrew
BREW_CHECK_CMND=$(brew help > /dev/null 2>&1)
BREW_INSTALLED=$?
if [[ $BREW_INSTALLED -ne 0 ]]; then
	print_green "* Installing homebrew..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	if [[ $? -eq 0 ]]; then
		print_green "* Brew installed"
	fi
else
	print_green "* Brew installed"
fi

# Check install cocoapods
POD_CHECK_CMND=$(pod --version > /dev/null 2>&1)
POD_INSTALLED=$?
if [[ $POD_INSTALLED -ne 0 ]]; then
	print_green "* Installing Cocoapods..."
	sudo gem install cocoapods

	if [[ $? -eq 0 ]]; then
		print_green "* Pod installed"
	fi
else
	print_green "* Pod installed"
fi

print_green "* Setting up Cocoapods repo..."
pod setup


print_green "* Cloning userinfo from repo ..."
rm -rf ~/ttmp
mkdir -p ~/ttmp
git clone https://bitbucket.org/thanhdev2703/environment ~/ttmp/env

print_green "* Coping zsh_profile ..."
cp ~/ttmp/env/zsh/.zsh_profile ~/.zsh_profile
print_green "* Coping zsh_rc ..."
cp ~/ttmp/env/zsh/.zshrc ~/.zshrc
print_green "* Coping scripts ..."
mkdir -p ~/.script/
cp -r ~/ttmp/env/script/ ~/.script
echo "export PATH=\$PATH:~/.script/" >> ~/.zsh_profile

# Clean up
rm -rf ~/ttmp

print_green "Everything OK"
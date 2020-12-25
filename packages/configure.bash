#!/bin/bash

: '
 © Copyright 2020 Josef Schönberger

 This file is part of Debian-Setup.

 Debian-Setup is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Debian-Setup is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Debian-Setup.  If not, see <http://www.gnu.org/licenses/>.
' 

echo "Configuring the list of packages to install. Would you like to install:"

filename=$1

if [ "$filename" == "" ]; then
	filename="./packages.txt"
fi

echo "vim-gtk3 bash-completion acpi lm-sensors htop curl bc fdisk ranger tree wget tree telnet sshfs imagemagick pandoc paprefs" >"$filename"

yn_choice() {
	while : ; do
		read -p "  $1 (y/n)? " input
		if [ "$input" == "y" ]; then
			choice=Y
			break;
		elif [ "$input" == "n" ]; then
			choice=N
			break;
		fi
		echo "Please enter a 'y' or a 'n'"
	done
}

number_choice() {
	while : ; do
		read -p "  $1 (a number)? " input
		if [[ "$input" =~ ^[0-9]+$ ]]; then
			choice=$input
			break;
		fi
		echo "Please enter a valid number"
	done
}

append() {
	echo "$1" >>"$filename"
}

if_append() {
	yn_choice "$1"
	if [ "$choice" == "Y" ]; then
		append "$2"
	fi
}

echo "Essentials:"

if_append "i3" "i3 i3blocks rofi feh"

if_append "GIMP" "gimp gimp-help-de"

echo "Entertainment:"

if_append "Youtube-DL" "youtube-dl"

if_append "Utils for Youtube-DL (ffmpeg & AtomicParsley)" "ffmpeg atomicparsley"

if_append "MPV" "mpv jq socat"

if_append "Fun in Terminal (cowsay, lolcat, sl, sudoku)" "cowsay lolcat sl sudoku"

echo "Development"

if_append "Git" "git"

if_append "Python 3" "python3 python3-dev"

if_append "NodeJS" "nodejs npm"

yn_choice "OpenJDK incl. Source"
if [ "$choice" == "Y" ]; then
	number_choice "   | Which version"
	append "openjdk-$choice-jdk openjdk-$choice-source"
	if_append "   | Including OpenJFX with source" "openjfx openjfx-source"
fi

yn_choice "C / C++ (gcc, g++, gdb)" 
if [ "$choice" == "Y" ]; then
	append "gcc gcc-doc g++ gdb gdb-doc build-essential"
	if_append "   | Make" "make cmake"
	if_append "   | strace" "strace"
	if_append "   | ClangD, ClangFormat" "clangd clang-format"
	if_append "   | GMP" "libgmp10 libgmp-dev gmp-doc"
	if_append "   | Perf" "linux-perf"
	if_append "   | Valgrind" "valgrind"
fi

if_append "Rust" "rustc rust-doc rust-src cargo"

if_append "Doxygen" "doxygen"

if_append "AutoConf, AutoGen, CheckInstall" "autoconf autogen checkinstall"

yn_choice "LaTeX" 
if [ "$choice" == "Y" ]; then
	append "texlive-fonts-extra texlive-lang-german texlive-science"
	if_append "   | TexStudio" "texstudio"
	if_append "   | LaTeX-MK" "latexmk"
fi

echo "Tools:"

if_append "Hexcurse" "hexcurse"
if_append "Lynx" "lynx"
if_append "SSH-Server" "openssh-server"
if_append "QEMU" "qemu-system-x86"
if_append "TMux" "tmux"

tr '\n' ' ' <$filename >tmp_packages_1912498172931.txt
mv tmp_packages_1912498172931.txt $filename
echo "DONE! Check $filename"

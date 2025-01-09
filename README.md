# Operating-System
This repository contains SKKU's OS assignment using xv6.

**Make sure you use x86 architecture in order to boot xv6 kernel.**
If you are a MAC user, emulating x86, or virtualizing x86 in ARM processor will not fulfill the pre-requisites of xv6.
You need to prepare a server that has x86 architecture.
You can either use a Windows OS and WSL, or ssh to a x86 server. 

**Use gcc version 11 as other gcc version make issues in compling.**

I currently use a Windows computer to use Ubuntu 24.04. Use WSL.
```
sudo apt update
sudo apt-get install gcc-11
sudo apt install qemu-system
```
If your Ubuntu has gcc-13 as default, you won't be able to compile xv6 saying there is a infinite loop. Follow the following instruction to downgrade your gcc version: <https://webhostinggeeks.com/howto/how-to-downgrade-gcc-version-on-ubuntu/>

## 1. CFS Scheduler

## 2. Virtual Memory (mmap)

## 3. Page Replacement (Swap-in, swap-out)

## 4. File Extension

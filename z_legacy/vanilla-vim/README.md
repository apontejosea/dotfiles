Vim
===

This vim solution is used accross multiple Windows 7 machines.  
It requires the creation of symbolic links in the command line, 
for which admin privileges are required.  If the command line 
doesn't allow for the creation of links in the Program Files 
directory, try by running the command prompt as administrator
((1) Right-click on the command prompt on the start menu and 
(2) click "Run as Administrator").


Installation
============

Assuming vim is installed in 'c:/Program Files/Vim'

1. mkdir %USERPROFILE%\vim
2. mkdir %USERPROFILE%\vim\vimfiles
3. Move whatever is inside the vimfiles original directory (Program Files) to the vimfiles directory just created.
4. Move the _vimerc file from Program Files to %USERPROFILE%\vim
5. cd 'c:/Program Files (x86)/Vim'
6. mklink _vimrc %USERPROFILE%\vim\\_vimrc
7. git clone https://github.com/gmarik/Vundle.vim.git %USERPROFILE%/vim/vimfiles/bundle/Vundle.vim
7. open gvim and run :BundleInstall! (you will probably have to remove existing plugins before in order to make space for the downloaded plugin repositories)


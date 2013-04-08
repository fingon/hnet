# Created:       Mon Apr  8 14:12:02 2013 mstenber
# Last modified: Mon Apr  8 14:28:33 2013 mstenber

all: build

build: netkit.build

netkit.build:
	make -C netkit/fs filesystem
	make -C netkit/kernel -j 9 kernel

clean: netkit.clean

netkit.clean:
	make -C netkit/fs clean
	make -C netkit/kernel clean

# Git utility targets

init:
	git submodule init
	git submodule update --recursive

sync:
	git submodule sync
	git submodule foreach git submodule sync


# Probably highly self-only tool, to make _all_ nested submodules rw
# instead of the default ro url
rw: sync rewrite-git-urls-rw

rewrite-git-urls-rw:
	perl -i.bak -pe \
		's/git:\/\/github\.com\/fingon/git\@github\.com:fingon/g' \
		`find .git -name 'config' -print`

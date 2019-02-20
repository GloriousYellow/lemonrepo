#!/usr/bin/env sh
set -eux

sed -i 's/exit \$E_ROOT/#disabled/g' /usr/sbin/makepkg

mkdir ~/.ssh
echo "Host *" >> ~/.ssh/config
echo "StrictHostKeyChecking no" >> ~/.ssh/config
ssh-add -D
ssh-add /root/.ssh/id_rsa_803e3ff627dc90db556ff9c520ad99fd

git submodule update --init --recursive

rm -rf dist
cp -r packages dist

cd dist

git clone git@github.com:GloriousYellow/lemonrepo-files.git _repo
rm -rf _repo/*

for dir in *; do
  if [ "$dir" != _repo ]; then
    cd "$dir"
    git init
    env PKGEXT='.pkg.tar.xz' makepkg -s --noconfirm
    cp *.pkg.tar.xz ../_repo
    cd ..
  fi
done

cd _repo
repo-add lemonrepo.db.tar.xz *.pkg.tar.xz

rm lemonrepo.db
rm lemonrepo.files

cp lemonrepo.db.tar.xz lemonrepo.db
cp lemonrepo.files.tar.xz lemonrepo.files

git config user.email "you@example.com"
git config user.name "Build Server"

git add .
git commit -am 'Automatic update'
git push

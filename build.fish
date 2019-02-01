#!/usr/bin/env fish

sed -i 's/exit \$E_ROOT/#disabled/g' /usr/sbin/makepkg
mkdir ~/.ssh
echo "StrictHostKeyChecking no" >> ~/.ssh/config

git submodule update --init --recursive

rm -rf dist
cp -r packages dist

cd dist

git clone git@github.com:GloriousYellow/lemonrepo-files.git _repo
rm -rf repo/*

for dir in *
  if [ $dir != _repo ]
    cd $dir
    git init
    env PKGEXT='.pkg.tar.xz' makepkg -s --noconfirm
    cp *.pkg.tar.xz ../_repo
    cd ..
  end
end

cd _repo
repo-add lemonrepo.db.tar.xz *.pkg.tar.xz
git add .
git commit -am 'Automatic update'
git push

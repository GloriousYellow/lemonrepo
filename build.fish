#!/usr/bin/env fish

sed -i 's/exit \$E_ROOT/#disabled/g' /usr/sbin/makepkg

git submodule update --init --recursive

rm -rf dist
cp -r packages dist

mkdir dist/_repo

cd dist
for dir in *
  cd $dir
  git init
  env PKGEXT='.pkg.tar.xz' makepkg -s --noconfirm
  cp *.pkg.tar.xz ../_repo
  cd ..
end

cd _repo
repo-add lemonrepo.db.tar.xz *.pkg.tar.xz
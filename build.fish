#!/usr/bin/env fish

rm -rf dist
cp -r packages dist
mkdir dist/_repo

chmod 777 -Rv .

useradd --no-create-home --shell=/bin/false build && usermod -L build
echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

cd dist
for dir in *
  cd $dir
  git init
  su build -s /bin/sh -c "env PKGEXT='.pkg.tar.xz' makepkg -s"
  cp *.pkg.tar.xz ../_repo
  cd ..
end

cd _repo
repo-add lemonrepo.db.tar.xz *.pkg.tar.xz
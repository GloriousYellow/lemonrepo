#!/usr/bin/env fish

rm -rf dist
cp -r packages dist
mkdir dist/_repo

chmod 777 -R .

cd dist
for dir in *
  cd $dir
  git init
  su nobody -s /bin/sh -c "env PKGEXT='.pkg.tar.xz' makepkg -s"
  cp *.pkg.tar.xz ../_repo
  cd ..
end

cd _repo
repo-add lemonrepo.db.tar.xz *.pkg.tar.xz
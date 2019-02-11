#!/usr/bin/env fish

sed -i 's/exit \$E_ROOT/#disabled/g' /usr/sbin/makepkg

mkdir ~/.ssh
echo "Host *" >> ~/.ssh/config
echo "StrictHostKeyChecking no" >> ~/.ssh/config
ssh-add /root/.ssh/id_rsa_803e3ff627dc90db556ff9c520ad99fd

git submodule update --init --recursive

rm -rf dist
cp -r packages dist

cd dist

#git clone git@github.com:GloriousYellow/lemonrepo-files.git _repo
rm -rf _repo/*

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

git config user.email "you@example.com"
git config user.name "Build Server"

git add .
git commit -am 'Automatic update'
git push

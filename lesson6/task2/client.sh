sudo -u vagrant ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -N "" -q
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/

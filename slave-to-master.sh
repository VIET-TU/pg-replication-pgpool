#!/bin/bash

# truy cập vào môi trường postgresql thiết lập có thể write/read
sudo -i -u postgres psql postgres -c "SELECT pg_promote();"

# cập nhật user replicator
sudo -i -u postgres psql postgres -c "ALTER USER replicator WITH PASSWORD 'viettu';"

# ghi thông tin server còn lại vào để làm thành slave của server này
echo "host    replication     replicator      192.168.56.13/24          md5" >> /etc/postgresql/14/main/pg_hba.conf

# khởi động lại postgresql
systemctl restart postgresql
#!/bin/bash

# truy cập vào môi trường postgresql thiết lập có thể write/read
sudo -i -u postgres psql postgres -c "SELECT pg_promote();"

# dừng postgresql
systemctl stop postgresql

# xóa hết dữ liệu cũ
rm -rf /var/lib/postgresql/14/main/*

# chạy lệnh backup dữ liệu từ master mới
sudo -u postgres PGPASSWORD="viettu" pg_basebackup -h 192.168.56.12 -D /var/lib/postgresql/14/main -U replicator -P -v -R -X stream -C -S slave_1

# khởi động lại postgresql
systemctl start postgresql
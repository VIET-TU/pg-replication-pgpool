#!/bin/bash

# Đường dẫn đến thư mục lưu trữ các bản sao lưu
backup_dir="/backup/pg/"

# Đường dẫn tới công cụ pg_dump
pg_dump_path="/usr/bin/pg_dump"

# Tên cơ sở dữ liệu cần sao lưu
database_name="postgres"

# Tạo tên tệp tin sao lưu với định dạng ngày-tháng-năm-giờ-phút-giây
backup_file="$backup_dir/backup_$(date +"%Y-%m-%d-%H-%M-%S").sql"

# Thực hiện sao lưu cơ sở dữ liệu
sudo -i -u postgres pg_dump -U postgres -d $database_name -f $pg_dump_path/$backup_file

# Đếm số lượng các bản sao lưu hiện có
backup_count=$(ls -1 $backup_dir | wc -l)

# Nếu số lượng bản sao lưu vượt quá 7, xóa bản sao lưu cũ nhất
if [ $backup_count -gt 7 ]; then
  oldest_backup=$(ls -t $backup_dir | tail -1)
  rm "$backup_dir/$oldest_backup"
fi
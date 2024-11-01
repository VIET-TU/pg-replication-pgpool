#!/bin/bash

log_file="output.log"
max_size=10485760  # Giới hạn kích thước là 10MB (10 * 1024 * 1024 bytes)

server1_ip="192.168.56.11"
server2_ip="192.168.56.12"
server3_ip="192.168.56.13"
port="5432"
username="postgres"
password="viettu"
database="postgres"

# Biến flag để kiểm tra trạng thái đã tạo file hay chưa
created_file=0

while true; do
    # Kiểm tra kết nối tới server 1
    pg_isready -h $server1_ip -p $port -U $username -d $database > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        if [ $created_file -eq 0 ]; then
            # Nếu server 1 không phản hồi và file chưa được tạo
            scp /home/slave-to-master.sh root@$server2_ip:slave-to-master.sh
            scp /home/new-slave-master.sh root@$server3_ip:new-slave-master.sh
            ssh root@$server2_ip "chmod +x slave-to-master.sh && ./slave-to-master.sh"
            ssh root@$server3_ip "chmod +x new-slave-master.sh && ./new-slave-master.sh"
            current_time=$(date +"%Y-%m-%d %H:%M:%S")
            echo "$current_time - Postgresql Master không hoạt động đã tiến hành chuyển đổi Master"
            created_file=1  # Đánh dấu là file đã được tạo
        fi
    else
        current_time=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$current_time - Server 1 đang hoạt động"
        created_file=0  # Đặt trạng thái file về chưa tạo khi kết nối được khôi phục
    fi

    # Kiểm tra kích thước của tệp tin log
    if [ -f $log_file ] && [ $(stat -c %s $log_file) -gt $max_size ]; then
        truncate -s 0 $log_file  # Cắt giảm kích thước tệp tin log về 0
        echo "Giảm kích thước file."
    fi

    sleep 5
done
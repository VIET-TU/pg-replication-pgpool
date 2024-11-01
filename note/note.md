[URL][https://chatgpt.com/g/g-2DQzU5UZl-code-copilot/c/98cba58b-3e9f-4d86-8272-b99b735bd64f] tk ll6012

# Dưới đây là hướng dẫn chi tiết về cách chỉnh sửa file cấu hình pg_hba.conf cho PostgreSQL phiên bản 14 và giải thích từng dòng trong file đó để bạn có thể hiểu rõ hơn về cách `thiết lập quyền truy cập`:

# Truy cập và chỉnh sửa file cấu hình

Mở file cấu hình bằng trình chỉnh sửa văn bản (như vi):

```bash
vi /etc/postgresql/14/main/pg_hba.conf
```

Xóa toàn bộ nội dung cũ và thay thế bằng nội dung mới sau đây:

```plaintext
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer
# IPv4 local connections:
host    all             all             0.0.0.0/0               scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256

```

# Giải thích chi tiết từng dòng

## Cấu trúc file pg_hba.conf

File pg_hba.conf sử dụng cấu trúc cơ bản như sau:

- `TYPE`: Loại kết nối (local, host).
- `DATABASE`: Tên cơ sở dữ liệu mà quy tắc áp dụng.
- `USER`: Người dùng mà quy tắc áp dụng.
- `ADDRESS`: Địa chỉ IP của kết nối (chỉ áp dụng cho host).
- `METHOD`: Phương thức xác thực.

## Nội dung chi tiết

## Dòng `local all all peer`:

- TYPE: local chỉ định kết nối từ máy chủ nội bộ.
- DATABASE: all nghĩa là quy tắc áp dụng cho tất cả cơ sở dữ liệu.
- USER: all nghĩa là quy tắc áp dụng cho tất cả người dùng.
- METHOD: peer nghĩa là xác thực qua hệ thống người dùng Linux/Unix. Người dùng PostgreSQL phải có cùng tên với người dùng hệ thống.

## Dòng `host all all 0.0.0.0/0 scram-sha-256`:

- TYPE: host chỉ định kết nối qua TCP/IP.
- DATABASE: all nghĩa là áp dụng cho tất cả cơ sở dữ liệu.
- USER: all nghĩa là áp dụng cho tất cả người dùng.
- ADDRESS: 0.0.0.0/0 nghĩa là cho phép tất cả địa chỉ IPv4.
- METHOD: scram-sha-256 là một phương pháp xác thực bảo mật, yêu cầu tên người dùng và mật khẩu.

## Dòng `host all all ::1/128 scram-sha-256`:

- TYPE: host chỉ định kết nối qua TCP/IP.
- DATABASE: all nghĩa là áp dụng cho tất cả cơ sở dữ liệu.
- USER: all nghĩa là áp dụng cho tất cả người dùng.
- ADDRESS: ::1/128 là địa chỉ loopback IPv6 cho phép kết nối từ localhost.
- METHOD: scram-sha-256 là một phương pháp xác thực bảo mật, yêu cầu tên người dùng và mật khẩu.

## Dòng `local replication all peer`:

- TYPE: local chỉ định kết nối từ máy chủ nội bộ.
- DATABASE: replication nghĩa là áp dụng cho quyền sao chép dữ liệu.
- USER: all nghĩa là áp dụng cho tất cả người dùng.
- METHOD: peer xác thực bằng cách sử dụng tên người dùng hệ thống.

## Dòng host `replication all 127.0.0.1/32 scram-sha-256`:

- TYPE: host chỉ định kết nối qua TCP/IP.
- DATABASE: replication nghĩa là áp dụng cho quyền sao chép dữ liệu.
- USER: all nghĩa là áp dụng cho tất cả người dùng.
- ADDRESS: 127.0.0.1/32 là địa chỉ loopback IPv4, chỉ cho phép kết nối từ localhost.
- METHOD: scram-sha-256 là một phương pháp xác thực bảo mật.

## Dòng `host replication all ::1/128 scram-sha-256`:

- TYPE: host chỉ định kết nối qua TCP/IP.
- DATABASE: replication nghĩa là áp dụng cho quyền sao chép dữ liệu.
- USER: all nghĩa là áp dụng cho tất cả người dùng.
- ADDRESS: ::1/128 là địa chỉ loopback IPv6.
- METHOD: scram-sha-256 là một phương pháp xác thực bảo mật.

## Ghi chú

Phương pháp xác thực `scram-sha-256`: Đây là phương pháp bảo mật cao hơn so với md5, yêu cầu tên người dùng và mật khẩu được xác thực bằng một hàm băm bảo mật.
Phương pháp `peer`: Xác thực dựa trên người dùng hệ thống, thường dùng cho kết nối cục bộ khi người dùng PostgreSQL trùng với người dùng hệ thống.

====================================================================================================================================

# Để giúp bạn hiểu rõ hơn về phương thức xác thực peer, mình sẽ cung cấp một ví dụ chi tiết về cách hoạt động của phương thức này.

## Phương thức xác thực peer là gì?

- Phương thức `peer` là một cơ chế xác thực được sử dụng cho các kết nối `local` (tức là các kết nối `không qua mạng`, mà từ chính máy chủ nơi PostgreSQL đang chạy). Khi sử dụng phương thức này, PostgreSQL sẽ xác thực người dùng dựa trên thông tin của hệ thống Linux/Unix. Điều này có nghĩa là người dùng đang cố gắng kết nối với PostgreSQL phải có cùng tên với người dùng hệ thống Linux/Unix.

## Ví dụ minh họa

Giả sử bạn có hệ thống Ubuntu và bạn đã cài đặt PostgreSQL trên máy này. Bạn có các người dùng sau:

### Người dùng hệ thống Linux/Unix:

-alice (`có thể đăng nhập vào hệ thống Ubuntu`).

### Người dùng PostgreSQL:

- alice (`được tạo trong PostgreSQL`).

## Cách hoạt động

### 1. Tạo người dùng hệ thống:

Giả sử bạn đã tạo một người dùng hệ thống có tên là `alice`:

```sh
sudo adduser alice
```

### 2.Tạo người dùng trong PostgreSQL:

- Bạn cũng tạo một người dùng trong PostgreSQL có tên là `alice`:

```sql
sudo -u postgres psql
CREATE USER alice;
```

### 3. Cấu hình trong pg_hba.conf:

Bạn đã cấu hình pg_hba.conf để cho phép xác thực peer như sau:

```plaintext
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer

```

### 4. Kết nối tới PostgreSQL:

Khi người dùng hệ thống alice đăng nhập vào hệ thống Linux và cố gắng kết nối với PostgreSQL:

```bash
sudo -i -u alice
psql -U alice -d mydatabase
```

Kết nối thành công: PostgreSQL sẽ kiểm tra xem người dùng hệ thống alice có trùng tên với người dùng PostgreSQL alice không. Nếu có, việc kết nối sẽ được cho phép mà không cần mật khẩu.

Kết nối thất bại: Nếu người dùng hệ thống không trùng tên với người dùng PostgreSQL, hoặc người dùng PostgreSQL không tồn tại, thì kết nối sẽ bị từ chối.

## Tóm lại

- Lợi ích của peer: Là phương thức xác thực đơn giản và nhanh chóng cho các kết nối cục bộ khi bạn không muốn quản lý mật khẩu.
  -Hạn chế của peer: Chỉ hoạt động khi người dùng hệ thống và PostgreSQL trùng tên, `không phù hợp cho kết nối từ xa qua mạng.`

====================================================================================================================================================

## Để hiểu rõ hơn về phương thức xác thực scram-sha-256, mình sẽ giải thích và đưa ra một ví dụ cụ thể về cách thiết lập và sử dụng phương thức này trong PostgreSQL.

Phương thức xác thực scram-sha-256 là gì?
SCRAM-SHA-256 (Salted Challenge Response Authentication Mechanism using SHA-256) là một phương thức xác thực mạnh mẽ, sử dụng thuật toán băm SHA-256 để mã hóa mật khẩu. Phương thức này an toàn hơn so với MD5 vì nó cung cấp khả năng bảo mật cao hơn thông qua việc sử dụng một giá trị muối (salt) và một quá trình lặp băm (hash iterations), giúp bảo vệ mật khẩu khỏi các cuộc tấn công dò mật khẩu.

## Ví dụ minh họa

Giả sử bạn có hệ thống với PostgreSQL và bạn muốn sử dụng scram-sha-256 để xác thực người dùng từ xa.

Cài đặt và cấu hình

## 1. Tạo người dùng PostgreSQL với scram-sha-256:

Đầu tiên, bạn cần tạo một người dùng trong PostgreSQL và đặt mật khẩu cho họ với phương thức xác thực scram-sha-256.

```sql
sudo -u postgres psql
CREATE USER bob WITH PASSWORD 'strongpassword' ENCRYPTED WITH SCRAM-SHA-256;
```

Trong lệnh trên:

- bob là tên người dùng PostgreSQL.
- 'strongpassword' là mật khẩu của người dùng, được mã hóa với scram-sha-256.

## 2. Cấu hình pg_hba.conf để sử dụng scram-sha-256:

Mở file cấu hình pg_hba.conf và thêm hoặc sửa các dòng sau để sử dụng scram-sha-256 cho các kết nối từ xa:

```plaintext
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             bob             0.0.0.0/0               scram-sha-256
host    all             bob             ::0/0                   scram-sha-256

```

- `host` all bob 0.0.0.0/0 scram-sha-256: Cho phép người dùng bob kết nối từ bất kỳ địa chỉ IPv4 nào bằng cách sử dụng scram-sha-256.
- `host` all bob ::0/0 scram-sha-256: Cho phép người dùng bob kết nối từ bất kỳ địa chỉ IPv6 nào bằng cách sử dụng scram-sha-256.

## 3. Kết nối tới PostgreSQL:

Người dùng bob có thể kết nối đến PostgreSQL từ xa với thông tin đăng nhập của họ bằng một công cụ như psql hoặc một ứng dụng khách khác:

```bash
psql -h your_postgres_host -U bob -d your_database
Password: strongpassword
```

- Trong lệnh trên:
  -h your_postgres_host: Địa chỉ máy chủ PostgreSQL.
  -U bob: Tên người dùng PostgreSQL (bob).
  -d your_database: Tên cơ sở dữ liệu mà bạn muốn kết nối.

===========================================================================================================================

### Step 2: Thiết lập cấu hình trên Master

Tiếp theo chúng ta cần tạo một user replica để phục vụ cho việc thiết lập Postgresql high availability Master-Slave

Tại server Master tiến hành thực hiện các bước sau để cấu hình cho Postgresql thành node master

```sh
sudo su - postgres # chuyển đổi người dùng hiện tại sang người dùng “postgres”
```

Câu lệnh chi tiết

```bash
createuser --replication -P -e replicator #tạo một người dùng “replicator” trong cơ sở dữ liệu PostgreSQL, tiến hành nhập Password bạn muốn để hoàn thành
```

## Giải thích từng thành phần của CHATGPT

- `createuser`: Đây là công cụ dòng lệnh đi kèm với PostgreSQL để tạo người dùng mới trong hệ quản trị cơ sở dữ liệu PostgreSQL.

- `--replication`: Tham số này cấp quyền sao chép dữ liệu cho người dùng. Người dùng có quyền này có thể thực hiện các thao tác liên quan đến sao lưu và phục hồi dữ liệu giữa các máy chủ PostgreSQL. Đây là một phần quan trọng trong việc thiết lập các hệ thống PostgreSQL hoạt động theo cơ chế sao chép (replication).

- `-P`: Tham số này yêu cầu bạn nhập mật khẩu cho người dùng mới. Sau khi chạy câu lệnh, bạn sẽ được yêu cầu nhập mật khẩu cho người dùng này hai lần (để xác nhận).

- `-e`: Tham số này bật chế độ hiển thị câu lệnh SQL thực sự được gửi đến máy chủ PostgreSQL để tạo người dùng. Điều này hữu ích để xem chính xác câu lệnh SQL nào được thực thi.

- `replicator`: Đây là tên của người dùng PostgreSQL mới mà bạn đang tạo. Bạn có thể thay thế replicator bằng tên người dùng khác tùy theo nhu cầu của bạn.

## Cách hoạt động

Khi bạn chạy câu lệnh này, PostgreSQL sẽ thực hiện các bước sau:

1. Yêu cầu bạn nhập mật khẩu cho người dùng replicator.

2. Tạo người dùng mới trong PostgreSQL với quyền sao chép dữ liệu.

3. Hiển thị câu lệnh SQL tương ứng (nếu có sử dụng tùy chọn -e), ví dụ như:

```sql
CREATE ROLE replicator WITH LOGIN REPLICATION PASSWORD 'yourpassword';
```

Khi nào sử dụng
Câu lệnh này thường được sử dụng trong các trường hợp sau:

- Thiết lập replication: Khi bạn cần thiết lập sao chép dữ liệu giữa các máy chủ PostgreSQL, bạn sẽ cần tạo một người dùng có quyền sao chép.
- Quản lý cơ sở dữ liệu lớn: Sử dụng replication để cân bằng tải giữa các máy chủ hoặc để tạo các bản sao lưu dữ liệu.

### GIẢI THÍCH CỦA BLOG

Giải thích từng phần của câu lệnh:

- `“createuser“`: Đây là một câu lệnh trong PostgreSQL được sử dụng để tạo một người dùng mới trong cơ sở dữ liệu.
- `“–replication“`: Đây là một tùy chọn của câu lệnh createuser để chỉ định rằng người dùng mới được tạo sẽ có quyền sao chép (replication). Quyền sao chép cho phép người dùng tham gia vào việc sao chép dữ liệu từ máy chủ PostgreSQL chính (primary) sang các máy chủ PostgreSQL khác (standby) để đảm bảo tính sẵn sàng và sao lưu dự phòng.
- `“-P“`: Đây là một tùy chọn để yêu cầu nhập mật khẩu cho người dùng mới. Khi tùy chọn này được sử dụng, bạn sẽ được yêu cầu nhập mật khẩu cho người dùng mới ngay sau khi câu lệnh được thực thi.
- `“-e“`: Đây là một tùy chọn để hiển thị câu lệnh SQL được sử dụng để tạo người dùng trong kết quả đầu ra. Nó giúp bạn xem câu lệnh SQL tạo người dùng đó.
- `“replicator“`: Đây là tên người dùng mới được tạo. Trong ví dụ này, người dùng mới được đặt tên là “replicator”.

===> Khi câu lệnh được thực thi thành công, một người dùng mới có tên “replicator” sẽ được tạo trong cơ sở dữ liệu PostgreSQL với quyền sao chép (replication) và bạn sẽ được yêu cầu nhập mật khẩu cho người dùng này.

```sh
$ exit # thoát khỏi người dùng “postgres”

$ vi /etc/postgresql/14/main/pg_hba.conf # mở file chứa các quy tắc xác thực và phân quyền cho các kết nối đến cơ sở dữ liệu PostgreSQL và thêm 2 dòng dưới đây vào cuối file (2 IP server Slave 1 và Slave 2)
```

```plaintext
host    replication     replicator      192.168.56.12/24       md5
host    replication     replicator      192.168.56.13/24       md5
```

```sh
$ systemctl restart postgresql # khởi động lại Postgresql
```

====> Và đây là những câu lệnh đã chạy ở trên để thiết lập Postgresql trên Server Master

=====================================================================================================

## Step 3: Thiết lập cấu hình trên Slave

Truy cập sang server `Slave 1` và làm các bước sau:

```sh

$ systemctl stop postgresql # dừng Postgresql

$ cp -R /var/lib/postgresql/14/main /var/lib/postgresql/14/stand-by-bkp # backup lại data cũ ra một thư mục khác (bước này có thể bỏ qua)

$ rm -rf /var/lib/postgresql/14/main/* # xóa dữ liệu cũ

$ sudo su - postgres # chuyển đổi người dùng hiện tại sang người dùng “postgres”

$ pg_basebackup -h 10.32.3.171 -D /var/lib/postgresql/14/main -U replicator -P -v -R -X stream -C -S slave_1 # sử dụng để sao chép cơ sở dữ liệu PostgreSQL từ một máy chủ chính (primary) sang một máy chủ sao chép (standby) mới và bạn tiến hành nhập mật khẩu user replicator vừa tạo trên Postgresql server Master
```

## Giải thích từng phần của câu lệnh:

`“pg_basebackup“`: Đây là một công cụ dòng lệnh được cung cấp bởi PostgreSQL để sao chép cơ sở dữ liệu từ máy chủ chính sang máy chủ sao chép.
`“-h 10.32.3.171“`: Đây là tùy chọn để chỉ định địa chỉ IP hoặc tên máy chủ của máy chủ chính từ nơi cơ sở dữ liệu sẽ được sao chép.
`“-D /var/lib/postgresql/14/main“`: Đây là tùy chọn để chỉ định đường dẫn đến thư mục dữ liệu của máy chủ sao chép, nơi cơ sở dữ liệu sao chép sẽ được lưu trữ.
`“-U replicator“`: Đây là tùy chọn để chỉ định tên người dùng (replicator) mà công cụ pg_basebackup sẽ sử dụng để kết nối và sao chép cơ sở dữ liệu từ máy chủ chính.
`“-P“`: Đây là tùy chọn để yêu cầu nhập mật khẩu cho người dùng (replicator) khi thực hiện sao chép.
`“-v“`: Đây là tùy chọn để hiển thị tiến trình sao chép chi tiết trong quá trình thực thi lệnh.
`“-R“`: Đây là tùy chọn để chỉ định rằng máy chủ sao chép sẽ được cấu hình để chạy dưới dạng máy chủ sao chép (standby) và sẵn sàng để nhận các bản cập nhật từ máy chủ chính.
`“-X stream“`: Đây là tùy chọn để chỉ định phương thức truyền dữ liệu là stream replication. Trong trường hợp này, dữ liệu sẽ được truyền từ máy chủ chính đến máy chủ sao chép thông qua luồng dữ liệu (stream).
`“-C“`: Đây là tùy chọn để chỉ định rằng tệp pg_control cũng sẽ được sao chép. Tệp pg_control chứa thông tin quản lý cấu hình và trạng thái của cơ sở dữ liệu.
`“-S slave_1“`: Đây là tùy chọn để chỉ định tên người ghi (slot) được sử dụng để xác định vị trí sao chép. Tên người ghi được sử dụng để giới hạn việc sao chép chỉ đến vị trí xác định, giúp giữ cơ sở dữ liệu sao chép ở một trạng thái nhất định.

### Giải Thích Chi Tiết của CHATGPT

1. `pg_basebackup`:

Đây là công cụ dòng lệnh của PostgreSQL dùng để tạo một bản sao lưu cơ sở dữ liệu đầy đủ từ máy chủ chính. Công cụ này rất hữu ích khi bạn cần tạo bản sao để sao lưu hoặc thiết lập một máy chủ dự phòng (standby server).

2. `-h` 10.32.3.171:

   -h chỉ định địa chỉ IP của máy chủ PostgreSQL chính mà bạn muốn sao lưu. Ví dụ này cho thấy bạn đang kết nối đến máy chủ có địa chỉ IP là 10.32.3.171.

- 3. -D /var/lib/postgresql/14/main:

  -D chỉ định thư mục đích nơi mà dữ liệu sao lưu sẽ được lưu trữ trên máy chủ phụ. Thư mục này cần trống hoặc không chứa dữ liệu PostgreSQL từ trước. Nó là nơi mà toàn bộ dữ liệu từ máy chủ chính sẽ được sao chép vào.

4. `-U replicator`:

-U chỉ định tên người dùng có quyền thực hiện sao chép dữ liệu. Người dùng replicator phải có quyền REPLICATION trên máy chủ chính để thực hiện quá trình sao chép.

5. `-P`:

Hiển thị tiến trình sao lưu lên màn hình. Với tùy chọn này, bạn sẽ thấy được tiến độ của quá trình sao lưu, giúp theo dõi trạng thái công việc dễ dàng hơn.

6. `-v`:

Bật chế độ chi tiết (verbose mode), cho phép in ra thông tin chi tiết về từng bước trong quá trình sao lưu. Điều này hữu ích cho việc gỡ lỗi hoặc theo dõi.

7. `-R`:

Tự động tạo file cấu hình khôi phục (recovery.conf) trong thư mục đích. File này cần thiết để máy chủ phụ hoạt động như một máy chủ dự phòng, sẵn sàng tiếp nhận dữ liệu và cập nhật từ máy chủ chính.

8. `-X` stream:

Chỉ định cách thức sao chép các bản ghi giao dịch (WAL logs) bằng phương thức truyền trực tuyến (stream). Điều này đảm bảo các thay đổi dữ liệu liên tục từ máy chủ chính cũng được cập nhật vào bản sao lưu trong quá trình sao chép.

9. `-C`:

Tạo một slot sao chép mới (replication slot) trên máy chủ chính để giữ các bản ghi giao dịch cần thiết cho quá trình sao lưu, tránh việc chúng bị xóa trước khi sao chép hoàn tất.

10. `-S slave_1`:

Đặt tên cho slot sao chép là slave_1. Slot sao chép giúp đảm bảo rằng tất cả các thay đổi trong cơ sở dữ liệu trên máy chủ chính đều được ghi nhận và có thể truyền tải đầy đủ đến máy chủ phụ. Slot này giúp tránh mất dữ liệu nếu máy chủ phụ không thể theo kịp với các bản ghi giao dịch của máy chủ chính.

## Tại Sao Cần Thiết

- Sao Lưu và Khôi Phục: Dùng để tạo bản sao lưu đầy đủ của cơ sở dữ liệu, có thể khôi phục trong trường hợp gặp sự cố.

- Replication (Sao Chép): Thiết lập hệ thống máy chủ phụ sẵn sàng tiếp nhận dữ liệu từ máy chủ chính, giúp tăng cường khả năng phục hồi và phân phối tải cho hệ thống.

---

## Replication Slot là gì?

Replication slot trong PostgreSQL là một cơ chế giúp quản lý và kiểm soát việc sao chép dữ liệu từ máy chủ chính (primary server) sang máy chủ phụ (standby server). Nó đảm bảo rằng các bản ghi giao dịch (WAL logs) không bị xóa khỏi máy chủ chính cho đến khi chúng đã được sao chép hoàn toàn tới máy chủ phụ. Điều này giúp duy trì tính nhất quán của dữ liệu và ngăn ngừa mất mát dữ liệu trong quá trình sao chép.

## Tại sao cần Replication Slot?

1. Đảm bảo tính nhất quán: Slot giúp giữ lại các bản ghi giao dịch cần thiết cho quá trình sao chép, đảm bảo rằng máy chủ phụ có thể nhận được đầy đủ dữ liệu và cập nhật cần thiết từ máy chủ chính.

2. Ngăn ngừa mất dữ liệu: Nếu máy chủ phụ không thể theo kịp tốc độ ghi của máy chủ chính (do băng thông mạng hạn chế hoặc vấn đề khác), replication slot sẽ ngăn việc xóa các bản ghi giao dịch trước khi chúng được sao chép hoàn tất.

3. Quản lý tài nguyên hiệu quả: Replication slot giúp quản lý và điều phối tài nguyên cho các tiến trình sao chép, đảm bảo rằng dữ liệu được sao chép đúng thứ tự và đầy đủ.

## Hoạt động của Replication Slot

1. Tạo replication slot: Khi bạn tạo một replication slot, PostgreSQL sẽ theo dõi vị trí của các bản ghi giao dịch mà máy chủ phụ đang sao chép. Slot này đóng vai trò như một điểm kiểm soát, đảm bảo rằng các bản ghi giao dịch không bị xóa trước khi máy chủ phụ có thể tiếp nhận chúng.

2. Quản lý vị trí ghi: Replication slot theo dõi vị trí ghi của máy chủ phụ. Khi máy chủ phụ xác nhận đã nhận được và xử lý các bản ghi giao dịch, nó sẽ gửi thông tin này về máy chủ chính để cập nhật vị trí ghi trong slot.

3. Giữ lại WAL logs: Các bản ghi giao dịch (WAL logs) sẽ được giữ lại trên máy chủ chính cho đến khi chúng được sao chép thành công đến máy chủ phụ, ngăn chặn việc xóa chúng quá sớm và tránh mất mát dữ liệu.

Ví dụ minh họa
Trong câu lệnh bạn đã đưa ra:

```bash
pg_basebackup -h 10.32.3.171 -D /var/lib/postgresql/14/main -U replicator -P -v -R -X stream -C -S slave_1
```

`-S slave_1`: Tạo một replication slot có tên là slave_1. Slot này được sử dụng để quản lý quá trình sao chép cho máy chủ phụ (thường được gọi là "slave" hoặc "standby") có tên là slave_1.

## Khi nào nên sử dụng Replication Slot?

Sao chép liên tục: Khi bạn muốn thiết lập một hệ thống sao chép liên tục và đảm bảo rằng tất cả dữ liệu được sao chép đầy đủ mà không có rủi ro mất mát.

Cân bằng tải: Khi bạn sử dụng các máy chủ phụ để phân phối tải công việc từ máy chủ chính, giúp tăng cường hiệu suất hệ thống.

Khả năng phục hồi cao (High Availability): Khi bạn muốn thiết lập các máy chủ phụ để đảm bảo hệ thống có thể tiếp tục hoạt động ngay cả khi máy chủ chính gặp sự cố.

## Tóm lại

Replication slot là một phần quan trọng trong việc quản lý và tối ưu hóa quá trình sao chép dữ liệu trong PostgreSQL. Nó đảm bảo rằng dữ liệu được sao chép đầy đủ và chính xác từ máy chủ chính sang máy chủ phụ, giúp duy trì tính nhất quán và ngăn ngừa mất mát dữ liệu.

```sh
 exit # thoát khỏi người dùng “postgres”
 systemctl start postgresql # khởi động lại Postgresql
```

===========> Và đây là những câu lệnh đã chạy ở trên để thiết lập trên Server Slave 1

### ====> Làm tượng tự như ta cũng được kết quả tương tự (chú ý bước sao chép dữ liệu bạn hãy đổi thành slave_2) trên server Slave 2

---

# Step 4: Kiểm tra hoạt động Master-Slave

Chúng ta quay lại Server master và kiểm tra bằng các bước sau

```sh
$ sudo -i -u postgres psql postgres -c "SELECT * FROM pg_replication_slots;" # truy vấn thông tin về các người ghi (replication slots) đang tồn tại trong Postgresql
```

===> Chúng ta đã thiết lập và có 2 Slave trạng thái là t (true) và một số thông tin khác bạn hãy tìm hiểu thêm nếu muốn nhé chúng ta tiếp tục kiểm tra

```sh
$ sudo -i -u postgres psql postgres truy cập vào môi trường dòng lệnh của PostgreSQL với quyền người dùng “postgres” thông qua sudo
```

Tạo table users

```sql
postgres=# CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
```

Thêm dữ liệu sample vào table users

```sql
postgres=# INSERT INTO users (name) VALUES ('administrator'); INSERT INTO users (name) VALUES ('elroy');
postgres=# select * from users; --- truy vấn thông tin
```

## Tiếp theo chúng ta thử qua server Slave 1 để kiểm tra xem đã được đồng bộ dữ liệu chưa

```sh
$ sudo -i -u postgres psql postgres truy cập vào môi trường dòng lệnh của PostgreSQL với quyền người dùng “postgres” thông qua sudo

```

```sql
postgres=# select * from users; --- truy vấn thông tin và đã có kết quả tương tự Slave 1 của chúng ta đã hoạt động
```

## ===> Tương tự chúng ta check qua server Slave 2 và thấy rằng nó cũng đã hoạt động

## Bạn có thấy mô hình ở trên Slave chỉ có thể read only không là chỉ có thể select dữ liệu và không thể insert chúng ta cùng thử trên server Slave 1

```sql
postgres=# INSERT INTO customers (name) VALUES ('guest'); thêm dữ liệu và được kết quả lỗi dưới đây
```

## ===> Vậy là chúng ta đã thiết lập thành công bước đầu Postgresql high availability cho 3 servers với Server 1 làm Postgresql Master và Server 2 làm Postgresql Slave 1 và Server 3 làm Postgresql Slave 2.

## Cài đặt PostgreSQL Client:

Trên Ubuntu, bạn có thể cài đặt psql bằng cách sử dụng lệnh sau:

```bash
sudo apt update
sudo apt install postgresql-client
```

## đăng nhập với database tên `postgres`

```sql
psql -h 10.32.3.110 -p 5432 -U postgres -d postgres

\dt -- liện kê tables

CREATE DATABASE your_database_name;

\l -- show các db
```

## đăng nhập với database `reddit`

```sh
psql -U your_username -d reddit
\dt # liệt kê table
```

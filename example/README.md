# example

A new Flutter project.

## Getting Started

```uml
@startuml
title Quá trình Xác thực và Đăng xuất thông qua MKDC-SSO
participant "Người dùng" as User
participant "Ứng dụng" as App
participant "Xác thực" as AuthView
participant "MKDC-SSO" as WSO2

User -> App: Khởi động
App -> App: Kiểm tra token
alt Có token
    App --> User: Hiển thị trạng thái đã đăng nhập và token
else Không có token
    App --> User: Hiển thị nút đăng nhập
end

User -> App: Nhấn đăng nhập
App -> WSO2: Mở và Hiển thị trang xác thực
User -> AuthView: Nhập thông tin xác thực
AuthView -> WSO2: Gửi thông tin xác thực
WSO2 --> App: Trả về mã ủy quyền (code)
App -> WSO2: Trao đổi mã ủy quyền cho token truy cập
WSO2 --> App: Trả token truy cập
App -> App: Lưu token truy cập
App --> User: Hiển thị trạng thái đã đăng nhập

User -> App: Nhấn đăng xuất
App -> WSO2: Mở và hiển thị trang đăng xuất
User -> AuthView: Xác nhận đăng xuất
AuthView -> WSO2: Xác nhận đăng xuất
WSO2 --> App: Xác nhận đã đăng xuất
App -> App: Xóa token
App --> User: Hiển thị trạng thái chưa đăng nhập

@enduml
```
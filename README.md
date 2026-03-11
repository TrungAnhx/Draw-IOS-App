# Draw! - Advanced Markup App

Ứng dụng vẽ và ghi chú nâng cao được xây dựng bằng **SwiftUI**, **PaperKit**, và **PencilKit**. Ứng dụng cho phép người dùng chèn văn bản, hình khối, hình ảnh và vẽ tay bằng Apple Pencil hoặc ngón tay lên một khung canvas linh hoạt.

## ✨ Tính năng chính
- **Markup Canvas:** Sử dụng công nghệ PaperKit mới nhất để quản lý các đối tượng (văn bản, hình ảnh, hình khối).
- **PencilKit Integration:** Hỗ trợ đầy đủ các công cụ vẽ (bút chì, bút mực, tẩy) thông qua Tool Picker.
- **Insert Objects:**
  - Chèn văn bản với font chữ hệ thống.
  - Chèn hình khối (Hình chữ nhật, Ngôi sao,...).
  - Chèn hình ảnh từ thư viện ảnh (Photos Picker).
- **Export:** 
  - Xuất bản vẽ ra định dạng `UIImage` và lưu vào thư viện ảnh.
  - Xuất dữ liệu bản vẽ ra định dạng `Data` (Markup format) để lưu trữ hoặc truyền tải.

## 🛠 Công nghệ sử dụng
- **SwiftUI:** Framework xây dựng giao diện người dùng.
- **PaperKit:** Framework cung cấp khả năng Markup chuyên sâu (tương tự như tính năng sửa ảnh trong iOS Photos).
- **PencilKit:** Cung cấp bộ công cụ vẽ chuyên nghiệp.
- **Observation Framework:** Quản lý dữ liệu hiệu quả với macro `@Observable`.

## 🚀 Yêu cầu hệ thống
- **Hệ điều hành:** iOS 17.0 trở lên (Một số tính năng nâng cao yêu cầu phiên bản mới hơn).
- **Thiết bị:** iPhone/iPad (Khuyến khích sử dụng Apple Pencil trên iPad để có trải nghiệm tốt nhất).

## 📂 Cấu trúc thư mục
- `Draw_App.swift`: Điểm khởi đầu của ứng dụng.
- `ContentView.swift`: Màn hình chính chứa các menu điều khiển và Toolbar.
- `Helpers/EditorView.swift`: Bridge giữa SwiftUI và PaperKit (UIViewControllerRepresentable).
- `Helpers/EditorData.swift`: Lớp xử lý logic, quản lý dữ liệu Markup và xuất file.

---
*Created with ❤️ by TrungAnhx*

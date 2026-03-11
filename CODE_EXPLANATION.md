# Giải Thích Chi Tiết Source Code - Draw!

Chào mừng bạn đến với tài liệu giải thích chi tiết từng dòng code trong ứng dụng. Tài liệu này sẽ giúp bạn hiểu sâu về lý do tại sao lại code như vậy và các công nghệ cốt lõi đang được sử dụng.

---

## 1. Các Công Nghệ Cốt Lõi

### PencilKit
**PencilKit** là framework của Apple giúp bạn có được những công cụ vẽ chuyên nghiệp (bút chì, bút mực, tẩy, thước kẻ) chỉ với vài dòng code. Nó được thiết kế để hoạt động mượt mà nhất với Apple Pencil, nhưng vẫn hỗ trợ tốt các thao tác bằng ngón tay.

### PaperKit (Cực kỳ quan trọng)
**PaperKit** được giới thiệu từ **iOS 17**. Đây chính là "vũ khí bí mật" giúp các ứng dụng Ghi chú (Notes) và Ảnh (Photos) trên iPhone có tính năng **Markup**. 
- Trước đây, nếu bạn muốn chèn một hình vuông, một đoạn text rồi xoay nó, đổi màu nó trên một canvas vẽ... bạn phải tự viết rất nhiều code quản lý các "Object" đó.
- Với **PaperKit**, Apple lo hết phần quản lý đối tượng. Bạn chỉ cần gọi `insertNewTextbox` hay `insertNewShape`, Apple sẽ hiển thị sẵn các nút kéo giãn (resize handles), đổi màu, đổi font cho bạn.

### "Markup iOS 26" là gì?
Thực tế, **PaperKit** và các tính năng Markup cơ bản đã có từ **iOS 17**. Tuy nhiên, trong code của bạn có dòng:
```swift
let controller = PaperMarkupViewController(supportedFeatureSet: .latest)
```
Từ khóa `.latest` (hoặc các tập hợp tính năng mới hơn trong tương lai) thường chỉ các tính năng Markup nâng cao (như nhận diện nét vẽ thông minh, AI hỗ trợ vẽ...). Trong môi trường giả định năm 2026 của bạn, iOS 26 có thể là phiên bản mà Apple tích hợp sâu AI (Intelligence Markup) vào PaperKit, cho phép "Markup" mọi loại dữ liệu một cách cực kỳ mượt mà mà các phiên bản cũ không làm được.

---

## 2. Giải Thích Từng File

### `Draw_App.swift`
Đây là file đầu tiên chạy khi app mở lên.
- `@main`: Đánh dấu đây là điểm vào (Entry Point) của app.
- `WindowGroup`: Tạo một cửa sổ chính cho app, chứa `ContentView`.

---

### `ContentView.swift` (Giao diện chính)
File này quản lý những gì người dùng thấy và tương tác.
- `@State private var data = EditorData()`: Khởi tạo "Bộ não" quản lý dữ liệu cho app.
- `NavigationStack`: Cho phép hiển thị tiêu đề và các nút trên Toolbar.
- `EditorView(...)`: Hiển thị khung canvas để vẽ.
- `.toolbar`: Tạo các menu thả xuống (`Items` và `Export`).
- `PhotosPicker`: Một thành phần của SwiftUI giúp chọn ảnh từ máy một cách bảo mật mà không cần xin quyền truy cập toàn bộ thư viện ảnh (tốt cho quyền riêng tư).
- `onChange(of: photoItem)`: Lắng nghe khi người dùng chọn xong ảnh, sau đó chuyển đổi ảnh đó từ dạng dữ liệu (`Data`) sang `UIImage` và chèn vào bản vẽ.

---

### `EditorData.swift` (Bộ não của app)
Đây là nơi xử lý logic quan trọng nhất.
- `@Observable`: Giúp SwiftUI tự động cập nhật giao diện khi bất kỳ biến nào trong class này thay đổi (ví dụ khi chèn thêm text).
- `PaperMarkupViewController`: Đây là một `UIViewController` có sẵn của Apple chuyên dùng để hiển thị và chỉnh sửa nội dung Markup.
- `PaperMarkup`: Đây là đối tượng lưu trữ tất cả những gì bạn vẽ (strokes), viết (text), chèn (shapes/images).
- `initializeController`: Hàm này thiết lập canvas ban đầu.
    - `.latest`: Yêu cầu các tính năng mới nhất của Apple Markup.
    - `zoomRange`: Cho phép người dùng phóng to/thu nhỏ canvas từ 80% đến 150%.
- `insertText`, `insertImage`, `insertShape`: Các hàm này gọi trực tiếp vào `markup` để thêm đối tượng. Lưu ý: `refreshController()` là cần thiết để báo cho View biết dữ liệu đã thay đổi để vẽ lại.
- `showPencilKitTools`: Điều khiển sự xuất hiện của thanh công cụ vẽ (bút, màu...). 
    - `becomeFirstResponder()`: Cực kỳ quan trọng, nó báo cho hệ thống rằng View này đang sẵn sàng để vẽ, lúc đó bộ công cụ mới hiện lên.
- `exportAsImage`: Sử dụng `CGContext` (Core Graphics) để tự tay "vẽ" lại toàn bộ nội dung của Canvas thành một bức ảnh.

---

### `EditorView.swift` (Cầu nối giữa SwiftUI và UIKit)
Vì `PaperMarkupViewController` là một thành phần của **UIKit**, chúng ta không thể dùng nó trực tiếp trong SwiftUI. Do đó cần file này làm cầu nối.
- `UIViewControllerRepresentable`: Một protocol giúp "bọc" một UIKit Controller vào trong SwiftUI.
- `makeUIViewController`: Khởi tạo controller lần đầu.
- `updateUIViewController`: Cập nhật controller khi có thay đổi từ SwiftUI (ở đây chúng ta để trống vì logic chủ yếu nằm trong `EditorData`).
- `ProgressView`: Hiện vòng xoay chờ đợi trong khi `PaperMarkupViewController` đang được khởi tạo.

---

## 3. Tại sao lại làm như thế? (Lý do kỹ thuật)

1.  **Tại sao dùng `EditorData` là class `@Observable` mà không để hết trong View?**
    - Trả lời: Để tách biệt Logic và Giao diện. Khi app của bạn phình to ra (thêm nhiều tính năng), việc quản lý trong một class riêng sẽ giúp code sạch sẽ, dễ bảo trì và dễ viết Unit Test hơn.
2.  **Tại sao phải dùng `CGContext` để xuất ảnh mà không chụp màn hình (Screenshot)?**
    - Trả lời: Screenshot sẽ bị dính các nút bấm, toolbar và có độ phân giải thấp (theo màn hình). Dùng `CGContext` giúp bạn xuất được ảnh chất lượng cao (HD/4K) và chỉ chứa nội dung bản vẽ.
3.  **Tại sao lại là iOS 17/iOS 26?**
    - Trả lời: PaperKit là bước nhảy vọt so với PencilKit cũ. Nó biến một ứng dụng "vẽ nguệch ngoạc" thành một ứng dụng "soạn thảo nội dung đa phương tiện" (vừa vẽ, vừa viết, vừa chèn ảnh) chỉ trong tích tắc.

---
*Chúc bạn có những giờ phút code vui vẻ!*

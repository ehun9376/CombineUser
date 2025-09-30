# CombineUser

一個使用 **SwiftUI**、**Clean Architecture** 和 **Combine Framework** 構建的現代 iOS 用戶管理應用程式，展示了現代 iOS 開發的最佳實踐，包含聲明式 UI、響應式編程和企業級架構設計。

## 📱 功能特色

- 🔍 **用戶列表** - 從 JSONPlaceholder API 獲取並顯示用戶列表
- 👤 **用戶詳情** - 查看個別用戶的詳細資訊，支援推頁導航
- 🎨 **現代化 SwiftUI UI** - 聲明式用戶界面，支援深淺色主題
- 🔄 **響應式程式設計** - 使用 Combine 框架處理異步操作和狀態管理
- 🧭 **程式化導航** - 使用 NavigationCoordinator 實現型別安全的路由系統
- 🔁 **智能重試機制** - 具備網路失敗自動重試功能
- ⚡ **統一狀態管理** - 使用泛型 ViewState 統一管理 UI 狀態
- 🏗️ **依賴注入** - 完整的 DI 容器系統，支援不同生命週期管理
- ✅ **完整測試覆蓋** - 包含單元測試、Repository 測試和 TDD 示範

## 🏗️ 架構設計

本專案採用 **SwiftUI + Clean Architecture** 設計模式，結合現代 iOS 開發最佳實踐：

```
┌─────────────────────────────────────────────────────────────┐
│                 SwiftUI Presentation Layer                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │ SwiftUI     │  │ ViewModel   │  │ NavigationCoordinator│   │
│  │ Views       │  │(@Published) │  │ + Type-Safe Routing │   │
│  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌───────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│  │   Use Cases   │  │    Entities     │  │  Repositories   ││
│  │  (Business)   │  │   (Models)      │  │  (Protocols)    ││
│  └───────────────┘  └─────────────────┘  └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│  │ Repository Impl │  │   DTOs + Maps   │  │   API Client    ││
│  │                 │  │                 │  │  + RetryPolicy  ││
│  └─────────────────┘  └─────────────────┘  └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│  │ DI Container    │  │ Navigation      │  │ Environment     ││
│  │ (Dependencies)  │  │ (Coordinator)   │  │ (Config)        ││
│  └─────────────────┘  └─────────────────┘  └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

### 📁 專案結構

```
CombineUser/
├── CombineUser/
│   ├── CombineUserApp.swift            # SwiftUI App 入口點
│   ├── Info.plist                      # 應用程式配置
│   ├── Core/                           # 核心基礎設施
│   │   ├── Network/
│   │   │   ├── APIClient.swift         # 網路客戶端（含重試機制）
│   │   │   ├── Endpoint.swift          # API 端點定義
│   │   │   └── APIURL.swift           # API URL 配置
│   │   ├── Errors/
│   │   │   ├── APIError.swift          # API 層錯誤定義
│   │   │   └── DomainError.swift       # 領域層錯誤定義
│   │   ├── State/
│   │   │   └── ViewState.swift         # 泛型 UI 狀態管理
│   │   ├── Navigation/
│   │   │   └── SwiftUICoordinator.swift # 型別安全的導航系統
│   │   ├── DIContainer/
│   │   │   └── DIContainer.swift       # 依賴注入容器
│   │   ├── Alert/
│   │   │   ├── AlertViewController.swift # 全域提示系統
│   │   │   └── OverlayWindowAlertPresenter.swift
│   │   └── Widgets/                    # UI 組件庫
│   │       └── Buttons/
│   │           └── SimpleButton.swift  # 自定義按鈕組件
│   ├── Feature/
│   │   └── Users/                      # 用戶功能模組
│   │       ├── Domain/
│   │       │   ├── UserModel.swift           # 用戶實體（支援 SwiftUI）
│   │       │   ├── UsersRepository.swift     # Repository 協議
│   │       │   └── UseCase/                  # Use Cases
│   │       │       ├── FetchUsersUseCase.swift    # 獲取用戶列表
│   │       │       ├── FetchUsersByIdUseCase.swift # 獲取單一用戶
│   │       │       ├── FetchUserDetailUseCase.swift # 獲取用戶詳情
│   │       │       └── DeleteUserUseCase.swift   # 刪除用戶
│   │       ├── Data/
│   │       │   ├── UserDTO.swift             # 數據傳輸對象
│   │       │   ├── UserMapper.swift          # DTO ↔ Domain 映射
│   │       │   ├── UsersEndpoint.swift       # Users API 端點
│   │       │   └── UsersRepositoryImpl.swift # Repository 實現
│   │       └── Presentation/
│   │           ├── UsersList/
│   │           │   ├── UsersListView.swift        # SwiftUI 用戶列表視圖
│   │           │   └── UsersListViewModel.swift   # 響應式視圖模型
│   │           └── UserDetail/
│   │               └── UserDetailView.swift       # SwiftUI 用戶詳情視圖
│   ├── Assets.xcassets/               # 資源文件
│   ├── CombineUserTests/               # 單元測試
│   │   ├── MockURL/
│   │   │   └── MockURL.swift           # 網路請求 Mock
│   │   └── UserTests/
│   │       ├── UserListViewModelTests/
│   │       │   └── UsersListViewModelTests.swift # ViewModel 測試
│   │       ├── UserUseCaseTests/
│   │       │   ├── UserUseCaseTests.swift      # Use Case 測試
│   │       │   └── UserDtoConvertTests.swift   # DTO 轉換測試
│   │       └── UserRepoTests/
│   │           └── UserRepoTests.swift         # Repository 測試
│   └── TDD_Example_UsersListViewModelTests.swift # TDD 示範
└── CombineUser.xcodeproj/             
```

## 🛠️ 技術棧

- **語言**: Swift 5.0+
- **最低支援版本**: iOS 16.0+
- **開發工具**: Xcode 15.0+
- **UI 框架**: 
  - **SwiftUI** (聲明式用戶界面)
  - **Combine** (響應式程式設計)
  - **Foundation** (基礎功能)
- **架構模式**: 
  - **Clean Architecture** (分層架構)
  - **MVVM** (SwiftUI + ObservableObject)
  - **Dependency Injection** (自定義 DI 容器)
- **導航系統**: 
  - **NavigationStack** (iOS 16+ 原生導航)
  - **NavigationCoordinator** (程式化路由管理)
- **網路層**: 
  - **URLSession + Combine** (異步網路請求)
  - **自定義重試機制** (智能錯誤恢復)
- **狀態管理**: 
  - **@Published + @StateObject** (SwiftUI 響應式)
  - **泛型 ViewState<T>** (統一狀態模式)
- **測試框架**: 
  - **XCTest** (單元測試 + UI 測試)
  - **TDD** (測試驅動開發示範)
- **API**: [JSONPlaceholder](https://jsonplaceholder.typicode.com) (免費測試 API)

## 🚀 快速開始

### 系統需求
- **macOS**: 13.0+ (Ventura)
- **Xcode**: 15.0+
- **iOS 設備**: 16.0+ (支援 SwiftUI NavigationStack)
- **Swift**: 5.7+ (支援 async/await 和泛型改進)

### 安裝步驟

1. **克隆專案**
   ```bash
   git clone https://github.com/ehun9376/CombineUser.git
   cd CombineUser
   ```

2. **開啟專案**
   ```bash
   open CombineUser.xcodeproj
   ```

3. **專案配置**
   - 確保 **Deployment Target** 設定為 iOS 16.0+
   - 檢查 **Swift Language Version** 為 5.7+
   - 啟用 **SwiftUI Preview** 功能

4. **選擇目標設備**
   - 建議使用 **iPhone 14** 或更新的模擬器
   - 支援所有 iOS 16+ 設備 (iPhone & iPad)

5. **運行專案**
   ```bash
   # 透過 Xcode
   ⌘ + R
   
   # 或透過終端
   xcodebuild -scheme CombineUser -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

### SwiftUI 開發體驗
```swift
// 啟用 SwiftUI Preview (在任何 View 文件中)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
            .environmentObject(AppContainer.shared.makeUsersListViewModel())
    }
}
```

### 運行測試
```bash
# 單元測試 (所有測試)
⌘ + U

# 特定測試類別
xcodebuild test -scheme CombineUser -only-testing:CombineUserTests/UserUseCaseTests

# 終端執行全部測試
xcodebuild test -scheme CombineUser -destination 'platform=iOS Simulator,name=iPhone 15'
```

### SwiftUI 功能展示
1. **📱 原生 SwiftUI 界面**
   - 聲明式語法和即時預覽
   - 自適應佈局 (iPhone / iPad)
   - Dark Mode 自動支援

2. **🧭 現代導航系統**
   - NavigationStack (iOS 16+)
   - 程式化路由管理
   - 類型安全的頁面導航

3. **⚡ 響應式狀態管理**
   - @Published + @StateObject
   - Combine + SwiftUI 深度整合
   - 泛型 ViewState<T> 模式

4. **🔄 網路 + UI 同步**
   - 自動重試機制
   - Loading/Error/Success 狀態
   - 無縫的用戶體驗

## 🔧 核心組件說明

### 🏛️ Domain Layer (領域層)

- **Entities**: `User`, `Address`, `Company` - 核心業務實體
- **Use Cases**: 包含應用程式的業務邏輯
  - `FetchUsersUseCase` - 獲取用戶列表
  - `FetchUsersByIdUseCase` - 獲取特定用戶  
  - `FetchUserDetailUseCase` - 獲取用戶詳細資訊
  - `DeleteUserUseCase` - 刪除用戶
- **Repository Protocol**: `UsersRepository` - 定義數據存取接口

### 💾 Data Layer (數據層)

- **Repository Implementation**: `UsersRepositoryImpl` - 實現數據存取邏輯
- **DTOs**: `UserDTO`, `AddressDTO`, `CompanyDTO` - 處理 API 響應數據格式
- **Mappers**: `UserMapper` - 在 DTO 和 Domain 實體間轉換
- **API Client**: 
  - `APIClient` - 通用網路請求處理
  - `RetryPolicy` - 智能重試機制（支援指數退避）
  - `Endpoint` - API 端點抽象
- **Error Handling**: `APIError` → `DomainError` 錯誤轉換

### 🎨 Presentation Layer (展示層)

- **SwiftUI Views**: 
  - `UsersListView` - 聲明式用戶列表界面
  - `UserDetailView` - 響應式用戶詳情頁
  - `UserRowView` - 可重用的用戶卡片組件
- **ObservableObject ViewModels**: 
  - `UsersListViewModel` - 使用 `@Published` 實現 SwiftUI 響應式綁定
  - 與 Combine 深度整合的狀態管理
- **Navigation System**:
  - `NavigationCoordinator` - 程式化導航控制
  - `SwiftUICoordinator` - 類型安全的路由管理
  - 支援 `NavigationStack` (iOS 16+)

### 🔧 Core Infrastructure (核心基礎設施)

- **Network Layer**: 
  - `APIClient` - 基於 Combine 的異步網路請求
  - `RetryPolicy` - 智能重試機制（指數退避）
  - `Endpoint` - 類型安全的 API 端點定義
- **State Management**: 
  - `ViewState<T>` - 泛型狀態管理 (Loading/Loaded/Error)
  - SwiftUI 響應式狀態綁定
- **Dependency Injection**:
  - `AppContainer` - 自定義 DI 容器
  - `EnvironmentObject` - SwiftUI 環境注入
- **SwiftUI 特有架構**:
  - `@Published` 屬性包裝器
  - `@StateObject` / `@ObservedObject` 生命週期管理
  - `@EnvironmentObject` 依賴注入模式

## 🧪 測試策略

專案採用多層次測試架構，確保代碼品質：

### 測試類型

- **Unit Tests**: 測試 Use Cases 和 Repository 的業務邏輯
- **Integration Tests**: 測試 API 客戶端和數據映射
- **DTO Mapping Tests**: 驗證 DTO 到 Domain 實體的轉換正確性
- **Mock Network Tests**: 使用 `MockURL` 模擬網路請求
- **UI Tests**: 基本的 UI 測試框架

### 測試架構

```swift
// 使用 Mock Repository 進行 Use Case 測試
class UsersRepositoryMock: UsersRepository {
    var fetchUsersResult: AnyPublisher<[User], DomainError>!
    var fetchUserResult: AnyPublisher<User, DomainError>!
    var deleteResult: AnyPublisher<Bool, DomainError>!
    
    func fetchUsers() -> AnyPublisher<[User], DomainError> {
        return fetchUsersResult
    }
}
```

### 測試覆蓋範圍

- ✅ Use Case 業務邏輯測試
- ✅ Repository 實現測試  
- ✅ DTO 轉換正確性測試
- ✅ 網路錯誤處理測試
- ✅ Mock 網路請求測試

## 📋 API 文檔

應用程式使用 [JSONPlaceholder](https://jsonplaceholder.typicode.com) 作為後端 API：

- **GET /users** - 獲取所有用戶
- **GET /users/{id}** - 獲取特定用戶

## 🔄 核心技術特色詳解

### 智能重試機制

```swift
// RetryPolicy 支援指數退避重試
struct RetryPolicy {
    let maxRetries: Int
    let initialDelay: TimeInterval
    let retryable: ((APIError) -> Bool)
    
    static let networkAnd5xx: RetryPolicy = RetryPolicy(
        maxRetries: 3,
        initialDelay: 0.5,
        retryable: { error in
            switch error {
            case .transport: return true
            case .server(let status): return (500...599).contains(status)
            default: return false
            }
        }
    )
}
```

### SwiftUI 響應式 UI 系統

```swift
// SwiftUI View 中的狀態響應
struct UsersListView: View {
    @StateObject private var viewModel: UsersListViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView("載入中...")
            case .loaded(let users):
                List(users) { user in
                    UserRowView(user: user)
                        .onTapGesture {
                            coordinator.push(.userDetail(user))
                        }
                }
            case .error(let error):
                ErrorView(error: error) {
                    viewModel.load()
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}
```

### NavigationCoordinator 類型安全路由

```swift
// 類型安全的導航管理
enum Destination: Hashable {
    case usersList
    case userDetail(User)
}

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
}
```

### SwiftUI + Combine 響應式數據流

```swift
// SwiftUI ObservableObject ViewModel
@MainActor
class UsersListViewModel: ObservableObject {
    @Published var state: ViewState<[User]> = .loading
    
    private let fetchUsersUseCase: FetchUsersUseCase
    private var cancellables = Set<AnyCancellable>()
    
    func load() {
        state = .loading
        
        fetchUsersUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.state = .error(error)
                    }
                },
                receiveValue: { [weak self] users in
                    self?.state = .loaded(users)
                }
            )
            .store(in: &cancellables)
    }
}
```

### 泛型狀態管理系統

```swift
enum ViewState<T> {
    case loading
    case loaded(T)
    case error(Error)
    
    // SwiftUI 便利屬性
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }
}

// SwiftUI View 中的狀態響應
struct UsersListView: View {
    @StateObject private var viewModel: UsersListViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("載入中...")
            case .loaded(let users):
                UsersList(users: users)
            case .error(let error):
                ErrorView(error: error) {
                    viewModel.load()
                }
            }
        }
        .onAppear { viewModel.load() }
    }
}
```

## 🎯 專案亮點

### 1. **現代 SwiftUI + Clean Architecture 混合設計**
- 保留 Clean Architecture 的領域和數據層
- SwiftUI 原生展示層，享受聲明式 UI 好處
- ObservableObject + @Published 響應式狀態管理

### 2. **進階導航系統**
- NavigationCoordinator 程式化路由控制
- 類型安全的 Destination 枚舉
- NavigationStack (iOS 16+) 現代導航體驗

### 3. **Enhanced SwiftUI 架構模式**
- EnvironmentObject 依賴注入
- 泛型 ViewState<T> 統一狀態管理
- @MainActor 線程安全的 ViewModel

### 4. **完整的測試與 Preview 支援**
- Mock 系統完整，支援網路層測試
- SwiftUI Preview 即時開發體驗
- TDD 示範與最佳實踐

### 5. **現代 iOS 開發特性**
- iOS 16+ NavigationStack 支援
- Async/Await 與 Combine 混合使用
- Dark Mode 與自適應佈局自動支援
- iPad 與 iPhone 通用界面設計

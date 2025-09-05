//
//  ResponsiveLayout.swift
//  AdoreVenture - Showcase Version
//
//  Created by Dagmawi Mulualem
//  This demonstrates responsive design patterns and adaptive layouts
//

import SwiftUI

// MARK: - Device Type Detection
enum DeviceType {
    case iPhone
    case iPad
    case mac
}

struct DeviceInfo {
    static var current: DeviceType {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
        #elseif os(macOS)
        return .mac
        #else
        return .iPhone
        #endif
    }
    
    static var isCompact: Bool {
        current == .iPhone
    }
    
    static var isRegular: Bool {
        current == .iPad || current == .mac
    }
}

// MARK: - Responsive Grid
struct ResponsiveGrid<Content: View>: View {
    let columns: [GridItem]
    let content: Content
    
    init(
        minItemSize: CGFloat = 300,
        maxItemSize: CGFloat = 400,
        spacing: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        
        // Calculate number of columns based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - (spacing * 2) // Account for padding
        let numberOfColumns = max(1, Int(availableWidth / maxItemSize))
        
        self.columns = Array(repeating: GridItem(
            .flexible(minimum: minItemSize, maximum: maxItemSize),
            spacing: spacing
        ), count: numberOfColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            content
        }
    }
}

// MARK: - Adaptive Layout
struct AdaptiveLayout<Compact: View, Regular: View>: View {
    let compact: Compact
    let regular: Regular
    
    init(
        @ViewBuilder compact: () -> Compact,
        @ViewBuilder regular: () -> Regular
    ) {
        self.compact = compact()
        self.regular = regular()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            compact
        } else {
            regular
        }
    }
}

// MARK: - Responsive Container
struct ResponsiveContainer<Content: View>: View {
    let content: Content
    let maxWidth: CGFloat
    
    init(maxWidth: CGFloat = 1200, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.maxWidth = maxWidth
    }
    
    var body: some View {
        content
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Responsive Padding
struct ResponsivePadding: ViewModifier {
    let compact: EdgeInsets
    let regular: EdgeInsets
    
    init(
        compact: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        regular: EdgeInsets = EdgeInsets(top: 24, leading: 32, bottom: 24, trailing: 32)
    ) {
        self.compact = compact
        self.regular = regular
    }
    
    func body(content: Content) -> some View {
        content
            .padding(DeviceInfo.isCompact ? compact : regular)
    }
}

extension View {
    func responsivePadding(
        compact: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        regular: EdgeInsets = EdgeInsets(top: 24, leading: 32, bottom: 24, trailing: 32)
    ) -> some View {
        modifier(ResponsivePadding(compact: compact, regular: regular))
    }
}

// MARK: - Responsive Font Size
struct ResponsiveFont: ViewModifier {
    let compact: Font
    let regular: Font
    
    init(compact: Font, regular: Font) {
        self.compact = compact
        self.regular = regular
    }
    
    func body(content: Content) -> some View {
        content
            .font(DeviceInfo.isCompact ? compact : regular)
    }
}

extension View {
    func responsiveFont(compact: Font, regular: Font) -> some View {
        modifier(ResponsiveFont(compact: compact, regular: regular))
    }
}

// MARK: - Responsive Navigation
struct ResponsiveNavigationView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            NavigationView {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - Responsive Sheet
struct ResponsiveSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            content
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        } else {
            content
                .frame(width: 400, height: 600)
                .cornerRadius(16)
        }
    }
}

// MARK: - Responsive List
struct ResponsiveList<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            List {
                content
            }
            .listStyle(PlainListStyle())
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    content
                }
                .padding()
            }
        }
    }
}

// MARK: - Responsive Card Grid
struct ResponsiveCardGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    
    init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ResponsiveGrid(minItemSize: 280, maxItemSize: 350) {
            ForEach(data) { item in
                content(item)
            }
        }
    }
}

// MARK: - Responsive Sidebar
struct ResponsiveSidebar<Sidebar: View, Content: View>: View {
    let sidebar: Sidebar
    let content: Content
    
    init(
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> Content
    ) {
        self.sidebar = sidebar()
        self.content = content()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            NavigationView {
                content
            }
        } else {
            NavigationSplitView {
                sidebar
            } detail: {
                content
            }
        }
    }
}

// MARK: - Responsive Tab View
struct ResponsiveTabView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if DeviceInfo.isCompact {
            TabView {
                content
            }
        } else {
            HStack(spacing: 0) {
                content
            }
        }
    }
}

// MARK: - Responsive Spacing
struct ResponsiveSpacing: ViewModifier {
    let compact: CGFloat
    let regular: CGFloat
    
    init(compact: CGFloat, regular: CGFloat) {
        self.compact = compact
        self.regular = regular
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, DeviceInfo.isCompact ? compact : regular)
    }
}

extension View {
    func responsiveSpacing(compact: CGFloat, regular: CGFloat) -> some View {
        modifier(ResponsiveSpacing(compact: compact, regular: regular))
    }
}

// MARK: - Preview
struct ResponsiveLayout_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveNavigationView {
            VStack(spacing: 20) {
                Text("Responsive Design Demo")
                    .responsiveFont(
                        compact: .title2,
                        regular: .largeTitle
                    )
                
                ResponsiveGrid(minItemSize: 200, maxItemSize: 300) {
                    ForEach(0..<6) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 100)
                            .overlay(
                                Text("Card \(index + 1)")
                                    .font(.headline)
                            )
                    }
                }
                
                AdaptiveLayout {
                    VStack {
                        Text("Compact Layout")
                        Text("This is the iPhone layout")
                    }
                } regular: {
                    HStack {
                        Text("Regular Layout")
                        Text("This is the iPad layout")
                    }
                }
            }
            .responsivePadding()
        }
    }
}

//
//  Theme.swift
//  AdoreVenture - Showcase Version
//
//  Created by Dagmawi Mulualem
//  This demonstrates the app's design system and theming approach
//

import SwiftUI

// MARK: - Color Theme
struct AppTheme {
    // Primary Colors
    static let primaryBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let primaryBlueDark = Color(red: 0.0, green: 0.35, blue: 0.8)
    
    // Secondary Colors
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    
    // Neutral Colors
    static let backgroundGray = Color(.systemGray6)
    static let cardBackground = Color(.systemBackground)
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    
    // Status Colors
    static let successGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
}

// MARK: - Typography
struct AppTypography {
    // Headers
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.semibold)
    static let title3 = Font.title3.weight(.medium)
    
    // Body Text
    static let headline = Font.headline.weight(.semibold)
    static let body = Font.body
    static let bodyBold = Font.body.weight(.medium)
    static let callout = Font.callout
    
    // Small Text
    static let subheadline = Font.subheadline
    static let footnote = Font.footnote
    static let caption = Font.caption
    static let caption2 = Font.caption2
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
}

// MARK: - Shadow
struct AppShadow {
    static let small = Shadow(
        color: .black.opacity(0.1),
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let medium = Shadow(
        color: .black.opacity(0.1),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let large = Shadow(
        color: .black.opacity(0.15),
        radius: 8,
        x: 0,
        y: 4
    )
}

// MARK: - Custom Shadow Modifier
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct ShadowModifier: ViewModifier {
    let shadow: Shadow
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

extension View {
    func appShadow(_ shadow: Shadow) -> some View {
        modifier(ShadowModifier(shadow: shadow))
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyBold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppTheme.primaryBlue)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyBold)
            .foregroundColor(AppTheme.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppTheme.primaryBlue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppCornerRadius.medium)
            .appShadow(AppShadow.medium)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Loading View
struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryBlue))
            
            Text(message)
                .font(AppTypography.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AppSpacing.xl)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppTheme.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, AppSpacing.xl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AppSpacing.xl)
    }
}

// MARK: - Tag View
struct TagView: View {
    let text: String
    let color: Color
    
    init(_ text: String, color: Color = AppTheme.primaryBlue) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .font(AppTypography.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(color.opacity(0.1))
            .cornerRadius(AppCornerRadius.small)
    }
}

// MARK: - Rating View
struct RatingView: View {
    let rating: Double
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
            
            Text(String(format: "%.1f", rating))
                .font(AppTypography.caption)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textSecondary)
        }
    }
}

// MARK: - Preview
struct Theme_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Button Styles
            VStack(spacing: 12) {
                Button("Primary Button") { }
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Secondary Button") { }
                    .buttonStyle(SecondaryButtonStyle())
            }
            
            // Card Style
            VStack(alignment: .leading, spacing: 8) {
                Text("Card Title")
                    .font(AppTypography.headline)
                
                Text("This is a sample card with the app's card style applied.")
                    .font(AppTypography.body)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .cardStyle()
            
            // Tags and Rating
            HStack {
                TagView("outdoor")
                TagView("family-friendly", color: AppTheme.accentGreen)
                Spacer()
                RatingView(rating: 4.5)
            }
            
            // Loading and Empty States
            LoadingView(message: "Loading adventures...")
                .frame(height: 100)
        }
        .padding()
        .background(AppTheme.backgroundGray)
    }
}

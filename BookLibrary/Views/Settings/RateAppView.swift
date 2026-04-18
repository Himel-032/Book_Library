import SwiftUI

struct RateAppView: View {

    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var ratingViewModel = AppRatingViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var selectedRating = 0

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var pageBackground: Color {
        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
    }

    private var cardBackground: Color {
        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    private var fieldBackground: Color {
        isDarkMode ? Color(red: 0.20, green: 0.21, blue: 0.25) : Color(red: 0.98, green: 0.96, blue: 0.91)
    }

    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
    }

    private var primaryText: Color {
        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    private var accent: Color {
        Color(red: 0.18, green: 0.38, blue: 0.26)
    }

    private var amber: Color {
        Color(red: 0.73, green: 0.42, blue: 0.11)
    }

    private var canSubmit: Bool {
        selectedRating > 0 && !ratingViewModel.isSubmitting && !authViewModel.currentUserId.isEmpty
    }

    var body: some View {
        ZStack {
            pageBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    summaryCard
                    ratingCard

                    if let message = ratingViewModel.message {
                        Text(message)
                            .font(.footnote)
                            .foregroundColor(secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Rate My App")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let userId = authViewModel.currentUserId
            ratingViewModel.startListening(currentUserId: userId)
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 10) {
            Text("Community Rating")
                .font(.headline)
                .foregroundColor(primaryText)

            Text(String(format: "%.1f", ratingViewModel.averageRating))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(primaryText)

            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(round(ratingViewModel.averageRating)) ? "star.fill" : "star")
                        .foregroundColor(amber)
                }
            }

            Text("\(ratingViewModel.totalRatings) rating\(ratingViewModel.totalRatings == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundColor(secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }

    private var ratingCard: some View {
        VStack(spacing: 14) {
            Text("Your Rating")
                .font(.headline)
                .foregroundColor(primaryText)

            HStack(spacing: 10) {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        selectedRating = index
                    } label: {
                        Image(systemName: index <= selectedRating ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundColor(index <= selectedRating ? amber : secondaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(fieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(10)

            if ratingViewModel.userRating > 0 {
                Text("Your current saved rating: \(ratingViewModel.userRating) star\(ratingViewModel.userRating == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(secondaryText)
            }

            Button {
                ratingViewModel.submitRating(selectedRating, userId: authViewModel.currentUserId) { success in
                    guard success else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        dismiss()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if ratingViewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                    }
                    Text(ratingViewModel.isSubmitting ? "Submitting..." : "Submit Rating")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(accent)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit)
            .opacity(canSubmit ? 1 : 0.65)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

import SwiftUI

struct DailyRationViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DailyRationViewController {
        return DailyRationViewController()
    }

    func updateUIViewController(_ uiViewController: DailyRationViewController, context: Context) {
        // Ничего обновлять не требуется
    }
}

struct DailyRationViewControllerWrapperContainer: View {
    var body: some View {
        ZStack {
            Color(uiColor: DesignSystem.Colors.background)
                .ignoresSafeArea()
            DailyRationViewControllerWrapper()
        }
    }
}

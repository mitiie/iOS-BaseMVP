import Combine
import Foundation

enum AppEvent {
    case onboardingCompleted
    case purchasedSuccessfully(source: IAPSource)
}

protocol AppEventSending: AnyObject {
    func send(_ event: AppEvent)
}

protocol AppEventObserving: AnyObject {
    var events: AnyPublisher<AppEvent, Never> { get }
}

final class AppEventBus: AppEventSending, AppEventObserving {
    private let subject = PassthroughSubject<AppEvent, Never>()

    var events: AnyPublisher<AppEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    func send(_ event: AppEvent) {
        subject.send(event)
    }
}

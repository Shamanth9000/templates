import Foundation
import AsyncHTTPClient
import StripeKit

class StripeService {
    private let client: StripeClient

    init() {
        client = StripeClient(
            httpClient: HTTPClient(eventLoopGroupProvider: .singleton), apiKey: ProcessInfo.processInfo.environment["STRIPE_SECRET_KEY"]!)
    }

    func checkoutSubscription(context: RuntimeContext, userId: String, successUrl: String, failureUrl: String) async throws -> Session? {
        let lineItem: [String: Any] = [
            "price_data": [
                "unit_amount": 1000, // $10.00
                "currency": "usd",
                "recurring": [
                    "interval": "month"
                ],
                "product_data": [
                    "name": "Premium Subscription"
                ]
            ],
            "quantity": 1
        ]

        do {
            return try await client.sessions.create(
                paymentMethodTypes: ["card"],
                lineItems: [lineItem],
                successUrl: successUrl,
                cancelUrl: failureUrl,
                clientReferenceID: userId,
                subscriptionData: [
                    "metadata": [
                        "userId": userId,
                    ],
                ],
                mode: .subscription
            )
        } catch {
            context.error(error)
            return nil
        }
    }
}

import edfapay_pg_sdk
import Flutter
import UIKit

public final class EdfaApplePaySheetPlugin: NSObject, FlutterPlugin {
    private var pendingResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "edfapay_apple_pay_sheet",
            binaryMessenger: registrar.messenger()
        )
        let instance = EdfaApplePaySheetPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "canMakePayments":
            result(EdfaApplePaySheet().canMakePayments())
        case "present":
            guard pendingResult == nil else {
                result(FlutterError(
                    code: "payment_in_progress",
                    message: "An Apple Pay sheet is already active.",
                    details: nil
                ))
                return
            }
            guard let arguments = call.arguments as? [String: Any],
                  let orderMap = arguments["order"] as? [String: Any],
                  let payerMap = arguments["payer"] as? [String: Any],
                  let rootViewController = Self.rootViewController() else {
                result(FlutterError(
                    code: "invalid_arguments",
                    message: "Apple Pay could not load its payment details or view controller.",
                    details: nil
                ))
                return
            }

            pendingResult = result
            let order = EdfaPgSaleOrder(
                id: orderMap["id"] as! String,
                amount: (orderMap["amount"] as! NSNumber).doubleValue,
                currency: orderMap["currency"] as! String,
                description: orderMap["description"] as! String
            )
            let payer = EdfaPgPayer(
                firstName: payerMap["firstName"] as! String,
                lastName: payerMap["lastName"] as! String,
                address: payerMap["address"] as! String,
                country: payerMap["country"] as! String,
                city: payerMap["city"] as! String,
                zip: payerMap["zip"] as! String,
                email: payerMap["email"] as! String,
                phone: payerMap["phone"] as! String,
                ip: payerMap["ip"] as! String,
                options: nil
            )

            EdfaApplePaySheet().present(
                fromViewController: rootViewController,
                merchantIdentifier: arguments["merchantIdentifier"] as! String,
                countryCode: arguments["countryCode"] as! String,
                currencyCode: arguments["currencyCode"] as! String,
                merchantName: arguments["merchantName"] as! String,
                order: order,
                payer: payer,
                successUrl: arguments["successUrl"] as! String,
                failureUrl: arguments["failureUrl"] as! String,
                onSuccess: { [weak self] response in
                    self?.finish(["status": "success", "response": String(describing: response)])
                },
                onFailure: { [weak self] error in
                    self?.finish(["status": "failure", "error": String(describing: error)])
                },
                onCancelled: { [weak self] in
                    self?.finish(["status": "cancelled"])
                }
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func finish(_ value: [String: String]) {
        let result = pendingResult
        pendingResult = nil
        result?(value)
    }

    private static func rootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let root = scenes.flatMap(\.windows).first(where: \.isKeyWindow)?.rootViewController
        var visible = root
        while let presented = visible?.presentedViewController {
            visible = presented
        }
        return visible
    }
}

import ReactiveSwift
import Result

// MARK: -
// MARK: Map JSON Response
// MARK: -
extension SignalProducerProtocol where Value == (Data, URLResponse), Error == NetworkError {
    /**
     Attempts to convert `NSData` values (ignore `NSURLResponse`) into `AnyObject` JSON objects.

     - returns: An event stream that sends the result of `NSJSONSerialization.JSONObjectWithData`, or an error.
     */
    func mapJSONResponse() -> SignalProducer<(Any, URLResponse), NetworkError> {
        return attemptMap { (data, response) in
            do {
                let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                return .success(json, response)
            } catch {
                return .failure(.incorrectDataReturned)
            }
        }
    }
}

// MARK: -
// MARK: Map Network Error
// MARK: -
extension SignalProducerProtocol where Error == AnyError {
    /**
     Maps `NSError` into `NetworkError`.

     - returns: An event stream that relies on `NetworkError` types.
     */
    public func mapNetworkError() -> SignalProducer<Value, NetworkError> {
        return mapError { NetworkError(error: $0.error as NSError) }
    }
}


// MARK: -
// MARK: Extension, Signal
// MARK: -
public extension SignalProtocol {
    /**
     Returns a signal that silences any errors.
     */
    
    func ignoreError() -> Signal<Value, NoError> {
        return flatMapError { error in
            return SignalProducer.empty }
    }
}

// MARK: -
// MARK: Extension, Signal Producer
// MARK: -
public extension SignalProducerProtocol {
    /**
     Returns a signal producer that silences any errors.
     */
    
    func ignoreError() -> SignalProducer<Value, NoError> {
        return lift { $0.ignoreError() }
    }
}

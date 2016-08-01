import ReactiveCocoa
import Result

// MARK: -
// MARK: Map JSON
// MARK: -
extension SignalProducerType where Value == NSData, Error == NetworkError {
    /**
     Attempts to convert `NSData` values into `AnyObject` JSON objects.

     - returns: An event stream that sends the result of `NSJSONSerialization.JSONObjectWithData`, or an error.
     */
    func mapJSON() -> SignalProducer<AnyObject, NetworkError> {
        return attemptMap { data -> Result<AnyObject, NetworkError> in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                return .Success(json)
            } catch _ {
                return .Failure(NetworkError.IncorrectDataReturned)
            }
        }
    }
}

// MARK: -
// MARK: Extension, Map Resource JSON
// MARK: -
extension SignalProducerType where Value == [String:AnyObject], Error == NetworkError {
    func mapResourceJSON<R: ResourceJSON>() -> SignalProducer<R, Error> {
        return attemptMap { json -> Result<R, Error> in
            if let resource = R(json) {
                return .Success(resource)
            } else {
                return .Failure(NetworkError.IncorrectDataReturned)
            }
        }
    }
}

// MARK: -
// MARK: Map JSON Response
// MARK: -
extension SignalProducerType where Value == (NSData, NSURLResponse), Error == NetworkError {
    /**
     Attempts to convert `NSData` values (ignore `NSURLResponse`) into `AnyObject` JSON objects.

     - returns: An event stream that sends the result of `NSJSONSerialization.JSONObjectWithData`, or an error.
     */
    func mapJSONResponse() -> SignalProducer<AnyObject, NetworkError> {
        return map { $0.0 }.mapJSON()
    }
}

// MARK: -
// MARK: Map Network Error
// MARK: -
extension SignalProducerType where Error == NSError {
    /**
     Maps `NSError` into `NetworkError`.

     - returns: An event stream that relies on `NetworkError` types.
     */
    public func mapNetworkError() -> SignalProducer<Value, NetworkError> {
        return mapError { NetworkError(error: $0) }
    }
}


// MARK: -
// MARK: Extension, Signal
// MARK: -
public extension SignalType {
    /**
     Returns a signal that silences any errors.
     */
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    func ignoreError() -> Signal<Value, NoError> {
        return flatMapError { error in
            print("An error occurred: ", error)
            return SignalProducer.empty }
    }

    /**
     Try to cast `Value` to some type `T`.
     `nil` if the attempt fails.

     Equivalent to map { $0 as? T }
     */
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    func castTo<T>(_ : T.Type) -> Signal<T?, Error> {
        return map { $0 as? T }
    }
}

// MARK: -
// MARK: Extension, Signal Producer
// MARK: -
public extension SignalProducerType {
    /**
     Returns a signal producer that silences any errors.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { error in
            print("An error occurred: ", error)
            return SignalProducer.empty }
    }

    /**
     Try to cast `Value` to some type `T`.
     `nil` if the attempt fails.

     Equivalent to map { $0 as? T }
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    func castTo<T>(_ : T.Type) -> SignalProducer<T?, Error> {
        return lift { $0.castTo(T) }
    }

    /**
     Only forward `NEXT` values when sampler (or its latest value) is true
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    func filterWhile(sampler: SignalProducer<Bool, NoError>) -> SignalProducer<Value, Error> {
        return combineLatestWith(sampler.promoteErrors(Error)).filter { $0.1 } .map { $0.0 }
    }
}

enum ValidationError: Error {
    case missingFields(String)
}

func throwIfMissing(_ obj: [String: Any], _ keys: [String]) throws {
    let missing = keys.filter { key in
        return obj[key] == nil
    }

    if !missing.isEmpty {
        throw ValidationError.missingFields(
            "Missing required fields: \(missing.joined(separator: ", "))")
    }
}
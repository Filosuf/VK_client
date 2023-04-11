//
//  TokenStorage.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import Foundation

protocol TokenStorageProtocol {
    func saveToken(_ token: ApiToken)

    func getToken() -> ApiToken?

    func removeToken()
}


final class TokenStorage: TokenStorageProtocol {
    // MARK: - Properties
    private let accountName = "accountName"
    private let serviceName = "serviceName"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Methods

    func saveToken(_ token: ApiToken) {
        if getToken() == nil {
            setToken(token)
        } else {
            updateToken(token)
        }
    }

    func getToken() -> ApiToken? {
        return fetchToken()
    }

    func removeToken() {
        deleteToken()
    }

    // MARK: - Private methods
private func setToken(_ token: ApiToken) {
    // Convert ApiToken to Data.
    guard let tokenData =  try? encoder.encode(token) else {
        print("Невозможно получить данные типа Data")
        return
    }

    // Создаем атрибуты для хранения файла.
    let attributes = [
        kSecClass: kSecClassGenericPassword,
        kSecValueData: tokenData,
        kSecAttrAccount: accountName,
        kSecAttrService: serviceName,
    ] as CFDictionary

    // Добавляем новую запись в Keychain. nil - указатель на объекты, которые были добавлены в базу данных Keychain.
    let status = SecItemAdd(attributes, nil)

    guard status == errSecSuccess else {
        print("Невозможно добавить токен, ошибка номер: \(status).")
        return
    }

    print("Токен добавлен успешно.")
}

private func fetchToken() -> ApiToken? {
    // Создаем поисковые атрибуты.
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: true
    ] as CFDictionary

    // Объявляем ссылку на объект, которая в будущем будет указывать на полученную запись Keychain.
    var extractedData: AnyObject?
    // Запрашиваем запись в Keychain.
    let status = SecItemCopyMatching(query, &extractedData)

    guard status != errSecItemNotFound else {
        print("Токен не найден в Keychain.")
        return nil
    }

    guard status == errSecSuccess else {
        print("Невозможно получить токен, ошибка номер: \(status).")
        return nil
    }

    guard let tokenData = extractedData as? Data,
          let token = try? decoder.decode(ApiToken.self, from: tokenData) else {
        print("Невозможно преобразовать Data в токен.")
        return nil
    }

    return token
}

private func updateToken(_ token: ApiToken) {
    // Переводим токен в объект типа Data.
    guard let tokenData = try? encoder.encode(token) else {
        print("Невозможно получить Data из токена.")
        return
    }

    // Создаем поисковые атрибуты.
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: false // Не обязательно, false по-умолчанию.
    ] as CFDictionary

    let attributesToUpdate = [
        kSecValueData: tokenData,
    ] as CFDictionary

    let status = SecItemUpdate(query, attributesToUpdate)

    guard status == errSecSuccess else {
        print("Невозможно обновить токен, ошибка номер: \(status).")
        return
    }

    print("Токен обновлен успешно.")
}

private func deleteToken() {
    // Создаем поисковые атрибуты
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: false  // Не обязательно, false по-умолчанию.
    ] as CFDictionary

    let status = SecItemDelete(query)

    guard status == errSecSuccess else {
        print("Невозможно удалить токен, ошибка номер: \(status).")
        return
    }

    print("Токен удален успешно.")
}


private func decodeStatus(_ status: OSStatus) {
    switch status {
    case errSecSuccess:
        print("Keychain Status: No error.")
    case errSecUnimplemented:
        print("Keychain Status: Function or operation not implemented.")
    case errSecIO:
        print("Keychain Status: I/O error (bummers)")
    case errSecOpWr:
        print("Keychain Status: File already open with with write permission")
    case errSecParam:
        print("Keychain Status: One or more parameters passed to a function where not valid.")
    case errSecAllocate:
        print("Keychain Status: Failed to allocate memory.")
    case errSecUserCanceled:
        print("Keychain Status: User canceled the operation.")
    case errSecBadReq:
        print("Keychain Status: Bad parameter or invalid state for operation.")
    case errSecInternalComponent:
        print("Keychain Status: Internal Component")
    case errSecNotAvailable:
        print("Keychain Status: No keychain is available. You may need to restart your computer.")
    case errSecDuplicateItem:
        print("Keychain Status: The specified item already exists in the keychain.")
    case errSecItemNotFound:
        print("Keychain Status: The specified item could not be found in the keychain.")
    case errSecInteractionNotAllowed:
        print("Keychain Status: User interaction is not allowed.")
    case errSecDecode:
        print("Keychain Status: Unable to decode the provided data.")
    case errSecAuthFailed:
        print("Keychain Status: The user name or passphrase you entered is not correct.")
    default:
        print("Keychain Status: Unknown. (\(status))")
    }
}

}

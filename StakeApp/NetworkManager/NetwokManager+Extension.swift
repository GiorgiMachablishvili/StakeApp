import UIKit
import Alamofire

extension NetworkManager {
    func updateUserProfile(userId: Int, image: UIImage?, nickname: String?, completion: @escaping (Result<UserDataResponse>) -> Void) {
        let url = "https://bovagames.fun/users/\(userId)"

        // Convert the image to Data
        var imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 0.8)
        }

        // Prepare the multipart form data
        AF.upload(
            multipartFormData: { multipartFormData in
                if let imageData = imageData {
                    multipartFormData.append(imageData, withName: "user_image", fileName: "profile.jpg", mimeType: "image/jpeg")
                }
                if let nickname = nickname {
                    multipartFormData.append(Data(nickname.utf8), withName: "user_name")
                }
            },
            to: url,
            method: .patch
        )
        .validate()
        .responseDecodable(of: UserDataResponse.self) { response in
            switch response.result {
            case .success(let userData):
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

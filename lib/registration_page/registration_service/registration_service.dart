import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterService {
  final String baseUrl = "http://localhost:5000/api";

  Future<bool> registerDriverAndVehicle({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String username,
    required String dateOfBirth, // should be YYYY-MM-DD
    File? profileImage,
    // Vehicle fields
    required String vehicleBrand,
    required String vehicleModel,
    required String vehicleColor,
    required String productionYear,
    required String numberPlate,
    required String luggage,
    required String passengers,
    required String flatRate,
    required String pricePerKm,
    List<File>? carImages,
  }) async {
    try {
      final driverId = await _registerDriver(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        username: username,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
      );

      if (driverId == null) return false;

      final vehicleSuccess = await _registerVehicle(
        driverId: driverId,
        vehicleBrand: vehicleBrand,
        vehicleModel: vehicleModel,
        vehicleColor: vehicleColor,
        productionYear: productionYear,
        numberPlate: numberPlate,
        luggage: luggage,
        passengers: passengers,
        flatRate: flatRate,
        pricePerKm: pricePerKm,
        carImages: carImages,
        username: username,
      );

      return vehicleSuccess;
    } catch (e) {
      print("❌ Error in registerDriverAndVehicle: $e");
      return false;
    }
  }

  Future<int?> _registerDriver({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String username,
    required String dateOfBirth,
    File? profileImage,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/driver/register"),
    );

    request.fields.addAll({
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "confirmPassword": confirmPassword,
      "username": username,
      "dateOfBirth": dateOfBirth, // send as YYYY-MM-DD
    });

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "profilePicture", // must match backend field name
        profileImage.path,
      ));
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("Driver API Response: $respStr");

    if (response.statusCode == 200) {
      final data = jsonDecode(respStr);
      return data["driver"]?["id"] ?? data["id"]; // flexible extraction
    } else {
      print("❌ Driver register failed: $respStr");
      return null;
    }
  }

  Future<bool> _registerVehicle({
    required String username,
    required int driverId,
    required String vehicleBrand,
    required String vehicleModel,
    required String vehicleColor,
    required String productionYear,
    required String numberPlate,
    required String luggage,
    required String passengers,
    required String flatRate,
    required String pricePerKm,
    List<File>? carImages,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/vehicle/add/$username"),
    );

    request.fields.addAll({
      "driver_id": driverId.toString(),
      "vehicleBrand": vehicleBrand,
      "vehicleModel": vehicleModel,
      "vehicleColor": vehicleColor,
      "productionYear": productionYear,
      "numberPlate": numberPlate,
      "luggage": luggage,
      "passengers": passengers,
      "flat_rate": flatRate,
      "pricePerKm": pricePerKm,
    });

    if (carImages != null && carImages.isNotEmpty) {
      for (var img in carImages) {
        request.files.add(await http.MultipartFile.fromPath(
          "carImages[]", // safer for arrays
          img.path,
        ));
      }
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("Vehicle API Response: $respStr");

    if (response.statusCode == 200) {
      return true;
    } else {
      print("❌ Vehicle register failed: $respStr");
      return false;
    }
  }
}

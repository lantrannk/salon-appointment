const String apiUrl = 'https://63ab8e97fdc006ba60609b9b.mockapi.io';

const String userUrl = '$apiUrl/users';

const String appointmentUrl = '$apiUrl/appointments';

const Map<String, String> headers = {'Content-Type': 'application/json'};

const List<String> allServices = [
  'Back',
  'Neck & Shoulders',
  'Non-Invasive Body Contouring',
];

const String phoneNumberRegExpPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';

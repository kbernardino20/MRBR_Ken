import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue],
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Meeting Room Booking Reservation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login(title: 'Login App')),
                  );
                },
                child: const Text('Let\'s Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center( // Wrap the Container with a Center widget
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (emailController.text == "kenBernardino@gmail.com" &&
                          passwordController.text == "123456789") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BookingPage(
                                    email: emailController.text)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid credentials")));
                      }
                    }
                  },
                  child: const Text('Log in'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: const Text('Don\'t have an account? Register here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final String email;

  BookingPage({Key? key, required this.email}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController purposeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int numberOfPeople = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve a Meeting Room'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center( // Wrap the Column with a Center widget
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Align content to the center
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Welcome, ${widget.email}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Align content to the center
                  children: [
                    Expanded(child: Text('No. of Pax *')),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (numberOfPeople > 1) numberOfPeople--;
                        });
                      },
                    ),
                    Text('$numberOfPeople'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          numberOfPeople++;
                        });
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text('Date *: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text('Time *: ${selectedTime.format(context)}'),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null && picked != selectedTime) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                ),
                TextField(
                  controller: purposeController,
                  decoration: InputDecoration(labelText: 'Purpose'),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to RoomList widget passing necessary parameters
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomList(
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          numberOfPeople: numberOfPeople,
                          purpose: purposeController.text,
                        ),
                      ),
                    );
                  },
                  child: const Text('Find a room'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to Profile screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen (),
                          ),
                        );
                      },
                      child: Text('Profile'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Notification screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Text('Notification'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Perform logout operation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                        );
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RoomList extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int numberOfPeople;
  final String purpose;

  RoomList({
    required this.selectedDate,
    required this.selectedTime,
    required this.numberOfPeople,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            _buildRoomSection(context, "Conference Rooms", [
              Room(name: "Conference Room A", description: "Ideal for large meetings", capacity: 10),
              Room(name: "Conference Room B", description: "Equipped with multimedia facilities", capacity: 8),
              Room(name: "Conference Room C", description: "Suitable for workshops and seminars", capacity: 12),
            ]),
            _buildRoomSection(context, "Board Rooms", [
              Room(name: "Board Room X", description: "Executive board room with modern decor", capacity: 6),
              Room(name: "Board Room Y", description: "Perfect for high-level strategy meetings", capacity: 8),
            ]),
            _buildRoomSection(context, "Training Rooms", [
              Room(name: "Training Room 1", description: "Spacious room for educational sessions", capacity: 20),
              Room(name: "Training Room 2", description: "Equipped with projectors and whiteboards", capacity: 15),
            ]),
            _buildRoomSection(context, "Small Meeting Rooms", [
              Room(name: "Meeting Room 101", description: "Cozy room for intimate discussions", capacity: 4),
              Room(name: "Meeting Room 102", description: "Quiet space for brainstorming sessions", capacity: 6),
            ]),
            _buildRoomSection(context, "Virtual Meeting Rooms", [
              Room(name: "Virtual Room Alpha", description: "Connect with remote participants seamlessly", capacity: 20),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSection(BuildContext context, String title, List<Room> rooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return ListTile(
              title: Text(room.name),
              subtitle: Text(room.description),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to the BookingConfirmation widget when the "Book" button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirmation(
                        bookedRoom: room,
                        bookingDate: selectedDate,
                        bookingTime: selectedTime,
                        numberOfPeople: numberOfPeople,
                        purpose: purpose,
                      ),
                    ),
                  );
                },
                child: Text('Book'),
              ),
            );
          },
        ),
        Divider(),
      ],
    );
  }
}

class Room {
  final String name;
  final String description;
  final int capacity;

  Room({
    required this.name,
    required this.description,
    required this.capacity,
  });
}

class BookingConfirmation extends StatelessWidget {
  final Room bookedRoom;
  final DateTime bookingDate;
  final TimeOfDay bookingTime;
  final int numberOfPeople;
  final String purpose;

  BookingConfirmation({
    required this.bookedRoom,
    required this.bookingDate,
    required this.bookingTime,
    required this.numberOfPeople,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room: ${bookedRoom.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Description: ${bookedRoom.description}'),
              SizedBox(height: 8),
              Text('Capacity: ${bookedRoom.capacity}'),
              SizedBox(height: 16),
              Text('Date: ${bookingDate.day}/${bookingDate.month}/${bookingDate.year}'),
              SizedBox(height: 8),
              Text('Time: ${bookingTime.hour}:${bookingTime.minute}'),
              SizedBox(height: 8),
              Text('Number of People: $numberOfPeople'),
              SizedBox(height: 16),
              Text('Purpose:'),
              Text(purpose),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigate to ConfirmBookingForm after confirming the booking
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmBookingForm(),
                    ),
                  );
                },
                child: Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmBookingForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Booking'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thank you, your booking has been confirmed',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the BookingPage
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingPage(email: "kenBernardino@gmail.com")));
                },
                child: Text('Back to Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            _buildBookedRoomSection(context, "Upcoming Bookings", [
              BookedRoom(
                roomName: "Conference Room A",
                date: "01/06/2024",
                time: "10:00 AM",
                purpose: "Team Meeting",
              ),
              BookedRoom(
                roomName: "Board Room X",
                date: "02/06/2024",
                time: "11:30 AM",
                purpose: "Presentation",
              ),
            ]),
            _buildBookedRoomSection(context, "Past Bookings", [
              BookedRoom(
                roomName: "Training Room 1",
                date: "03/04/2024",
                time: "09:00 AM",
                purpose: "Training Session",
              ),
            ]),
            _buildBookedRoomSection(context, "Cancelled Bookings", [
              BookedRoom(
                roomName: "Virtual Room Beta",
                date: "28/05/2024",
                time: "02:00 PM",
                purpose: "Webinar",
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBookedRoomSection(BuildContext context, String title, List<BookedRoom> bookedRooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bookedRooms.length,
          itemBuilder: (context, index) {
            final bookedRoom = bookedRooms[index];
            return ListTile(
              title: Text(bookedRoom.roomName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${bookedRoom.date}'),
                  Text('Time: ${bookedRoom.time}'),
                  Text('Purpose: ${bookedRoom.purpose}'),
                ],
              ),
              trailing: title != "Cancelled Bookings" && _isUpcomingBooking(bookedRoom.date)
                  ? ElevatedButton(
                      onPressed: () {
                        // Navigate to CancelledBookingDetails screen with bookedRoom details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CancelledBookingDetails(bookedRoom: bookedRoom),
                          ),
                        );
                      },
                      child: Text('Cancel'),
                    )
                  : null,
            );
          },
        ),
        Divider(),
      ],
    );
  }

  bool _isUpcomingBooking(String bookingDate) {
    // Compare booking date with current date to determine if it's upcoming
    DateTime currentDate = DateTime.now();
    DateTime parsedBookingDate = DateFormat('dd/MM/yyyy').parse(bookingDate);
    return parsedBookingDate.isAfter(currentDate);
  }
}

class BookedRoom {
  final String roomName;
  final String date;
  final String time;
  final String purpose;

  BookedRoom({
    required this.roomName,
    required this.date,
    required this.time,
    required this.purpose,
  });
}

class CancelledBookingDetails extends StatelessWidget {
  final BookedRoom bookedRoom;

  CancelledBookingDetails({required this.bookedRoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room: ${bookedRoom.roomName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Date: ${bookedRoom.date}'),
                Text('Time: ${bookedRoom.time}'),
                Text('Purpose: ${bookedRoom.purpose}'),
                SizedBox(height: 24),
                Text(
                  'This booking is now cancelled.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingPage(email: "kenBernardino@gmail.com")));
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email: kenBernardino@gmail.com',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Full Name: Kenneth Isaac Bernardino'),
                Text('Employee Number: 12300309'),
                Text('Department: IT'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingPage(email: "kenBernardino@gmail.com")));
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController employeeNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Full Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: employeeNumberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Employee Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your employee number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Department"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your department';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform registration logic
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
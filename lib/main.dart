import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Kegiatan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  // Daftar kegiatan
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Kegiatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.blue),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayTextStyle: TextStyle(color: Colors.blue),
                defaultTextStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Kegiatan pada tanggal: ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventPage(
                      selectedDate: _selectedDay,
                      // Menyampaikan daftar kegiatan ke halaman "Tambah Kegiatan"
                      events: _events,
                      // Fungsi untuk menambah kegiatan ke dalam daftar
                      addEvent: (String event, DateTime date) {
                        setState(() {
                          _events.add({'kegiatan': event, 'tanggal': date});
                        });
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add, size: 20),
              label: Text('Tambah Kegiatan', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.blue.shade700,
                elevation: 5,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.black,
                child: ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    final String kegiatan = event['kegiatan'];
                    final DateTime tanggal = event['tanggal'];

                    return Dismissible(
                      key: Key('$kegiatan-$tanggal'),
                      onDismissed: (direction) {
                        setState(() {
                          _events.removeAt(index);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '$kegiatan - ${tanggal.day}/${tanggal.month}/${tanggal.year}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: const Color.fromARGB(255, 180, 0, 0)),
                              onPressed: () {
                                setState(() {
                                  _events.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventPage extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> events; // Daftar kegiatan
  final Function(String, DateTime)
      addEvent; // Fungsi untuk menambah kegiatan ke dalam daftar

  const AddEventPage({
    Key? key,
    required this.selectedDate,
    required this.events,
    required this.addEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String kegiatan = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kegiatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tambahkan kegiatan:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                kegiatan = value;
              },
              decoration: InputDecoration(
                labelText: 'Kegiatan',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 164, 138, 255),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Menambah kegiatan ke dalam daftar
                addEvent(kegiatan, selectedDate);
                // Kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text('Simpan Kegiatan', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

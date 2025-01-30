import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdstock/themes/app_theme.dart';
import 'package:gdstock/widgets/image_card.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/disbursement_record.dart';
import 'utils/util_method.dart';
import 'screens/app_info.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme, // 라이트 테마 적용
      darkTheme: AppTheme.darkTheme, // 다크 테마 적용
      themeMode: ThemeMode.system, // 시스템 설정에 따라 변경
      home: const InventoryPage(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late String _currentTime;
  late Timer _timer;
  int _sample1Count = 0;
  int _sample2Count = 0;
  String _selectedDepartment = "3W"; // 기본 부서
  final List<DisbursementRecord> _disbursementRecords = [];

  @override
  void initState() {
    super.initState();
    _currentTime = getFormattedTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = getFormattedTime();
      });
    });
    _loadDisbursementRecords(); // 저장된 기록 로드
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _addDisbursementRecord(
      String department, int sample1Count, int sample2Count) async {
    final record = DisbursementRecord(
      department: department,
      dateTime: DateTime.now(),
      sample1Count: sample1Count,
      sample2Count: sample2Count,
      otherItem: '없음',
    );
    if (mounted) {
      setState(() {
        _disbursementRecords.add(record);
      });
    }
    await _saveDisbursementRecords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("불출 기록이 저장되었습니다.")),
      );
    }
  }

  Future<void> _addOtherItemRecord(
      String department, int sample1Count, int sample2Count, String otherItem) async {
    final record = DisbursementRecord(
      department: department,
      dateTime: DateTime.now(),
      sample1Count: 0,
      sample2Count: 0,
      otherItem: otherItem,
    );
    if (mounted) {
      setState(() {
        _disbursementRecords.add(record);
      });
    }
    await _saveDisbursementRecords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("불출 기록이 저장되었습니다.")),
      );
    }
  }

  Future<void> _deleteDisbursementRecord(DisbursementRecord record) async {
    setState(() {
      _disbursementRecords.remove(record);
    });
    await _saveDisbursementRecords(); // 데이터 저장
  }

  // SharedPreferences에 데이터 저장
  Future<void> _saveDisbursementRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonRecords = _disbursementRecords
        .map((record) => jsonEncode(record.toJson()))
        .toList();
    await prefs.setStringList('disbursementRecords', jsonRecords);
  }

  // SharedPreferences에서 데이터 로드
  Future<void> _loadDisbursementRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonRecords =
      prefs.getStringList('disbursementRecords');

    if (jsonRecords != null) {
      setState(() {
        _disbursementRecords.addAll(
          jsonRecords
              .map((record) => DisbursementRecord.fromJson(jsonDecode(record))),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키패드가 나타날 때 화면 크기 변경을 방지
      appBar: AppBar(
        toolbarHeight: 70, // 원하는 높이 지정 (기본값은 56)
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // 아래쪽 여백 추가
            child: Image.asset(
              'assets/gm_gd_KR.png',
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                "3W",
                "ICU",
                "5W",
                "6W",
                "7W",
                "일반검진",
                "출장검진",
                "종합검진",
                "진단검진",
                "ER",
                "주사실",
                "AK",
                "약제팀"
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(choice),
                      IconButton(
                        icon: Icon(Icons.add, size: 20, color: Colors.black),
                        onPressed: () {
                          _showAddItemDialog(choice);
                        },
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/gm_gd_black.png',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("불출 기록"),
              onTap: () {
                Navigator.pop(context);
                _showDisbursementRecords(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("정보"),
              onTap: () {
                Navigator.pop(context);
                showAppInfo(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    _selectedDepartment,
                    key: ValueKey(_selectedDepartment),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800, // 세련된 색상 적용
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15), // 더 넉넉한 간격
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    _currentTime,
                    key: ValueKey(_currentTime),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent.shade700, // 더 강조된 색상
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ImageCard(
                  imagePath: 'assets/sample_1.jpg',
                  count: _sample1Count,
                  onUpdate: (value) {
                    setState(() {
                      _sample1Count = (_sample1Count + value).clamp(0, 999);
                    });
                  },
                  label: '혈액라벨',
                  color: Colors.red,
                ),
                const SizedBox(width: 16),
                ImageCard(
                  imagePath: 'assets/sample_2.jpg',
                  count: _sample2Count,
                  onUpdate: (value) {
                    setState(() {
                      _sample2Count = (_sample2Count + value).clamp(0, 999);
                    });
                  },
                  label: '수액라벨',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _addDisbursementRecord(
                _selectedDepartment,
                _sample1Count,
                _sample2Count,
              );

              setState(() {
                _sample1Count = 0;
                _sample2Count = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("불출 기록이 저장되었습니다.")),
              );
            },
            child: const Text("불출하기"),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  void _showDisbursementRecords(BuildContext context) {
    final Map<String, List<DisbursementRecord>> groupedRecords = {};
    for (final record in _disbursementRecords) {
      groupedRecords.putIfAbsent(record.department, () => []).add(record);
    }
    groupedRecords.forEach((department, records) {
      records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: const Text(
              "부서별 불출 기록",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // 제목 색상
              ),
            ),
          ),
          content: SizedBox(
            height: 400,
            width: double.maxFinite,
            child: ListView(
              children: groupedRecords.entries.map((entry) {
                int totalSample1Count = 0;
                int totalSample2Count = 0;

                for (var record in entry.value) {
                  totalSample1Count += record.sample1Count;
                  totalSample2Count += record.sample2Count;
                }
                return Card(  // 카드로 배경을 개선
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 모서리
                  ),
                  elevation: 5, // 그림자 효과
                  child: ExpansionTile(
                    title: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // 부서 이름 색상
                      ),
                    ),
                    subtitle: Text(
                      "혈액라벨: $totalSample1Count개, 수액라벨: $totalSample2Count개",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey, // 총합 색상
                      ),
                    ),
                    shape: Border(), // 테두리 제거
                    children: entry.value.map((record) {
                      String formattedDate = record.dateTime.toString().split('.')[0]; // 마이크로초 제거

                      return ListTile(
                        title: Text(
                          // Check if otherItem is '없음', then show only blood and IV labels
                          record.otherItem == '없음'
                              ? "혈액라벨: ${record.sample1Count}개, 수액라벨: ${record.sample2Count}개"
                              : "기타: ${record.otherItem}", // Otherwise show the otherItem
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // 샘플 개수 색상
                          ),
                        ),
                        subtitle: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600], // 날짜 색상
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showPasswordDialog(context, record);
                          },
                        ),
                      );
                    }).toList(),
                  ),

                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "닫기",
                style: TextStyle(
                  color: Colors.blue, // 닫기 버튼 색상
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context, DisbursementRecord record) {
    final TextEditingController passwordController = TextEditingController();
    const String adminPassword = "8954";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("관리자 비밀번호 입력"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "비밀번호",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text == adminPassword) {
                  _deleteDisbursementRecord(record);
                  Navigator.pop(context); // 비밀번호 팝업 닫기
                  Navigator.pop(context); // 기존 다이얼로그 닫기
                  _showDisbursementRecords(context); // 새 다이얼로그 열기
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("비밀번호가 일치하지 않습니다."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemDialog(String department) {
    TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$department - 기타 불출품 입력'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: "Ex) 키보드 1개 , 마우스 1개"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                String newItem = textController.text.trim();
                if (newItem.isNotEmpty) {
                  _addOtherItemRecord(
                      department, _sample1Count, _sample2Count, newItem);
                  Navigator.of(context).pop(); // 입력 후 닫기
                }
              },
              child: Text("추가"),
            ),
          ],
        );
      },
    );
  }
}

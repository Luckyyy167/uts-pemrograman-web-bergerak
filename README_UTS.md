Nama: Lucky Dwi Darmawan
NIM: 362558302010
Kelas: 2E Teknologi Rekayasa Perangkat Lunak

Hasil Jawaban Saya
1. Halaman daftar ditampilkan oleh `TaskListScreen` yang menggunakan `LayoutBuilder` untuk mendeteksi lebar layar. Jika lebar kurang dari 700 px (ukuran telepon), task ditampilkan dalam satu kolom. Jika lebar 700 px atau lebih (tablet), task ditampilkan dalam dua kolom menggunakan `GridView.builder` dengan `crossAxisCount: 2`.
Di bagian atas halaman terdapat `_SummaryCard` yang menampilkan ringkasan jumlah total tugas, jumlah belum selesai, dan jumlah selesai. Bila belum ada tugas, ditampilkan *empty state* berupa ikon dan teks "Belum ada tugas". Setiap kartu tugas menampilkan judul, mata kuliah, dan status selesai/belum.
Untuk mencegah overflow pada layar sempit, layout menggunakan `SafeArea` dan `GridView` tanpa teks yang dipaksakan melebar.
2. Form tambah tugas ada di `TaskFormScreen`. Form menggunakan `GlobalKey<FormState>` dan dua `TextFormField` untuk judul dan mata kuliah. Validasi dilakukan dengan `validator` yang memeriksa apakah nilai setelah `.trim()` kosong — artinya nilai yang hanya berisi spasi tetap dianggap tidak valid. 
Navigasi dibuka menggunakan `Navigator.push<Task>` dari halaman daftar. Saat tombol **Simpan** ditekan, data Task dikembalikan ke halaman daftar melalui `Navigator.pop(context, task)`. Saat tombol **Batal** ditekan, `Navigator.pop(context)` dipanggil tanpa argumen sehingga daftar tidak berubah.
3. State dikelola menggunakan `setState` di dalam `_TaskListScreenState`. Saat tugas baru ditambahkan (`_addTask`), tugas langsung ditambahkan ke awal list dan `setState` dipanggil agar UI langsung diperbarui tanpa reload.
Untuk menandai tugas selesai/belum, method `_toggleTask` membuat list baru dengan `map` dan `copyWith`, lalu memanggil `setState` dan `_storage.save`. Perubahan status langsung terlihat pada kartu dan ringkasan karena keduanya bergantung pada `_tasks` dan `_completedCount` yang merupakan getter reaktif.
4. Pemuatan data dilakukan secara asynchronous di `_loadTasks()`. Selama proses berlangsung, variabel `_isLoading = true` menyebabkan UI menampilkan `CircularProgressIndicator`. Setelah selesai:

- Jika berhasil → daftar tugas atau *empty state* ditampilkan.
- Jika `FormatException` → pesan error dari exception ditampilkan beserta tombol **Coba Lagi**.
- Jika error lain → pesan umum `'Data tugas gagal dimuat. Coba lagi.'` ditampilkan.

Tombol **Coba Lagi** memanggil ulang `_loadTasks()` sehingga loading cycle dimulai dari awal. Simulasi error tersedia melalui `PopupMenuButton` → "Simulasikan error saat memuat", yang menyetel `_simulateNextError = true` lalu memanggil `_storage.load(simulateError: true)` yang melempar `FormatException`.
5. ersistensi diimplementasikan di `TaskStorage` menggunakan `SharedPreferences` dan JSON:

- **`toJson()`** di `Task` — mengonversi objek Task menjadi `Map<String, Object?>` berisi `id`, `title`, `course`, dan `isDone`.
- **`fromJson()`** di `Task` — mem-parse Map hasil `jsonDecode` kembali menjadi objek Task dengan fallback aman (`as String? ?? ''`, `as bool? ?? false`).
- **`load()`** — membaca String JSON dari SharedPreferences dengan key `'task'`, mendekode dengan `jsonDecode`, lalu membangun list Task dengan `Task.fromJson`.
- **`save()`** — mengonversi seluruh list Task ke JSON dengan `jsonEncode`, lalu menyimpan ke SharedPreferences. Memeriksa nilai bool dari `setString`; melempar `FormatException` bila gagal.
- **`clear()`** — memanggil `prefs.remove('task')` untuk menghapus data dari penyimpanan persisten.

Data tetap tersedia setelah aplikasi ditutup dan dibuka kembali karena dibaca ulang dari SharedPreferences di `initState` → `_loadTasks()`.

## Cara Menjalankan Aplikasi
- cd starter-uts
- flutter pub get
- flutter run

## Hasil pengerjaan 
- Telephone (Device Iphone 17 Pro) : Jalankan di emulator dengan lebar ≤ 360 px (misal Pixel 4) → kartu tampil satu kolom.
- Bukti:![Hasil Device Telephone.png](screenshot/Hasil%20Device%20Telephone.png)

Tablet (Ipad Mini A17 pro) : Jalankan di emulator tablet (misal iPad Pro, lebar ≥ 700 px) → kartu tampil dua kolom.
-Bukti: ![Hasil Device Tablet.png](screenshot/Hasil%20Device%20Tablet.png)

## Hasil 'Flutter Analyze'
uckydwidarmawan@MacBook-Air-Lucky starter-uts % flutter analyze
Analyzing starter-uts...                                                
No issues found! (ran in 1.4s)
Screenshot:




# nawalapatra_mobile
[![Build status](https://build.appcenter.ms/v0.1/apps/8d981f8f-5d92-4fbb-8b10-f53adcd1601d/branches/main/badge)](https://appcenter.ms)
Website NawalaPatra : [NawalaPatra](https://nawalapatra.pythonanywhere.com/)

## *Anggota Kelompok E-12*

- Alma Putri Nashrida (2206814671)
- Azka Nydia Estiningtyas (2206028970)
- Natanael Bonaparte Halomoan Nababan (2206828310)
- Naufal Aulia (2206082455)
- Mochammad Wahyu Suryansyah (2206083142)


## *Latar Belakang*

Nawala Patra adalah aplikasi daring yang dibuat untuk membantu misi Kongres Bahasa Indonesia XII yaitu “Literasi dalam Kebhinekaan untuk Kemajuan Bangsa.” Nawala Patra sendiri berasal dari bahasa sansekerta yang artinya tulisan atau karangan. Aplikasi ini memiliki cakupan tidak hanya user sebagai pembaca, tetapi user dapat mengunggah buku atau karangannya sendiri sebagai penulis. User juga dapat menyarankan ataupun me-request buku yang user inginkan. Selain itu, kami sangat meyakini user sangat ingin berdiskusi terkait buku yang mereka baca. Maka kami menyediakan sebuah forum diskusi mengenai topik yang user inginkan. User dapat membuka topik, ataupun merespon topik yang user lain buka.


## *Dataset*

Nawala Patra menggunakan dataset pada link [berikut.](https://github.com/uchidalab/book-dataset/blob/master/Task1/book30-listing-test.csv)


## *Daftar Modul*

Nawala Patra memiliki beberapa modul yaitu:

### 🏛️ Library 🏛️
Berisi kumpulan-kumpulan buku yang tersedia pada Nawala Patra. User dapat mencari buku yang diinginkan dengan menggunakan fitur search yang tersedia. User Login dapat menggunakan fitur bookmark buku untuk menyimpan buku pilihannya.


### 📚 MyBooks 📚
Berisi kumpulan-kumpulan buku yang sudah disimpan menggunakan fitur bookmark dan buku-buku yang sudah di-publish. Hanya User Login yang dapat mengakses modul MyBooks.


### 🎖️ LeaderBoard 🎖️
Menampilkan sebuah LeaderBoard Buku berdasarkan voting dari User Login. User Guest hanya bisa melihat LeaderBoard tanpa bisa melakukan voting.


### 🧵 Discussion Forum 🧵
Menampilkan forum-forum diskusi yang dibuat/dimulai oleh User Login. Forum diskusi bisa membahas spesifik suatu buku atau sekedar topik-topik mengenai literasi. User Guest hanya bisa membaca dan melihat diskusi yang tersedia tanpa bisa ikut andil dalam forum yang tersedia. 


### 🧩 Writer’s Jam 🧩
Sebuah section dimana User Login dapat melakukan submisi karya atau buku setiap minggunya. Pada bagian ini, terdapat tema-tema yang berbeda tiap minggu yang akan berubah secara otomatis. User Guest hanya bisa melihat karya yang ditampilkan, tidak bisa melakukan submisi.



## *Role dan Peran pengguna*

| Fitur | User (Logged in) | Guest |
| - | - | - |
| Library |  Dapat menggunakan fitur search dan add bookmark. Dapat melakukan request buku untuk ditambahkan | Hanya bisa menggunakan fitur search buku. |
| MyBooks | Dapat lihat buku yang sedang atau selesai dibaca dan melihat karya sendiri. | Tidak dapat mengakses MyBooks. |
| LeaderBoard | Bisa melihat semua leaderboard dan berpartisipasi dalam poll/voting (memberi suara). | Hanya bisa melihat leaderboard ranking atas saja dan tidak dapat berpartisipasi dalam poll/voting. |
| Discussion Forum | Dapat membaca dan berpartisipasi dalam diskusi di comment section seperti memulai diskusi atau me-reply sebuah diskusi. | Tidak dapat mengakses forum |
| Writer's Jam | Dapat mengunggah karya pada prompt yang diberikan di minggu tersebut | Dapat melihat prompt minggu ini dan karya penulis, tetapi tidak bisa  berpartisipasi dalam writer's jam. |


## *Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester*

1. Pertama, kita perlu melakukan setup autentikasi pada Django untuk Flutter dengan membuat django-app authentication dan menambahkan dependency http ke dalam proyek untuk memungkinkan pertukaran data melalui HTTP request.
2. Membuat model sesuai dengan respons yang diterima dari data yang berasal dari layanan web. Model ini dirancang agar sesuai dengan struktur data JSON yang diperoleh.
3. Dengan menggunakan dependensi http, kami melakukan pengambilan data dari layanan web menggunakan metode HTTP GET.
4. Melakukan konversi data di mana data JSON yang diterima dikonversikan ke dalam objek Dart yang sesuai dengan model yang telah kami buat sebelumnya.
5. Menggunakan widget FutureBuilder untuk menampilkan data dengan efisien. Widget ini memungkinkan kami untuk menangani proses asynchronous dan menampilkan data dengan baik di dalam aplikasi kami.
6. Mengimplementasikan autentikasi menggunakan package pbp_django_auth. Langkah ini memastikan bahwa pengguna hanya dapat mengakses fitur tertentu setelah berhasil melakukan autentikasi.
7. Memodifikasi root widget untuk menyediakan CookieRequest library ke semua child widgets dengan menggunakan Provider yang bertujuan untuk membuat objek Provider baru yang akan membagikan instance CookieRequest dengan semua komponen yang ada di aplikasi.


## *Menambahkan tautan berita acara ke README.md*

Berita Acara kami dapat dilihat melalui link [berikut.](https://docs.google.com/spreadsheets/d/1DGLs_WakaCFOlIHw1fgt20vvZ-bWXzsQ/edit?usp=sharing&ouid=105632398927722211424&rtpof=true&sd=true)

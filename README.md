# Ditonton - Flutter Expert Project

[![CI](https://github.com/your-username/a199-flutter-expert-project/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/a199-flutter-expert-project/actions/workflows/ci.yml)

Repository ini merupakan submission kelas Flutter Expert Dicoding Indonesia — aplikasi **Ditonton** untuk menampilkan daftar film dan serial TV dari The Movie Database (TMDB).

## Fitur

- **Movies**: Now Playing, Popular, Top Rated, Detail, Search, Watchlist
- **TV Series**: Now Playing, Popular, Top Rated, Detail, Season & Episode, Search, Watchlist
- **State Management**: flutter_bloc (BLoC pattern)
- **SSL Pinning**: Koneksi HTTP ke TMDB API dilindungi dengan SSL certificate pinning
- **Firebase**: Analytics & Crashlytics terintegrasi
- **CI/CD**: GitHub Actions otomatis menjalankan test dan coverage

---

## Tips Submission Awal

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan. Karena kriteria pada submission ini akan diperiksa setelah seluruh berkas testing berhasil dijalankan.


## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas `test.sh` pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui *terminal* atau *command prompt*. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:
1. Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.
    - Bagi pengguna **Linux**, jalankan perintah berikut pada terminal.
        ```
        sudo apt-get update -qq -y
        sudo apt-get install lcov -y
        ```
    
    - Bagi pengguna **Mac**, jalankan perintah berikut pada terminal.
        ```
        brew install lcov
        ```
    - Bagi pengguna **Windows**, ikuti langkah berikut.
        - Install [Chocolatey](https://chocolatey.org/install) pada komputermu.
        - Setelah berhasil, install [lcov](https://community.chocolatey.org/packages/lcov) dengan menjalankan perintah berikut.
            ```
            choco install lcov
            ```
        - Kemudian cek **Environtment Variabel** pada kolom **System variabels** terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
            | Variable | Value|
            | ----------- | ----------- |
            | GENTHTML | C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml |
            | LCOV_HOME | C:\ProgramData\chocolatey\lib\lcov\tools |
        
2. Untuk mempermudah proses verifikasi testing, jalankan perintah berikut.
    ```
    git init
    ```
3. Kemudian jalankan berkas `test.sh` dengan perintah berikut pada *terminal* atau *powershell*.
    ```
    test.sh
    ```
    atau
    ```
    ./test.sh
    ```
    Proses ini akan men-*generate* berkas `lcov.info` dan folder `coverage` terkait dengan laporan coverage.
4. Tunggu proses testing selesai hingga muncul web terkait laporan coverage.

# a199-flutter-expert-project

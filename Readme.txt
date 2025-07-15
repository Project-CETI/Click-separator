## 🐋 Sperm Whale Click Separation Tool (MATLAB)

This MATLAB program detects and separates **sperm whale echolocation clicks**, clustering them by individual whales.

> ⚠️ **Note**: This version currently works **only on Windows operating systems** due to the compiler and MEX configuration.

---

### ⚙️ Requirements

- **MATLAB** with the following add-on:
  - **MinGW-w64 C/C++/Fortran Compiler**

#### One-time compilation step:
Open the MATLAB Command Window and run:
```matlab
mex mcc4mot.c
```

---

### ▶️ How to Run

1. Open the script `Click_separator.m` in MATLAB.
2. Press the **Run** button.
3. A dialog box will appear — **select the folder** containing your recorded audio files.

---

### 📊 Output

- The script outputs a structure named `Det`, which stores the **click arrival times** for each detected whale.
  - For example, the click times for the second whale are stored in:
    ```matlab
    Det(2).ToAs
    ```

- The results are also automatically saved to a **CSV file** with the same name as the input audio file.

---

Feel free to open an issue or contribute if you find this tool useful for your acoustic analysis work!

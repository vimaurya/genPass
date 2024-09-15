1. [genpass.ps1](#genpassps1)
2. [monitor.ps1](#monitorps1)


## genpass.ps1
This can be used to generate passwords or random security pin based on a secret PIN that you always remember.

### Usage : 

```powershell
./genpass.ps1 -u admin -d instagram
```
where `-u` is your username and `-d` is the domain where you will use this password, this is to ensure that you can use different password for different domains.

Then it will ask you to enter your temppass which should specifically be 6 digit long.

![image](https://github.com/user-attachments/assets/2cc2c250-08f6-4965-b7d8-09ef1d1470bd)

This will generate a password that can be accepted anywhere. It will have a capital letter, special character, numbers.

![image](https://github.com/user-attachments/assets/f962f7e6-9fcc-4bf9-b1df-51ae073d810f)

Password strength according to [https://www.passwordmonster.com/](https://www.passwordmonster.com/)


## monitor.ps1

This script, `monitor.ps1`, is used to auto-delete files of a certain type that have not been updated for a specified number of days.

**Note:** If no file type is specified, the script will delete all files in the specified directory.

### Usage

### Parameters

- **`-type`**: Specifies the type of files to delete. Valid values include:
  - `img` for image files (`.img`, `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.tiff`)
  - `pdf` for PDF files (`.pdf`)
  - Any other value to specify a particular file extension (e.g., `.txt`, `.docx`).

- **`-days`**: Specifies the number of days. Files not updated within this timeframe will be deleted.

### Example

```powershell
# To delete image files not updated in the last 30 days
.\monitor.ps1 -type "img" -days 30
```
![image](https://github.com/user-attachments/assets/3a87d1c8-3312-476d-ace9-d6cb9e188e16)

```powershell
# To delete PDF files not updated in the last 10 days
.\monitor.ps1 -type "pdf" -days 10
```
![image](https://github.com/user-attachments/assets/e6502015-cd33-45b0-adb9-2c8054314bd3)

```powershell
# To delete all files not updated in the last 7 days
.\monitor.ps1 -days 7
```
![image](https://github.com/user-attachments/assets/32083f01-5d31-4c13-9aaf-c7d7f62f78bd)


## Removing all files

![image](https://github.com/user-attachments/assets/f1f051af-3b22-4bef-b92d-ed60c584fa55)



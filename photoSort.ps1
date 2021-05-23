
# 
# NAME: photoSort.ps1
#
# AUTHOR: Steven A. Guccione
# DATE  : 5/19/2021
# 
# COMMENT: Looks for JPEG files in a directory and moves them into subdirectories
#          based on their EXIF date tag.  Based on various implementations around
#          the web.
#

# Load DLL to get EXIF Photo tags
add-type -AssemblyName System.Drawing
$load = [reflection.assembly]::LoadWithPartialName("System.Drawing")

# Get JPEG files
$Files = Get-ChildItem -filter *.jpg

foreach ($file in $Files) {

   try {

      # Get date tag from bitmap and change ':' to '-'
      $bitmap = New-Object -TypeName system.drawing.bitmap -ArgumentList $file.fullname
      $dateTag = $bitmap.GetPropertyItem(0x9003).Value[0..9]
      $dateTag[4] = [char] '-'
      $dateTag[7] = [char] '-'
      $date = [System.Text.Encoding]::ASCII.GetString($dateTag)
      # Write-Output "Date:  $date"
      $bitmap.Dispose()

      # Make new directory if it doesn't exist
      If (-not (Test-Path $date)) {
         # Write-Output "New directory:  $date"
         $newDir = New-Item $date -Type Directory
         }

      Write-Output "Moving file $file to directory $date"
      mv $file.FullName $date

   } catch {
      Write-Output "Error processing file $file"
   }

   }

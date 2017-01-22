$archive = "release.zip"
If (Test-Path $archive){
        Remove-Item $archive
}
Compress-Archive -Path "game/*" -CompressionLevel Fastest -DestinationPath $archive

$exe = "Sparky And The Other Fish.exe"
If (Test-Path $exe){
        Remove-Item $exe
}
gc "C:\Program Files\LOVE\love.exe", $archive -Enc Byte -Read 512 | sc $exe -Enc Byte

$out = "Sparky And The Other Fish.zip"
If (Test-Path $out){
        Remove-Item $out
}
Compress-Archive -Path $exe, "C:\Program Files\LOVE\*.dll" -CompressionLevel Fastest -DestinationPath $out

Remove-Item $archive
Remove-Item $exe

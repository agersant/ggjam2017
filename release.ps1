$archive = "release.zip"
If (Test-Path $archive){
        Remove-Item $archive
}
Compress-Archive -Path "game/*" -CompressionLevel Fastest -DestinationPath $archive

$out = "release.exe"
If (Test-Path $out){
        Remove-Item $out
}
gc "C:\Program Files\LOVE\love.exe", $archive -Enc Byte -Read 512 | sc $out -Enc Byte

Remove-Item $archive
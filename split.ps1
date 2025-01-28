# split.ps1
param (
    [int]$chunkSize = 10MB
)

$inputFile = "web\onnx_model\model.onnx"
$baseOutputName = "web\onnx_model\model.onnx.gz.part"

# First compress the file
$compressedBytes = @()
$input = [System.IO.File]::ReadAllBytes($inputFile)
$outputStream = New-Object System.IO.MemoryStream
$gzipStream = New-Object System.IO.Compression.GZipStream($outputStream, [System.IO.Compression.CompressionLevel]::Optimal)
$gzipStream.Write($input, 0, $input.Length)
$gzipStream.Close()
$compressedBytes = $outputStream.ToArray()
$outputStream.Close()

# Split the compressed file into chunks
$totalChunks = [math]::Ceiling($compressedBytes.Length / $chunkSize)
Write-Host "Splitting into $totalChunks chunks..."

for ($i = 0; $i -lt $totalChunks; $i++) {
    $start = $i * $chunkSize
    $length = [math]::Min($chunkSize, $compressedBytes.Length - $start)
    $chunk = New-Object byte[] $length
    [Array]::Copy($compressedBytes, $start, $chunk, 0, $length)
    [System.IO.File]::WriteAllBytes("$baseOutputName$i", $chunk)
    Write-Host "Created chunk $i of size $($chunk.Length) bytes"
}

Write-Host "Done! Created $totalChunks chunks."
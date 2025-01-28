# compress.ps1
$inputFile = "web\onnx_model\model.onnx"
$outputFile = "web\onnx_model\model.onnx.gz"

# Create a FileStream for the input file
$input = New-Object System.IO.FileStream($inputFile, [System.IO.FileMode]::Open)
# Create a FileStream for the output file
$output = New-Object System.IO.FileStream($outputFile, [System.IO.FileMode]::Create)
# Create a GZipStream for compression
$gzip = New-Object System.IO.Compression.GZipStream($output, [System.IO.Compression.CompressionLevel]::Optimal)

# Copy the input to the GZip stream
$input.CopyTo($gzip)

# Clean up
$gzip.Close()
$output.Close()
$input.Close()

Write-Host "Compression complete. Check the size of $outputFile"
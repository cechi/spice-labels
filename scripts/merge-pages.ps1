$outFile = Join-Path (Get-Location).Path "build/all.pdf";
$inFiles = Get-ChildItem "build" -Filter "*.png";

$doc = [System.Drawing.Printing.PrintDocument]::new();
$opt = $doc.PrinterSettings = [System.Drawing.Printing.PrinterSettings]::new();
$opt.PrinterName = "Microsoft Print to PDF";
$opt.PrintToFile = $true;
$opt.PrintFileName = $outFile;

$script:_pageIndex = 0;
$doc.add_PrintPage({
	param($sender, [System.Drawing.Printing.PrintPageEventArgs] $e)
	$file = $inFiles[$script:_pageIndex];
	Write-Host "print $($file.FullName)"
	$script:_pageIndex = $script:_pageIndex + 1

	$image = [System.Drawing.Image]::FromFile($file.FullName)
	$e.Graphics.DrawImage($image, $e.PageBounds)
	$e.HasMorePages = $script:_pageIndex -lt $inFiles.Count
	$image.Dispose();
})

$doc.PrintController = [System.Drawing.Printing.StandardPrintController]::new();

$doc.Print();
$doc.Dispose();
param(
	$inDir = "build/labels",
	$outDir = "build",
	$paperWidth = 210,
	$paperHeight = 297,
	$margin = 15,
	$dpi = 300
)
	
$inchmm = 25.4;
$w = [int][math]::Round($dpi * ($paperWidth / $inchmm));
$h = [int][math]::Round($dpi * ($paperHeight / $inchmm));
$m = [int][math]::Round($dpi * ($margin / $inchmm));
$columns = 0;
$rows = 0;
$pageLabelCount = 0;

$page = $null;
$g = $null;
$drawingRect = New-Object System.Drawing.Rectangle($m, $m, ($w - 2 * $m), ($h - 2 * $m));

$labelIndex = 0;
$pageIndex = 0;

$labels = Get-ChildItem $inDir;
$labels | ForEach-Object {
	$label = New-Object System.Drawing.Bitmap($_.FullName);

	if ($labelIndex -eq 0) {
		$columns = [math]::Floor($drawingRect.Width / $label.Width)
		$rows = [math]::Floor($drawingRect.Height / $label.Height)
		$pageLabelCount = $columns * $rows;
	}

	if (($labelIndex % $pageLabelCount) -eq 0) {
		if ($null -ne $page) {
			$filename = Join-Path $outDir "page-$($pageIndex).png";
			$page.Save($filename);
			$page.Dispose();
			$g.Dispose();
		}

		Write-Host "$($pageIndex + 1)/$([math]::Ceiling($labels.Count / $pageLabelCount)) making " -NoNewLine
		Write-Host "page-$($pageIndex).png" -ForegroundColor Green

		$page = New-Object System.Drawing.Bitmap($w, $h);
		$page.SetResolution($dpi, $dpi);
		$g = [System.Drawing.Graphics]::FromImage($page);
		$pageIndex = $pageIndex + 1;
	}

	$i = $labelIndex % $pageLabelCount;
	$r = [int][math]::Floor($i / $columns);
	$c = $i % $columns;
	$g.DrawImage($label, ($c * $label.Width + $m), ($r * $label.Height + $m));

	$label.Dispose();
	$labelIndex = $labelIndex + 1
}

if ($null -ne $page) {
	$filename = Join-Path $outDir "page-$($pageIndex).png";
	$page.Save($filename);
	$page.Dispose();
	$g.Dispose();
}

# $columns = [math]::Floor($w / )
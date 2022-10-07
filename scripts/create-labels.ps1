param(
	$labelWidth = 35,
	$labelHeight = 25,
	$margin = 3,
	$dpi = 300,
	$outDir = "build/labels",
	$assetDir = "assets",
	$fontName = "Tycho'sRecipe", #"FR_KMS_01cs", #"Arial",
	$fontSize = 12,
	$lang = "cs"
)

$inchmm = 25.4;

$w = [int][math]::Round($dpi * ($labelWidth / $inchmm))
$h = [int][math]::Round($dpi * ($labelHeight / $inchmm))
$m = [int][math]::Round($dpi * ($margin / $inchmm))


$mapping = Get-Content "mapping.json" -Encoding "Utf8" | ConvertFrom-Json;
$unit = [ref][System.Drawing.GraphicsUnit]::Pixel;

$overlayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 0, 0, 0));
$rect = New-Object System.Drawing.RectangleF(0, 0, $w, $h);
$overlayRect = New-Object System.Drawing.RectangleF($m, $m, ($w - 2 * $m), ($h - 2 * $m));
$font = New-Object System.Drawing.Font($fontName, $fontSize);
$fontBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255));
$stringFormat = New-Object System.Drawing.StringFormat;
$stringFormat.Alignment = [System.Drawing.StringAlignment]::Center;
$stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center;

$i = 0;
$mapping | ForEach-Object {
	$i = $i + 1
	Write-Host "$($i)/$($mapping.Count) making " -NoNewline
	Write-Host $_.labels.en -ForegroundColor Yellow

	$text = $_.labels.$lang
	
	$filename = Join-Path $outDir ($text + '.png')
	$filename = $filename.Replace("`n", "");
	$filename = $filename.Replace("`r", "");
	$bgFilename = Join-Path $assetDir $_.background

	$background = New-Object System.Drawing.Bitmap($bgFilename);

	$label = New-Object System.Drawing.Bitmap($w, $h);
	$label.SetResolution($dpi, $dpi);
	$g = [System.Drawing.Graphics]::FromImage($label);
	
	# background
	$g.DrawImage($background, $label.GetBounds($unit), $rect, [System.Drawing.GraphicsUnit]::Pixel)
	
	# overlay
	$g.FillRectangle($overlayBrush, $overlayRect)
	
	# text
	$g.DrawString($text, $font, $fontBrush, $overlayRect, $stringFormat);
	
	$label.Save($filename);
	
	$g.Dispose();
	$background.Dispose();
	$label.Dispose();
}
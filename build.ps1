$dpi = 300;
$labelWidth = 35;
$labelHeight = 35;
$fontName = "Tycho'sRecipe";
$fontSize = 12;
$lang = "cs";


./scripts/create-labels.ps1 -dpi $dpi -labelWidth $labelWidth -labelHeight $labelHeight -fontName $fontName -fontSize $fontSize -lang $lang
./scripts/merge-labels.ps1 -dpi $dpi
./scripts/merge-pages.ps1
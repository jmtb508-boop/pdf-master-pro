Add-Type -AssemblyName System.Drawing

$resDir = "C:\Users\التوحيد\.gemini\antigravity\scratch\pdf-master-pro-android\android\app\src\main\res"

$configs = @(
    @{ Folder = "mipmap-mdpi"; AppSize = 48; ForeSize = 108 },
    @{ Folder = "mipmap-hdpi"; AppSize = 72; ForeSize = 162 },
    @{ Folder = "mipmap-xhdpi"; AppSize = 96; ForeSize = 216 },
    @{ Folder = "mipmap-xxhdpi"; AppSize = 144; ForeSize = 324 },
    @{ Folder = "mipmap-xxxhdpi"; AppSize = 192; ForeSize = 432 }
)

function Draw-PDFAppIcon([int]$size, [bool]$isRound) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $scale = [double]$size / 256.0

    # Background
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    if ($isRound) {
        $path.AddEllipse(8.0 * $scale, 8.0 * $scale, 240.0 * $scale, 240.0 * $scale)
    } else {
        $rx = 16.0 * $scale; $ry = 16.0 * $scale; $rw = 224.0 * $scale; $rh = 224.0 * $scale; $rad = 40.0 * $scale
        $path.AddArc([float]$rx, [float]$ry, [float]$rad, [float]$rad, 180, 90)
        $path.AddArc([float]($rx + $rw - $rad), [float]$ry, [float]$rad, [float]$rad, 270, 90)
        $path.AddArc([float]($rx + $rw - $rad), [float]($ry + $rh - $rad), [float]$rad, [float]$rad, 0, 90)
        $path.AddArc([float]$rx, [float]($ry + $rh - $rad), [float]$rad, [float]$rad, 90, 90)
        $path.CloseFigure()
    }

    $pt1 = New-Object System.Drawing.PointF (0, 0)
    $pt2 = New-Object System.Drawing.PointF ($size, $size)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush ($pt1, $pt2, [System.Drawing.Color]::FromArgb(239, 68, 68), [System.Drawing.Color]::FromArgb(185, 28, 28))
    $g.FillPath($bgBrush, $path)

    # White document
    $docX = 64.0 * $scale; $docY = 44.0 * $scale; $docW = 128.0 * $scale; $docH = 168.0 * $scale; $fold = 36.0 * $scale
    $docPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $docPath.AddLine([float]$docX, [float]$docY, [float]($docX + $docW - $fold), [float]$docY)
    $docPath.AddLine([float]($docX + $docW), [float]($docY + $fold), [float]($docX + $docW), [float]($docY + $docH))
    $docPath.AddLine([float]($docX + $docW), [float]($docY + $docH), [float]$docX, [float]($docY + $docH))
    $docPath.CloseFigure()

    $whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(250, 250, 250))
    $g.FillPath($whiteBrush, $docPath)

    # Flap
    $foldPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $foldPath.AddLine([float]($docX + $docW - $fold), [float]$docY, [float]($docX + $docW - $fold), [float]($docY + $fold))
    $foldPath.AddLine([float]($docX + $docW - $fold), [float]($docY + $fold), [float]($docX + $docW), [float]($docY + $fold))
    $foldPath.CloseFigure()
    $foldBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(215, 215, 220))
    $g.FillPath($foldBrush, $foldPath)

    # Red banner for PDF
    $bannerX = 48.0 * $scale; $bannerY = 115.0 * $scale; $bannerW = 160.0 * $scale; $bannerH = 52.0 * $scale
    $bannerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 38, 38))
    $g.FillRectangle($bannerBrush, [float]$bannerX, [float]$bannerY, [float]$bannerW, [float]$bannerH)

    $fontSize = 28.0 * $scale
    if ($fontSize -ge 6.0) {
        $font = New-Object System.Drawing.Font ("Arial", [float]$fontSize, [System.Drawing.FontStyle]::Bold)
        $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $format = New-Object System.Drawing.StringFormat
        $format.Alignment = [System.Drawing.StringAlignment]::Center
        $format.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rectF = New-Object System.Drawing.RectangleF ([float]$bannerX, [float]$bannerY, [float]$bannerW, [float]$bannerH)
        $g.DrawString("PDF", $font, $textBrush, $rectF, $format)
        $font.Dispose(); $textBrush.Dispose(); $format.Dispose()
    }

    # Gold PRO badge
    $proX = 135.0 * $scale; $proY = 175.0 * $scale; $proW = 54.0 * $scale; $proH = 22.0 * $scale
    $proBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(245, 158, 11))
    $g.FillRectangle($proBrush, [float]$proX, [float]$proY, [float]$proW, [float]$proH)

    $pFontSize = 10.5 * $scale
    if ($pFontSize -ge 5.0) {
        $pFont = New-Object System.Drawing.Font ("Arial", [float]$pFontSize, [System.Drawing.FontStyle]::Bold)
        $pBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $pFormat = New-Object System.Drawing.StringFormat
        $pFormat.Alignment = [System.Drawing.StringAlignment]::Center
        $pFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
        $pRectF = New-Object System.Drawing.RectangleF ([float]$proX, [float]$proY, [float]$proW, [float]$proH)
        $g.DrawString("PRO", $pFont, $pBrush, $pRectF, $pFormat)
        $pFont.Dispose(); $pBrush.Dispose(); $pFormat.Dispose()
    }

    $g.Dispose()
    return $bmp
}

function Draw-PDFLauncherForeground([int]$size) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Adaptive icons have safe zone in center 66% (scaled)
    $scale = ([double]$size / 432.0) * 1.5
    $offsetX = ($size - (256.0 * $scale)) / 2.0
    $offsetY = ($size - (256.0 * $scale)) / 2.0

    # White document
    $docX = $offsetX + (64.0 * $scale)
    $docY = $offsetY + (44.0 * $scale)
    $docW = 128.0 * $scale
    $docH = 168.0 * $scale
    $fold = 36.0 * $scale

    $docPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $docPath.AddLine([float]$docX, [float]$docY, [float]($docX + $docW - $fold), [float]$docY)
    $docPath.AddLine([float]($docX + $docW), [float]($docY + $fold), [float]($docX + $docW), [float]($docY + $docH))
    $docPath.AddLine([float]($docX + $docW), [float]($docY + $docH), [float]$docX, [float]($docY + $docH))
    $docPath.CloseFigure()

    # Drop shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(60, 0, 0, 0))
    $shadowMatrix = New-Object System.Drawing.Drawing2D.Matrix
    $shadowMatrix.Translate(0, 4.0 * $scale)
    $docPath.Transform($shadowMatrix)
    $g.FillPath($shadowBrush, $docPath)
    $shadowMatrix.Translate(0, -4.0 * $scale)
    $docPath.Transform($shadowMatrix)

    $whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(250, 250, 250))
    $g.FillPath($whiteBrush, $docPath)

    # Flap
    $foldPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $foldPath.AddLine([float]($docX + $docW - $fold), [float]$docY, [float]($docX + $docW - $fold), [float]($docY + $fold))
    $foldPath.AddLine([float]($docX + $docW - $fold), [float]($docY + $fold), [float]($docX + $docW), [float]($docY + $fold))
    $foldPath.CloseFigure()
    $foldBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(215, 215, 220))
    $g.FillPath($foldBrush, $foldPath)

    # Red banner for PDF
    $bannerX = $offsetX + (48.0 * $scale)
    $bannerY = $offsetY + (115.0 * $scale)
    $bannerW = 160.0 * $scale
    $bannerH = 52.0 * $scale
    $bannerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 38, 38))
    $g.FillRectangle($bannerBrush, [float]$bannerX, [float]$bannerY, [float]$bannerW, [float]$bannerH)

    $fontSize = 28.0 * $scale
    if ($fontSize -ge 6.0) {
        $font = New-Object System.Drawing.Font ("Arial", [float]$fontSize, [System.Drawing.FontStyle]::Bold)
        $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $format = New-Object System.Drawing.StringFormat
        $format.Alignment = [System.Drawing.StringAlignment]::Center
        $format.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rectF = New-Object System.Drawing.RectangleF ([float]$bannerX, [float]$bannerY, [float]$bannerW, [float]$bannerH)
        $g.DrawString("PDF", $font, $textBrush, $rectF, $format)
        $font.Dispose(); $textBrush.Dispose(); $format.Dispose()
    }

    # Gold PRO badge
    $proX = $offsetX + (135.0 * $scale)
    $proY = $offsetY + (175.0 * $scale)
    $proW = 54.0 * $scale
    $proH = 22.0 * $scale
    $proBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(245, 158, 11))
    $g.FillRectangle($proBrush, [float]$proX, [float]$proY, [float]$proW, [float]$proH)

    $pFontSize = 10.5 * $scale
    if ($pFontSize -ge 5.0) {
        $pFont = New-Object System.Drawing.Font ("Arial", [float]$pFontSize, [System.Drawing.FontStyle]::Bold)
        $pBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $pFormat = New-Object System.Drawing.StringFormat
        $pFormat.Alignment = [System.Drawing.StringAlignment]::Center
        $pFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
        $pRectF = New-Object System.Drawing.RectangleF ([float]$proX, [float]$proY, [float]$proW, [float]$proH)
        $g.DrawString("PRO", $pFont, $pBrush, $pRectF, $pFormat)
        $pFont.Dispose(); $pBrush.Dispose(); $pFormat.Dispose()
    }

    $g.Dispose()
    return $bmp
}

foreach ($cfg in $configs) {
    $folderPath = Join-Path $resDir $cfg.Folder
    if (!(Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
    }

    # ic_launcher.png
    $iconSquare = Draw-PDFAppIcon -size $cfg.AppSize -isRound $false
    $iconSquare.Save((Join-Path $folderPath "ic_launcher.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconSquare.Dispose()

    # ic_launcher_round.png
    $iconRound = Draw-PDFAppIcon -size $cfg.AppSize -isRound $true
    $iconRound.Save((Join-Path $folderPath "ic_launcher_round.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconRound.Dispose()

    # ic_launcher_foreground.png
    $iconFore = Draw-PDFLauncherForeground -size $cfg.ForeSize
    $iconFore.Save((Join-Path $folderPath "ic_launcher_foreground.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconFore.Dispose()

    Write-Host "Icons generated for $($cfg.Folder)"
}

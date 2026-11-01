Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class MascotBgRemover
{
    public static void ProcessImage(string inputPath, string outputPath)
    {
        using (Bitmap src = new Bitmap(inputPath))
        {
            int w = src.Width;
            int h = src.Height;
            Bitmap dest = new Bitmap(w, h, PixelFormat.Format32bppArgb);

            BitmapData srcData = src.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
            BitmapData destData = dest.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);

            int stride = srcData.Stride;
            int bytes = Math.Abs(stride) * h;
            byte[] srcBytes = new byte[bytes];
            byte[] destBytes = new byte[bytes];

            System.Runtime.InteropServices.Marshal.Copy(srcData.Scan0, srcBytes, 0, bytes);
            src.UnlockBits(srcData);

            Array.Copy(srcBytes, destBytes, bytes);

            bool[,] isBg = new bool[w, h];
            Queue<Point> queue = new Queue<Point>();

            for (int x = 0; x < w; x++)
            {
                CheckAndEnqueue(x, 0, srcBytes, stride, isBg, queue);
                CheckAndEnqueue(x, h - 1, srcBytes, stride, isBg, queue);
            }
            for (int y = 0; y < h; y++)
            {
                CheckAndEnqueue(0, y, srcBytes, stride, isBg, queue);
                CheckAndEnqueue(w - 1, y, srcBytes, stride, isBg, queue);
            }

            int[] dx = { 1, -1, 0, 0, 1, -1, 1, -1 };
            int[] dy = { 0, 0, 1, -1, 1, 1, -1, -1 };

            while (queue.Count > 0)
            {
                Point pt = queue.Dequeue();
                for (int i = 0; i < 8; i++)
                {
                    int nx = pt.X + dx[i];
                    int ny = pt.Y + dy[i];
                    if (nx >= 0 && nx < w && ny >= 0 && ny < h && !isBg[nx, ny])
                    {
                        CheckAndEnqueue(nx, ny, srcBytes, stride, isBg, queue);
                    }
                }
            }

            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                {
                    int idx = y * stride + x * 4;
                    if (isBg[x, y])
                    {
                        destBytes[idx + 0] = 0;
                        destBytes[idx + 1] = 0;
                        destBytes[idx + 2] = 0;
                        destBytes[idx + 3] = 0;
                    }
                    else
                    {
                        bool nearBg = false;
                        for (int i = 0; i < 4; i++)
                        {
                            int nx = x + dx[i];
                            int ny = y + dy[i];
                            if (nx >= 0 && nx < w && ny >= 0 && ny < h && isBg[nx, ny])
                            {
                                nearBg = true;
                                break;
                            }
                        }

                        if (nearBg)
                        {
                            byte b = srcBytes[idx + 0];
                            byte g = srcBytes[idx + 1];
                            byte r = srcBytes[idx + 2];
                            int avg = (r + g + b) / 3;
                            if (avg > 220)
                            {
                                int alpha = Math.Max(0, (255 - avg) * 7);
                                destBytes[idx + 3] = (byte)Math.Min(255, alpha);
                            }
                        }
                    }
                }
            }

            System.Runtime.InteropServices.Marshal.Copy(destBytes, 0, destData.Scan0, bytes);
            dest.UnlockBits(destData);
            dest.Save(outputPath, ImageFormat.Png);
            dest.Dispose();
        }
    }

    private static void CheckAndEnqueue(int x, int y, byte[] data, int stride, bool[,] isBg, Queue<Point> queue)
    {
        if (isBg[x, y]) return;
        int idx = y * stride + x * 4;
        byte b = data[idx + 0];
        byte g = data[idx + 1];
        byte r = data[idx + 2];

        if (r > 218 && g > 218 && b > 218)
        {
            isBg[x, y] = true;
            queue.Enqueue(new Point(x, y));
        }
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"

$items = @(
    "goat_idle",
    "goat_teacher",
    "goat_happy",
    "goat_sad",
    "goat_rocker",
    "goat_baby",
    "goat_shy",
    "goat_grumpy",
    "goat_shocked"
)

foreach ($item in $items) {
    $in = "assets/mascot/$item.jpeg"
    $out = "assets/mascot/$item.png"
    if (Test-Path $in) {
        [MascotBgRemover]::ProcessImage($in, $out)
        Write-Output "Converted: $out"
    }
}

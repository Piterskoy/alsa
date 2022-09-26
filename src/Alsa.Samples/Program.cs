// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System;
using System.Threading;
using Iot.Device.Media;

namespace Alsa.Samples
{
    class Program
    {
        // Plumbing code to facilitate a graceful exit.
          static CancellationTokenSource exitCts = new CancellationTokenSource(); // Cancellation token to stop the SIP transport and RTP stream.

        static void Main(string[] args)
        {
            SoundConnectionSettings settings = new SoundConnectionSettings();
            Console.WriteLine($"PlaybackDeviceName={settings.PlaybackDeviceName}");
            Console.WriteLine($"MixerDeviceName={settings.MixerDeviceName}");
            Console.WriteLine($"RecordingDeviceName={settings.RecordingDeviceName}");

            using SoundDevice device = SoundDevice.Create(settings);

            Console.WriteLine("Recording...");
            device.Record(10, "/home/pi/record.wav");

            Console.WriteLine("Playing...");
            device.Play("/home/pi/record.wav");


            Console.WriteLine("Press Ctrl+C to exit!");
            // Ctrl-c will gracefully exit the call at any point.
            Console.CancelKeyPress += delegate (object sender, ConsoleCancelEventArgs e)
            {
                e.Cancel = true;
                exitCts.Cancel();
            };

            // Wait for a signal saying the call failed, was cancelled with ctrl-c or completed.
            exitCts.Token.WaitHandle.WaitOne();
            Console.WriteLine("Exiting...");
        }
    }
}

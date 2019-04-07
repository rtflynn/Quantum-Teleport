using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System.Linq;      // for Enumerable

namespace Quantum.Quantum_Teleport_Single_Qubit
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                var rand = new System.Random();
                System.Console.WriteLine($"For our first trick, we'll use quantum teleportation to send classical bits.");
                System.Console.WriteLine($"That is, we'll send and receive qubits in states |0> and |1> only.\n\n");
                foreach (var i in Enumerable.Range(0,10))
                {
                    var sent = rand.Next(2) == 0;     // rand.Next(2) returns a nonnegative random integer less than 2
                    var received = TeleportClassicalMessage.Run(qsim, sent).Result;
                    System.Console.WriteLine($"Round {i}:\t Sent {sent}, \t Received {received}.");
                    System.Console.WriteLine(sent == received ? "Teleportation Successful!" : "\n");

                }

                System.Console.WriteLine($"\n\nFor our second trick, we'll quantum teleport states " +
                    $"1/sqrt(2) * (|0> +/- |1>) .");
                System.Console.WriteLine($"We'll use H+ and H- as names for these two states.\n\n");
                foreach (var i in Enumerable.Range(0, 10))
                {
                    var sent = rand.Next(2) == 0;     // rand.Next(2) returns a nonnegative random integer less than 2
                    var received = TeleportNonclassicalQubit.Run(qsim, sent).Result;
                    System.Console.WriteLine($"Round {i}:\t Sent " + (sent? "H+" : "H-") + ", \t Received " +
                       (received? "H+" : "H-") + ".");
                    System.Console.WriteLine(sent == received ? "Teleportation Successful!" : "\n");
                }



            }
        }
    }
}